# Assumptions:
# 1. Windows Server Machine
# 2. Maintenance should verify a minimum free disk space
# 3. Maintenance should *NOT* delete logs inside retention policy to ensure #2
# 4. If Minimum free space requirement is not met. Alert should be issued.

$retentionDays = 30
$logDirectory = "C:\SRE_Task\Logs"
$minimumFreeSpacePercentage = 0.8

$alertEmailAddress = "fergal.reilly@bedegaming.com"
$alertSmtpServer = "1.1.1.1"

function Remove-FilesOutwithRetentionPolicy() {
    $minDate = (Get-Date).AddDays(-1 * $retentionDays).ToString("yyyyMMdd")

    Get-ChildItem -Path "$logDirectory\*" -Include *.log, *.zip -File `
        | Where-Object { $_.Name -lt $minDate } `
        | ForEach-Object { Remove-Item $_ }
}

function Compress-OldLogs() {
    # Log files we're keeping, compress to a zip to save space.
    $currentLog = (Get-Date).ToString("yyyyMMdd")

    Get-ChildItem -Filter "*.log" `
        | Where-Object { $_.BaseName -ne $currentLog } `
        | ForEach-Object { 
            Compress-Archive $_ -DestinationPath "$($_.Name).zip" -CompressionLevel Optimal
            Remove-Item $_ -Force
        }
}

function Get-FreeSpacePercentage() {
    $drive = (Get-Item $logDirectory).PSDrive.Name
    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$($drive):'" `
        | Select-Object Size,FreeSpace

    return ($disk.FreeSpace / $disk.Size)
}

function Ensure-MinimumFreeSpace() {
    $currentPercentage = Get-FreeSpacePercentage

    if ($currentPercentage -lt $minimumFreeSpacePercentage) {
        $serverName = $env:computername

        # Options:
        # 1. Send an email - Example in comment below. Most likely would wish to limit frequency of emails to avoid spamming
        # 2. Notify some service (e.g. SCCM?)
        # 3. Take no direct action. Trust that other routines are monitoring for minimum space and alerting when this has been breached.
        # 4. Delete compressed log files inside the retention period (oldest first) to free up additional space

        # Send-MailMessage -To $alertEmailAddress `
        #     -From "SRE_Task@bedegaming.com" `
        #     -Subject "$serverName Disk Space Too Log ($currentPercentage)" `
        #     -Body "The Server space on $serverName has breached the minimum threshold after cleaning up logs for SRE_Task. Please Take action to resolve this issue." `
        #     -SmtpServer $alertSmtpServer `
        #     -Credential "SomeCredentialValues"
    }
}

function Run-LogCleanup() {
    Push-Location $logDirectory

    Remove-FilesOutwithRetentionPolicy
    Compress-OldLogs
    Ensure-MinimumFreeSpace

    Pop-Location
}

Run-LogCleanup