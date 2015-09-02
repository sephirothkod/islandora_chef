#
# Cookbook Name:: islandora
# Recipe:: default
#
# Copyright (C) 2013 MJ Suhonos
# 
# MIT License <http://mit-license.org>
#

# make sure we're up-to-date
include_recipe 'apt::default'

# install drupal & drush
include_recipe 'drupal::drush'
include_recipe 'drupal::install'

# install fedora using mysql
include_recipe 'fedora::mysql'

# install solr standalone
include_recipe 'hipsnip-solr::default'