#
# Cookbook Name:: islandora
# Recipe:: default
#
# Copyright 2014, University of Toronto Libraries, Ryerson University Library and Archives
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

# Java Backend
include_recipe 'tomcat'
include_recipe 'djatoka' # NB: djatoka modifies tomcat's startup CLASSPATH so it has to be installed first
include_recipe 'fedora-commons::mysql'
include_recipe 'solr'
include_recipe 'gsearch' # NB: gsearch depends on fedora and solr being installed first
include_recipe 'git'
include_recipe 'islandora::backend'

# Drupal Frontend
include_recipe 'drupal::install'
include_recipe 'islandora::frontend'
include_recipe 'islandora::frontend-custom'
