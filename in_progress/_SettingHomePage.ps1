##ROUGH SETTING OF HOMEPAGE USING PNP PROVISIONING TEMPLATE - SEE END
##OTHER USEFUL CODE SNIPPETS NEED ORGANISING/SPLITTING OFF

#Get the unwanted web-parts from the page:

$sites = Get-UnifiedGroup -Filter {[Alias] -like "CL-*"} | Select-Object -First 10

### GETTING WEBPARTS

foreach ($site in $sites) {
    
    Connect-PnPOnline -Url $site.SharePointSiteUrl -UseWebLogin
    
    Write-Output ("Fetching home for " + $site)
    $page = Get-PnPClientSidePage -Identity 'Home'
    
    Write-Output ("Getting webparts for " + $site)
    Get-PnPClientSideComponent -Page $page.PageTitle #| 
    #Where-Object {$_.Title -eq "Quick links" -or $_.Title -eq "Document library" }
}#end foreach site


### PUBLISHING PAGES

foreach ($site in $sites) {
    
    Connect-PnPOnline -Url $site.SharePointSiteUrl -UseWebLogin
    
    Write-Output ("Fetching home for " + $site)
    $page = Get-PnPClientSidePage -Identity 'Home'
    
    Write-Output "Publishing homepage"
    Set-PnPClientSidePage -Identity $page.PageTitle -Publish #| 
    #Where-Object {$_.Title -eq "Quick links" -or $_.Title -eq "Document library" }
}#end foreach site


### APPLY PROVISIONING TEMPLATE TO SET HOMEPAGE

$sites = Get-UnifiedGroup -Filter {[Alias] -like "BSS-*"}
$template = ".\template.xml"

foreach ($site in $sites) {
    Connect-PnPOnline -Url $site.SharePointSiteUrl -UseWebLogin
    Apply-PnPProvisioningTemplate -Path $template
}#end foreach site