# Definition: minecraft::ban
#
# This definition adds an ip address to the Minecraft server's banned ip list
#
define minecraft::ban(
  $file   = 'banned-players.txt',
  $ensure = 'present'
){

  include ::minecraft
  
  concat::fragment{"ban_fragment_${name}":
    ensure  => $ensure,
    target  => "${::minecraft::homedir}/${file}",
    content => $name,
    notify  => Service['minecraft']
  }
}