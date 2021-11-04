##
# load (dot-source) *.PS1 files, excluding unit-test scripts (*.Tests.*), and disabled scripts (__*)
#

Get-ChildItem *.ps1 -Recurse -Filter '__*','*.Tests.*' | ForEach-Object {

    # dot-source script
    . $_

}

# @("$PSScriptRoot\Public\*.ps1","$PSScriptRoot\Private\*.ps1") | 
#     Get-ChildItem  -ErrorAction 'Continue' | 
#     Where-Object { $_.Name -like '*.ps1' -and $_.Name -notlike '__*' -and $_.Name -notlike '*.Tests*' } | 
#     ForEach-Object {

#         # dot-source script
#         . $_
#     }

##
# Create aliases for compatibility
#

Set-Alias -Name 'Get-Driver' -Value 'Get-FuelCloudDriver'
Set-Alias -Name 'Set-Driver' -Value 'Set-FuelCloudDriver'