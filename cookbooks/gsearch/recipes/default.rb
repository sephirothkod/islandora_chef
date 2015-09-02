#
# Cookbook Name:: gsearch
# Recipe:: default
#
# Copyright 2013, University of Toronto Libraries, Ryerson University Library and Archives
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

### This recipe assumes that solr has been installed and attributes are defined

# Install ant using package manager
package "ant" do
  action :install
end

package "ant-contrib" do
  action :install
end

include_recipe 'ark'

# Download GSearch
ark 'gsearch' do
  url "http://downloads.sourceforge.net/fedora-commons/fedoragsearch-#{node[:gsearch][:version]}.zip"
  version node[:gsearch][:version]
  checksum node[:gsearch][:sha256]
  home_dir node[:gsearch][:installpath]
end

# Symlink WAR file into Tomcat
link "#{node[:tomcat][:webapp_dir]}/fedoragsearch.war" do
  to "#{node[:gsearch][:installpath]}/fedoragsearch.war"
  owner node[:tomcat][:user]
  group node[:tomcat][:group]
end

# Wait until the directory exists
ruby_block "wait for WAR to extract" do
  block do
    tries = 5
    folder = "#{node[:tomcat][:webapp_dir]}/fedoragsearch"
    until (tries -= 1).zero? or File.directory? folder
      sleep 10
    end
    Chef::Application.fatal! "Unable to extract WAR file to: #{folder}" unless File.directory? folder
  end
end

# Generate templated FgsConfig properties
template "#{Chef::Config[:file_cache_path]}/install.properties" do
  source "fgsconfig.properties.erb"
  owner node[:tomcat][:user]
  group node[:tomcat][:group]
end

# Create GSearch config using templated property file
execute "generate gsearch config" do
  cwd "#{node[:tomcat][:webapp_dir]}/fedoragsearch/FgsConfig/"
  command "ant -f fgsconfig-basic.xml -propertyfile #{Chef::Config[:file_cache_path]}/install.properties"
end

# Put the new logging file in place
template "#{node[:tomcat][:webapp_dir]}/fedoragsearch/WEB-INF/classes/log4j.properties" do
  source "log4j.properties.erb"
  owner node[:tomcat][:user]
  group node[:tomcat][:group]
end

# Delete the old XML logging file
file "#{node[:tomcat][:webapp_dir]}/fedoragsearch/WEB-INF/classes/log4j.xml" do
  action :delete
end