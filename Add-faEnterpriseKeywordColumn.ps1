<#
.SYNOPSIS
Adds Enterprise Keyword Columns to lists.
.DESCRIPTION
Give a more detailed and fuller description of what it does. Elaborate on usage scenarios, limitations, prerequisites and cross-refer to other similar scripts as necessary where there could be confusion.
.PARAMETER ParameterName
Give details of parameter and how its used.
.PARAMETER ParameterName
(repeat as required)
.EXAMPLE
Give a usage example with explanation.
.EXAMPLE
(repeat as required)
#>

$sites = Get-UnifiedGroup -Filter {[Alias] -like "BSS-*"}

foreach ($site in $sites) {

Write-Output "Getting lists from site $site"
Connect-PnPOnline -Url $site.SharePointSiteUrl -UseWebLogin

$lists = 'Management',
         'Employees',
         'WorkActivities',
         'WorkEquipment',
         'Substances',
         'Workplaces',
         'HR',
         'Quality'

    foreach ($list in $lists) {
        Write-Output "Adding Enterprise Keywords to $($site.Alias) $list"
        Add-PnPField -List $list -Field "TaxKeyword"

    }#end foreach list
}#end foreach site