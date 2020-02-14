$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-Driver" -tag 'unit' {

    $AccessToken = ''

    Context "Valid credentials supplied" {

        It "returns the list of drivers" {

            $request = @{
                Uri='https://api.fuelcloud.com/rest/v1.0/driver'
                Headers = @{
                    Authorization=$AccessToken
                    "Content-Type"='application/json'
                }
            }

            # arrange
            $response = @(
                # page one
                @{ 
                    StatusCode="200"
                    Content = @{
                        data = @()
                        meta = @{
                            previous=$null
                            total=100
                            per_page=50
                            next='https://api.fuelcloud.com/rest/v1.0/driver?page%5Bnumber%5D=2'
                        }
                    }
                }
                # page two
                @{ 
                    StatusCode="200"
                    Content = @{
                        data = @()
                        meta = @{
                            previous='https://api.fuelcloud.com/rest/v1.0/driver?page%5Bnumber%5D=1'
                            total=100
                            per_page=50
                            next=$nuoo
                        }
                    }
                }
            )

            Mock Invoke-WebRequest { returns $response[0] }
            Mock Invoke-WebRequest { returns $response[1] }

            #Assert
            Assert‐MockCalled Invoke-WebRequest -Times 1 -Exactly

        }
    } # /Context

    Context "Invalid credentials supplied" {

        # arrange
        $response = @{ 
            StatusCode="200"
            Content = @{
                error = @{message = "some error occurred"}
            }
        }

        Mock Invoke-WebRequest { returns $response }

        # Assert‐MockCalled Invoke-WebRequest -Times 1 -Exactly

    } # /Context

}