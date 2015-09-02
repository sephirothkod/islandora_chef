# use the latest JDK
default[:java][:jdk_version] = '7'

# set Drupal and Drush versions
default[:drupal][:version] = '7.22'
default[:drupal][:checksum] = '068d7a77958fce6bb002659aa7ccaeb7'
default[:drupal][:drush][:version] = '7.x-5.9'
default[:drupal][:drush][:checksum] = '70feb5cb95e7995c58cbf709a6d01312'

# set Solr version
default[:solr][:version] = '4.4.0'