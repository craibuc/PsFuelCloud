$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-AccessToken" -tag 'integration' {

    Context "supplying a valid refresh token" {

        #arrange
        $Parent = Split-Path -Parent $here

        $AccessToken = Get-Content -Path "$Parent\AccessToken.txt" -Raw
        Write-Debug "AccessToken: $AccessToken"    
        $PSDefaultParameterValues['*:AccessToken'] = $AccessToken

        $RefreshToken = Get-Content -Path "$Parent\RefreshToken.txt" -Raw
        Write-Debug "RefreshToken: $RefreshToken"

        It "creates a new access token" {
            # act
            $Actual = New-AccessToken -AccessToken $AccessToken -RefreshToken $RefreshToken

            # assert
            $Actual | Should -BeLike 'Bearer *'
        }    
    }

    Context "supplying an INvalid refresh token" {

        #arrange
        $RefreshToken = 'invalid token'

        It "throws an exception" {
            # act / assert
            { New-AccessToken -RefreshToken $RefreshToken  -ErrorAction Stop} | Should -Throw # ""
        }    
    }

}
