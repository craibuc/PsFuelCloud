<#
.SYNOPIS
Saves Fuel Cloud settings to a file in the module's root directory.

.EXAMPLE
PS> .\Save-Settings.ps1

.NOTES
$FuelCloudSettings = Import-Clixml (Join-Path $Parent 'Settings.FuelCloud.xml')

#>

# script's location
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path  # WindowsPowerShell\Modules\PsFuelCloud\Public
$Parent = Split-Path -Parent $here  # WindowsPowerShell\Modules\PsFuelCloud\
$SettingsPath = Join-Path $Parent 'Settings.FuelCloud.xml'

Write-Host "Go to https://dashboard.fuelcloud.com/account/api`n"

# prompt for values
@{
    AccessToken = Read-Host "Supply the 'Access Token' value"
    RefreshToken = Read-Host "Supply the 'Refresh Token' value"
    Expires=Read-Host "Supply the 'Expire' value"
} |
# save as Xml
Export-Clixml $SettingsPath

Write-Host "S`nettings saved to $SettingsPath"