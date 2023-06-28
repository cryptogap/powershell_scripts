#check path to see if it exists
$symantec = "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection"
$logPath = "\\192.1.2.210\GeneralShare\Logs\Symantec\UpdateLog.txt"

$date = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
$computerName = $env:COMPUTERNAME
$user = $env:USERNAME

$smtpServer = "fbcad-org.mail.protection.outlook.com"
$smtpPort = "25"
$smtpFrom = "AutoSymantec@fbcad.org"
$smtpTo = "daviddouglas@fbcad.org, garrettpost@fbcad.org"
$messageSubject = "Symantec Endpoint Protection Update"
$messageBody = "User: $user`nComputer: $computerName`nDate: $date`n`n Symantec Endpoint Protection is not installed on this computer."
$encryption = "none"




if (Test-Path $symantec) {
    #if it exists, run the update command
    Write-Host "Symantec Endpoint Protection is installed on this computer."
    #append to log file
    Add-Content -Path $logPath -Value "Date: $date - Symantec Endpoint Protection is installed on $computerName."
    #run exe file to update definitions
    & "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\SepLiveUpdate.exe"

    #check if update was successful
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Symantec Endpoint Protection definitions were updated successfully."
        Add-Content -Path $logPath -Value "Date: $date - Symantec Endpoint Protection definitions were updated successfully on $computerName."
    }
    else {
        Write-Host "Symantec Endpoint Protection definitions were not updated successfully."
        Add-Content -Path $logPath -Value "Date: $date - Symantec Endpoint Protection definitions were not updated successfully on $computerName."
    }

}
else {
    Write-Host "Symantec Endpoint Protection is not installed on this computer."
    Add-Content -Path $logPath -Value "Date: $date - Symantec Endpoint Protection is not installed on $computerName."
    Send-MailMessage -From $smtpFrom -To $smtpTo -Subject $messageSubject -Body $messageBody -SmtpServer $smtpServer -Port $smtpPort -DeliveryNotificationOption OnSuccess -Priority High
    #send email
    
    


    
}

if (Test-Path $logPath) {
    Write-Host "Log path exists."
}
else {
    Write-Host "Log path does not exist."
}
