# Description

Installs and configures [Islandora](http://islandora.ca).

Included [Vagrant](http://www.vagrantup.com) and [Berkshelf](http://berkshelf.com) files for easy VM creation

# Requirements

## Platform:

Tested on Ubuntu 12.04 (precise)

## Cookbooks

Opscode cookbooks:

* hipsnip-solr

Custom cookbooks:

* drupal (https://github.com/gondoi/drupal-cookbook)
* fedora commons (https://github.com/mjsuhonos/fedora-cookbook)

# Attributes
__TODO__

# Recipes

Include the Islandora recipe to install Islandora on your system; this will also automatically start the server.

	include_recipe "fedora"

### Default
- install/configure Fedora Commons using mySQL as the database
- install/configure Drupal using mySQL as the database
- install/configure Solr running in its own Tomcat instance
- __TODO__ GSearch
- __TODO__ Djatoka
- __TODO__ about eleventy-billion plugins, modules and connectors
- __TODO__ configurate everything above

# License
MIT License (<http://mit-license.org>)

# Author
Copyright © 2013 MJ Suhonos (<mjsuhonos@ryerson.ca>)

# Acknowledgements
Many thanks to Graham Stewart and others at the University of Toronto Libraries for [LibraryChef](https://github.com/LibraryChef).

Thanks also to Kai Sternad for [Instant Fedora Commons](https://github.com/kaisternad/instant-fedora-commons).