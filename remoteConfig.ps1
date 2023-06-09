#ask the user for the remote computer name

$computer = Read-Host "Enter the computer name"

$username = Read-Host "Enter the username"


#ping the computer to see if it is online

$ping = New-Object System.Net.NetworkInformation.Ping

$Reply = $ping.send($computer)

if ($Reply.status -eq "Success") {
    #Wr

    Write-Host "The computer is online"

    #create a new session with domain credentials

    $session = New-PSSession -ComputerName $computer -Credential $username 

    #check if the session is open

    if ($session.State -eq "Opened") {
        Write-Host "The session is open" -ForegroundColor Green

        #use sessioon to check if "Zabbix Agent 2" service is installed

        if (Invoke-Command -Session $session -ScriptBlock { Get-Service -Name "Zabbix Agent 2" }) {
            Write-Host "The Zabbix Agent 2 service is installed" -ForegroundColor Green

        
            #use the session to check if "Zabbix Agent 2" service is running

            if (Invoke-Command -Session $session -ScriptBlock { Get-Service -Name "Zabbix Agent 2" }  ) {
                Write-Host "The Zabbix Agent 2 service is running" -ForegroundColor Green

    
                #if the service is running stop it

                Invoke-Command -Session $session -ScriptBlock { Stop-Service -Name "Zabbix Agent 2" }

                Write-Host "The Zabbix Agent 2 service has been stopped" -ForegroundColor Green



            } 

            if (Invoke-Command -Session $session -ScriptBlock { Test-Path -Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.conf.old" }) {
                Write-Host "The old config file exists" -ForegroundColor Red

                Invoke-Command -Session $session -ScriptBlock { Remove-Item -Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.conf.old" }

                Write-Host "The old config file has been removed" -ForegroundColor Green


            }
            else {
                Write-Host "The old config file does not exist" -ForegroundColor Green
            }

            if (Invoke-Command -Session $session -ScriptBlock { Test-Path -Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.win.conf.old" }) {
                Write-Host "The old win config file exists" -ForegroundColor Red

                Invoke-Command -Session $session -ScriptBlock { Remove-Item -Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.win.conf.old" }

                Write-Host "The old  win config file has been removed" -ForegroundColor Green

            }
            else {
                Write-Host "The old win config file does not exist" -ForegroundColor Green
            }

            if (Invoke-Command -Session $session -ScriptBlock { Test-Path -Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.conf" }) {
                Write-Host "The config file exists" -ForegroundColor Red

                Invoke-Command -Session $session -ScriptBlock { Rename-Item -Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.conf" -NewName "zabbix_agent2.conf.old" }

                Write-Host "The config file has been removed" -ForegroundColor Green

            }
            else {
                Write-Host "The config file does not exist" -ForegroundColor Green
            }

            if (Invoke-Command -Session $session -ScriptBlock { Test-Path -Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.win.conf" }) {
                Write-Host "The win config file exists" -ForegroundColor Red

                Invoke-Command -Session $session -ScriptBlock { Rename-Item -Path "C:\Program Files\Zabbix Agent 2\zabbix_agent2.win.conf" -NewName "zabbix_agent2.win.conf.old" }

                Write-Host "The win config file has been removed" -ForegroundColor Green

            }
            else {
                Write-Host "The win config file does not exist" -ForegroundColor Green
            }

            if (Invoke-Command -Session $session -ScriptBlock { Test-Path -Path "\\fbcaddata\Company\Department\Technology\Zabbix\zabbix_agent2.conf" -and Test-Path -Path "\\fbcaddata\Company\Department\Technology\Zabbix\zabbix_agent2.win.conf" }) {
                Write-Host "Both config files exists" -ForegroundColor Green

            }
            else {
                Write-Host "The config file does not exist" -ForegroundColor Red

                Write-Host "The script will now exit, please check the connection and try again." -ForegroundColor Red

                exit
            }


            #copy the config file to the program files folder

            Copy-Item -Path "\\fbcaddata\Company\Department\Technology\Zabbix\*" -Destination "C:\Program Files\Zabbix Agent 2" -ToSession $session

            #start the service

            Invoke-Command -Session $session -ScriptBlock { Start-Service -Name "Zabbix Agent 2" }

            #close the session

            Remove-PSSession -Session $session

            Write-Host "The Zabbix Agent 2 service has been restarted" -ForegroundColor Green
        }
        else {
            Write-Host "The Zabbix Agent 2 service is not installed" -ForegroundColor Red

            #download the Zabbix Agent 2 installer from zabbix server and install it

       
            #Invoke-Command -Session $session -ScriptBlock { Start-Process -FilePath "C:\zabbix_agent2-6.4.3-windows-amd64-openssl.msi" -ArgumentList "/quiet" -Wait }


        }

    

        
    
    }
    else {
        Write-Host "The session is closed" -ForegroundColor Red
    }

}
else {
    #if the computer is offline, display a message
    Write-Host "The computer is offline"
}