# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 1080, host: 1080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

  # Install postgresql
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update; 
    apt-get install -y postgresql postgresql-server-dev-9.5
    sudo -u postgres createuser ubuntu -s; true
  SHELL
  
  # Install erlang 20.1
  config.vm.provision "shell", inline: <<-SHELL
    if [[ $(erl +V 2>&1) != Erlang*9.1* ]]
    then
      apt-get update
      apt-get -y install build-essential libncurses5-dev openssl libssl-dev fop xsltproc unixodbc-dev
      cd /tmp
      wget -q http://www.erlang.org/download/otp_src_20.1.tar.gz
      tar zxvf otp_src_20.1.tar.gz
      cd otp_src_20.1
      export ERL_TOP=$(pwd)
      ./configure && make && make install
      rm -rf /tmp/otp_src_20.1.tar.gz otp_src_20.1
    else
      echo Seems Erlang 20.1 is already installed
    fi
  SHELL

  # Install Elixir 1.5.2
  config.vm.provision "shell", inline: <<-SHELL
    ELIXIR_DIR=/usr/local/lib/Elixir-1.5.2
    if [ ! -d $ELIXIR_DIR ]
    then
      mkdir $ELIXIR_DIR
      cd $ELIXIR_DIR
      wget -q https://github.com/elixir-lang/elixir/releases/download/v1.5.2/Precompiled.zip
      unzip Precompiled.zip
      rm Precompiled.zip
      echo '# Elixir path' >> /etc/profile
      echo 'export PATH=$PATH:/usr/local/lib/Elixir-1.5.2/bin' >> /etc/profile
    else
      echo Seems Elixir 1.5.2 is already installed
    fi
  SHELL

  config.vm.provision "shell",
    inline: "apt-get install inotify-tools"

  # Copy gitconfig
  config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"

  # Setup SSH forwarding
  config.ssh.forward_agent = true
end
