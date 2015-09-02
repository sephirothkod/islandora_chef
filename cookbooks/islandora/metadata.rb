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

name             'islandora'
maintainer       'MJ Suhonos'
maintainer_email 'mjsuhonos@ryerson.ca'
license          "Apache 2.0 <http://www.apache.org/licenses/LICENSE-2.0.html>"
description      'Installs/Configures Islandora'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '7.1.4'

# Use specific versions of recipes because upstream versions have bugs
depends          'mysql', '= 5.5.3'
depends          'tomcat', '= 0.15.12'

depends          'djatoka'
depends          'fedora-commons'
depends          'solr'
depends          'gsearch'
depends          'git'
depends          'drupal'
