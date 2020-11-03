<#
https://powershell.org/forums/topic/pester-invoke-webrequest/
https://groups.google.com/forum/#!topic/pester/ZgNpVc36Z0k
#>

BeforeAll {

    # /PsFuelCloud
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsFuelCloud/PsFuelCloud/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsFuelCloud/Public/"

    # /PsFuelCloud/Tests/Fixtures/
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # Set-FuelCloudDriver.ps1
    $SUT = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    . (Join-Path $PublicPath $SUT)

}

Describe "Set-FuelCloudDriver" -tag 'unit' {

    Context "Parameter validation" {
        BeforeAll {
            $Command = Get-Command 'Set-FuelCloudDriver'
        }

        Context 'AccessToken' {
            BeforeEach {
                $ParameterName = 'AccessToken'
            }
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'id' {
            BeforeEach {
                $ParameterName = 'id'
            }
            It "is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'full_name' {
            BeforeEach {
                $ParameterName = 'full_name'
            }
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'phone' {
            BeforeEach {
                $ParameterName = 'phone'
            }
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'pin' {
            BeforeEach {
                $ParameterName = 'pin'
            }
            It "is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            It "is 5, numeric digits in length" {
                $Attribute = $command.Parameters[$ParameterName].Attributes | Where-Object { $_.TypeId -eq [System.Management.Automation.ValidateRangeAttribute] }
                $Attribute.MinRange | Should -Be 0
                $Attribute.MaxRange | Should -Be 99999
            }
        }

        Context 'code' {
            BeforeEach {
                $ParameterName = 'code'
            }
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'status' {
            BeforeEach {
                $ParameterName = 'status'
            }
            It "is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            It "is 0 or 1" {
                $Attribute = $command.Parameters[$ParameterName].Attributes | Where-Object { $_.TypeId -eq [System.Management.Automation.ValidateRangeAttribute] }
                $Attribute.MinRange | Should -Be 0
                $Attribute.MaxRange | Should -Be 1
            }

        }

    } # /context (parameter validation)

    Context "Usage" {
    
        BeforeAll {

            # arrange
            $AccessToken = '7522a674-f71d-4c51-ba0c-c8cff735d6b5'

            $Driver = @{
                id = 123456
                full_name = 'First Last'
                pin = 100 # test for 0 padding
                code = 'FL1234'
                phone = '1234567890'
                status = 0
            }

            Mock Invoke-WebRequest {
                $Fixture = 'Set-FuelCloudDriver.Response.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

        }

        BeforeEach {
            # act
            $Actual = Set-FuelCloudDriver -AccessToken $AccessToken @Driver
        }

        Context "Request" {

            It "add the Access Token to the Authorization header" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Headers.Authorization -eq $AccessToken
                }
            }

            It "sends a PATCH request" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Method -eq 'Patch'
                }
            }

            It "sends a request to the specified Uri" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $Uri -eq "https://api.fuelcloud.com/rest/v1.0/driver/$( $Driver.id )"
                }
            }

            It "sets the full_name property correctly" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $BodyHash = $Body | ConvertFrom-Json
                    $BodyHash.full_name -eq $Driver.full_name
                }
            }

            It "sets the pin property correctly" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $BodyHash = $Body | ConvertFrom-Json
                    $BodyHash.pin -eq $Driver.pin.ToString().PadLeft(5,'0')
                }
            }

            It "sets the phone property correctly" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $BodyHash = $Body | ConvertFrom-Json
                    $BodyHash.phone -eq $Driver.phone
                }
            }

            It "sets the code property correctly" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $BodyHash = $Body | ConvertFrom-Json
                    $BodyHash.code -eq $Driver.code
                }
            }

            It "sets the status property correctly" {
                # assert 
                Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                    $BodyHash = $Body | ConvertFrom-Json
                    $Driver.status ? $BodyHash.status -eq $Driver.status : $BodyHash.status -eq 0
                }
            }
    
        } # /context request

        Context "Response" {

            It "sets the full_name property correctly" {
                # assert 
                $Actual.full_name -eq $Driver.full_name
            }

            It "sets the pin property correctly" {
                # assert 
                $Actual.pin -eq $Driver.pin
            }

            It "sets the phone property correctly" {
                # assert 
                $Actual.phone -eq $Driver.phone
            }

            It "sets the code property correctly" {
                # assert 
                $Actual.code -eq $Driver.code
            }

            It "sets the status property correctly" {
                # assert 
                $Actual.status -eq $Driver.status
            }

        } # /context response

    } # /context Usage

}
