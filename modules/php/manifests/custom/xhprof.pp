define php::custom::xhprof (
  $output_dir = '/home/vagrant/xhprof'
) {
    if !defined(File[$output_dir]) {
      file { $output_dir :
        ensure => directory,
        owner  => 'www-data'
      }
    }

    exec { 'xhprof-output-dir' :
      command => "echo 'xhprof.output_dir=\"${output_dir}\"' >> ${php::params::config_dir}/pecl-xhprof.ini",
      path    => '/bin',
      require => Exec["pecl-xhprof"]
    }

    git::repo { 'xhprof' :
      path   => '/var/www/xhprof',
      source => 'https://github.com/facebook/xhprof.git'
    }

    exec { 'chown-xhprof-output' :
      command => "chown www-data ${output_dir} -R",
      path    => '/bin',
      require => [
        File[$output_dir],
        Git::Repo['xhprof']
      ]
    }
}
