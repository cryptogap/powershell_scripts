#get server name from user
$server = Read-Host "Enter the server name"

# Set the credentials for the remote server (replace with actual username and password)
$credentials = Get-Credential -Credential "fbcad\garrettpost"

# Create a PowerShell session on the remote server
$session = New-PSSession -ComputerName $server -Credential $credentials

# Enter the remote session
Enter-PSSession $session

#check if winrm is enabled
Invoke-Command -Session $session -ScriptBlock { Get-Service WinRM | Select-Object -Property Name, StartType, Status }

#Set execution policy to unrestricted
Invoke-Command -Session $session -ScriptBlock { Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force }

#Install NuGet package provider
Invoke-Command -Session $session -ScriptBlock { Install-PackageProvider -Name NuGet -Force }

#Install PSWindowsUpdate module
Invoke-Command -Session $session -ScriptBlock { Install-Module -Name PSWindowsUpdate -Force }

#Import PSWindowsUpdate module
Invoke-Command -Session $session -ScriptBlock { Import-Module -Name PSWindowsUpdate -Force }

#Check if PSWindowsUpdate module is installed
Invoke-Command -Session $session -ScriptBlock { Get-Module -Name PSWindowsUpdate }

# Invoke command on the remote server
Invoke-Command -Session $session -ScriptBlock { Enable-PSRemoting -Force }


#create virtual account to run command in on remote computer
Invoke-Command -Session $session -ScriptBlock { New-LocalUser -Name "fbcad\garrettpost" -NoPassword -PasswordNeverExpires }


# Invoke command on the remote server
Invoke-Command -Session $session -ScriptBlock { Get-WindowsUpdate -verbose -computer $server -AcceptAll -Install -AutoReboot }

#Invoke command on the remote server to install pending updates





# Exit the remote session
Exit-PSSession

# Remove the PowerShell session
Remove-PSSession $session
