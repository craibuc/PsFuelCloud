<#
.SYNOPSIS
Labore labore ea est sint deserunt excepteur cillum sit elit et eiusmod nisi est magna.

.PARAMETER AccessToken
Bearer token.

.PARAMETER name
The label of the vehicle. This is used to identify the vehicle within your account.

.PARAMETER code
Vehicle code is an arbitrary code you can assign to a vehicle. This value can be included in reports, and is often used for importing into other systems.

.PARAMETER status
When set to 1 this vehicle will be active. When set to 0 this vehicle will be disabled. Disabled vehicles cannot be used by drivers at the pump.

.PARAMETER taxable
Tax exemption status for the vehicle. Accepted values: fed, state, fed_state, none.

.PARAMETER tank_capacity
Volume of the vehicle's tank.

.PARAMETER product_type
Fuel type of the vehicle. Accepted values: Gasoline, Diesel, Special, all

.PARAMETER all_allowed_products
When set to 1, this vehicle can use all products in its product category. When set to 0, this vehicle can only use the products listed in the product array.

.PARAMETER product
Accepts an array of product IDs. If all_allowed_products is set to 1, this vehicle can only use pumps with these products.

.PARAMETER custom_data_field
Accepts an array of objects. id is the ID of the custom_data_field in your account, value is that vehicle's new value for that field.

.LINK
https://developer.fuelcloud.com/?version=latest#70f5fca8-8707-4919-a8e9-9486681377ca

#>
function Set-FuelCloudVehicle {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]$AccessToken,

        [Parameter(ValueFromPipelineByPropertyName,Mandatory)]
        [int]$id,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$code,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(0,1)]
        [int]$status,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('fed', 'state', 'fed_state', 'none')]
        [string]$taxable,

        [Parameter(ValueFromPipelineByPropertyName)]
        [decimal]$tank_capacity,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('Gasoline', 'Diesel', 'Special', 'all')]
        [string]$product_type,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(0,1)]
        [int]$all_allowed_products,

        [Parameter(ValueFromPipelineByPropertyName)]
        [int[]]$product,

        [Parameter(ValueFromPipelineByPropertyName)]
        [object[]]$custom_data_field
    )

    begin {    
        $Headers = @{Authorization = $AccessToken}
    }
    process
    {
        $Uri = "https://api.fuelcloud.com/rest/v1.0/vehicle/$id"
        Write-Debug "Uri: $Uri"

        # make a copy of Dictionary
        $Body = @{} + $PSBoundParameters

        # remove parameters that won't be posted
        $Body.Remove('AccessToken')
        $Body.Remove('id')

        # correct values

        Write-Debug $Body

        # PATCH
        $Content = ( Invoke-WebRequest -Uri $uri -Method Patch -Body ($Body | ConvertTo-Json) -ContentType "application/json" -Headers $Headers ).Content | ConvertFrom-Json
    
        # returns PsCustomObject representation of object
        if ( $Content.data ) { $Content.data }
    
        # otherwise raise an exception
        elseif ($Content.error) { Write-Error -Message $Content.error.message }    
    }
    end {}

}
