<#
.SYNOPSIS
Sets the 'Quick Lauch' navigation on the site.
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

Write-Output ("Connecting to " + $site)
Connect-PnPOnline -Url $site.SharePointSiteUrl -UseWebLogin

Write-Output "Removing old Navigation Nodes"
Get-PnPNavigationNode |
Where-Object {($_.Title -ne 'Home') -and ($_.Title -ne 'Recent')} |
Remove-PnPNavigationNode -Force -Confirm:$false

$nodes = ('Management',
         'Employees',
         'Work Activities',
         'Work Equipment',
         'Substances',
         'Workplaces',
         'HR',
         'Quality')

    foreach ($node in $nodes) {
        Write-Output ("Adding Navigation Node " + $node)
        $nodeparameters = @{
            'Location' = 'QuickLaunch'
            'Title' = $node
            'URL' = ((Get-PnPList -Identity ($node -replace '/s', '')).RootFolder.ServerRelativeUrl)
        }
        Add-PnPNavigationNode @nodeparameters

    }#end foreach list
}#end foreach site