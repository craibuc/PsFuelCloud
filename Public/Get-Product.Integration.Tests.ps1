$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "Get-Product" -tag 'integration' {

    # arrange
    $Parent = Split-Path -Parent $here
    $AccessToken = Get-Content -Path "$Parent\Credential.txt" -Raw
    Write-Debug "AccessToken: $AccessToken"

    $PSDefaultParameterValues['*:AccessToken'] = $AccessToken

    Context "No parameters supplied" {

        It "returns all products" {
            # act
            $Product = Get-Product

            # assert
            $Product | Measure-Object | Select-Object -Expand Count | Should -BeGreaterThan 1
        }
  
    }

    Context "`$Id parameter supplied" {

        $Id = '883'

        It "returns the specified product" {
            # act
            $Product = Get-Product -Id $Id

            # assert
            $Product | Should -HaveCount 1
        }
        
    }

}
