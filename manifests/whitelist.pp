# Definition: minecraft::whitelist
#
# This definition adds a player to the Minecraft server's whitelist
#
define minecraft::whitelist(
  $dir    = $minecraft::homedir,
  $file   = 'white-list.txt',
  $ensure = 'present'
){

  include minecraft

  concat::fragment{"whitelist_fragment_${name}":
    ensure  => $ensure,
    target  => "${dir}/${file}",
    content => $name,
    notify  => Service['minecraft']
  }
}
