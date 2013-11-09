# Definition: minecraft::ban
#
# This definition adds a player to the Minecraft server's ban list
#
define minecraft::ban(
  $dir   = $minecraft::homedir,
  $file  = 'banned-players.txt',
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

  concat::fragment{"ban_fragment_${name}":
    target  => "${dir}/${file}",
    content => $name,
    notify  => Service['minecraft']
  }
}