#
# Cookbook Name:: fedora-commons
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

# Download Fedora installer
remote_file "#{Chef::Config['file_cache_path']}/fcrepo-installer.jar" do
  source "http://downloads.sourceforge.net/project/fedora-commons/fedora/#{node['fedora']['version']}/fcrepo-installer-#{node['fedora']['version']}.jar"
  mode "0644"
  checksum node['fedora']['sha256']
  action :create_if_missing
end

# Generate templated install properties
template "template install.properties" do
  source "install.properties.erb"
  path "#{Chef::Config['file_cache_path']}/install.properties"
  mode "0644"
end

# Install Fedora using templated properties
execute "install fedora" do
  command "java -jar #{Chef::Config['file_cache_path']}/fcrepo-installer.jar #{Chef::Config['file_cache_path']}/install.properties"
  creates "#{node['fedora']['installpath']}/server/config/fedora.fcfg"
  action :run
end

# Set ownership of Fedora directory tree to Tomcat user
execute "set tomcat ownership" do
  command "chown -R #{node['tomcat']['user']}:#{node['tomcat']['group']} #{node['fedora']['installpath']}"
end