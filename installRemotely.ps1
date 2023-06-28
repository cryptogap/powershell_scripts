#Create a script that will install remotely 

#Variables
$serverIP = "192.1.2.16"

$organizationID = "300c52d6-9d44-4674-a62b-a23d87ff95e8"

#run Remotely_Installer.exe with arguments

Start-Process -FilePath "\\192.1.2.210\GeneralShare\installers\Remotely_Installer.exe" -ArgumentList "/S /v/qn ORGANIZATIONID=$organizationID SERVERIP=$serverIP" -Wait

.\