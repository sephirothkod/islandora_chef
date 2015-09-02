#
# Cookbook Name:: islandora
# Recipe:: frontend-custom
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

# install uploadprogress PHP extension with PEAR/PECL
php_pear "uploadprogress" do
  action :install
end

# get jwplayer from jwplayer
ark 'jwplayer' do
  url "https://account.jwplayer.com/static/download/jwplayer-#{node['jwplayer']['version']}.zip"
  checksum node['jwplayer']['sha256']
  path "#{node['drupal']['dir']}/sites/all/libraries"
  action :put
end

# get video.js from videojs
ark 'videojs' do
  url "http://www.videojs.com/downloads/video-js-#{node['videojs']['version']}.zip"
  checksum node['videojs']['sha256']
  home_dir node['videojs']['installpath']
end

# get FITS from Harvard
ark 'fits' do
  url "http://projects.iq.harvard.edu/files/fits/files/fits-#{node[:fits][:version]}.zip"
  version  node['fits']['version']
  checksum node['fits']['sha256']
  home_dir node['fits']['installpath']
end

# make FITS executable
file "/usr/share/fits/fits.sh" do
  mode "0755"
  action :touch
end

# download openseadragon javascript
# TODO: figure out a cleaner way of doing this (openseadragon exract directory is not openseadragon)
ark 'openseadragon_js' do
  url "https://github.com/openseadragon/openseadragon/releases/download/v1.1.1/openseadragon-bin-1.1.1.tar.gz"
  checksum node['openseadragon_js']['sha256']
  home_dir node['openseadragon_js']['installpath']
end


# Download files required for funky library dependencies from github
node['islandora']['supp_downloads_libraries'].each do |resource|
  # create the directory
  directory "#{node['drupal']['dir']}/sites/all/libraries/#{resource['dirname']}" do
    action :create
    recursive true
    user node['drupal']['system']['user']
    group node['drupal']['system']['group']
  end

  # download from github
  git "#{node['drupal']['dir']}/sites/all/libraries/#{resource['dirname']}" do
    repository "#{resource['repo']}"
    action :checkout
    user node['drupal']['system']['user']
    group node['drupal']['system']['group']
  end
end


# Install Islandora modules with funky dependencies
node['islandora']['funkymodules'].each do |funkymodule|

  # Checkout git repositories as Drupal modules
  git "#{node['drupal']['dir']}/sites/all/modules/#{funkymodule}" do
    repository "git://github.com/Islandora/#{funkymodule}.git"
    action :checkout
    branch node['islandora']['version']
    user node['drupal']['system']['user']
    group node['drupal']['system']['group']
  end

  # Use Drush to install downloaded modules
  drupal_module funkymodule do
    dir node['drupal']['dir']
    action :install
  end
end

# Enable some modules that were installed above
node['islandora']['modulesToEnable'].each do |enableMod|
  drupal_module enableMod do
    dir node['drupal']['dir']
    action :enable
  end
end

# Install Additional Functionality modules
node['islandora']['additionalFunctionalityModules'].each do |afmodule|

  # Checkout git repositories as Drupal modules
  git "#{node['drupal']['dir']}/sites/all/modules/#{afmodule['dirname']}" do
    repository afmodule['repo']
    action :checkout
    branch afmodule['branch']
    user node['drupal']['system']['user']
    group node['drupal']['system']['group']
  end

  # Use Drush to install downloaded modules
  drupal_module afmodule['dirname'] do
    dir node['drupal']['dir']
    action :install
  end
end

# use Drush to set Islandora default parameters
node['islandora']['default_params'].each do |param|
  drupal_module param['name'] do
    dir node['drupal']['dir']
    action param['action'].to_sym
    variable param['variable']
    value param['value']
  end
end

#WARC tools
# install packages essential for WARC tools
execute "apt-get install" do
  environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  command "apt-get install python-setuptools python-unittest2 -y --force-yes"
  ignore_failure false
end

