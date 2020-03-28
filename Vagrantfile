Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "forwarded_port", guest: 8080, host: 5123
  config.vm.network "forwarded_port", guest: 81, host: 5124
  config.vm.network "forwarded_port", guest: 80, host: 5125
  config.vm.provision "shell", path: "./provision.sh"
end
