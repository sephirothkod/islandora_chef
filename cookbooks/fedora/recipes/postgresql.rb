#
# Cookbook Name:: fedora-commons
# Recipe:: postgresql
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

# install postgresql
include_recipe 'postgresql'
include_recipe 'postgresql::server'
include_recipe 'database::postgresql'

# define the database connection
postgres_connection = ({
  :host => node['postgresql']['config']['listen_addresses'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']})

# create the fedora postgresql database
postgresql_database node['fedora']['database']['name'] do
  connection postgres_connection
  action :create
end

# create the fedora postgresql user
postgresql_database_user node['fedora']['database']['username'] do
  connection postgres_connection
  password node['fedora']['database']['password']
  action :create
end

# grant permissions to localhost
postgresql_database_user node['fedora']['database']['username'] do
  connection postgres_connection
  password node['fedora']['database']['password']
  database_name node['fedora']['database']['name']
  host node['postgresql']['config']['listen_addresses']
  action :grant
end

# set database type to postgresql
node.default['fedora']['database']['type'] = 'postgresql'

# install fedora
include_recipe 'fedora-commons::default'