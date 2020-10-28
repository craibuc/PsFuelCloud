<#
.SYNOPSIS
Create a new FuelCloud driver.

.PARAMETER AccessToken
Bearer token.

.PARAMETER full_name
The driver's full name.

.PARAMETER code
The driver's code.

.PARAMETER phone
The driver's telephone #.

.PARAMETER pin
The driver's PIN (5-digit numeric value, from 00000 to 99999).  If not provided, a PIN will be generated.

.LINK
https://developer.fuelcloud.com/?version=latest#5cb824b2-7faf-46a2-98b1-698e79d4786e

#>
function New-FuelCloudDriver {
    
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]$AccessToken,

        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [string]$full_name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$code,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$phone,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(0,99999)]
        [int]$pin
    )

    begin {
        $Uri = "https://api.fuelcloud.com/rest/v1.0/driver/"
        Write-Debug "Uri: $Uri"
    
        $Headers = @{Authorization = $AccessToken}
    }

    process {
    
        $Body = @{}
        if ($full_name) { $Body['full_name']=$full_name }
        # ensure pin is between 00000 and 99999
        if ($pin) { $Body['pin']=$pin.ToString().PadLeft(5,'0') }
        if ($phone) { $Body['phone']=$phone }
        if ($code) { $Body['code']=$code }
    
        # POST
        $Content = ( Invoke-WebRequest -Uri $uri -Method Post -Body $Body -ContentType "application/json" -Headers $Headers ).Content | ConvertFrom-Json
    
        # returns PsCustomObject representation of object
        if ( $Content.data ) { $Content.data }
    
        # otherwise raise an exception
        elseif ($Content.error) { Write-Error -Message $Content.error.message }
    
    }

    end {}

}
