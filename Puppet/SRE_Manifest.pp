group {
  'SRE_TestGroup':
    ensure    => present,
}

user {
  'SRE_TestUser':
    ensure    => present,
    password  => 'letmein123',
    groups    => 'SRE_TestGroup'
}

$sre_directories = [
  'C:\SRE_Task',
  'C:\SRE_Task\Logs',
  'C:\SRE_Task\Maintenance'
]

file {
  $sre_directories:
    ensure => directory
}

acl {
  $sre_directories:
    permissions => [
        { identity => 'SRE_TestGroup', rights => ['full'] }
      ]
}

file {
  'C:\SRE_Task\Maintenance\Logfile-Maintenance.ps1':
    source => 'https://raw.githubusercontent.com/ObsidianPhoenix/SRE.Task/master/MaintenanceScript/Logfile-Maintenance.ps1',
    ensure => file
}
