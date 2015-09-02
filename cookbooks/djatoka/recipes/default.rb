#
# Cookbook Name:: djatoka
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

include_recipe 'ark'

# Download Djatoka
ark 'adore-djatoka' do
  url "http://downloads.sourceforge.net/project/djatoka/djatoka/#{node['djatoka']['version']}/adore-djatoka-#{node['djatoka']['version']}.tar.gz"
  version node['djatoka']['version']
  checksum node['djatoka']['sha256']
  home_dir node['djatoka']['installpath']

  # add platform-specific kdu binaries to global PATH
  has_binaries ["bin/#{node['djatoka']['platform']}/kdu_compress", "bin/#{node['djatoka']['platform']}/kdu_expand"]
end

# Create the ld.conf.d file required for kdu to work
template "/etc/ld.so.conf.d/kdu_libs.conf" do
  source "kdu_libs.conf.erb"
  mode 0644
end

# link to required SO libraries for kdu
execute "ldconfig_kdu" do
  only_if "test `ldconfig -p | grep -c kdu_` -eq 0"
  command "ldconfig"
  action :run
end

# set additional Tomcat runtime options to include kdu libraries
node.default['tomcat']['catalina_options'] = "-Dkakadu.home=#{node['djatoka']['installpath']}/bin/#{node['djatoka']['platform']} -Djava.library.path=#{node['djatoka']['installpath']}/lib/#{node['djatoka']['platform']} -DLD_LIBRARY_PATH=#{node['djatoka']['installpath']}/lib/#{node['djatoka']['platform']}"

# Symlink WAR file into Tomcat
link "#{node['tomcat']['webapp_dir']}/adore-djatoka.war" do
  to "#{node['djatoka']['installpath']}/dist/adore-djatoka.war"
  owner node['tomcat']['user']
  owner node['tomcat']['group']
end

# Wait until the directory exists
ruby_block "wait for WAR to extract" do
  block do
    tries = 5
    folder = "#{node['tomcat']['webapp_dir']}/adore-djatoka/WEB-INF/classes"
    until (tries -= 1).zero? or File.directory? folder
      sleep 10
    end
    Chef::Application.fatal! "Unable to extract WAR file to: #{folder}" unless File.directory? folder
  end
end

# Put the djatoka logging file in place
template "#{node['tomcat']['webapp_dir']}/adore-djatoka/WEB-INF/classes/log4j.properties" do
  source "log4j.properties.erb"
  owner node['tomcat']['user']
  owner node['tomcat']['group']
  mode "0755"
end