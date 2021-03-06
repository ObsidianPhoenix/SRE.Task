**Contents**

This Repository contains several elements for Log File Maintenance:

1. [Logfile-Maintenance.ps1](MaintenanceScript/Logfile-Maintenance.ps1) - A Powershell script that will clean up logfiles generated by the application
2. [SRE_Manifest.pp](Puppet/SRE_Manifest.pp) - A puppet manifest that creates the relevant directories and sets up the log management task
3. [Setup.ps1](TestSetup/Setup.ps1) - A basic script that will create test log files for the last 60 days.

**Assumptions:**

1. Windows Server Machine
2. Log Files are generated to `C:\SRE_Task\Logs`
3. Log Files are created in date format, e.g. `20181008.log`
4. Maintenance should verify a minimum free disk space
5. Maintenance should *NOT* delete logs inside retention policy to ensure #2
6. If Minimum free space requirement is not met. Some action should be taken. (**NB:** This action is discussed but not implemented)
7. Puppet has the puppetlabs-acl module installed
        `puppet module install puppetlabs-acl --version 2.0.1`