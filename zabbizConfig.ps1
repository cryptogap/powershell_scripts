$ServiceName = "Zabbix Agent 2"
#path to zabbix_agent2.conf
$zabbixConfig = "C:\Program Files\Zabbix Agent 2\"

$winConfigDownloadLink = "https://raw.githubusercontent.com/cryptogap/powershell_scripts/main/supportingFiles/zabbix_agent2.win.conf"
$configDownloadLink = "https://raw.githubusercontent.com/cryptogap/powershell_scripts/main/supportingFiles/zabbix_agent2.conf"




$arrService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($null -eq $arrService) {
    Write-Host "Service $ServiceName not found" -ForegroundColor Red

    #download and install zabbix agent2 
    Write-Host "Downloading Zabbix Agent 2" -ForegroundColor Green
    Invoke-WebRequest -Uri "https://cdn.zabbix.com/zabbix/binaries/stable/6.4/6.4.3/zabbix_agent2-6.4.3-windows-amd64-openssl.msi" -OutFile "C:\zabbix_agent2-6.4.3-windows-amd64-openssl.msi"
    #download config files
    Write-Host "Downloading config files" -ForegroundColor Green
    Invoke-WebRequest -Uri $configDownloadLink -OutFile "C:\zabbix_agent2.conf"
    Invoke-WebRequest -Uri $winConfigDownloadLink -OutFile "C:\zabbix_agent2.win.conf"



    Write-Host "Installing Zabbix Agent 2" -ForegroundColor Green
    #install zabbix agent2 with config file
    Start-Process -FilePath "C:\zabbix_agent2-6.4.3-windows-amd64-openssl.msi" -Wait
    #remove install file
    Write-Host "Removing install file" -ForegroundColor Green
    Remove-Item -Path "C:\zabbix_agent2-6.4.3-windows-amd64-openssl.msi"
    #move config files to zabbix agent 2 folder
    Write-Host "Moving config files to zabbix agent 2 folder" -ForegroundColor Green

    #check if file exists
    if (Test-Path -Path "$zabbixConfig\zabbix_agent2.conf") {
        Write-Host "Config file found" -ForegroundColor Green
        #rename config file
        Rename-Item -Path "$zabbixConfig\zabbix_agent2.conf" -NewName "zabbix_agent2.conf.old"
        Write-Host "Renamed config file to zabbix_agent2.conf.old" -ForegroundColor Green
    }
    else {
        Write-Host "Config file not found" -ForegroundColor Red
    }

    #check if file exists
    if (Test-Path -Path "$zabbixConfig\zabbix_agent2.win.conf") {
        Write-Host "Config file found" -ForegroundColor Green
        #rename config file
        Rename-Item -Path "$zabbixConfig\zabbix_agent2.win.conf" -NewName "zabbix_agent2.win.conf.old"
        Write-Host "Renamed config file to zabbix_agent2.win.conf.old" -ForegroundColor Green
    }
    else {
        Write-Host "Config file not found" -ForegroundColor Red
    }

    Move-Item -Path "C:\zabbix_agent2.conf" -Destination "$zabbixConfig\zabbix_agent2.conf"
    Move-Item -Path "C:\zabbix_agent2.win.conf" -Destination "$zabbixConfig\zabbix_agent2.win.conf"
    #start service
    Write-Host "Starting service $ServiceName" -ForegroundColor Green
    Start-Service -Name $ServiceName
    #check to see if service is running
    $arrService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    if ($arrService.Status -eq "Running") {
        Write-Host "Service $ServiceName is running" -ForegroundColor Green
        #restart service
        Write-Host "Restarting service $ServiceName" -ForegroundColor Yellow
        Restart-Service -Name $ServiceName
        #check to see if service is running
        $arrService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

        if ($arrService.Status -eq "Running") {
            Write-Host "Service $ServiceName is running" -ForegroundColor Green
        }
        else {
            Write-Host "Service $ServiceName is not running" -ForegroundColor Red
        }

    }
    else {
        Write-Host "Service $ServiceName is not running" -ForegroundColor Red
    }

    
    

    exit
}
else {
    Write-Host "Service $ServiceName found" -ForegroundColor Green
    #stop service
    if ($arrService.Status -eq "Running") {
        Write-Host "Stopping service $ServiceName" -ForegroundColor Green
        Stop-Service -Name $ServiceName
    }
    else {
        Write-Host "Service $ServiceName is not running" -ForegroundColor Yellow
    }
}

