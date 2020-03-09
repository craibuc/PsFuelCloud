<#
.SYNOPIS
lorem

.PARAMETER RefreshToken

.EXAMPLE
New-AccessToken -AccessToken 'Bearer ...' -RefreshToken 'U3RhS3...'

AccessToken  RefreshToken  Expires
-----------  ------------  -------
Bearer T     ZU85Q2xtd...  03/15/2020 08:21 (PM)

#>
function New-AccessToken {

    [CmdletBinding()]
    param
    (
        [string]$AccessToken,
        [string]$RefreshToken
    )

    Write-Debug "$($MyInvocation.MyCommand.Name)"
    Write-Debug "AccessToken: $AccessToken"
    Write-Debug "RefreshToken: $RefreshToken"

    $Uri = "https://api.fuelcloud.com/rest/refresh-token/$RefreshToken"
    Write-Debug "Uri: $Uri"

    $Headers = @{Authorization=$AccessToken}
    
    try 
    {
        $Content = ( Invoke-WebRequest -Uri $Uri -Method Get -ContentType "application/x-www-form-urlencoded" -Headers $Headers ).Content | ConvertFrom-Json

        # returns PsCustomObject representation of object
        if ( $Content )
        {
            $Hash = [PSCustomObject]@{
                AccessToken = $Content.access_token
                RefreshToken = $Content.refresh_token
                Expires = (Get-Date).AddSeconds($Content.expires_in)
            }
            Write-Debug $Hash
            $Hash
        }
    
        # otherwise raise an exception
        elseif ($Content.error) { Write-Error -Message $Content.error.message }
    
    }
    catch {
        Throw $_.Exception.Message
    }

}
