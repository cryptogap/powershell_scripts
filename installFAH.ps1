#check if folding at home is installed

$FAH = Test-Path "C:\Program Files (x86)\FAHClient\FAHClient.exe"

if ($FAH -eq $null) {
    Write-Host "Folding@home is not installed"
}
else {
    Write-Host "Folding@home is installed"
}


if ($FAH -eq $null) {
    #install folding at home

    $url = "https://download.foldingathome.org/releases/public/release/fah-installer/windows-10-32bit/v7.6/fah-installer_7.6.21_x86.exe"

    $output = "C:\Users\Public\fah-installer_7.6.21_x86.exe"

    Invoke-WebRequest -Uri $url -OutFile $output

    Start-Process -FilePath $output -Wait

    Remove-Item $output

    #create folding@home service

    $FAHService = Get-Service -Name FAHClient

    if ($FAHService -eq $null) {
        Write-Host "Folding@home service does not exist"
    }
    else {
        Write-Host "Folding@home service exists"
    }

    if ($FAHService -eq $null) {
        $FAHService = New-Service -Name FAHClient -BinaryPathName "C:\Program Files (x86)\FAHClient\FAHClient.exe" -DisplayName "Folding@home Client" -StartupType Automatic
    }

    #remove desktop shortcut

    $desktop = [System.Environment]::GetFolderPath("Desktop")

    $shortcut = Get-ChildItem -Path $desktop -Filter "*Folding@home*" -Recurse

    if ($shortcut -eq $null) {
        Write-Host "Folding@home shortcut does not exist"
    }
    else {
        Write-Host "Folding@home shortcut exists"
    }

    if ($shortcut -ne $null) {
        Remove-Item $shortcut.FullName
    }

    #remove start menu shortcut

    $startMenu = [System.Environment]::GetFolderPath("CommonStartMenu")

    $shortcut = Get-ChildItem -Path $startMenu -Filter "*Folding@home*" -Recurse

    if ($shortcut -eq $null) {
        Write-Host "Folding@home shortcut does not exist"
    }
    else {
        Write-Host "Folding@home shortcut exists"
    }

    $publicURL = "C:\Users\Public\Desktop\Folding@home.lnk"

    if (Test-Path $publicURL) {
        Remove-Item $publicURL
    }

    Write-Host "Take a moment to configure Folding@home then come back."

    Read-Host -Prompt "Press Enter to continue"

    #disable folding at home tray icons
}
