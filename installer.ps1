#check if chocolatey is installed if it is write host "chocolatey is installed" and install if not and write host "chocolatey is not installed" and exit

if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
    Write-Host "chocolatey is installed" -ForegroundColor Green
} else {
    Write-Host "chocolatey is not installed" -ForegroundColor Red

    Write-Host "Installing chocolatey" -ForegroundColor Green
    #install chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    
    #check if chocolatey is installed
    if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
        Write-Host "chocolatey is installed" -ForegroundColor Green
    } else {
        Write-Host "Error: Chocolatey is not installed" -ForegroundColor Red
        Write-Host "Exiting" -ForegroundColor Red
        exit
    }
}

#TODO: Remove following remove when done testing

#Ask user if they want to remove chocolatey

$remove = Read-Host -Prompt "Do you want to remove chocolatey? (y/n)"

if ($remove -eq "y") {
    Write-Host "Removing chocolatey" -ForegroundColor Green
    choco uninstall chocolatey -y
    Write-Host "Chocolatey removed" -ForegroundColor Green
    Write-Host "Removing remnant files" -ForegroundColor Green
    Remove-Item -Path C:\ProgramData\chocolatey -Recurse -Force
    Write-Host "Remnant files removed" -ForegroundColor Green

} else {
    Write-Host "Chocolatey not removed" -ForegroundColor Red
}


#Upgrade all packages installed by chocolatey

Write-Host "Upgrading all packages installed by chocolatey" -ForegroundColor Green
choco upgrade all -y
Write-Host "All packages upgraded" -ForegroundColor Green




#ask the user if they want to install the package, repeat until they say no

do {
    $package = Read-Host -Prompt "Do you want to install a package? (y/n)"
    if ($package -eq "y") {
        $package = Read-Host -Prompt "Enter the name of the package you want to install"

        choco install $package -y
        
    }
} until ($package -eq "n")

#install all packages in the array

Write-Host "Installing packages" -ForegroundColor Green
foreach ($package in $packages) {
    choco upgrade $package -y
}

Write-Host "Packages installed" -ForegroundColor Green

#ask the user if they want to remove the package, repeat until they say no

do {
    $package = Read-Host -Prompt "Do you want to remove a package? (y/n)"
    if ($package -eq "y") {
        $package = Read-Host -Prompt "Enter the name of the package you want to remove"
        choco uninstall $package -y
    }
} until ($package -eq "n")

Write-Host "Packages removed" -ForegroundColor Green






