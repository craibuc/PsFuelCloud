<#
.SYNOPIS
Returns a date-range object that represents the symbolic value.

.PARAMETER SymbolicDate
One of these values: 'Yesterday', 'LastMonth', 'LastYear'.

.INPUTS
None

.OUTPUTS
PsCustomObject

.EXAMPLE
Get-SmartDate 'LastMonth'

FromDate           ToDate
--------           ------
2/2/20 12:00:00 AM 2/2/20 11:59:59 PM

#>
function Get-SmartDate {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory,Position=0)]
        [ValidateSet('Yesterday','LastMonth','LastYear')] 
        [string]$SymbolicDate
    )

	Write-Debug "$($MyInvocation.MyCommand.Name)"
	Write-Debug "SymbolicDate: $SymbolicDate"

    switch ($SymbolicDate)
    {
        'Yesterday'
        {
            return [PsCustomObject]@{
                FromDate = (Get-Date).Date.AddDays(-1) # today @ 12:00:00, less one day
                ToDate = (Get-Date).Date.AddSeconds(-1) # today @ 12:00:00, less one second    
            }
        }
        'LastMonth'
        {
            return [PsCustomObject]@{
                FromDate = (Get-Date -Day 1).Date.AddMonths(-1) # first day of current month @ 12:00:00, less one month
                ToDate = (Get-Date -Day 1).Date.AddSeconds(-1) # first day of current month @ 12:00:00, less one second
            }
        }
        'LastYear' 
        {
            return [PsCustomObject]@{
                FromDate = (Get-Date -Month 1 -Day 1).Date
                ToDate = (Get-Date -Month 1 -Day 1).Date.AddYears(1).AddSeconds(-1)
            }
        }
        # Default{}
    }

}
