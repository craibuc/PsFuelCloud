<#
https://powershell.org/forums/topic/pester-invoke-webrequest/
https://groups.google.com/forum/#!topic/pester/ZgNpVc36Z0k
#>

# /PsFuelCloud
$ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

# /PsFuelCloud/PsFuelCloud/Public
$PublicPath = Join-Path $ProjectDirectory "/PsFuelCloud/Public/"

# /PsFuelCloud/Tests/Fixtures/
# $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

# Set-FuelCloudDriver.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFuelCloud/PsFuelCloud/Public/Set-FuelCloudDriver.ps1
. (Join-Path $PublicPath $sut)

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
        }

    } # /context (parameter validation)

}
