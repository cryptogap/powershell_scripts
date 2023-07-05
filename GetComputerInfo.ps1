#write a script that get the computers info and writes it to the console

#Get the computer name
$computerName = $env:COMPUTERNAME

#Get the OS version
$osVersion = (Get-WmiObject Win32_OperatingSystem).Caption

#Get the OS Architecture
$osArchitecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture

#Get the OS Service Pack
$osServicePack = (Get-WmiObject Win32_OperatingSystem).ServicePackMajorVersion

#Get the OS Install Date
$osInstallDate = (Get-WmiObject Win32_OperatingSystem).InstallDate

#Get the OS Last Boot Up Time
$osLastBootUpTime = (Get-WmiObject Win32_OperatingSystem).LastBootUpTime

#Get the OS Serial Number
$osSerialNumber = (Get-WmiObject Win32_OperatingSystem).SerialNumber

#Get the OS Registered User
$osRegisteredUser = (Get-WmiObject Win32_OperatingSystem).RegisteredUser

#Get the OS Organization
$osOrganization = (Get-WmiObject Win32_OperatingSystem).Organization

#Get the OS Product ID
$osProductID = (Get-WmiObject Win32_OperatingSystem).SerialNumber

#Get the OS Build Number
$osBuildNumber = (Get-WmiObject Win32_OperatingSystem).BuildNumber

#Get the OS Build Type
$osBuildType = (Get-WmiObject Win32_OperatingSystem).BuildType

#Get the OS System Directory
$osSystemDirectory = (Get-WmiObject Win32_OperatingSystem).SystemDirectory

#Get the OS Windows Directory
$osWindowsDirectory = (Get-WmiObject Win32_OperatingSystem).WindowsDirectory

#Get the OS Version
$osVersion = (Get-WmiObject Win32_OperatingSystem).Version

#Get the OS Locale
$osLocale = (Get-WmiObject Win32_OperatingSystem).Locale

#Get the OS Language
$osLanguage = (Get-WmiObject Win32_OperatingSystem).OSLanguage

#Get the OS Country Code
$osCountryCode = (Get-WmiObject Win32_OperatingSystem).CountryCode

#Get the OS Current Time Zone
$osCurrentTimeZone = (Get-WmiObject Win32_OperatingSystem).CurrentTimeZone

#Get the OS Number of Users
$osNumberOfUsers = (Get-WmiObject Win32_OperatingSystem).NumberOfUsers

#Get the OS Number of Processes
$osNumberOfProcesses = (Get-WmiObject Win32_OperatingSystem).NumberOfProcesses

#Get the OS Number of Licensed Users
$osNumberOfLicensedUsers = (Get-WmiObject Win32_OperatingSystem).NumberOfLicensedUsers

#Get the OS Number of Users
$osNumberOfUsers = (Get-WmiObject Win32_OperatingSystem).NumberOfUsers

#Get the OS Number of Processes
$osNumberOfProcesses = (Get-WmiObject Win32_OperatingSystem).NumberOfProcesses





#write the computer info to the console
Write-Host "Computer Name: $computerName"
Write-Host "OS Version: $osVersion"
Write-Host "OS Architecture: $osArchitecture"
Write-Host "OS Service Pack: $osServicePack"
Write-Host "OS Install Date: $osInstallDate"
Write-Host "OS Last Boot Up Time: $osLastBootUpTime"
Write-Host "OS Serial Number: $osSerialNumber"
Write-Host "OS Registered User: $osRegisteredUser"
Write-Host "OS Organization: $osOrganization"
Write-Host "OS Product ID: $osProductID"
Write-Host "OS Build Number: $osBuildNumber"
Write-Host "OS Build Type: $osBuildType"
Write-Host "OS System Directory: $osSystemDirectory"
Write-Host "OS Windows Directory: $osWindowsDirectory"
Write-Host "OS Version: $osVersion"
Write-Host "OS Locale: $osLocale"
Write-Host "OS Language: $osLanguage"
Write-Host "OS Country Code: $osCountryCode"
Write-Host "OS Current Time Zone: $osCurrentTimeZone"
Write-Host "OS Number of Users: $osNumberOfUsers"
Write-Host "OS Number of Processes: $osNumberOfProcesses"
Write-Host "OS Number of Licensed Users: $osNumberOfLicensedUsers"
Write-Host "OS Number of Users: $osNumberOfUsers"
Write-Host "OS Number of Processes: $osNumberOfProcesses"
