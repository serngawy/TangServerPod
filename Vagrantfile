$install_tangserver = <<SCRIPT
 sudo dnf -y install tang firewalld tcpdump
 sudo systemctl start firewalld
 sudo systemctl enable firewalld
 sudo firewall-cmd --add-service=http --permanent
 sudo firewall-cmd --reload
 sudo systemctl enable tangd.socket --now
 sudo systemctl show tangd.socket -p Listen
SCRIPT

$install_clevis = <<SCRIPT
 sudo dnf -y install cryptsetup clevis clevis-luks clevis-dracut 
SCRIPT

disk = './encryptedDisk.vdi'

Vagrant.configure("2") do |config|
  config.vm.box = "fedora/32-cloud-base"
  config.vm.box_version = "32.20200422.0"
  config.vm.define :tangserver do |tangserver|
    tangserver.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      v.customize ["modifyvm", :id, "--memory", "2048"]
    end
    tangserver.vm.network "private_network",  ip: "192.168.99.200"
    tangserver.vm.hostname = "TangServer-VM"
    tangserver.vm.provision :shell, :inline => $install_tangserver
  end

  config.vm.define :tangserver1 do |tangserver1|
    tangserver1.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      v.customize ["modifyvm", :id, "--memory", "1024"]
    end
    tangserver1.vm.network "private_network",  ip: "192.168.99.205"
    tangserver1.vm.hostname = "TangServer1-VM"
    tangserver1.vm.provision :shell, :inline => $install_tangserver
  end
end

Vagrant.configure("2") do |config|
  # config.vm.box = "fedora/32-cloud-base"
  # config.vm.box_version = "32.20200422.0"

  BOX_URL = "https://oracle.github.io/vagrant-projects/boxes"
  BOX_NAME = "oraclelinux/8"

  config.vm.box = BOX_NAME
  config.vm.box_url = "#{BOX_URL}/#{BOX_NAME}.json"
  config.vm.box_version = "8.2.144"

  config.vm.define :tangclient do |tangclient|
    tangclient.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      v.customize ["modifyvm", :id, "--memory", "2048"]
      #v.gui = true
      unless File.exist?(disk)
      	v.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 512]
      end
      v.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
    end

    tangclient.vm.network "private_network",  ip: "192.168.99.201"
    tangclient.vm.hostname = "TangClient-VM"
    tangclient.vm.provision :shell, :inline => $install_clevis
  end
end
