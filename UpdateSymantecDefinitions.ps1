#check path to see if it exists
$symantec86 = "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection"
$symantec64 = "C:\Program Files\Symantec\Symantec Endpoint Protection"
$logPath = "\\192.1.2.210\GeneralShare\Logs\Symantec\UpdateLog.txt"

$date = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
$computerName = $env:COMPUTERNAME
$user = $env:USERNAME

$smtpServer = "fbcad-org.mail.protection.outlook.com"
$smtpServer2 = "mail-dm3gcc020110.inbound.protection.outlook.com"
$smtpPort = "25"
$smtpSecurePort = "587"
$smtpFrom = "AutoSymantec@fbcad.org"
$smtpTo = "garrettpost@fbcad.org"
$messageSubject = "[$computerName] - Symantec Endpoint Protection Update"
$encryption = "none"

Write-Host "----------------------------------------"
Write-host "Date: $date" -ForegroundColor Green
Write-host "Computer: $computerName" -ForegroundColor Blue
Write-host "User: $user" -ForegroundColor Yellow
Write-Host "----------------------------------------"
Write-Host "Testing if Symantec Endpoint Protection is installed on this computer..." -ForegroundColor Yellow

if (Test-Path $symantec86) {
    $symantecPath = $symantec86
    Write-Host "Symantec Endpoint Protection x86 is installed on this computer."
} elseif (Test-Path $symantec64) {
    $symantecPath = $symantec64
    Write-Host "Symantec Endpoint Protection x64 is installed on this computer."
} else {
    $messageBody = "User: $user`nComputer: $computerName`nDate: $date`n`n Symantec Endpoint Protection is not installed on this computer."


    Write-Host "Symantec Endpoint Protection is not installed on this computer." -ForegroundColor Red
    Write-Host "Writing to log file..." -ForegroundColor Blue
    Add-Content -Path $logPath -Value "Date: $date - Symantec Endpoint Protection is not installed on $computerName."
    Write-Host "Sending email to $smtpTo..." -ForegroundColor Yellow
   #send an email to the helpdesk
    Send-MailMessage -From $smtpFrom -To $smtpTo -Subject $messageSubject -Body $messageBody -SmtpServer $smtpServer -Port $smtpPort -DeliveryNotificationOption OnSuccess -Priority High
    return
}

if (Test-Path $logPath) {
    Write-Host "Log path exists."
}
else {
    Write-Host "Log path does not exist."
    return
}



    #if it exists, run the update command
    Write-Host "Symantec Endpoint Protection is installed on this computer."
    #append to log file
    Add-Content -Path $logPath -Value "Date: $date - Symantec Endpoint Protection is installed on $computerName."
    #run exe file to update definitions
    & "$symantecPath\SepLiveUpdate.exe"

    #check if update was successful
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Symantec Endpoint Protection definitions were updated successfully."
        Add-Content -Path $logPath -Value "Date: $date - Symantec Endpoint Protection definitions were updated successfully on $computerName."
    }
    else {
        $messageBody = "User: $user`nComputer: $computerName`nDate: $date`n`n Symantec Endpoint Protection was not updated successfully."


        Write-Host "Symantec Endpoint Protection definitions were not updated successfully."
        Add-Content -Path $logPath -Value "Date: $date - Symantec Endpoint Protection definitions were not updated successfully on $computerName."
        Send-MailMessage -From $smtpFrom -To $smtpTo -Subject $messageSubject -Body $messageBody + -SmtpServer $smtpServer -Port $smtpPort -DeliveryNotificationOption OnSuccess -Priority High
    }




