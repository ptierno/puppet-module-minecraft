# Definition: minecraft::whitelist
#
# This definition adds a player to the Minecraft server's whitelist
#
define minecraft::whitelist(
  $file   = 'white-list.txt',
  $ensure = 'present'
){

  include ::minecraft

  concat::fragment{"whitelist_fragment_${name}":
    ensure  => $ensure,
    target  => "${::minecraft::homedir}/${file}",
    content => $name,
    notify  => Service['minecraft']
  }
}
