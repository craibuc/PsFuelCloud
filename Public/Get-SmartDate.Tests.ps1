$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-SmartDate" {

    Context "Yesterday" {
        #arrange
        [PsCustomObject]$Expected = @{
            FromDate = (Get-Date).Date.AddDays(-1) # today @ 12:00:00, less one day
            ToDate = (Get-Date).Date.AddSeconds(-1) # today @ 12:00:00, less one second
        }

        It "returns a PsCustomObject that represents yesterday, from 12:00:00 to 23:59:59" {
            # act
            $Actual = Get-SmartDate -SymbolicDate 'Yesterday'

            # assert
            $Actual.FromDate | Should -Be $Expected.FromDate
            $Actual.ToDate | Should -Be $Expected.ToDate
        }    
    }

    Context "LastMonth" {
        #arrange
        [PsCustomObject]$Expected = @{
            FromDate = (Get-Date -Day 1).Date.AddMonths(-1) # first day of current month @ 12:00:00, less one month
            ToDate = (Get-Date -Day 1).Date.AddSeconds(-1) # first day of current month @ 12:00:00, less one second
        }

        It "returns a PsCustomObject that represents last month, from 12:00:00 to 23:59:59" {
            # act
            $Actual = Get-SmartDate -SymbolicDate 'LastMonth'

            # assert
            $Actual.FromDate | Should -Be $Expected.FromDate
            $Actual.ToDate | Should -Be $Expected.ToDate
        }    
    }

    Context "LastYear" {
        #arrange
        [PsCustomObject]$Expected = @{
            FromDate = (Get-Date -Month 1 -Day 1).Date  # first day of the current year @ 12:00:00
            ToDate = (Get-Date -Month 1 -Day 1).Date.AddYears(1).AddSeconds(-1)  # first day of the current year @ 12:00:00, plus one year, less one second
        }

        It "returns a PsCustomObject that represents last year, from 12:00:00 to 23:59:59" {
            # act
            $Actual = Get-SmartDate -SymbolicDate 'LastYear'

            # assert
            $Actual.FromDate | Should -Be $Expected.FromDate
            $Actual.ToDate | Should -Be $Expected.ToDate
        }    
    }

    Context "Invalid symbolic value" {
        It "throw an exception" {
            # act / assert
            { Get-SmartDate 'dummy' -ErrorAction Stop } | Should Throw "Cannot validate argument on parameter 'SymbolicDate'."
        }    
    }

}
