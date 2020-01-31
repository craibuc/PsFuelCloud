<#
https://powershell.org/forums/topic/pester-invoke-webrequest/
https://groups.google.com/forum/#!topic/pester/ZgNpVc36Z0k
#>

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Set-Driver" {

    mock 'Invoke-WebRequest' {
		'invoke-webrequest mocked'
    }

    Context "-FullName" {
        It "does something useful" {
            $true | Should -Be $false

            Assert-MockCalled 'Invoke-WebRequest' -Times 1 -Exactly

        }
    }

    Context "-PIN" {
        It "does something useful" {
            $true | Should -Be $false
        }
    }

    Context "-Phone" {
        It "does something useful" {
            $true | Should -Be $false
        }
    }

    Context "-Code" {
        It "does something useful" {
            $true | Should -Be $false
        }
    }

    Context "-Status" {
        It "does something useful" {
            $true | Should -Be $false
        }
    }

}
