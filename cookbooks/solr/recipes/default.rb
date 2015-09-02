#
# Cookbook Name:: solr
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

ark 'solr' do
  url "http://archive.apache.org/dist/lucene/solr/#{node['solr']['version']}/solr-#{node['solr']['version']}.tgz"
  version node['solr']['version']
  checksum node['solr']['sha256']
  home_dir node['solr']['installpath']
end

# Symlink WAR file into Tomcat
link "#{node['tomcat']['webapp_dir']}/solr.war" do
  to "#{node['solr']['installpath']}/dist/solr-#{node['solr']['version']}.war"
  owner node['tomcat']['user']
  group node['tomcat']['group']
end

# Configure Tomcat for Solr context
template "#{node['tomcat']['context_dir']}/solr.xml" do
  source "tomcat_solr.xml.erb"
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode 0644
end

# Basic Solr configuration
template "#{node['solr']['installpath']}/solr.xml" do
  source "solr.xml.erb"
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode 0644
end

# Create Solr core home
directory "#{node['solr']['installpath']}/#{node['solr']['core_name']}/conf" do
  action :create
  recursive true
end

execute "copy config from solr example into tomcat" do
  # NB: this will also copy a bunch of extra unrequired stuff: .html files, /xslt, /velocity
  command "cp -fr #{node['solr']['installpath']}/example/solr/collection1/conf/* #{node['solr']['installpath']}/#{node['solr']['core_name']}/conf"
end

# Set ownership of Solr core directory tree to Tomcat user
execute "set tomcat ownership" do
  command "chown -R #{node['tomcat']['user']}:#{node['tomcat']['group']} #{node['solr']['installpath']}/#{node['solr']['core_name']}"
end