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
  $dir    = $minecraft::homedir,
  $file   = 'server.properties',
  $ensure = 'present',
  $owner  = $minecraft::owner,
  $group  = $minecraft::group,
  $mode   = '0664',
  $value,
){
  concat{"${dir}/${file}":
    owner => $owner,
    group => $group,
    mode  => $mode,
    force => true,
    warn  => true,
  }

  concat::fragment{"server_prop_fragment_${name}":
    ensure  => $ensure,
    target  => "${dir}/${file}",
    content => "${name}=${value}",
    notify  => Service['minecraft']
  }
}
