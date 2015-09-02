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

# Version of Djatoka to install
default['djatoka']['version'] = '1.1'
default['djatoka']['sha256'] = '2eebdb81ceadb20aebe56e5d4bcbc9b4969170609a410ca03f6049a68013d3a9'

# System-specific Djatoka root path
default['djatoka']['installpath'] = '/usr/share/djatoka'

# Assumine x64 Linux for now
# TODO: determine what platform we are using using eg. RUBY_PLATFORM
default['djatoka']['platform'] = 'Linux-x86-64' # reported as 'x86_64-linux'

# Ensure Oracle JDK since OpenJDK is incompatible
default['java']['install_flavor'] = "oracle"
default['java']['oracle']['accept_oracle_download_terms'] = true
