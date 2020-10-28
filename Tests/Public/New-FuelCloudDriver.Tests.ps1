# /PsFuelCloud
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFuelCloud/PsFuelCloud/Public
$PublicPath = Join-Path $ProjectDirectory "/PsFuelCloud/Public/"

# /PsFuelCloud/Tests/Fixtures/
$FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# New-FuelCloudDriver.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFuelCloud/PsFuelCloud/Public/New-FuelCloudDriver.ps1
. (Join-Path $PublicPath $sut)

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

        It "creates the correct request and returns the expected response" {
            # act
            $Actual = New-FuelCloudDriver -AccessToken AccessToken @Driver

            # assert 
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                Write-Debug "Headers: $Headers"
                $Method -eq 'Post' `
                -and $Uri -eq 'https://api.fuelcloud.com/rest/v1.0/driver/' `
                -and $Body.full_name -eq $Driver.full_name
                # ` -and $Headers -eq @{Authorization = $AccessToken}
            }

            $Actual.count | Should -Be 1
            $Actual.full_name | Should -Be $Driver.full_name
            $Actual.code | Should -Be $Driver.code
            $Actual.phone | Should -Be $Driver.phone
            $Actual.pin | Should -Be $Driver.pin
        }

    }
}
