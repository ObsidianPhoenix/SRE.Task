$sre_GroupName = 'SRE_TestGroup'

#Create the user and the group
group {
  $sre_GroupName:
    ensure    => present,
}

user {
  'SRE_TestUser':
    ensure    => present,
    password => 'letmein123',
    groups    => $sre_GroupName
}

#Create the Directories with the appropriate permissions
$sre_directories = [
  'C:\SRE_Task',
  'C:\SRE_Task\Logs',
  'C:\SRE_Task\Maintenance'
]

file {
  $sre_directories:
    ensure => directory
}

file {
  'C:\SRE_Task\Maintenance\Logfile-Maintenance.ps1':
    source => 'https://raw.githubusercontent.com/ObsidianPhoenix/SRE.Task/master/MaintenanceScript/Logfile-Maintenance.ps1',
    ensure => file
}

acl {
  $sre_directories:
    permissions => [
        { identity => $sre_GroupName, rights => ['read', 'write', 'modify'] }
      ]
}

#Create the Job to clean up the Log Files.
scheduled_task {
  'SRE_Task Logfile Maintenance':
    ensure => present,
    enabled => true,
    command => 'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe',
    arguments => '-ExecutionPolicy Bypass c:\sre_task\maintenance\logfile-maintenance.ps1',
    trigger => {
      schedule => daily,
      every => 1,
      start_date => '2011-08-31', #This resets the scheduled job whenever it is run. Is there a way to stop it doing this?
      start_time => '08:00',
      minutes_interval => '5' #Run every 5 minutes for testing. In reality, we'd probably want to run this daily or hourly?
    }
}
