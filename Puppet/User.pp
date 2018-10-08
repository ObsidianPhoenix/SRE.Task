user {
  'SRE_TestUser':
    ensure => present,
    password => 'letmein123',
    gid => '100'
}
