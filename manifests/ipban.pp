# Definition: minecraft::ipban
#
# This definition adds an ip address to the Minecraft server's banned ip list
#
define minecraft::ipban(
  $dir    = $minecraft::homedir,
  $file   = 'banned-ips.txt',
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

  concat::fragment{"ipban_fragment_${name}":
    ensure  => $ensure,
    target  => "${dir}/${file}",
    content => $name,
    notify  => Service['minecraft']
  }
}