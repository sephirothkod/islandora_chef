#
# Cookbook Name:: fedora-commons
# Recipe:: mysql
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

# install mysql
include_recipe 'mysql::server'
include_recipe 'database'

# define the database connection
mysql_connection = ({
  :host => node['mysql']['bind_address'],
  :username => 'root',
  :password => node['mysql']['server_root_password']})

# create the fedora mysql database
bash node['fedora']['database']['name'] do
  code <<-EOH
    mysql -u root -prootpass -e "create database fedora3;"
    mysql -u root -prootpass -e "alter database fedora3 default charactor set utf8;"
    mysql -u root -prootpass -e "alter database fedora3 default collate utf8_bin;"
    EOH
end

# create the fedora mysql user
bash node['fedora']['database']['username'] do
  code <<-EOH
    mysql -u root -prootpass -e "create user fedoraAdmin@localhost identified by 'fedoraAdmin';"
    EOH
end

# grant permissions to localhost
bash node['fedora']['database']['username'] do
  code <<-EOH
    mysql -u root -prootpass -e "grant all on fedora3.* to fedoraAdmin@localhost;"
    mysql -u root -prootpass -e "flush privileges;"
    EOH
end

# set database type to mysql
node.default['fedora']['database']['type'] = 'mysql'

# install fedora
include_recipe 'fedora-commons::default'
