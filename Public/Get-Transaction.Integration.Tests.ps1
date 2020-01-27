$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Integration.Tests\.', '.'
. "$here\$sut"

Describe "Get-Transaction" -tag 'integration' {

    # arrange
    $Parent = Split-Path -Parent $here
    $AccessToken = Get-Content -Path "$Parent\Credential.txt" -Raw
    Write-Debug "AccessToken: $AccessToken"

    $PSDefaultParameterValues['*:AccessToken'] = $AccessToken

    Context "No parameters supplied" {

        It "returns all transaction that occurred Today" {
            # act
            $Transaction = Get-Transaction

            # assert
            $Transaction | Measure-Object | Select-Object -Expand Count | Should -BeGreaterThan 1
        }
  
    }

    Context "`$DriverId parameter supplied" {

        $DriverId =406652

        It "returns all transaction for that `$DriverId" {
            # act
            $Transaction = Get-Transaction -DriverId $DriverId

            # assert
            $Transaction | Select-Object -ExpandProperty driver_id -First 1 | Should -Be $DriverId
        }
  
    }

    Context "`$PumpName parameter supplied" {

        $PumpName ='Pump 6'

        It "returns all transaction for that `$PumpName" {
            # act
            $Transaction = Get-Transaction -PumpName $PumpName

            # assert
            $Transaction | Select-Object -ExpandProperty pump_name -First 1 | Should -Be $PumpName
        }
  
    }

    Context "`$SiteId parameter supplied" {

        $SiteId =200128

        It "returns all transaction for that `$SiteId" {
            # act
            $Transaction = Get-Transaction -SiteId $SiteId

            # assert
            $Transaction | Select-Object -ExpandProperty site_id -First 1 | Should -Be $SiteId
        }
  
    }

    Context "`$VehicleId parameter supplied" {

        $VehicleId =203590

        It "returns all transaction for that `$VehicleId" {
            # act
            $Transaction = Get-Transaction -VehicleId $VehicleId

            # assert
            $Transaction | Select-Object -ExpandProperty vehicle_id -First 1 | Should -Be $VehicleId
        }
  
    }

}
