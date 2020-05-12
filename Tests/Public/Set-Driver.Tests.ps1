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

# New-AccessToken.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'

# . /PsFuelCloud/PsFuelCloud/Public/New-AccessToken.ps1
. (Join-Path $PublicPath $sut)

Describe "Set-Driver" -tag 'unit' {

    mock Invoke-WebRequest {}

    Context "-FullName" {
        It "does something useful"  -Skip{
            $true | Should -Be $false

            Assert-MockCalled 'Invoke-WebRequest' -Times 1 -Exactly

        }
    }

    Context "-PIN" {
        It "does something useful"  -Skip{
            $true | Should -Be $false
        }
    }

    Context "-Phone" {
        It "does something useful"  -Skip{
            $true | Should -Be $false
        }
    }

    Context "-Code" {
        It "does something useful"  -Skip{
            $true | Should -Be $false
        }
    }

    Context "-Status" {
        It "does something useful" -Skip {
            $true | Should -Be $false
        }
    }

}
