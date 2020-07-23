<#
.SYNOPSIS

.PARAMETER Id
Vehicle record identified by Id

.PARAMETER StartingDate
Vehicle records created or modified after StartingDate

.PARAMETER EndingDate
Vehicle records created or modified before EndingDate

.EXAMPLE
Get-Vehicle -AccessToken $AccessToken

All Vehicle records

.EXAMPLE
Get-Vehicle -AccessToken $AccessToken -Id $Id

Vehicle record identified by Id

.EXAMPLE
Get-Vehicle -AccessToken $AccessToken -StartingDate $StartingDate -EndingDate $EndingDate

Vehicle records created or modified within date range.

.NOTES
    2020-01-27 - CB - adding loop
#>
function Get-Vehicle {

    [CmdletBinding()]
    param
    (
        [Parameter(ParameterSetName='None',Mandatory)]
        [Parameter(ParameterSetName='ById',Mandatory)]
        [Parameter(ParameterSetName='ByDate',Mandatory)]
        [string]$AccessToken,

        [Parameter(ParameterSetName='ById',Mandatory)]
        [int]$Id,

        [Parameter(ParameterSetName='ByDate',Mandatory)]
        [datetime]$StartingDate,

        [Parameter(ParameterSetName='ByDate',Mandatory)]
        [datetime]$EndingDate
    )

	Write-Debug "$($MyInvocation.MyCommand.Name)"
	Write-Debug "AccessToken: $AccessToken"
	Write-Debug "Id: $Id"
    Write-Debug "StartingDate: $StartingDate"
    Write-Debug "EndingDate: $EndingDate"

    $Uri = "https://api.fuelcloud.com/rest/v1.0/vehicle"
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
        # if ( $Content.data ) { $Content.data }
        if ( $Content.data ) 
        { 
            $Content.data | 
            # date-range filter
            Where-Object { 
                (
                    # parameters not supplied
                    (-not $StartingDate -and -not $EndingDate) -or
                    (
                        (
                            ( [datetime]$_.created -ge $StartingDate.ToUniversalTime() -and [datetime]$_.created -le $EndingDate.ToUniversalTime() ) -or
                            ( [datetime]$_.updated -ge $StartingDate.ToUniversalTime() -and [datetime]$_.updated -le $EndingDate.ToUniversalTime() )
                        )
                    )
                ) 
            } |
            ForEach-Object {

                # rename created --> created_utc
                $created_utc = [datetime]$_.created
                $_.PSObject.Properties.Remove('created')
                $_ | Add-Member -NotePropertyName created_utc -NotePropertyValue $created_utc

                # add created; populate with created_utc @ local
                $_ | Add-Member -NotePropertyName created -NotePropertyValue $created_utc.ToLocalTime()

                # rename updated --> updated_utc
                $updated_utc = [datetime]$_.updated
                $_.PSObject.Properties.Remove('updated')
                $_ | Add-Member -NotePropertyName updated_utc -NotePropertyValue $updated_utc

                # add updated; populate with updated_utc @ local
                $_ | Add-Member -NotePropertyName updated -NotePropertyValue $updated_utc.ToLocalTime()

                $_

            }
        }
        # otherwise raise an exception
        elseif ($Content.error) { Write-Error -Message $Content.error.message }
    
    } while ( $null -ne $Uri )
}
