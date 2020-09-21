<#
.SYNOPSIS
Labore labore ea est sint deserunt excepteur cillum sit elit et eiusmod nisi est magna.

.PARAMETER AccessToken

.PARAMETER id
The driver's ID.

.PARAMETER full_name
The driver's full name.

.PARAMETER pin
The driver's PIN.

.PARAMETER phone
The driver's phone.

.PARAMETER code
The driver's code.

.LINK
https://developer.fuelcloud.com/?version=latest#5cb824b2-7faf-46a2-98b1-698e79d4786e

#>
function New-FuelCloudDriver {
    
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]$AccessToken,

        [Parameter(Mandatory)]
        [string]$full_name,

        [Parameter()]
        [string]$phone,

        [Parameter()]
        [int]$pin,

        [Parameter()]
        [string]$code
    )

    begin {

        Write-Debug "$($MyInvocation.MyCommand.Name)"
        Write-Debug "AccessToken: $AccessToken"
        Write-Debug "full_name: $full_name"
        Write-Debug "pin: $pin"
        Write-Debug "phone: $phone"
        Write-Debug "code: $code"
        
        $Uri = "https://api.fuelcloud.com/rest/v1.0/driver/"
        Write-Debug "Uri: $Uri"
    
        $Headers = @{Authorization = $AccessToken}
    }

    process {
    
        $Body = @{}
        if ($full_name) { $Body['full_name']=$full_name }
        if ($pin) { $Body['pin']=$pin }
        if ($phone) { $Body['phone']=$phone }
        if ($code) { $Body['code']=$code }
        if ($status) { $Body['status']=$status }
    
        # PATCH
        $Content = ( Invoke-WebRequest -Uri $uri -Method Post -Body $Body -ContentType "application/json" -Headers $Headers ).Content | ConvertFrom-Json
    
        # returns PsCustomObject representation of object
        if ( $Content.data ) { $Content.data }
    
        # otherwise raise an exception
        elseif ($Content.error) { Write-Error -Message $Content.error.message }
    
    }

    end {}

}
