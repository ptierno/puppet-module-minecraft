# Definition: minecraft::server_prop
#
# This definition sets a configuration option in the Minecraft
# server.properties file
#
# Parameters:
# - $value: What the property should be set to
#
# Sample Usage:
#
#  minecraft::server_prop { 'spawn-monsters':
#    value => 'true'
#  }
#
define minecraft::server_prop(
  $file   = 'server.properties',
  $ensure = 'present',
  $value,
){

  include ::minecraft

  concat::fragment{"server_prop_fragment_${name}":
    ensure  => $ensure,
    target  => "${::minecraft::homedir}/${file}",
    content => "${name}=${value}",
    notify  => Service['minecraft']
  }
}
