name             'ubuntu-baseline'
maintainer       'MJ Suhonos'
maintainer_email 'mj@suhonos.ca'
license          'MIT License <http://mit-license.org>'
description      'Prepares a base Ubuntu box image for installation'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1'

depends          'apt'
depends          'build-essential'
depends          'unattended_upgrades'
