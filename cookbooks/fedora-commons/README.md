# Description

This cookbook will install and configure [Fedora Commons](http://www.fedora-commons.org), supporting:

* Apache Derby (embedded)
* PostgreSQL
* MySQL

Included [Vagrant](http://www.vagrantup.com) and [Berkshelf](http://berkshelf.com) files for easy VM creation

# Requirements

## Platform

Tested on Ubuntu 12.04 (precise) and CentOS 6.4

## Cookbooks
* java
* tomcat
* database
* mysql
* postgresql

# Attributes
__TODO__

# Usage
Vagrant example (assumes Virtualbox & Vagrant are installed)

1. `git clone https://github.com/ryersonlibrary/fedora`
2. `cd fedora`
3. `bundle`
4. `berks`
5. `vagrant plugin install vagrant-berkshelf`
6. `vagrant plugin install vagrant-omnibus`
7. `vagrant up`
8. Enjoy your new instance at http://localhost:8080!

## Recipes
#### Default
- install/configure Fedora Commons using embedded Derby as the database

#### MySQL
- install/configure Fedora Commons using a MySQL instance on same node

#### PostgreSQL
- install/configure Fedora Commons using a PostgreSQL instance on same node

# How to

Vagrant example (assumes Virtualbox & Vagrant are installed)

1. `git clone https://github.com/mjsuhonos/fedora-cookbook`
2. `cd fedora-cookbook`
3. `bundle`
4. `berks`
5. `vagrant plugin install vagrant-berkshelf`
6. `vagrant plugin install vagrant-omnibus`
7. `vagrant up`
8. Enjoy your new fcrepo instance at http://localhost:8080!

# License
[Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)

# Author
Copyright © 2013 MJ Suhonos (<mjsuhonos@ryerson.ca>)

###Acknowledgements
Many thanks to Graham Stewart and others at the University of Toronto Libraries for [LibraryChef](https://github.com/LibraryChef).

Thanks also to Kai Sternad for [Instant Fedora Commons](https://github.com/kaisternad/instant-fedora-commons).
