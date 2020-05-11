<#
.NOTES
    2020-01-27 - CB - adding loop
#>
function Get-Driver {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]$AccessToken,

        [int]$Id
    )

	Write-Debug "$($MyInvocation.MyCommand.Name)"
	Write-Debug "AccessToken: $AccessToken"
	Write-Debug "Id: $Id"

    $Uri = "https://api.fuelcloud.com/rest/v1.0/driver"
    if ($Id) { $Uri = "$Uri/$Id" }
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
