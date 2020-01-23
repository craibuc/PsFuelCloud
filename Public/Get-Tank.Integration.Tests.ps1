$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "Get-Tank" -tag 'integration' {

    # arrange
    $Parent = Split-Path -Parent $here
    $AccessToken = Get-Content -Path "$Parent\Credential.txt" -Raw
    Write-Debug "AccessToken: $AccessToken"

    $PSDefaultParameterValues['*:AccessToken'] = $AccessToken

    Context "No parameters supplied" {

        It "returns all tanks" {
            # act
            $Tank = Get-Tank

            # assert
            $Tank | Measure-Object | Select-Object -Expand Count | Should -BeGreaterThan 1
        }

    }

    Context "`$Id parameter supplied" {

        $Id = '200179'

        It "returns the specified tank" {
            # act
            $Tank = Get-Tank -Id $Id

            # assert
            $Tank | Should -HaveCount 1
        }
        
    }

}
