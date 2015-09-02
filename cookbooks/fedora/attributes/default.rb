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

# Version of Fedora Commons to install
default['fedora']['version'] = '3.7.0'
default['fedora']['sha256'] = '40d3fe844cf8d20d9556e369792d162c2eb54c46274126da6734db09d0a3521c'

# System-specific Fedora root path
default['fedora']['installpath'] = '/usr/local/fedora'

# Default install.properties values
default['fedora']['context'] = 'fedora'
default['fedora']['adminuser'] = 'fedoraAdmin'
default['fedora']['adminpassword'] = 'fedoraAdmin'

# Database connection information; use built-in Derby by default
default['fedora']['database']['name'] = 'fedora3'
default['fedora']['database']['username'] = 'fedoraAdmin'
default['fedora']['database']['password'] = 'fedoraAdmin'
