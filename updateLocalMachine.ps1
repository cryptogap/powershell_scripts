$date = Get-Date -Format "yyyy-MM-dd"
$computerName = $env:COMPUTERNAME

$time = Get-Date -Format "HH:mm:ss"

$smtpServer = "fbcad-org.mail.protection.outlook.com"
$smtpPort = "25"
$smtpFrom = "AutoWindowsUpdate@fbcad.org"
$smtpTo = "garrettpost@fbcad.org"
$messageSubject = "[$computerName] - Windows Update"

$logFileLocation = "\\192.1.2.210\GeneralShare\Logs\$date\$computerName.txt"

#create empty array to hold updates
$updates = @()

#check if folder exists and create if it doesn't
if (!(Test-Path "\\192.1.2.210\GeneralShare\Logs\$date")) {
    New-Item -ItemType Directory -Path "\\192.1.2.210\GeneralShare\Logs\$date"
}

#check if file exists and create if it doesn't
if (!(Test-Path $logFileLocation)) {
    New-Item -ItemType File -Path $logFileLocation
}


$Session = New-Object -ComObject "Microsoft.Update.Session"
$Searcher = $Session.CreateUpdateSearcher()
$Result = $Searcher.Search("IsInstalled=0 and Type='Software'")

if ($Result.Updates.Count -eq 0) {
    Write-Output "$time - No updates are available."

    #log to file that no updates are available
    Add-Content -Path $logFileLocation -Value "$time - No updates are available."

    if (!($env:COMPUTERNAME -eq "FBCAD22T-01713")) {
        #send email that no updates are available
        Send-MailMessage -From $smtpFrom -To $smtpTo -Subject $messageSubject -Body "$time - No updates are available." -SmtpServer $smtpServer -Port $smtpPort -DeliveryNotificationOption OnFailure
    }
}
else {
    Write-Output "$time - Available updates:"
    foreach ($Update in $Result.Updates) {
        Write-Output " - $($Update.Title)"

        #add updates to array
        $updates += $Update.Title

        $Downloader = $Session.CreateUpdateDownloader()
        $Downloader.Updates = $Result.Updates
        $Downloader.Download()

        $Installer = New-Object -ComObject "Microsoft.Update.Installer"
        $Installer.Updates = $Result.Updates
        $InstallationResult = $Installer.Install()

        Write-Output " - $($Update.Title) - $($InstallationResult.ResultCode)"

        if ($InstallationResult.RebootRequired) {
            Write-Output " - $($Update.Title) - Reboot required."
        }

        

        #log to file that updates are available
        Add-Content -Path $logFileLocation -Value "$time - Available updates:"
        Add-Content -Path $logFileLocation -Value " - $($Update.Title)"
        Add-Content -Path $logFileLocation -Value " - $($Update.Title) - $($InstallationResult.ResultCode)"

        if ($InstallationResult.RebootRequired) {
            Add-Content -Path $logFileLocation -Value " - $($Update.Title) - Reboot required."
        }


    }


    if (!($env:COMPUTERNAME -eq "FBCAD22T-01713")) {
        
        #Message body for email
        $messageBody = Get-Content $logFileLocation `n`n`n` + "Available updates: `n" + $updates
        #send email that no updates are available
        Send-MailMessage -From $smtpFrom -To $smtpTo -Subject $messageSubject -Body $messageBody -SmtpServer $smtpServer -Port $smtpPort -DeliveryNotificationOption OnFailure
    }

    if ($InstallationResult.RebootRequired) {
        Write-Output "Initiating reboot..."
        Restart-Computer -Force
            
    }

}
