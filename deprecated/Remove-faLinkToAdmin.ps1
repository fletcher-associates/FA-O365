<#
.SYNOPSIS
Removes the navigation link back to the main admin site on the top navigation bar of client sites.
.DESCRIPTION
No longer required due to new Hub-Site functionality.
.PARAMETER ParameterName
Give details of parameter and how its used
.PARAMETER ParameterName
(repeat as required)
.EXAMPLE
Give a usage example with explanation
.EXAMPLE
(repeat as required)
#>
[CmdletBinding()]

$sites = Get-UnifiedGroup -Identity 'BSS-*'

foreach ($site in $sites) {
    Connect-PnPOnline -url $site.SharePointSiteUrl -UseWebLogin
        $remove = @{
            'Title'    = 'Admin' ;
            'Location' = 'TopNavigationBar' ;
            'Force'    = $true
        }#end remove parameters
        Remove-PnPNavigationNode @remove
}#end foreach sites