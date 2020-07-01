$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-Vehicle" -tag 'unit' {

    # arrange
    Context "No parameters supplied" {

        It "returns all vehicles" {
            # act
            $Vehicle = Get-Vehicle

            # assert
            $Vehicle | Measure-Object | Select-Object -Expand Count | Should -BeGreaterThan 1
        }
  
    }

    Context "`$Id parameter supplied" {

        $Id = '203536'

        It "returns the specified vehicle" {
            # act
            $Vehicle = Get-Vehicle -Id $Id

            # assert
            $Vehicle | Should -HaveCount 1
        }
        
    }
    
}
