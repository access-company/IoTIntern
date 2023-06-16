#!/bin/bash
set -euo pipefail -o posix

#
# Edit this section before launching an EC2 instance for making AMI
#
gear_dir_name=IoTIntern
iot_intern_repo_url="https://github.com/access-company/${gear_dir_name}.git"
erlang_version="20.3.8.25"
elixir_version="1.9.4"
nodejs_version="14.17.1"


admin_password=""
user_password=""
admin_ssh_pubkey='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdUtImrkF223X3Eyj+Kv8jaSltvCldKKcr/46eGMDvl'
user_ssh_pubkey='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEfzA7yQtj8YRPunRbrF/OhiVMH8DAXe7E4wGHNolhmZ'

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
  ./configure --prefix=/usr --libdir=/lib64 && make && make install
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
    gear_dir="${home_dir}/${gear_dir_name}"
    git clone "${iot_intern_repo_url}" "${gear_dir}"
    chown -R "${name}:${name}" "${gear_dir}"

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
  su intern-admin -c "asdf plugin update erlang 9ca2dea00fd13e0ba8b35d5f8d5f48dfd27ff4a2" # This is the latest commit which uses kerl v2.1.2. kerl >= v2.2.0 does not support Erlang v.20
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
  su intern-admin -c "asdf install nodejs ${nodejs_version}"
  su intern-admin -c "npm install --global yarn"
  echo "[Done] installed nodejs ${nodejs_version}"

  #
  # Compile gear in advance
  #

  su intern-user -c "cd /home/intern-user/${gear_dir_name} && mix deps.get && mix deps.get && MIX_ENV=dev mix compile && MIX_ENV=test mix compile"
  echo "[Done] compiled the gear"

  #
  # Prepare environment for elixir-training by using docker
  # to avoid affecting the compilation environment of the iot-intern gear
  #

  # Kernel parameter tuning
  content=$(cat <<'EOF'
vm.swappiness = 10
EOF
  )
  echo "${content}" >> '/etc/sysctl.d/docker-compose-elixir-training.conf'
  echo "[Done] tuned kernel parameters"

  # Install swap file
  swapfile_size_in_mb=1024
  dd if=/dev/zero of=/swapfile count="${swapfile_size_in_mb}" bs=1M
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile swap swap defaults 0 0' >> /etc/fstab
  echo "[Done] installed swap file"

  # Install docker and docker-compose
  sudo yum install -y docker
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -a -G docker intern-admin
  curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  echo "[Done] installed docker and docker-compose"

  content=$(cat << "EOF"
[Unit]
Description=Elixir training
Requires=docker.service

[Service]
Environment=MAKE_FILE=/home/intern-user/IoTIntern/doc/elixir-training-with-livebook/Makefile

ExecStartPre=-/usr/local/bin/docker rm -f Elixirise
ExecStart=/usr/local/bin/make -f ${MAKE_FILE}
ExecStop=/usr/local/bin/docker stop Elixirise

Restart=always
Type=simple

[Install]
WantedBy=multi-user.target
EOF
  )

  echo "${content}" > /etc/systemd/system/docker-compose-elixir-training.service
  sudo systemctl start docker-compose-elixir-training
  sudo systemctl enable docker-compose-elixir-training
  echo "[Done] registerd docker-compose-elixir-training service"

  echo 'Finished all steps!'
) &> "$log"
