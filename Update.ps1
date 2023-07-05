$date = Get-Date -Format "yyyy-MM-dd"
$computerName = $env:COMPUTERNAME

$smtpServer = "fbcad-org.mail.protection.outlook.com"
$smtpServer2 = "mail-dm3gcc020110.inbound.protection.outlook.com"
$smtpPort = "25"
$smtpSecurePort = "587"
$smtpFrom = "AutoWindowsUpdate@fbcad.org"
$smtpTo = "garrettpost@fbcad.org"
$messageSubject = "[$computerName] - Windows Update"
$encryption = "none"

$logFileLocation = "\\192.1.2.210\GeneralShare\Logs\$date\$computerName.txt"

#check if folder exists and create if it doesn't
if (!(Test-Path "\\192.1.2.210\GeneralShare\Logs\$date")) {
    New-Item -ItemType Directory -Path "\\192.1.2.210\GeneralShare\Logs\$date"
}

#check if file exists and create if it doesn't
if (!(Test-Path $logFileLocation)) {
    New-Item -ItemType File -Path $logFileLocation
}




#check if NuGet is installed

if (Get-PackageProvider -Name NuGet -ListAvailable) {
    Write-Host "NuGet Package Provider Installed"

    #log to file that NuGet is installed
    Add-Content -Path $logFileLocation -Value "NuGet Package Provider Installed"
}
else {
    Write-Host "NuGet Package Provider Not Installed"
    Write-Host "Installing NuGet Package Provider..."
    Install-PackageProvider -Name NuGet -Force 
    #log to file that NuGet is not installed
    Add-Content -Path $logFileLocation -Value "NuGet Package Provider Not Installed"

}


Write-Host "Setting Execution Policy..."
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 

#Write to log file that Execution Policy is set
Add-Content -Path $logFileLocation -Value "Execution Policy Set"

Write-Host "Installing PSWindowsUpdate Module..."
Install-Module -Name PSWindowsUpdate -Force

#Write to log file that PSWindowsUpdate is installed
Add-Content -Path $logFileLocation -Value "PSWindowsUpdate Module Installed"

Write-Host "Getting Windows Updates..."

Add-Content -Path $logFileLocation -Value "Windows Updates Being Installed"

Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

#Write to log file that Windows Updates are installed
Add-Content -Path $logFileLocation -Value "Windows Updates Installed"

$history = Get-WUHistory

#Write to log file value of $history
Add-Content -Path $logFileLocation -Value $history

#send email that updates are installed
$messageBody = "Windows Updates have been installed on $computerName.`n`n $history `n`n The computer will reboot in 5 minutes."

Send-MailMessage -From $smtpFrom -To $smtpTo -Subject $messageSubject -Body $messageBody -SmtpServer $smtpServer -Port $smtpPort -DeliveryNotificationOption OnSuccess -Priority High

#rebboot computer
#Write to log file that computer is rebooting
Add-Content -Path $logFileLocation -Value "Computer Rebooting"
# Restart-Computer -Force
