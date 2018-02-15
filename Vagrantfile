Vagrant.configure(2) do |config|

  config.vm.network :private_network, ip: "192.168.58.111"
  config.vm.box = "ubuntu/xenial64"
  
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1524"
  end
  config.vm.provision :shell, path: "bootstrap.sh"
  config.vm.synced_folder "./", "/var/www"


end
