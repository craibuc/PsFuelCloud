BeforeAll {

    # diretories
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsFuelCloud/Public/"
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # dot sourcing
    $sut = (Split-Path -Leaf $PsCommandPath) -replace '\.Tests\.', '.'
    . (Join-Path $PublicPath $sut)

}

Describe "Get-FuelCloudDriver" -tag 'unit' {

    Context "Parameter validation" {
        BeforeAll { $Command = Get-Command 'Get-FuelCloudDriver' }

        Context 'AccessToken' {
            BeforeAll {
                $ParameterName = 'AccessToken'
            }

            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'Id' {
            BeforeAll {
                $ParameterName = 'Id'
                $ParameterSetName = 'ById'
            }

            It "is an [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            It "is mandatory member of '$ParameterSetName' parameter set" {
                $Command.parameters[$ParameterName].parametersets[$ParameterSetName].IsMandatory | Should -Be $true
            }

        }

        Context 'Code' {
            BeforeAll {
                $ParameterName = 'Code'
                $ParameterSetName = 'ByCode'
            }

            It "is an [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory member of '$ParameterSetName' parameter set" {
                $Command.parameters[$ParameterName].parametersets[$ParameterSetName].IsMandatory | Should -Be $true
            }

        }

        Context 'Phone' {
            BeforeAll {
                $ParameterName = 'Phone'
                $ParameterSetName = 'ByPhone'
            }

            It "is an [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory member of '$ParameterSetName' parameter set" {
                $Command.parameters[$ParameterName].parametersets[$ParameterSetName].IsMandatory | Should -Be $true
            }

        }

        Context 'Status' {
            BeforeAll {
                $ParameterName = 'Status'
                $ParameterSetName = 'ByStatus'
            }

            It "is an [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            It "is mandatory member of '$ParameterSetName' parameter set" {
                $Command.parameters[$ParameterName].parametersets[$ParameterSetName].IsMandatory | Should -Be $true
            }

        }

        Context 'StartingDate' {
            BeforeAll {
                $ParameterName = 'StartingDate'
                $ParameterSetName = 'ByDate'
            }

            It "is a [datetime]" {
                $Command | Should -HaveParameter $ParameterName -Type datetime
            }
            It "is mandatory member of '$ParameterSetName' parameter set" {
                $Command.parameters[$ParameterName].parametersets[$ParameterSetName].IsMandatory | Should -Be $true
            }

        }

        Context 'EndingDate' {
            BeforeAll {
                $ParameterName = 'EndingDate'
                $ParameterSetName = 'ByDate'
            }

            It "is a [datetime]" {
                $Command | Should -HaveParameter $ParameterName -Type datetime
            }
            It "is mandatory member of '$ParameterSetName' parameter set" {
                $Command.parameters[$ParameterName].parametersets[$ParameterSetName].IsMandatory | Should -Be $true
            }

        }

    } # /context (parameter validation)

    Context 'No filtering parameters' {

        BeforeAll {

            # arrange
            $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'

            Mock Invoke-WebRequest {
                Write-Debug "***** Page 1 *****"
                $Fixture = 'Get-FuelCloudDriver.Response.Multiple.1.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

            Mock Invoke-WebRequest {
                Write-Debug "***** Page 0 *****"
                $Fixture = 'Get-FuelCloudDriver.Response.Multiple.0.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            } -ParameterFilter { $Uri -eq 'https://api.fuelcloud.com/rest/v1.0/driver' }

            # act
            $Actual = Get-FuelCloudDriver -AccessToken $AccessToken
        }

        BeforeEach {
            # act
            $Actual = Get-FuelCloudDriver -AccessToken $AccessToken
        }

        Context "Request" {

            It "sets the Authorization header to the AccessToken" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Headers.Authorization -eq $AccessToken
                }
            }

            It "sets the Content-Type header to 'application/x-www-form-urlencoded'" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $ContentType -eq 'application/x-www-form-urlencoded'
                }
            }

            It "sets the Method to Get" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Method -eq 'Get'
                }
            }

            It "sets the Uri correctly" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Uri -eq "https://api.fuelcloud.com/rest/v1.0/driver"
                }
            }

            it "makes multiple requests to get all pages" {
                # assert
                Assert-MockCalled Invoke-WebRequest -Times 2 -Exactly
            }
        
        }

        Context "Response" {

            It "returns the list of drivers" {
                # assert
                $Actual.length | Should -Be 4
            }
    
        }

    } # /context (no filter parameters)

    Context 'ById' {

        BeforeAll {

            # arrange
            $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'
            $Id = 123456

            Mock Invoke-WebRequest {
                $Fixture = 'Get-FuelCloudDriver.Response.One.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

        }

        BeforeEach {
            # act
            $Actual = Get-FuelCloudDriver -AccessToken $AccessToken -Id $Id
        }

        Context "Request" {

            It "sets the Authorization header to the AccessToken" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Headers.Authorization -eq $AccessToken
                }
            }

            It "sets the Content-Type header to 'application/x-www-form-urlencoded'" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $ContentType -eq 'application/x-www-form-urlencoded'
                }
            }

            It "sets the Method to Get" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Method -eq 'Get'
                }
            }

            It "sets the Uri correctly" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Uri -eq "https://api.fuelcloud.com/rest/v1.0/driver/$Id"
                }
            }

        } # / context request

        Context "Response" {

            It "returns the specified driver" {
                # assert
                $Actual.id | Should -Be $Id
            }
    
        }


    } # /context (id)

    Context 'ByCode' {

        BeforeAll {

            # arrange
            $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'
            $Code = 'ABCDEF'

            Mock Invoke-WebRequest {
                $Fixture = 'Get-FuelCloudDriver.Response.One.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

        }

        BeforeEach {
            # act
            $Actual = Get-FuelCloudDriver -AccessToken $AccessToken -Code $Code
        }

        Context "Request" {

            It "sets the Authorization header to the AccessToken" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Headers.Authorization -eq $AccessToken
                }
            }

            It "sets the Content-Type header to 'application/x-www-form-urlencoded'" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $ContentType -eq 'application/x-www-form-urlencoded'
                }
            }

            It "sets the Method to Get" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Method -eq 'Get'
                }
            }

            It "sets the Uri correctly" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Uri -eq "https://api.fuelcloud.com/rest/v1.0/driver?filter[code]=$Code"
                }
            }

        } # / context request

        Context "Response" {

            It "returns the specified driver" {
                # assert
                $Actual.Code | Should -Be $Code
            }
    
        }


    } # /context (code)

    Context 'ByPhone' {

        BeforeAll {

            # arrange
            $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'
            $Phone = '8019310852'

            Mock Invoke-WebRequest {
                $Fixture = 'Get-FuelCloudDriver.Response.One.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

        }

        BeforeEach {
            # act
            $Actual = Get-FuelCloudDriver -AccessToken $AccessToken -Phone $Phone
        }

        Context "Request" {

            It "sets the Authorization header to the AccessToken" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Headers.Authorization -eq $AccessToken
                }
            }

            It "sets the Content-Type header to 'application/x-www-form-urlencoded'" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $ContentType -eq 'application/x-www-form-urlencoded'
                }
            }

            It "sets the Method to Get" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Method -eq 'Get'
                }
            }

            It "sets the Uri correctly" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Uri -eq "https://api.fuelcloud.com/rest/v1.0/driver?filter[phone]=$Phone"
                }
            }

        } # / context request

    } # /context (phone)

    Context 'ByStatus' {

        BeforeAll {

            # arrange
            $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'
            $Status = 1

            Mock Invoke-WebRequest {
                $Fixture = 'Get-FuelCloudDriver.Response.One.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

        }

        BeforeEach {
            # act
            $Actual = Get-FuelCloudDriver -AccessToken $AccessToken -Status $Status
        }

        Context "Request" {

            It "sets the Authorization header to the AccessToken" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Headers.Authorization -eq $AccessToken
                }
            }

            It "sets the Content-Type header to 'application/x-www-form-urlencoded'" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $ContentType -eq 'application/x-www-form-urlencoded'
                }
            }

            It "sets the Method to Get" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Method -eq 'Get'
                }
            }

            It "sets the Uri correctly" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Uri -eq "https://api.fuelcloud.com/rest/v1.0/driver?filter[status]=$Status"
                }
            }

        } # / context request

    } # /context (status)

    Context "ByDate" {

        BeforeAll {

            # arrange
            $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'
            $StartingDate = '05/01/2020'
            $EndingDate = '05/02/2020'

            Mock Invoke-WebRequest {
                $Fixture = 'Get-FuelCloudDriver.Response.Multiple.1.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

        }

        BeforeEach {
            # act
            $Actual = Get-FuelCloudDriver -AccessToken $AccessToken -StartingDate $StartingDate -EndingDate $EndingDate
        }

        Context "Request" {

            It "sets the Authorization header to the AccessToken" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Headers.Authorization -eq $AccessToken
                }
            }

            It "sets the Content-Type header to 'application/x-www-form-urlencoded'" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $ContentType -eq 'application/x-www-form-urlencoded'
                }
            }

            It "sets the Method to Get" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Method -eq 'Get'
                }
            }

            It "sets the Uri correctly" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Uri -eq "https://api.fuelcloud.com/rest/v1.0/driver"
                }
            }
    
        }

        Context "Response" {

            It "returns the specified driver" {
                # assert
                $Actual | Should -HaveCount 2
            }
    
        }

    }

    Context "Invalid credentials supplied" {

        BeforeAll {

            # arrange
            $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'

            Mock Invoke-WebRequest { 
                $Response = New-Object System.Net.Http.HttpResponseMessage 401
                $Phrase = 'Response status code does not indicate success: 401 (Unauthorized).'
                Throw New-Object Microsoft.PowerShell.Commands.HttpResponseException $Phrase, $Response
            }

        }

        it "throws an exception" {

            # act/assert
            { Get-FuelCloudDriver -AccessToken $AccessToken } | Should -Throw 'Response status code does not indicate success: 401 (Unauthorized).'
        }

    } # /Context

}