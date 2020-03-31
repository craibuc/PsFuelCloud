<#
.SYNOPSIS
Saves Fuel Cloud settings to a file in the module's root directory.

.EXAMPLE
PS> .\Save-Settings.ps1

.NOTES
$FuelCloudSettings = Import-Clixml (Join-Path $Parent 'Settings.FuelCloud.xml')

#>

# settings' location
$Parent = Split-Path -Path $PSScriptRoot -Parent
$SettingsPath = Join-Path $Parent 'Settings.FuelCloud.xml'

Write-Host "Go to https://dashboard.fuelcloud.com/account/api`n"

# prompt for values
[PsCustomObject]@{
    AccessToken = Read-Host "Supply the 'Access Token' value"
    RefreshToken = Read-Host "Supply the 'Refresh Token' value"
    Expires=Read-Host "Supply the 'Expire' value"
} |
# save as Xml
Export-Clixml $SettingsPath

Write-Host "Settings saved to $SettingsPath"