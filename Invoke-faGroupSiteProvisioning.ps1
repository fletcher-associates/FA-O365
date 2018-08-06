<#
.SYNOPSIS
Opens a browser session to initiate site provision after initial creation of Unified Group.
.DESCRIPTION
This is use as a workaround to Microsoft's default behaviour of not automatically provisioning group connected sites until a user has clicked on the link in the welcome email.
.PARAMETER ParameterName
Give details of parameter and how its used.
.PARAMETER ParameterName
(repeat as required)
.EXAMPLE
Give a usage example with explanation.
.EXAMPLE
(repeat as required)
#>

$confirmation = Read-Host "This will open a browser session for each group site that has not been provisioned. Are you sure you want to proceed? (Enter y or n)"
if ($confirmation -eq 'y') {

    $unprovisionedids = (Get-UnifiedGroup -Filter {[Alias] -like "BSS-*"} | Where-Object {$_.SharePointSiteUrl -eq $null}).ExternalDirectoryObjectId
    $provisioningurl = 'https://fletchersonline.sharepoint.com/_layouts/groupstatus.aspx?id=OBJECTID&target=site'

    foreach ($unprovisionedid in $unprovisionedids) {
        $goprovisionurl = $provisioningurl -replace "OBJECTID", $unprovisionedid
        Write-Host "Opening $goprovisionurl"
        Start-Process $goprovisionurl
    }#end foreach

}#end if