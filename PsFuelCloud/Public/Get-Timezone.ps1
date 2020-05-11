<#

.NOTES
    2020-01-28 - CB - adding loop; removing $Id code
#>
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
	Write-Debug "Uri: $Uri"

    $Headers = @{Authorization = $AccessToken}
    
    do
    {
        # GET
        $Content = ( Invoke-WebRequest -Uri $uri -Method Get -ContentType "application/x-www-form-urlencoded" -Headers $Headers ).Content | ConvertFrom-Json

        # get Uri for the next set of records
        $Uri = $Content.meta.next
        Write-Debug "Next Uri: $Uri"
    
        # returns PsCustomObject representation of object
        if ( $Content.data ) { $Content.data }

        # otherwise raise an exception
        elseif ($Content.error) { Write-Error -Message $Content.error.message }

    } while ( $null -ne $Uri )

}
