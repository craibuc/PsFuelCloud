# PsFuelCloud
PowerShell module that wraps the FuelCloud API.

## Installation

### Git

``` powershell
# change to Module directory
PS> Push-Location ~\Documents\WindowsPowerShell\Modules

# clone repository
PS> git clone git@github.com:craibuc/PsFuelCloud.git

# return to original location
PS> Pop-Location
```
## Usage

### Get-Driver
Irure cupidatat ipsum mollit amet pariatur labore laborum occaecat voluptate aute est consequat commodo sunt.

### Get-Product
Irure cupidatat ipsum mollit amet pariatur labore laborum occaecat voluptate aute est consequat commodo sunt.

### Get-Site
Irure cupidatat ipsum mollit amet pariatur labore laborum occaecat voluptate aute est consequat commodo sunt.

### Get-Tank

```powershell
Get-Tank | Select-Object name, tank_capacity, current_inventory, @{name='product_name';expression={$_.product.product_name}}, price_per_unit | Format-Table

name     tank_capacity current_inventory product_name  price_per_unit
----     ------------- ----------------- ------------  --------------
Diesel        10472.72          2476.519 BIO-DIESEL B5           2.00
Propane       18036.22          6979.752 PROPANE              1.11145
Unleaded       9993.68         8076.8418 UNLEADED             2.13159
```
### Get-Timezone
Nulla excepteur excepteur sint cillum cillum voluptate exercitation ut consequat non magna ipsum commodo qui.

### Get-Transation
Elit labore laboris nisi dolore incididunt laboris nulla cillum tempor fugiat ex irure.

```powershell
Get-Transaction | Select-Object  tank_id, @{name='created_date';expression={([datetime]$_.created_utc).ToLocalTime()}}, @{name='product_name';expression={$_.product.product_name}}, volume, unit, driver_id, vehicle_id, pump_name | Format-Table
```

### Get-Vehicle
Proident reprehenderit cupidatat labore et pariatur in sit anim magna.

## Contributors

- [Craig Buchanan](https://github.com/craibuc/)
