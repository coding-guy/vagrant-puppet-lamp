$mysql_root_password = '123'

exec { 'apt-get update' :
    command => 'apt-get update',
    path    => '/usr/bin/',
}

class { 'apt' :
    always_apt_update => true
}

package { ['gcc', 'make', 'python-software-properties',
           'vim', 'curl', 'git', 'subversion', 'git-svn'] :
    ensure  => installed,
    require => Exec['apt-get update'],
}

file { "/home/vagrant/.bash_aliases":
    source => "${settings::confdir}/files/dot/.bash_aliases",
    ensure  => present,
}

apt::ppa { 'ppa:ondrej/php5' : }

apt::builddep { 'php5' : }

class { 'apache' :
    require => Apt::Ppa['ppa:ondrej/php5'],
}

apache::module { 'rewrite' : }

apache::vhost { 'invoise':
    server_name   => 'invoise.dev',
    serveraliases => ['www.invoise.dev'],
    docroot       => '/var/www/invoi.se/web',
    port          => '80',
    priority      => '1',
}

apache::vhost { 'jtreminio':
    server_name   => 'jtreminio.dev',
    serveraliases => ['www.jtreminio.dev'],
    docroot       => '/var/www/jtreminio.com/website',
    port          => '80',
    priority      => '1',
}

apache::vhost { 'puphpet':
    server_name   => 'puphpet.dev',
    serveraliases => ['www.puphpet.dev'],
    docroot       => '/var/www/puphpet/web',
    port          => '80',
    priority      => '1',
}

class { 'php' :
    service => 'apache',
    require => Package['apache'],
}

php::module { 'cli' : }
php::module { 'curl' : }
php::module { 'intl' : }
php::module { 'mcrypt' : }
php::module { 'mysql' : }

class { 'php::pear' :
    require => Class['php'],
}

class { 'php::devel' :
    require => Class['php'],
}

php::pecl::module { 'pecl_http' :
    use_package => false,
}

class { 'xdebug' :
    require => Package['php'],
    notify  => Service['apache'],
}

xdebug::config { 'default' :
    default_enable        => '1',
    remote_autostart      => '1',
    remote_connect_back   => '1',
    remote_enable         => '1',
    remote_handler        => 'dbgp',
    remote_port           => '9000',
    show_local_vars       => '0',
    var_display_max_data  => '10000',
    var_display_max_depth => '20',
    show_exception_trace  => '0'
}

class { 'mysql' :
    root_password => $mysql_root_password,
}
