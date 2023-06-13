#ask the user for the remote computer name

$computer = Read-Host "Enter the computer name"

$username = Read-Host "Enter the username"

$win_config = "\\fbcaddata\Company\Department\Technology\Zabbix\configFiles\zabbix_agent2.win.conf"

$config = "\\fbcaddata\Company\Department\Technology\Zabbix\configFiles\zabbix_agent2.conf"


#ping the computer to see if it is online

$ping = New-Object System.Net.NetworkInformation.Ping

$Reply = $ping.send($computer)


if ($Reply.status -eq "Success") {
    #Wr

    Write-Host "The computer is online"

    
    

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

            $filecheck = "$win_config", "$config"

            $result = ($filecheck | Test-Path) -notcontains $false

            if ($result -eq $true) {
                Write-Host "Both config files exists" -ForegroundColor Green
                
                Copy-Item -Path "\\fbcaddata\Company\Department\Technology\Zabbix\configFiles\*" -Destination "C:\Program Files\Zabbix Agent 2" -ToSession $session

                #restart the service

                Invoke-Command -Session $session -ScriptBlock { Start-Service -Name "Zabbix Agent 2" }
            }
            else {
                Write-Host $filecheck -ForegroundColor Red

                Write-Host "The config file does not exist" -ForegroundColor Red

                Write-Host "The script will now exit, please check the connection and try again." -ForegroundColor Red

                Remove-PSSession -Session $session

                Write-Host "The session has been closed" -ForegroundColor Green

                exit
            }


            #copy the config file to the program files folder

            

            #start the service

            Invoke-Command -Session $session -ScriptBlock { Start-Service -Name "Zabbix Agent 2" }

            #close the session

            Remove-PSSession -Session $session

            Write-Host "The Zabbix Agent 2 service has been restarted" -ForegroundColor Green
        }
        else {
            Write-Host "The Zabbix Agent 2 service is not installed" -ForegroundColor Red

            #install zabbix with chocolatey

            #check if chocolatey is installed

            if (Invoke-Command -Session $session -ScriptBlock { Test-Path -Path "C:\ProgramData\chocolatey\bin\choco.exe" }) {
                Write-Host "Chocolatey is installed" -ForegroundColor Green

                #install zabbix agent 2 with chocolatey

                Invoke-Command -Session $session -ScriptBlock { choco install zabbix-agent2 -y }

                Write-Host "Zabbix Agent 2 has been installed" -ForegroundColor Green

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
    
                $filecheck = "$win_config", "$config"
    
                $result = ($filecheck | Test-Path) -notcontains $false
    
                if ($result -eq $true) {
                    Write-Host "Both config files exists" -ForegroundColor Green
                    
                    Copy-Item -Path "\\fbcaddata\Company\Department\Technology\Zabbix\configFiles\*" -Destination "C:\Program Files\Zabbix Agent 2" -ToSession $session

                    #restart the service

                    Invoke-Command -Session $session -ScriptBlock { Start-Service -Name "Zabbix Agent 2" }
                }
                else {
                    Write-Host $filecheck -ForegroundColor Red
    
                    Write-Host "The config file does not exist" -ForegroundColor Red
    
                    Write-Host "The script will now exit, please check the connection and try again." -ForegroundColor Red
    
                    Remove-PSSession -Session $session

                    Write-Host "The session has been closed" -ForegroundColor Green

                    exit
                }
            }
            else {
                Write-Host "Chocolatey is not installed" -ForegroundColor Red

                #install chocolatey

                Invoke-Command -Session $session -ScriptBlock { Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) }

                Write-Host "Chocolatey has been installed" -ForegroundColor Green

                #set the path

                Invoke-Command -Session $session -ScriptBlock { $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\ProgramData\chocolatey\bin" }

                Write-Host "The path has been set" -ForegroundColor Green

                #install zabbix agent 2 with chocolatey

                Invoke-Command -Session $session -ScriptBlock { choco install zabbix-agent2 -y }

                Write-Host "Zabbix Agent 2 has been installed" -ForegroundColor Green

                #stop the service

                Invoke-Command -Session $session -ScriptBlock { Stop-Service -Name "Zabbix Agent 2" }

                Write-Host "The Zabbix Agent 2 service has been stopped" -ForegroundColor Green

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
    
                $filecheck = "$win_config", "$config"
    
                $result = ($filecheck | Test-Path) -notcontains $false
    
                if ($result -eq $true) {
                    Write-Host "Both config files exists" -ForegroundColor Green
                    
                    Copy-Item -Path "\\fbcaddata\Company\Department\Technology\Zabbix\configFiles\*" -Destination "C:\Program Files\Zabbix Agent 2" -ToSession $session

                    #start the service

                    Invoke-Command -Session $session -ScriptBlock { Start-Service -Name "Zabbix Agent 2" }
                }
                else {
                    Write-Host $filecheck -ForegroundColor Red
    
                    Write-Host "The config file does not exist" -ForegroundColor Red
    
                    Write-Host "The script will now exit, please check the connection and try again." -ForegroundColor Red
    
                    Remove-PSSession -Session $session

                    Write-Host "The session has been closed" -ForegroundColor Green
                    exit
                }

                
            }

            

            Remove-PSSession -Session $session

            Write-Host "The session has been closed" -ForegroundColor Green


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