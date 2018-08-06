<#
.SYNOPSIS
Adds client group to Fletcher Associates modern hub-site.
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
[CmdletBinding()]

$sites = Get-UnifiedGroup -Identity 'BSS-*'

foreach ($site in $sites) {
        $hubsiteparameters = @{
            'HubSite'   = 'https://fletchersonline.sharepoint.com/sites/FletcherAssociates/' ;
            'Site'      = $site.SharePointSiteUrl ;
        }#end hubsiteparameters
        Add-SPOHubSiteAssociation @hubsiteparameters
}#end foreach sites