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
                $Command.parameters[$ParameterName].parametersets[$ParameterSetName].IsMandatory | Should -Be $false
            }

        }

        Context 'EndingDate' {
            $ParameterName = 'EndingDate'
            $ParameterSetName = 'ByDate'

            It "is a [datetime]" {
                $Command | Should -HaveParameter $ParameterName -Type datetime
            }
            It "is mandatory member of '$ParameterSetName' parameter set" {
                $Command.parameters[$ParameterName].parametersets[$ParameterSetName].IsMandatory | Should -Be $false
            }

        }

    } # /context (parameter validation)

}
