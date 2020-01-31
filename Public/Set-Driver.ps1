<#
.SYNOPSIS
Labore labore ea est sint deserunt excepteur cillum sit elit et eiusmod nisi est magna.

.PARAMETER AccessToken

.PARAMETER Id
The driver's ID.

.PARAMETER FullName
The driver's full name.

.PARAMETER PIN
The driver's PIN.

.PARAMETER Phone
The driver's phone.

.PARAMETER Code
The driver's code.

.PARAMETER Status
Enables (1) or Disables (1) the driver.

.LINK
https://developer.fuelcloud.com/?version=latest#04913aa9-7d59-46ff-be87-25fc53237e0b

#>
function Set-Driver {

    [CmdletBinding()]
    param
    (
        [string]$AccessToken,
        [int]$Id,
        [string]$FullName,
        [string]$PIN,
        [string]$Phone,
        [string]$Code,
        [int]$Status
    )

    Write-Debug "$($MyInvocation.MyCommand.Name)"
    Write-Debug "AccessToken: $AccessToken"
    Write-Debug "Id: $Id"

    $Uri = "https://api.fuelcloud.com/rest/v1.0/driver/$Id"
    Write-Debug "Uri: $Uri"

    $Headers = @{Authorization = $AccessToken}

    $Body = @{}
    if ($FullName) { $Body['full_name']=$FullName }
    if ($PIN) { $Body['pin']=$PIN }
    if ($Phone) { $Body['phone']=$Phone }
    if ($Code) { $Body['code']=$Code }
    if ($Status) { $Body['status']=$Status }

    # PATCH
    $Content = ( Invoke-WebRequest -Uri $uri -Method Patch -Body $Body -ContentType "application/json" -Headers $Headers ).Content | ConvertFrom-Json

    # returns PsCustomObject representation of object
    if ( $Content.data ) { $Content.data }

    # otherwise raise an exception
    elseif ($Content.error) { Write-Error -Message $Content.error.message }

}
