Vagrant.configure('2') do |config|
  config.vm.box = 'bento/amazonlinux-2'

  config.vm.hostname = 'elixir-training'

  config.vm.network "forwarded_port", guest: 8888, host:8888

  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.cpus = 1
    vb.memory = 1024
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'off']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'off']
  end

  config.vm.synced_folder './.jupyter', '/home/vagrant/.jupyter', type: "rsync", rsync_auto: true
  config.vm.synced_folder './notebooks', '/home/vagrant/notebooks', type:"virtualbox"
  config.vm.synced_folder './docker', '/home/vagrant/docker', type: "rsync", rsync_auto: true

  config.vm.provision 'shell', inline: <<-SHELL
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -a -G docker vagrant

    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  SHELL

  config.vm.provision 'shell', run: "always", inline: <<-SHELL
    cd /home/vagrant/docker
    su vagrant -c "/usr/local/bin/docker-compose up -d"
  SHELL
end
