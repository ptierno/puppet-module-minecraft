# == Class: minecraft::params
#
class minecraft::params {
  $user    = 'mcserver',
  $group   = 'mcserver',
  $homedir = '/opt/minecraft'
}