$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "Get-Timezone" -tag 'integration' {

    # arrange
    $Parent = Split-Path -Parent $here
    $AccessToken = Get-Content -Path "$Parent\Credential.txt" -Raw
    Write-Debug "AccessToken: $AccessToken"

    $PSDefaultParameterValues['*:AccessToken'] = $AccessToken

    Context "No parameters supplied" {

        It "returns all timezones" {
            # act
            $Timezone = Get-Timezone

            # assert
            $Timezone | Measure-Object | Select-Object -Expand Count | Should -BeGreaterThan 1
        }
  
    }

}
