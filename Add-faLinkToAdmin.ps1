<#
.SYNOPSIS
Adds a navigation link back to the main admin site on the top navigation bar of client sites.
.DESCRIPTION
Give a more detailed and fuller description of what it does. Elaborate on usage scenarios, limitations, prerequisites and cross-refer to other similar scripts as necessary where there could be confusion. 
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

$credential = Get-Credential
$sites = Get-UnifiedGroup -Identity 'BSS-*'

foreach ($site in $sites) {
    Connect-PnPOnline -url $site.SharePointSiteUrl -Credentials $credential
    try {
        $remove = @{
            'Title'    = 'Admin' ;
            'Location' = 'TopNavigationBar' ;
            'Force'    = $true 
        }#end remove parameters
        Remove-PnPNavigationNode @remove        
    } finally {
        $add = @{
            'External' = $true ;
            'First'    = $true ;
            'Location' = 'TopNavigationBar' ;
            'Title'    = 'Admin' ;
            'Url'      = 'https://fletchersonline.sharepoint.com/'
        }#end add parameters
        Add-PnPNavigationNode @add        
    }#end try/finally
}#end foreach sites