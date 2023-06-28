#ask the user for the remote computer name

$computer = Read-Host "Enter the computer name"

#save Password1! as secure string

$passwordSecure = "F61ac5b57e0911!!" | ConvertTo-SecureString -AsPlainText -Force

$credentials = New-Object System.Management.Automation.PSCredential("garrettpost", $passwordSecure)

$source = "C:\windows\System32\WindowsPowerShell\v1.0\modules\WindowsUpdate"

$destination = "C:\windows\system32\WindowsPowerShell\v1.0\modules"

#ping the computer to see if it is online

$ping = New-Object System.Net.NetworkInformation.Ping

$Reply = $ping.send($computer)


if ($Reply.status -eq "Success") {
    #Wr

    #create administrator session on remote computer

    $session = New-PSSession -ComputerName $computer -Credential $credentials

    #check if NuGet is installed on remote computer if it is write to the console that it is installed if not install it

    $check = Invoke-Command -Session $session -ScriptBlock {Get-Module -ListAvailable -Name "WindowsUpdate"}


    if ($check -eq $null) {
        Write-Host "Installing WindowsUpdate Module" -ForegroundColor Yellow
        Copy-Item -Path $source -Destination $destination -Recurse -Force
        Write-Host "WindowsUpdate Module Installed" -ForegroundColor Green
    } else {
        Write-Host "WindowsUpdate Module is already installed" -ForegroundColor Green
    }
    
    #check if the remote computer is pending a reboot if it is write to the console that it is pending a reboot if not continue

    $checkReboot = Invoke-Command -Session $session -ScriptBlock {Get-PendingReboot -ComputerName $env:COMPUTERNAME}

    if ($checkReboot -eq $null) {
        Write-Host "No reboot is pending" -ForegroundColor Green
    } else {
        Write-Host "Reboot is pending" -ForegroundColor Red
    }

    Remove-PSSession $session


}
