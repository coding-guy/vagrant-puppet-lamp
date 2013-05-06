$mysql_root_password = '123'

exec { 'apt-get update' :
    command => 'apt-get update',
    path    => '/usr/bin/',
}

class { 'apt' :
    always_apt_update => true
}

package { ['gcc', 'make', 'python-software-properties',
           'vim', 'curl', 'git', 'subversion'] :
    ensure  => installed,
    require => Exec['apt-get update'],
}

file { "/home/vagrant/.bash_aliases":
    source => "${settings::confdir}/files/dot/.bash_aliases",
    ensure  => present,
}

apt::ppa { 'ppa:ondrej/php5' : }

apt::builddep { 'php5' : }

class { 'git' :
    svn => true,
    gui => false,
}

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

php::ini { 'default' :
    value    => [
        'date.timezone = America/Chicago',
        'display_errors = On',
        'error_reporting = -1'
    ],
    template => 'extra-ini.erb',
    target   => 'error_reporting.ini',
    require  => Class['php'],
}

class { 'xdebug' :
    require => Package['php'],
    notify  => Service['apache'],
}

file_line { 'xdebug-cgi':
    line   => '
[xdebug]
xdebug.default_enable=1
xdebug.remote_autostart=1
xdebug.remote_connect_back=1
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_port=9000
xdebug.show_local_vars=0
xdebug.show_exception_trace=0
xdebug.var_display_max_data=10000
xdebug.var_display_max_depth=20',
    path    => '/etc/php5/apache2/php.ini',
    require => Class['php'],
    notify  => Service['apache'],
}

file_line { 'xdebug-cli':
    line   => '
[xdebug]
xdebug.default_enable=1
xdebug.remote_autostart=1
xdebug.remote_connect_back=0
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.remote_port=9000
xdebug.show_local_vars=0
xdebug.show_exception_trace=0
xdebug.var_display_max_data=10000
xdebug.var_display_max_depth=20',
    path    => '/etc/php5/cli/php.ini',
    require => Class['php']
}

class { 'mysql' :
    root_password => $mysql_root_password,
}
