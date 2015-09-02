#
# Cookbook Name:: ubuntu-baseline
# Recipe:: apt_get_upgrade
#
# Copyright (C) 2013 MJ Suhonos
#
# MIT License <http://mit-license.org>
#
# Do a system wide apt-get upgrade

execute "apt-get upgrade" do
  environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  command "apt-get upgrade -y --force-yes"
  ignore_failure true
end
