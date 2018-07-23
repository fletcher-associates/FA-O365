<#
.SYNOPSIS
Adds document libraries to client group sites.
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

#   LIST TEMPLATES
#   List ID     Title
#   100         Custom List
#   101         Document Library

$librarynames = (
    'Management',
    'Employees',
    'Work Activities',
    'Work Equipment',
    'Substances',
    'Workplaces',
    'HR',
    'Quality')

#$listnames = (
#    'List of Employees',
#    'List of Work Activities',
#    'List of Work Equipment',
#    'List of Substances',
#    'List of Workplaces')

#FOR THE LIBRARIES

foreach ($site in $sites) {
    Connect-PnPOnline -url $site.SharePointSiteUrl -UseWebLogin
    foreach ($libraryname in $librarynames) {
        $libraryparameters = @{
            'EnableVersioning' = $true ;
            'OnQuickLaunch'    = $true ;
            'Template'         = '101' ;
            'Title'            = $libraryname ;
            'Url'              = ($libraryname -replace '\s', '')
        }#end libraryparameters
        New-PnPList @libraryparameters
    }#end foreach libraries
}#end foreach sites

#FOR THE LISTS:

#foreach ($site in $sites) {
#    foreach ($listname in $listnames) {
#        $listparameters = @{
#               'EnableVersioning' = $true ;
#               'OnQuickLaunch' = $true ;
#               'Template' = '101' ;
#               'Title' = $listname ;
#               'Url' = $listname.Remove(0,8) -replace '\s',''
#            }#end listparameters
#        New-PnPList @listparameters
#    }#end foreach
#}#end foreach

#New-PnPList -OnQuickLaunch -Template 100 -Title




