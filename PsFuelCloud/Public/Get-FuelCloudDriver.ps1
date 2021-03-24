<#
.SYNOPSIS

.PARAMETER Id
Find Driver record identified by Id

.PARAMETER Code
Find Driver record identified by Code

.PARAMETER Phone
Find Driver record identified by telephone #

.PARAMETER Status
Find Driver record(s) identified by Status

.PARAMETER StartingDate
Driver records created or modified after StartingDate

.PARAMETER EndingDate
Driver records created or modified before EndingDate

.EXAMPLE
Get-Driver -AccessToken $AccessToken

All driver records

.EXAMPLE
Get-FuelCloudDriver -AccessToken $AccessToken -Id $Id

Driver record identified by Id

.EXAMPLE
Get-FuelCloudDriver -AccessToken $AccessToken -StartingDate $StartingDate -EndingDate $EndingDate

Driver records created or modified within date range.

.NOTES
    2020-07-01 - CB - adding StartingDate/EndingDate parameters and associated filtering logic; renaming created-->created_utc; renaming updated-->updated_utc; adding new created and update (local time)
    2020-01-27 - CB - adding loop
#>
function Get-FuelCloudDriver {

    [CmdletBinding()]
    param
    (
        [Parameter(ParameterSetName='None',Mandatory)]
        [Parameter(ParameterSetName='ById',Mandatory)]
        [Parameter(ParameterSetName='ByCode',Mandatory)]
        [Parameter(ParameterSetName='ByPhone',Mandatory)]
        [Parameter(ParameterSetName='ByStatus',Mandatory)]
        [Parameter(ParameterSetName='ByDate')]
        [string]$AccessToken,

        [Parameter(ParameterSetName='ById',Mandatory)]
        [int]$Id,

        [Parameter(ParameterSetName='ByCode',Mandatory)]
        [string]$Code,

        [Parameter(ParameterSetName='ByPhone',Mandatory)]
        [string]$Phone,

        [Parameter(ParameterSetName='ByStatus',Mandatory)]
        [ValidateSet(0,1)]
        [int]$Status,

        [Parameter(ParameterSetName='ByDate',Mandatory)]
        [datetime]$StartingDate,

        [Parameter(ParameterSetName='ByDate',Mandatory)]
        [datetime]$EndingDate
    )

	Write-Debug "$($MyInvocation.MyCommand.Name)"
	Write-Debug "AccessToken: $AccessToken"
    Write-Debug "Id: $Id"
    Write-Debug "Code: $Code"
    Write-Debug "Phone: $Phone"
    Write-Debug "Status: $Status"
    
    Write-Debug "StartingDate: $StartingDate"
    Write-Debug "EndingDate: $EndingDate"

    $Filter = @()
    if ($Code) { $Filter += "filter[code]=$Code"}
    if ($Phone) { $Filter += "filter[phone]=$Phone"}
    if ($Status) { $Filter += "filter[status]=$Status"}

    $Uri = "https://api.fuelcloud.com/rest/v1.0/driver"

    if ($Id) { $Uri = "$Uri/$Id" }
    elseif ($Filter.Length -gt 0) { $Uri = "{0}?{1}" -f $Uri, ($Filter -Join '&') }
    
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

                # # full_name = surname, first_name
                # if ( $_.full_name -match ',' )
                # {
                #     $_ | Add-Member -NotePropertyName first_name -NotePropertyValue ($_.full_name -split ',')[1].Trim()
                #     $_ | Add-Member -NotePropertyName surname -NotePropertyValue ($_.full_name -split ',')[0].Trim()
                # }
                # # full_name = first_name surname
                # elseif ( $_.full_name -match ' ' )
                # {
                #     $_ | Add-Member -NotePropertyName first_name -NotePropertyValue ($_.full_name -split ' ')[0].Trim()
                #     $_ | Add-Member -NotePropertyName surname -NotePropertyValue ($_.full_name -split ' ')[1].Trim()
                # }

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
