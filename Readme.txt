Assumptions:

 1. Windows Server Machine
 2. Maintenance should verify a minimum free disk space
 3. Maintenance should *NOT* delete logs inside retention policy to ensure #2
 4. If Minimum free space requirement is not met. Alert should be issued.
 5. Puppet has the puppetlabs-acl module installed
        `puppet module install puppetlabs-acl --version 2.0.1`