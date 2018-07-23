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