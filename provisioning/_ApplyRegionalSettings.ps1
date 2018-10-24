$templatepath = 'C:\Users\mikek\OneDrive\Git\FA-O365\provisioning\BSS239_2018_10_11_Regional.xml'
$sites = Get-UnifiedGroup -Filter {[Alias] -like "BSS-*"}

foreach ($site in $sites) {

    Write-Output "Applying regional settings to $site"
    Connect-PnPOnline -Url $site.SharePointSiteUrl -UseWebLogin
    Apply-PnPProvisioningTemplate -Path $templatepath

}#end foreach