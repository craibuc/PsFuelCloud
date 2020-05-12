# /PsFuelCloud
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFuelCloud/PsFuelCloud/Public
$PublicPath = Join-Path $ProjectDirectory "/PsFuelCloud/Public/"

# /PsFuelCloud/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# New-AccessToken.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFuelCloud/PsFuelCloud/Public/New-AccessToken.ps1
. (Join-Path $PublicPath $sut)

Describe "New-AccessToken" -tag 'unit' {

    Context "Valid credentials" {

        #arrange
        $AccessToken = 'Bearer old-access-token'
        $RefreshToken = 'old-refresh-token'
        $Url = "https://api.fuelcloud.com/rest/v1.0/refresh-token/$RefreshToken"

        $Content = @{
            access_token = 'new-access-token'
            type = 'Bearer'
            expires_in = 604800 # 7 days (60 * 60 * 24 * 7)
            refresh_token = 'new-refresh-token'
        }

        BeforeEach {

            # arrange
            Mock Invoke-WebRequest {

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Content = $Content | ConvertTo-Json
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response

            }
    
            # act
            $Actual = New-AccessToken -AccessToken $AccessToken -RefreshToken $RefreshToken

        }

        It "sends the expected request" {

            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $Method -eq 'GET' -and
                $ContentType -eq 'application/x-www-form-urlencoded' -and
                $Uri -eq $Url
            }

        }

        It "returns the expected response" {

            # assert
            $Actual.AccessToken | Should -Be ($Content.type + ' ' + $Content.access_token)
            $Actual.RefreshToken | Should -Be $Content.refresh_token
            $Actual.Expires | Should -BeOfType DateTime
    
        }    

    }

    Context "supplying an INvalid access token" {

        # arrange
        $AccessToken = 'Bearer invalid-access-token'
        $RefreshToken = 'refresh-token'

        Mock Invoke-WebRequest {
            <#
            {
                "title": "Bad credentials. Anonymous user resolved for a resource that requires authentication.",
                "detail": "Unauthorized",
                "status": 401
            }
            #>

            $Response = New-Object System.Net.Http.HttpResponseMessage 401
            $Phrase = 'Response status code does not indicate success: 401 (Unauthorized).'
            Throw New-Object Microsoft.PowerShell.Commands.HttpResponseException $Phrase, $Response
        }

        It "throws an exception" {
            # act / assert
            { New-AccessToken -AccessToken $AccessToken -RefreshToken $RefreshToken  -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 401 (Unauthorized)."
        }

    }

    Context "supplying an INvalid refresh token" {

        # arrange
        $AccessToken = 'Bearer access-token'
        $RefreshToken = 'invalid-refresh-token'

        Mock Invoke-WebRequest {
            $Response = New-Object System.Net.Http.HttpResponseMessage 404
            $Phrase = 'Response status code does not indicate success: 404 (Not Found).'
            Throw New-Object Microsoft.PowerShell.Commands.HttpResponseException $Phrase, $Response
        }

        It "throws an exception" {
            # act / assert
            { New-AccessToken -AccessToken $AccessToken -RefreshToken $RefreshToken  -ErrorAction Stop } | Should -Throw "Response status code does not indicate success: 404 (Not Found)."
        } 
  
    }

}