#write-host path to config
Write-Host "Path to config: $zabbixConfig" -ForegroundColor Green


#START OF CONFIG FILE CHECK
#check to see if config file exists
if (Test-Path -Path "$zabbixConfig\zabbix_agent2.conf") {
    Write-Host "Config file found" -ForegroundColor Green
    #rename config file
    #TODO: - check if file exists

    #check if zabbix_agent2.conf.old exists if it does, delete it first then rename the current config file
    if (Test-Path -Path "$zabbixConfig\zabbix_agent2.conf.old") {
        Write-Host "Config file found" -ForegroundColor Green
        #delete current config file
        Remove-Item -Path "$zabbixConfig\zabbix_agent2.conf.old"
        Write-Host "Deleted config file zabbix_agent2.conf.old" -ForegroundColor Yellow
    }


    Rename-Item -Path "$zabbixConfig\zabbix_agent2.conf" -NewName "zabbix_agent2.conf.old"
    Write-Host "Renamed config file to zabbix_agent2.conf.old" -ForegroundColor Yellow
}
else {
    Write-Host "Config file not found" -ForegroundColor Red
}

#download config file
Write-Host "Downloading config file" -ForegroundColor Green

Invoke-WebRequest -Uri $configDownloadLink -OutFile "$zabbixConfig\zabbix_agent2.conf"

#check to see if config file exists
if (Test-Path -Path "$zabbixConfig\zabbix_agent2.conf") {
    Write-Host "Config file downloaded" -ForegroundColor Green
}
else {
    Write-Host "Config file not downloaded" -ForegroundColor Red
}


#START OF WIN CONFIG FILE CHECK
#check to see if config file exists
if (Test-Path -Path "$zabbixConfig\zabbix_agent2.win.conf") {
    Write-Host "Config file found" -ForegroundColor Green
    #rename config file
    #TODO: - check if file exists

    if (Test-Path -Path "$zabbixConfig\zabbix_agent2.win.conf.old") {
        Write-Host "Config file found" -ForegroundColor Green
        #delete current config file
        Remove-Item -Path "$zabbixConfig\zabbix_agent2.win.conf.old"
        Write-Host "Deleted config file zabbix_agent2.win.conf.old" -ForegroundColor Yellow
    }


    Rename-Item -Path "$zabbixConfig\zabbix_agent2.win.conf" -NewName "zabbix_agent2.win.conf.old"
    Write-Host "Renamed config file to zabbix_agent2.win.conf.old" -ForegroundColor Yellow
}
else {
    Write-Host "Config file not found" -ForegroundColor Red
}

#download config file
Write-Host "Downloading config file" -ForegroundColor Green

Invoke-WebRequest -Uri $winConfigDownloadLink -OutFile "$zabbixConfig\zabbix_agent2.win.conf"

#check to see if config file exists

if (Test-Path -Path "$zabbixConfig\zabbix_agent2.win.conf") {
    Write-Host "Config file downloaded" -ForegroundColor Green
}
else {
    Write-Host "Config file not downloaded" -ForegroundColor Red
}

#start service
Write-Host "Starting service $ServiceName" -ForegroundColor Green
Start-Service -Name $ServiceName

#check to see if service is running
$arrService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($arrService.Status -eq "Running") {
    Write-Host "Service $ServiceName is running" -ForegroundColor Green
}
else {
    Write-Host "Service $ServiceName is not running" -ForegroundColor Red
}