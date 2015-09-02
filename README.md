# Islandora Chef

## Description

This cookbook will install and configure [Islandora](http://islandora.ca). Current version is 7.1.4.

Included [Vagrant](http://www.vagrantup.com) and [Berkshelf](http://berkshelf.com) files for easy VM creation

## Requirements

* [VirtualBox](https://www.virtualbox.org/)
* Ruby ([rbenv](https://github.com/sstephenson/rbenv) is handy for managing your Ruby installs)
* [Vagrant](http://localhost:8181) 1.5.2+
* [Bundler](http://bundler.io/) (`gem install bundler`)
* Berkshelf (`gem install berkshelf`)
* vagrant-berkshelf 2.0.1

## Platform

* Ubuntu 12.04
* Fedora 3.7.0
* GSearch 2.6.2
* Solr 4.2.0
* Drupal 7.33
* PHP 5.3.10
* Java 7 (Oracle)
* Djatoka 1.1
* Tomcat 7
* Apache 2.2.22
* PHP 5.3.10
* MySQL 5.5.40

## Cookbooks

* [drupal](http://github.com/gondoi/drupal-cookbook)
* ubuntu-baseline
* djatoka
* fedora
* solr
* gsearch

## Attributes

* `node["islandora"]["version"]` - The version of Islandora to install, in the format `7.x-1.4`. Default is `HEAD`.
* `node["drupal"]["site"]["name"]` - The Drupal website name, default is `Islandora Sandbox`.
* `node["drupal"]["site"]["admin"]` - The Drupal administrator username, default is `admin`.
* `node["drupal"]["site"]["pass"]` - The Drupal administrator password, default is `islandora`.
* `node["drupal"]["db"]["password"]` - The Drupal database password, default is `islandora`.
	* [complete list of Drupal attributes](https://github.com/gondoi/drupal-cookbook#attributes)
* `node["tomcat"]["base_version"]` - The version of Tomcat to install, default is `7`.
	* [complete list of Tomcat attributes](https://github.com/opscode-cookbooks/tomcat#attributes)
* `node["java"]["jdk_version"]` - JDK version to install, default is `7`.
* `node["java"]["install_flavor"]` - Flavor of JVM you would like installed, default is `oracle` to support Djatoka.
	* [complete list of Java attributes](https://github.com/agileorbit-cookbooks/java#attributes)
* `node["php"]["upload_max_filesize"]` - The maximum size of an uploaded file, default is `200M`.
* `node["php"]["post_max_size"]` - The maximum size of POST data allowed, default is `200M`.
	* [complete list of PHP attributes](https://github.com/opscode-cookbooks/php#attributes)
* `node['mysql']['server_root_password']` - Root password for the mysql database, default is `rootpass`.
	* [complete list of MySQL attributes](https://github.com/opscode-cookbooks/mysql#attributes)
* `node['fits']['techmd_version']` - Version of FITS to install, default is `0.8.3`.
* `node['fits']['techmd_dsid']` - The default datastream ID for FITS, default is `TECHMD_FITS`.
* `node['tesseract']['version']` - Version of Tesseract to install, default is `3.02.02`.
* `node['ffmpeg']['version']` - Version of FFmpeg to install, default is `1.1.4`.
* `node['jwplayer']['version']` - Version of JWPlayer to install, default is `6.10`.
* `node['videojs']['version']` - Version of video.js to install, default is `4.0.0`.

## Usage

1. `git clone https://github.com/ryersonlibrary/islandora_chef`
2. `cd islandora_chef`
3. `bundle`
4. `berks`
5. `vagrant plugin install vagrant-berkshelf --plugin-version '= 2.0.1'`
6. `vagrant plugin install vagrant-omnibus`
7. `vagrant up`
8. Enjoy your new Islandora instance at [http://localhost:8181](http://localhost:8181)!

## Known Issues

If you get an error like [this](https://gist.github.com/ruebot/439c6a23992e6660edcd) after step 7, you will need to edit the vagrant-berkshelf config as described [here](https://github.com/berkshelf/vagrant-berkshelf/issues/228#issue-47313643) or [here](https://github.com/berkshelf/vagrant-berkshelf/issues/228#issuecomment-62207197).

## License

[Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)

## Author

* MJ Suhonos (<mjsuhonos@ryerson.ca>)
* Paul Church (<pchurch@ryerson.ca>)
* Nick Ruest (<ruestn@yorku.ca>)

## Acknowledgements

Many thanks to [Graham Stewart](https://github.com/whitepine23) and others at the University of Toronto Libraries for [LibraryChef](https://github.com/utlib/chef-islandora).
