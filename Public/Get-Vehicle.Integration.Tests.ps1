$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "Get-Vehicle" -tag 'integration' {

    # arrange
    $Parent = Split-Path -Parent $here
    $AccessToken = Get-Content -Path "$Parent\Credential.txt" -Raw
    Write-Debug "AccessToken: $AccessToken"

    $PSDefaultParameterValues['*:AccessToken'] = $AccessToken

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
