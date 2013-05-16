define php::composer::run (
    $command = 'install',
    $path
) {
    exec { "composer-${path}-${command}":
        command => "composer ${command} --working-dir ${path}",
        path    => "${php::composer::install_location}",
        require => Class['php::composer'],
    }
}
