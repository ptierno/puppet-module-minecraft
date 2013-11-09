# Definition: minecraft::whitelist
#
# This definition adds a player to the Minecraft server's whitelist
#
define minecraft::whitelist(
  $dir    = $minecraft::homedir,
  $file   = 'white-list.txt',
  $ensure = 'present',
  $owner  = $minecraft::user,
  $group  = $minecraft::group,
  $mode   = '0644'
){

  include minecraft

  concat{"${dir}/${file}":
    owner          => $owner,
    group          => $group,
    mode           => $mode,
    ensure_newline => true
  }

  concat::fragment{"whitelist_fragment_${name}":
    ensure  => $ensure,
    target  => "${dir}/${file}",
    content => $name,
    notify  => Service['minecraft']
  }
}
