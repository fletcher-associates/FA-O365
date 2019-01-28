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

    Invoke-WebRequest -Uri 


}#end if


<#
Fold this in to make it happen transparently:

$Username = "badguy@EVILER.onmicrosoft.com"
$Password = "Password1"
$Url = "portal.office.com"

#Kills existing IE sessions
Get-Process iexplore -EA SilentlyContinue | Stop-Process

#Cleans up cookies, forms, and passwords in IE to avoid SSO
rundll32.exe InetCpl.cpl, ClearMyTacksByProcess 8
rundll32.exe InetCpl.cpl, ClearMyTacksByProcess 2
rundll32.exe InetCpl.cpl, ClearMyTacksByProcess 16
rundll32.exe InetCpl.cpl, ClearMyTacksByProcess 32

$ie = New-Object -ComObject InternetExplorer.Application
$ie.visible = $false
$ie.navigate($Url)
while($ie.ReadyState -ne 4) {Start-Sleep -m 100}

$ie.document.getElementById("cred_userid_inputtext").click();
$ie.document.getElementById("cred_password_inputtext").click();
$ie.document.getElementById("cred_sign_in_button").click()
#>