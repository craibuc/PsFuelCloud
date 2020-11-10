BeforeAll {

    # /PsFuelCloud
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    # /PsFuelCloud/PsFuelCloud/Public
    $PublicPath = Join-Path $ProjectDirectory "/PsFuelCloud/Public/"

    # /PsFuelCloud/Tests/Fixtures/
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # New-FuelCloudDriver.ps1
    $sut = (Split-Path -Leaf $PSCommandPath) -replace '\.Tests\.', '.'

    # . /PsFuelCloud/PsFuelCloud/Public/New-FuelCloudDriver.ps1
    . (Join-Path $PublicPath $sut)

}

Describe "New-FuelCloudDriver" -tag 'unit' {

    Context "Parameter validation" {
        BeforeAll {
            $Command = Get-Command 'New-FuelCloudDriver'
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
                $Attribute = $command.Parameters['pin'].Attributes | Where-Object { $_.TypeId -eq [System.Management.Automation.ValidateRangeAttribute] }
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

    } # /context (parameter validation)

    Context "Default" {
    
        BeforeAll {

            # arrange
            $AccessToken = '7522a674-f71d-4c51-ba0c-c8cff735d6b5'

            # should match the values in fixtures file
            $Driver = @{
                full_name = 'New Driver'
                pin = 68888
                code = 'D1121987'
                phone = '503-379-0000'
            }

            Mock Invoke-WebRequest {
                $Fixture = 'New-FuelCloudDriver.Response.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

        }

        BeforeEach {
            # act
            $Actual = New-FuelCloudDriver -AccessToken $AccessToken @Driver
        }

        It "uses the 'Post' Method" {    
            # assert
            Should -Invoke Invoke-WebRequest -ParameterFilter { $Method -eq 'Post' }
        }

        It "uses the correct Uri" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter { 
                $Uri -eq 'https://api.fuelcloud.com/rest/v1.0/driver' 
            }
        }

        It "uses a ContentType of 'application/json'" {    
            # assert
            Should -Invoke Invoke-WebRequest -ParameterFilter { $ContentType -eq 'application/json' }
        }

        It "adds an Authorization header" {    
            # assert
            Should -Invoke Invoke-WebRequest -ParameterFilter { $Headers['Authorization'] -eq $AccessToken }
        }

        It "creates the correct request and returns the expected response" {
            $Actual.count | Should -Be 1
            $Actual.full_name | Should -Be $Driver.full_name
            $Actual.code | Should -Be $Driver.code
            $Actual.phone | Should -Be $Driver.phone
            $Actual.pin | Should -Be $Driver.pin
        }

    }
}
