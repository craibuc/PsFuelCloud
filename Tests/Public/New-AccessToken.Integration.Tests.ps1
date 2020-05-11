$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$Parent = Split-Path -Parent $here

$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "New-AccessToken" -tag 'integration' {

    Context "supplying a valid refresh token" {

        #arrange
        $FuelCloudSettings = Import-Clixml (Join-Path $Parent 'Settings.FuelCloud.xml')

        Write-Debug "AccessToken: $($FuelCloudSettings.AccessToken)"
        Write-Debug "RefreshToken: $($FuelCloudSettings.RefreshToken)"

        It "creates a new access token" {
            # act
            $Actual = New-AccessToken -AccessToken $FuelCloudSettings.AccessToken -RefreshToken $FuelCloudSettings.RefreshToken

            # assert
            $Actual.access_token | Should -BeLike 'Bearer *'
            $Actual.refresh_token | Should -Not -BeNullOrEmpty
            $Actual.expires_at | Should -BeOfType DateTime
        }  
  
    }

    Context "supplying an invalid access token" {

        #arrange
        $AccessToken = 'invalid access token'

        It "throws a Not Found (404) exception" {
            # act / assert
            { New-AccessToken -AccessToken $AccessToken -RefreshToken $FuelCloudSettings.RefreshToken  -ErrorAction Stop} | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }    
    }

    Context "supplying an invalid refresh token" {

        #arrange
        $RefreshToken = 'invalid refresh token'

        It "throws a Not Found (404) exception" {
            # act / assert
            { New-AccessToken -AccessToken $FuelCloudSettings.AccessToken -RefreshToken $RefreshToken  -ErrorAction Stop} | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        }    
    }

}
