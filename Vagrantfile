# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
# Update apt and get dependencies
sudo yum update
sudo yum install -y unzip curl wget vim

# Download Nomad
echo Fetching Nomad...
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/0.2.3/nomad_0.2.3_linux_amd64.zip -o nomad.zip
wget https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_amd64.zip -O consul.zip
wget https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_web_ui.zip -O consul-ui.zip

echo Installing Consul...
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul
sudo mkdir /etc/consul.d
sudo chmod a+w /etc/consul.d
sudo mkdir -p /opt/consul/data/

echo Installing Consul Web UI...
sudo mkdir -p /opt/consul/www/ui
sudo unzip consul-ui.zip -d /opt/consul/www/ui/

sudo chmod -R a+w /opt/consul

echo Installing Nomad...
unzip nomad.zip
sudo chmod +x nomad
sudo mv nomad /usr/bin/nomad
sudo mkdir -p /opt/nomad/data/

sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d
sudo chmod -R a+w /opt/nomad

SCRIPT

Vagrant.configure(2) do |config|
  #config.vm.box = "puphpet/centos65-x64"
  config.vm.box = "Cent7"
  config.vm.provision "shell", inline: $script, privileged: false
  config.vm.provision "docker" # Just install it

  config.vm.define "n1" do |n1|
      n1.vm.hostname = "n1"
      n1.vm.network "private_network", ip: "172.20.20.10"
  end

  config.vm.define "n2" do |n2|
      n2.vm.hostname = "n2"
      n2.vm.network "private_network", ip: "172.20.20.11"
  end

  # Increase memory for Parallels Desktop
  config.vm.provider "parallels" do |p, o|
    p.memory = "1024"
  end

  # Increase memory for Virtualbox
  config.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
  end

  # Increase memory for VMware
  ["vmware_fusion", "vmware_workstation"].each do |p|
    config.vm.provider p do |v|
      v.vmx["memsize"] = "1024"
    end
  end

end
