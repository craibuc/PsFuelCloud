BeforeAll {

    # paths
    $ProjectDirectory = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
    $PublicPath = Join-Path $ProjectDirectory "/PsFuelCloud/Public/"
    $FixturesDirectory = Join-Path $ProjectDirectory "/Tests/Fixtures/"

    # dot source
    $Script = (Split-Path -Leaf $PsCommandPath) -replace '\.Tests\.', '.'
    . (Join-Path $PublicPath $Script)
}

Describe "Set-FuelCloudVehicle" -tag 'unit' {

    Context "Parameter validation" {
        BeforeAll { $Command = Get-Command 'Set-FuelCloudVehicle' }

        Context "AccessToken" {
            BeforeAll { $ParameterName='AccessToken'}
            It "is a [String]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'id' {
            BeforeAll { $ParameterName = 'id' }
            It "is a [int]" {
                $Command | Should -HaveParameter $ParameterName -Type int
            }
            It "is mandatory" {
                $Command | Should -HaveParameter $ParameterName -Mandatory
            }
        }

        Context 'name' {
            BeforeAll { $ParameterName = 'name' }
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            It "gets value from the pipeline by name" {
                # $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'code' {
            BeforeAll { $ParameterName = 'name' }
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
            # It "gets value from the pipeline by name" {
            #     # $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            # }
        }

        Context 'status' {
            BeforeAll { $ParameterName = 'status' }
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

        Context 'taxable' {
            BeforeAll { $ParameterName = 'taxable' }
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'tank_capacity' {
            BeforeAll { $ParameterName = 'tank_capacity' }
            It "is a [decimal]" {
                $Command | Should -HaveParameter $ParameterName -Type decimal
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'product_type' {
            BeforeAll { $ParameterName = 'product_type' }
            It "is a [string]" {
                $Command | Should -HaveParameter $ParameterName -Type string
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

        Context 'product' {
            BeforeAll { $ParameterName = 'product' }
            It "is a [int[]]" {
                $Command | Should -HaveParameter $ParameterName -Type int[]
            }
            It "is optional" {
                $Command | Should -HaveParameter $ParameterName -Not -Mandatory
            }
        }

    } # /Parameter validation

    Context "Request" {
        BeforeAll {

            $BaseUri = "https://api.fuelcloud.com/rest/v1.0/vehicle"
            $AccessToken = 'BEARER 01234567897abcdefghijklmnopqurtuvwxyz'
            $Expected = [pscustomobject]@{
                id=111111
                name='000000'
                code='0000AAA'
                status=1
                taxable='fed_state'
                tank_capacity=0
                product_type='Diesel'
                all_allowed_products=1
                product=402,403
                # custom_data_field = @( @{} )
            }
    
        }

        BeforeEach {
            # arrange
            Mock Invoke-WebRequest {
                $Fixture = 'Set-FuelCloudVehicle.Response.json'
                $Content = Get-Content (Join-Path $FixturesDirectory $Fixture) -Raw

                $Response = New-MockObject -Type  Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject
                $Response | Add-Member -Type NoteProperty -Name 'Content' -Value $Content -Force
                $Response
            }

            # act
            $Actual = $Expected | Set-FuelCloudVehicle -AccessToken $AccessToken
        }

        it "uses the correct Method" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $Method -eq 'Patch'
            }  -Times 1 -Exactly
        }

        it "uses the correct Uri" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $Uri -eq "$BaseUri/$( $Expected.id )"
            }  -Times 1 -Exactly
        }

        it "uses the correct Headers" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $ContentType -eq 'application/json' -and
                $Headers.Authorization -eq $AccessToken
            }  -Times 1 -Exactly
        }

        it "uses the correct Body" {
            # assert
            Assert-MockCalled Invoke-WebRequest -ParameterFilter {
                $ActualBody = $Body | ConvertFrom-Json

                $ActualBody.name -eq $Expected.name -and          
                $ActualBody.code -eq $Expected.code -and
                $ActualBody.status -eq $Expected.status -and
                $ActualBody.taxable -eq $Expected.taxable -and
                $ActualBody.tank_capacity -eq $Expected.tank_capacity -and
                $ActualBody.product_type -eq $Expected.product_type -and
                $ActualBody.all_allowed_products -eq $Expected.all_allowed_products -and
                (Compare-Object -ReferenceObject $Expected.product -DifferenceObject $ActualBody.product) -eq $null
            }  -Times 1 -Exactly
        }

    }

}
