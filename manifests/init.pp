# Class: minecraft
#
# This class installs and configures a Minecraft server
#
# Parameters:
# - $user: The user account for the Minecraft service
# - $group: The user group for the Minecraft service
# - $homedir: The directory in which Minecraft stores its data
# - $manage_java: Should this module manage the `java` package?
# - $manage_screen: Should this module manage the `screen` package?
# - $manage_curl: Should this module manage the `curl` package?
# - $heap_size: The maximum Java heap size for the Minecraft service in megabytes
# - $heap_start: The initial Java heap size for the Minecraft service in megabytes
#
# Sample Usage:
#
#  class { 'minecraft':
#    user      => 'mcserver',
#    group     => 'mcserver',
#    heap_size => 4096,
#  }
#
class minecraft(
  $user          = $minecraft::params::user,
  $group         = $minecraft::params::group,
  $homedir       = $minecraft::params::homedir,
  $mode          = '0644',
  $manage_java   = true,
  $manage_screen = true,
  $manage_curl   = true,
  $heap_size     = 2048,
  $heap_start    = 512
) inherits minecraft::params {

  validate_string($user)
  validate_string($group)
  validate_string($homedir)
  validate_bool($manage_java)
  validate_bool($manage_screen)
  validate_bool($manage_curl)
  validate_string($heap_size)
  validate_string($heap_size)

  if $manage_java {
    class { 'java':
      distribution => 'jre',
      before       => Service['minecraft']
    }
  }

  if $manage_screen {
    package {'screen':
      before => Service['minecraft']
    }
  }

  if $manage_curl {
    package {'curl':
      before => S3file["${homedir}/minecraft_server.jar"],
    }
  }
  
  group { $group:
    ensure => present,
  }

  user { $user:
    gid        => $group,
    home       => $homedir,
    managehome => true,
  }

  s3file { "${homedir}/minecraft_server.jar":
    source  => 'MinecraftDownload/launcher/minecraft_server.jar',
    require => User[$user],
  }

  concat{"${homedir}/banned-players.txt":
    owner          => $owner,
    group          => $group,
    mode           => $mode,
    ensure_newline => true
  }

  concat{"${homedir}/banned-ips.txt":
    owner          => $owner,
    group          => $group,
    mode           => $mode,
    ensure_newline => true
  }
  
  concat{"${homedir}/ops.txt":
    owner          => $owner,
    group          => $group,
    mode           => $mode,
    ensure_newline => true
  }
  
  concat{"${homedir}/white-list.txt":
    owner          => $owner,
    group          => $group,
    mode           => $mode,
    ensure_newline => true,
  }
  

  concat{"${homedir}/server.properties":
    owner          => $owner,
    group          => $group,
    mode           => $mode,
    ensure_newline => true
  }

  file { '/etc/init.d/minecraft':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => template('minecraft/minecraft_init.erb'),
  }

  service { 'minecraft':
    ensure    => running,
    require   => File['/etc/init.d/minecraft'],
    subscribe => S3file["${homedir}/minecraft_server.jar"],
  }
}