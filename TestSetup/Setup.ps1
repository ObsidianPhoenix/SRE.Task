#Create the Logging Folders.
$logDirectory = "C:\SRE_Task\Logs"
$dummyLogFile = "LogTemplate.log"
New-Item -ItemType Directory -Force -Path $logDirectory #TODO: This will be managed via puppet later.

Get-ChildItem -Path "$logDirectory\*" -File -Include *.log, *.zip | Foreach-Object { Remove-Item $_ -Force }

#Create Dummy files for testing.
for ($i = 0; $i -lt 60; $i++) {
    $fileDate = (Get-Date).AddDays(-1 * $i)

    $fileName = $fileDate.ToString("yyyyMMdd")
    if ($i -gt 30) {
        $fileName = $fileName + '.zip'
        $filePath = Join-Path $logDirectory $fileName

        Compress-Archive -Path $dummyLogFile -DestinationPath $filePath -CompressionLevel Optimal
    } 
    else {
        $fileName = $fileName + '.log'
        $filePath = Join-Path $logDirectory $fileName

        Copy-Item -Path $dummyLogFile -Destination $filePath -Force
    }
}