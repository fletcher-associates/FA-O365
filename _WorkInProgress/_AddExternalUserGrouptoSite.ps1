$sites = Get-SPOSite -Filter { Url -like "https://fletchersonline.sharepoint.com/sites/BSS-*" }
#Use Get-faClientSite

foreach ($site in $sites) {

    Write-Host "Connecting to $($site.Url)"
    Connect-PnPOnline -Url $site.Url -UseWebLogin

    Write-Host "Adding new permission level to $($site.Title)"
    Add-PnPRoleDefinition -RoleName 'Limited Read' -Clone Read -Exclude ViewVersions -Description 'Based on Read but excludes ViewVersions'

    Write-Host 'Adding new site group'
    New-PnPGroup -Title "$($site.Title) Client Users" -Description 'Group for Client users'

    Write-Host 'Assigning permission level to site group'
    Set-PnPGroupPermissions -Identity "$($site.Title) Client Users" -AddRole 'Limited Read'

}#foreach