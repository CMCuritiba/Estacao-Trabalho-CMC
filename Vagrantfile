# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "etv6-21"
  config.vm.box = "aaronvonawesome/linux-mint-21-cinnamon"
  config.vm.disk :disk, size: "15GB", primary: true
  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.memory = 2048
    vb.cpus = 2
  end
end
