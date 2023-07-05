# Check if Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Please install Chocolatey (https://chocolatey.org/) and run the script again."
    return
}

# Check if Chrome is installed
if (-not (Get-Command googlechrome -ErrorAction SilentlyContinue)) {
    Write-Host "Google Chrome is not installed. Please install Google Chrome and run the script again."
    return
}

# Update Google Chrome
Write-Host "Updating Google Chrome..."
choco upgrade googlechrome -y

# Check if the update was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Google Chrome was successfully updated."
} else {
    Write-Host "Failed to update Google Chrome."
}
