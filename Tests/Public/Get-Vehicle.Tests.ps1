# /PsFuelCloud
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFuelCloud/PsFuelCloud/Public
$PublicPath = Join-Path $ProjectDirectory "/PsFuelCloud/Public/"

# /PsFuelCloud/Tests/Fixtures/
$FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Get-Driver.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFuelCloud/PsFuelCloud/Public/Get-Driver.ps1
. (Join-Path $PublicPath $sut)

Describe "Get-Vehicle" -tag 'unit' {

    Context "Parameter validation" {
        $Command = Get-Command 'Get-Vehicle'

        Context 'AccessToken' {
            $ParameterName = 'AccessToken'

            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'Id' {
            $ParameterName = 'Id'
            $ParameterSetName = 'ById'

            It "is an [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            It "is mandatory member of '$ParameterSetName' parameter set" {
                $Command.parameters[$ParameterName].parametersets[$ParameterSetName].IsMandatory | Should -Be $true
            }

        }

        Context 'StartingDate' {
            $ParameterName = 'StartingDate'
            $ParameterSetName = 'ByDate'

            It "is a [datetime]" {
                $Command | Should -HaveParameter $ParameterName -Type datetime
            }
            It "is mandatory member of '$ParameterSetName' parameter set" {
                $Command.parameters[$ParameterName].parametersets[$ParameterSetName].IsMandatory | Should -Be $true
            }

        }

        Context 'EndingDate' {
            $ParameterName = 'EndingDate'
            $ParameterSetName = 'ByDate'

            It "is a [datetime]" {
                $Command | Should -HaveParameter $ParameterName -Type datetime
            }
            It "is mandatory member of '$ParameterSetName' parameter set" {
                $Command.parameters[$ParameterName].parametersets[$ParameterSetName].IsMandatory | Should -Be $true
            }

        }

    } # /context (parameter validation)

    Context "Default parameters" {

        # arrange
        $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'

        BeforeEach {

            Mock Invoke-WebRequest {
                Write-Debug "***** Page 1 *****"
                $Fixture = 'Get-Vehicle.Multiple.1.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

            Mock Invoke-WebRequest {
                Write-Debug "***** Page 0 *****"
                $Fixture = 'Get-Vehicle.Multiple.0.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            } -ParameterFilter { $Uri -eq 'https://api.fuelcloud.com/rest/v1.0/vehicle' }

            # act
            $Actual = Get-Vehicle -AccessToken $AccessToken
        }

        it "makes the correct request" {

            # arrange
            $Expected = @{
                Uri='https://api.fuelcloud.com/rest/v1.0/vehicle'
                Headers = @{
                    "Content-Type"='application/json'
                }
            }

            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $Method -eq 'Get' -and
                $Uri -eq $Expected.Uri
                $ContentType -eq $Expected.Headers."Content-Type"
                $Headers.Authorization -eq $AccessToken
            } -Times 2 -Exactly
        }

        It "returns the list of vehicles" {
            # assert
            $Actual.length | Should -Be 4
        }

    }

    Context "ById" {
        $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'
        $Id = 111111

        Mock Invoke-WebRequest {
            $Fixture = 'Get-Vehicle.One.json'
            $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

            $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
            $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
            $Response
        }

        BeforeEach {
            # act
            $Actual = Get-Vehicle -AccessToken $AccessToken -Id $Id
        }

        it "makes the correct request" {

            # arrange
            $Expected = @{
                Uri="https://api.fuelcloud.com/rest/v1.0/vehicle/$Id"
                Headers = @{
                    "Content-Type"='application/json'
                }
            }

            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $Method -eq 'Get' -and
                $Uri -eq "$($Expected.Uri)/$Id"
                $ContentType -eq $Expected.Headers."Content-Type"
                $Headers.Authorization -eq $AccessToken
            }  -Times 1 -Exactly
        }

        It "returns the specified driver" {
            # assert
            $Actual.id | Should -Be $Id
        }

    }

    Context "ByDate" {

        # arrange
        $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'
        $StartingDate = '05/01/2020'
        $EndingDate = '05/02/2020'

        BeforeEach {

            Mock Invoke-WebRequest {
                Write-Debug "***** Page 1 *****"
                $Fixture = 'Get-Vehicle.Multiple.1.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

            Mock Invoke-WebRequest {
                Write-Debug "***** Page 0 *****"
                $Fixture = 'Get-Vehicle.Multiple.0.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            } -ParameterFilter { $Uri -eq 'https://api.fuelcloud.com/rest/v1.0/vehicle' }

            # act
            $Actual = Get-Vehicle -AccessToken $AccessToken -StartingDate $StartingDate -EndingDate $EndingDate
        }

        it "makes the correct request" {

            # arrange
            $Expected = @{
                Uri="https://api.fuelcloud.com/rest/v1.0/vehicle"
                Headers = @{
                    "Content-Type"='application/json'
                }
            }

            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $Method -eq 'Get' -and
                $Uri -eq "$($Expected.Uri)/"
                $ContentType -eq $Expected.Headers."Content-Type"
                $Headers.Authorization -eq $AccessToken
            }  -Times 2 -Exactly
        }

        It "returns vehicles that have been created or updated between $StartingDate and $EndingDate" {
            # assert
            $Actual | Should -HaveCount 2
        }

    }

    Context "Invalid credentials supplied" {

        it "throws an exception" {
            # arrange
            $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'

            Mock Invoke-WebRequest { 
                $Response = New-Object System.Net.Http.HttpResponseMessage 401
                $Phrase = 'Response status code does not indicate success: 401 (Unauthorized).'
                Throw New-Object Microsoft.PowerShell.Commands.HttpResponseException $Phrase, $Response
            }

            # act/assert
            { Get-Vehicle -AccessToken $AccessToken } | Should -Throw 'Response status code does not indicate success: 401 (Unauthorized).'
        }

    } # /Context

}
