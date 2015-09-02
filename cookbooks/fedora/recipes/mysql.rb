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
include_recipe 'database::mysql'

# define the database connection
mysql_connection = ({
  :host => node['mysql']['bind_address'],
  :username => 'root',
  :password => node['mysql']['server_root_password']})

# create the fedora mysql database
mysql_database node['fedora']['database']['name'] do
  connection mysql_connection
  encoding 'utf8'
  collation 'utf8_unicode_ci'
  action :create
end

# create the fedora mysql user
mysql_database_user node['fedora']['database']['username'] do
  connection mysql_connection
  password node['fedora']['database']['password']
  action :create
end

# grant permissions to localhost
mysql_database_user node['fedora']['database']['username'] do
  connection mysql_connection
  password node['fedora']['database']['password']
  database_name node['fedora']['database']['name']
  host node['mysql']['bind_address']
  action :grant
end

# set database type to mysql
node.default['fedora']['database']['type'] = 'mysql'

# install fedora
include_recipe 'fedora-commons::default'
