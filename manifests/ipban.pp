# Definition: minecraft::ipban
#
# This definition adds an ip address to the Minecraft server's banned ip list
#
define minecraft::ipban(
  $dir   = $minecraft::homedir,
  $file  = 'banned-ips.txt',
  $owner = $minecraft::user,
  $group = $minecraft::group,
  $mode  = '0644'
){
  concat{"${dir}/${file}":
    owner => $owner,
    group => $group,
    mode  => $mode,
    force => true,
    warn  => true,
  }

  concat::fragment{"ipban_fragment_${name}":
    target  => "${dir}/${file}",
    content => $name,
    notify  => Service['minecraft']
  }
}