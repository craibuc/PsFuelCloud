<#
.SYNOPIS
lorem

.PARAMETER RefreshToken

.EXAMPLE
New-AccessToken -RefreshToken 'U3RhS3...'

Bearer UEYwS2...

#>
function New-AccessToken {

    [CmdletBinding()]
    param
    (
        [string]$AccessToken,

        [string]$RefreshToken
    )

    Write-Debug "$($MyInvocation.MyCommand.Name)"
    Write-Debug "AccessToken: $AccessToken"
	Write-Debug "RefreshToken: $RefreshToken"

    $Uri = "https://api.fuelcloud.com/rest/v1.0/refresh-token/$RefreshToken"
	Write-Debug "Uri: $Uri"

    $Content = ( Invoke-WebRequest -Uri $uri -Method Get -ContentType "application/x-www-form-urlencoded" ).Content | ConvertFrom-Json

    # returns PsCustomObject representation of object
    if ( $Content.data ) { $Content.data }

    # otherwise raise an exception
    elseif ($Content.error) { Write-Error -Message $Content.error.message }

}
