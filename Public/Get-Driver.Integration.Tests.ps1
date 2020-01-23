$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "Get-Driver" -tag 'integration' {

    # arrange
    $Parent = Split-Path -Parent $here
    $AccessToken = Get-Content -Path "$Parent\Credential.txt" -Raw
    Write-Debug "AccessToken: $AccessToken"

    $PSDefaultParameterValues['*:AccessToken'] = $AccessToken

    Context "No parameters supplied" {

        It "returns all drivers" {
            # act
            $Driver = Get-Driver

            # assert
            $Driver | Measure-Object | Select-Object -Expand Count | Should -BeGreaterThan 1
        }
  
    }

    Context "`$Id parameter supplied" {

        $Id = '404124'

        It "returns the specified driver" {
            # act
            $Driver = Get-Driver -Id $Id

            # assert
            $Driver | Should -HaveCount 1
        }
        
    }

}
