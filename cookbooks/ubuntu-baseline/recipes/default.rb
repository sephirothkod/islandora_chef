#
# Cookbook Name:: ubuntu-baseline
# Recipe:: default
#
# Copyright (C) 2013 MJ Suhonos
#
# MIT License <http://mit-license.org>
#

include_recipe 'apt::default'
include_recipe 'unattended_upgrades::default'
include_recipe 'ubuntu-baseline::apt_get_upgrade'
include_recipe 'build-essential::default'
