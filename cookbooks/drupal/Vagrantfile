# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "drupal-berkshelf"
  config.vm.box = "vagrant-ubuntu-12.04"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :private_network, ip: "33.33.33.11"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.ssh.max_tries = 40
  config.ssh.timeout   = 120
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.data_bags_path = "test/integration/data_bags"
    chef.encrypted_data_bag_secret_key_path = "test/integration/encrypted_data_bag_secret"
    chef.json = {
     :mysql => {
        :server_root_password => "root&pass",
        :server_repl_password => "repl&pass",
        :server_debian_password => "deb&pass"
     },
     :drupal => {
        :db => {
          :password => "drupalpass"
        }
      },
     :drush => {
       :options => "-v"
      }
    }

    chef.run_list = [
      "recipe[apt]",
      "recipe[drupal::install]",
      "recipe[drupal::lsyncd]"
    ]
  end
end
