function Get-Timezone {

    [CmdletBinding()]
    param
    (
        [string]$AccessToken
    )

	Write-Debug "$($MyInvocation.MyCommand.Name)"
	Write-Debug "AccessToken: $AccessToken"
	Write-Debug "Id: $Id"

    $Uri = "https://api.fuelcloud.com/rest/v1.0/timezones"
    # if ($Id) { $Uri = "$Uri/$Id" }
	Write-Debug "Uri: $Uri"

    $Headers = @{Authorization = $AccessToken}
    
    # GET
    $Content = ( Invoke-WebRequest -Uri $uri -Method Get -ContentType "application/x-www-form-urlencoded" -Headers $Headers ).Content | ConvertFrom-Json

	# returns PsCustomObject representation of object
	if ( $Content.data ) { $Content.data }

    # otherwise raise an exception
    elseif ($Content.error) { Write-Error -Message $Content.error.message }

}
