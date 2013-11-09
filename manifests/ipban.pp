# Definition: minecraft::ipban
#
# This definition adds an ip address to the Minecraft server's banned ip list
#
define minecraft::ipban(
  $file   = 'banned-ips.txt',
  $ensure = 'present'
){

  include ::minecraft
  
  concat::fragment{"ipban_fragment_${name}":
    ensure  => $ensure,
    target  => "${::minecraft::homedir}/${file}",
    content => $name,
    notify  => Service['minecraft']
  }
}