# download WARC tools from github
git "/home/vagrant/warctools" do
  repository "https://github.com/internetarchive/warctools.git"
  action :checkout
  user 'vagrant'
  group 'vagrant'
end

# run make commands on WARC tools
execute "warc build" do
  environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  command "cd /home/vagrant/warctools && ./setup.py build && sudo ./setup.py install"
  ignore_failure false
end

# Tesseract
# install leptonica
execute "apt-get install leptonica" do
  environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  command "apt-get install libleptonica-dev -y --force-yes"
  ignore_failure false
end

# download tesseract source
ark 'tesseract-ocr' do
  url "https://tesseract-ocr.googlecode.com/files/tesseract-ocr-#{node['tesseract']['version']}.tar.gz"
  version  node['tesseract']['version']
  checksum node['tesseract']['sha256']
  home_dir node['tesseract']['installpath']
end

# run make commands on tesseract source to build it
execute "tesseract build from source" do
  environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  command "cd #{node['tesseract']['installpath']} && sudo ./autogen.sh && sudo ./configure && sudo make && sudo make install && sudo ldconfig"
  creates "/usr/local/bin/tesseract"
  ignore_failure false
end

# download tesseract language data (english)
ark 'tesseract-ocr-english-language-data' do
  url "https://tesseract-ocr.googlecode.com/files/tesseract-ocr-#{node['tesseract_engdata']['version']}.eng.tar.gz"
  checksum node['tesseract_engdata']['sha256']
  path node['tesseract_engdata']['installpath']
  strip_components 2
  action :put
end

# place it in the tesseract directory
execute "move-english-language-files" do
  environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  command "cd #{node['tesseract_engdata']['installpath']} && sudo mv tesseract-ocr-english-language-data/* . && sudo rm -rf tesseract-ocr-english-language-data"
  ignore_failure false
end

# FFmpeg
#install libfaac (this is non-free, but required for MP4 streaming derivatives)
execute "sudo sed -i '/^# deb.*multiverse/ s/^# //' /etc/apt/sources.list && sudo apt-get update && sudo apt-get install libfaac-dev -y --force-yes" do
  environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  ignore_failure false
end

# install requirements
execute "sudo apt-get install autoconf automake build-essential libass-dev libfreetype6-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev yasm libx264-dev libmp3lame-dev unzip x264 libgsm1-dev libopencore-amrnb-dev libopencore-amrwb-dev libopenjpeg-dev libschroedinger-dev libspeex-dev libvpx-dev libxvidcore-dev libdc1394-22-dev -y --force-yes" do
  environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  ignore_failure false
end

# download FFmpeg source
ark 'ffmpeg' do
  url "http://www.ffmpeg.org/releases/ffmpeg-#{node['ffmpeg']['version']}.tar.gz"
  version node['ffmpeg']['version']
  checksum node['ffmpeg']['sha256']
  home_dir node['ffmpeg']['install_path']
end

# run make commands on FFmpeg source to build it
execute "ffmpeg build from source" do
  environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  command "cd #{node['ffmpeg']['installpath']} && sudo ./configure --enable-gpl --enable-version3 --enable-nonfree --enable-postproc --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libdc1394 --enable-libfaac --enable-libgsm --enable-libmp3lame --enable-libopenjpeg --enable-libschroedinger --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libxvid && sudo make && sudo make install && sudo ldconfig"
  creates "/usr/local/bin/ffmpeg"
  ignore_failure false
end

# install colorbox library
execute "install colorbox library" do
  environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
  command "cd /var/www/drupal/htdocs/sites/all/libraries && drush colorbox-plugin"
  creates "/var/www/drupal/htdocs/sites/all/libraries/colorbox"
  ignore_failure false
end

# use Drush to install Islandora solution pack objects
node['islandora']['solution_pack_objects'].each do |param|
  drupal_module param do
    dir node['drupal']['dir']
    action :ispiro
  end
end

# template php.ini
template "/etc/php5/apache2/php.ini" do
  source "php.ini.erb"
  notifies :restart, "service[apache2]"
end
