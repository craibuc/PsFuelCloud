<#
.SYNOPSIS
Returns transactions that occurred during a time period.

.PARAMETER AccessToken
Resembles 'Bearer lBCOWdDbXVRQnZqQzQ0...'

.PARAMETER FromDate
Include transactions that occur after this date.

.PARAMETER ToDate
Include transactions that occur prior to this date.

.PARAMETER DriverId
Include transactions that are assocated with this DriverId.

.PARAMETER SiteId
Include transactions that are assocated with this SiteId.

.PARAMETER PumpName
Include transactions that are assocated with this PumpName.

.PARAMETER VehicleId
Include transactions that are assocated with this VehicleId.

.NOTES
The `start_date` and `end_date` fields are values at UTC.

.LINK
https://developer.fuelcloud.com/?version=latest#e52c2e16-51da-401c-93d5-da53fb230f25

#>
function Get-Transaction {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]$AccessToken,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('start_date')]
        [datetime]$FromDate = (Get-Date).Date,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('end_date')]
        [datetime]$ToDate = (Get-Date).Date.AddDays(1).AddSeconds(-1),

        [int]$DriverId,
        [string]$PumpName,
        [int]$SiteId,
        [int]$VehicleId

    )

	Write-Debug "$($MyInvocation.MyCommand.Name)"
	Write-Debug "AccessToken: $AccessToken"

    Write-Debug "FromDate: $FromDate"
    Write-Debug "ToDate: $ToDate"

    $Filter = @()
    $Filter += "start_date=$($FromDate.ToUniversalTime().ToString("o"))"
    $Filter += "end_date=$($ToDate.ToUniversalTime().ToString("o"))"

    if ($DriverId) { $Filter += "filter[driver_id]=$DriverId"}
    if ($PumpName) { $Filter += "filter[pump_name]=$PumpName"}
    if ($SiteId) { $Filter += "filter[site_id]=$SiteId"}
    if ($VehicleId) { $Filter += "filter[vehicle_id]=$VehicleID"}

    $Uri = "https://api.fuelcloud.com/rest/v1.0/transaction?$( $Filter -Join '&' )"
	Write-Debug "Uri: $Uri"

    $Headers = @{Authorization = $AccessToken}
    
    do {

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
