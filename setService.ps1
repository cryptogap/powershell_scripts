$computer = Read-Host "Enter the computer name"

$username = Read-Host "Enter the username"

$password = Read-Host "Enter the password" -AsSecureString

$credentials = New-Object System.Management.Automation.PSCredential($username, $password)

# $service = Read-Host "Enter the service name"

$service = "WinRM"


$ping = New-Object System.Net.NetworkInformation.Ping
$Reply = $ping.send($computer)

Write-Host $Reply.status



Write-Host $Reply.RoundtripTime

if ($Reply.status -eq "Success") {

  

    .\psexec64.exe -s \\$computer -u "fbcad\$username" -p "F61ac5b57e0911!!" powershell.exe Enable-PSRemoting -Force

    

        
}