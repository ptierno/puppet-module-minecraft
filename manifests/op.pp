# Definition: minecraft::op
#
# This definition adds a player to the Minecraft server's auto-op list
#
define minecraft::op(
  $dir    = $minecraft::params::homedir,
  $file   = 'ops.txt',
  $ensure = 'present'
){

  include ::minecraft

  concat::fragment{"op_fragment_${name}":
    ensure  => $ensure,
    target  => "${dir}/${file}",
    content => $name,
    notify  => Service['minecraft']
  }
}