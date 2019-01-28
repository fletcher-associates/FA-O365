function Apply-faClientSiteProvisioningTemplate {
    param(
        [Parameter()]
        [string]$templatepath = 'C:\Users\mikek\OneDrive\Git\FA-O365\provisioning\BSS239_2018_10_11_Regional.xml',

        [Parameter()]
        [string]$site = (Get-UnifiedGroup -Filter {[Alias] -like "BSS-*"})
    )

    foreach ($s in $site) {

        Write-Verbose "Applying provisioning template to $s"
        Connect-PnPOnline -Url $s.SharePointSiteUrl -UseWebLogin
        Apply-PnPProvisioningTemplate -Path $templatepath
    
    }#foreach

}#function