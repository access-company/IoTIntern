#!/bin/bash
set -euo pipefail -o posix

#
# Edit this section before launching an EC2 instance for making AMI
#
iot_intern_repo_url="https://github.com/access-company/IoTIntern.git"

erlang_version="20.3.8.25"
elixir_version="1.9.4"
nodejs_version="10.23.0"

admin_password=""
user_password=""
admin_ssh_pubkey='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKIPKAZD/SvZuOqGaHmK7SuqQVsobk0BKqmGd2vrCxoN'
user_ssh_pubkey='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSkVAyNavvy7uq+xOskFm587XLID83yLWdAO+NT6/dL'

#
# Do setup
#
log="/tmp/bootstrap_amazonlinux2_$(date '+%Y%m%dT%H%M').log"
(
  #
  # Install basic packages
  #
  yum -y update
  yum groupinstall -y "Development Tools"
  yum install -y openssl-devel ncurses-devel expad-devel
  yum install -y openssl openssl-devel gcc-c++ unixODBC unixODBC-devel fop java-1.6.0-openjdk-devel
  # inotify is required by antikythera
  cd /opt
  git clone https://github.com/inotify-tools/inotify-tools.git --branch 3.20.2.2
  cd inotify-tools && bash autogen.sh
  ./configure --prefix=/usr && make && make install
  # development header of the Expat is required in compiling fast_xml, on which antikythera depends
  yum install -y patch expat-devel

  content=$(cat << 'EOF'
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
export PATH=$PATH:'/usr/local/bin/'
export LIBRARY_PATH=$LIBRARY_PATH:'/usr/local/lib/'
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:'/usr/local/lib/'
EOF
)
  echo "${content}" >> "/etc/bashrc"

  #
  # Add linux users
  #
  add_linux_user() {
    name="$1"
    uid="$2"
    password="$3"
    pubkey="$4"

    # Make primary group beforehand with the same `uid` (otherwise `useradd` creates a group with a different `gid`)
    groupadd --gid "${uid}" "${name}"
    useradd --uid "${uid}" -g "${uid}" "${name}"
    echo "${password}" | passwd --force --stdin "${name}"

    # Embedding user's public key
    home_dir="/home/${name}"
    dot_ssh_dir="${home_dir}/.ssh"
    auth_keys_path="${dot_ssh_dir}/authorized_keys"
    mkdir -p "${dot_ssh_dir}"
    echo "${pubkey}" > "${auth_keys_path}"
    chmod 600 "${auth_keys_path}"
    chown -R "${name}:${name}" "${dot_ssh_dir}"

    # Clone gear repository to the home directory
    repo_dir="${home_dir}/$(basename "${iot_intern_repo_url}" .git)"
    git clone "${iot_intern_repo_url}" "${repo_dir}"
    chown -R "${name}:${name}" "${repo_dir}"

    ln -s /etc/asdf-tool-versions "${home_dir}/.tool-versions"

    echo "[Done] Created a new user '${name}'."
  }

  add_linux_user intern-admin 501 "${admin_password}" "${admin_ssh_pubkey}"
  add_linux_user intern-user 502 "${user_password}" "${user_ssh_pubkey}"

  usermod -G wheel intern-admin

  #
  #  Install asdf
  #
  yum install -y automake autoconf readline-devel ncurses-devel openssl-devel libyaml-devel libxslt-devel libffi-devel libtool
  mkdir /opt/asdf
  git clone https://github.com/asdf-vm/asdf.git /opt/asdf --branch v0.8.1
  chown -R intern-admin:intern-admin /opt/asdf
  content=$(cat << 'EOF'
  export ASDF_DATA_DIR='/opt/asdf'
. /opt/asdf/asdf.sh
EOF
  )
  echo "${content}" >> "/etc/bashrc"
  set +u
  # shellcheck disable=SC1091
  source "/etc/bashrc"
  set -u
  echo "[Done] installed asdf"

  #
  # Install languages for gear development
  #
  touch /etc/asdf-tool-versions
  chown intern-admin:intern-admin /etc/asdf-tool-versions
  content=$(cat << EOF
erlang ${erlang_version}
elixir ${elixir_version}
nodejs ${nodejs_version}
EOF
  )
  echo "${content}" > /etc/asdf-tool-versions
  # Required to install asdf plugin by root user
  export HOME="/home/intern-admin/"

  # Erlang
  su intern-admin -c "asdf plugin-add erlang"
  su intern-admin -c "asdf install erlang ${erlang_version}"
  echo "[Done] installed Erlang ${erlang_version}"

  # Elixir
  su intern-admin -c "asdf plugin-add elixir"
  su intern-admin -c "asdf install elixir ${elixir_version}"
  su intern-admin -c "mix local.rebar"
  su intern-admin -c "mix local.hex --force"
  echo "[Done] installed Elixir ${elixir_version}"

  # Node.js
  yum install -y perl-Digest-SHA
  su intern-admin -c "asdf plugin-add nodejs"
  su intern-admin -c "bash /opt/asdf/plugins/nodejs/bin/import-release-team-keyring"
  su intern-admin -c "asdf install nodejs ${nodejs_version}"
  su intern-admin -c "npm install --global yarn"
  echo "[Done] installed nodejs ${nodejs_version}"

  #
  # Install jupyter notebook for elixir hands-on
  #

  # Create a linux user to start jupyter server
  useradd -m jupyter
  ln -s /etc/asdf-tool-versions /home/jupyter/.tool-versions
  echo "[Done] Created a new user jupyter"

  # Install jupyter
  su jupyter -c "python3 -m pip install --upgrade pip"
  su jupyter -c "python3 -m pip install jupyter"
  echo "[Done] Installed jupyter"

  #
  # Install IElixir (https://github.com/pprzetacznik/IElixir)
  #

  # sqlite3.h is required in IElixir
  yum install -y sqlite-devel

  # sodium
  # https://download.libsodium.org/libsodium/releases/
  cd /opt
  curl https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz | tar -xz
  cd libsodium-1.0.18
  ./configure && make && make install
  # zmq
  cd /opt
  wget https://github.com/zeromq/libzmq/releases/download/v4.2.0/zeromq-4.2.0.tar.gz
  tar xfz zeromq-4.2.0.tar.gz && rm zeromq-4.2.0.tar.gz
  cd zeromq-4.2.0
  ./configure && make && make install

  cd /home/jupyter
  su jupyter -c "git clone https://github.com/pprzetacznik/IElixir.git"
  cd IElixir
  su jupyter -c "git checkout 4785f3f3b9cf9d09399038cf6c4af438559d951a" # the last version compatible to elixir < 1.10
  su jupyter -c "mix deps.get"
  su jupyter -c "MIX_ENV=prod mix compile"
  su - jupyter -c "cd /home/jupyter/IElixir && ./install_script.sh"
  echo "[Done] Installed IElixir kernel"

  # Configure the jupyter server
  su - jupyter -c "jupyter notebook --generate-config"
  su jupyter -c "mkdir /home/jupyter/jupyter-working"

  content=$(cat << EOF
conf = get_config()

conf.NotebookApp.ip = '0.0.0.0'
conf.NotebookApp.notebook_dir = '/home/jupyter/jupyter-working'
conf.NotebookApp.token = u''
conf.NotebookApp.open_browser = False
conf.NotebookApp.port = 8081
EOF
  )
  echo "${content}" > /home/jupyter/.jupyter/jupyter_notebook_config.py

  # Configure the jupyter server to start automatically
  #
  # Use rc.local instead of systemd
  #  because we couldn't find the way to make tools installed by asdf work
  echo 'nohup su - jupyter -c "jupyter notebook" > /tmp/jupyter-notebook.log &' >> /etc/rc.local
  chmod 755 /etc/rc.d/rc.local
  echo "[Done] Configured jupyter server"

  echo 'Finished all steps!'
) &> "$log"
