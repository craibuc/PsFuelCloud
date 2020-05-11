$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "Get-Site" -tag 'integration' {

    # arrange
    $Parent = Split-Path -Parent $here
    $AccessToken = Get-Content -Path "$Parent\Credential.txt" -Raw
    Write-Debug "AccessToken: $AccessToken"

    $PSDefaultParameterValues['*:AccessToken'] = $AccessToken

    Context "No parameters supplied" {

        It "returns all sites" {
            # act
            $Site = Get-Site

            # assert
            $Site | Measure-Object | Select-Object -Expand Count | Should -BeGreaterThan 0
        }
  
    }

    Context "`$Id parameter supplied" {

        $Id = '200128'

        It "returns the specified site" {
            # act
            $Site = Get-Site -Id $Id

            # assert
            $Site | Should -HaveCount 1
        }
        
    }
    
}
