$groups = Get-UnifiedGroup -Filter {[Alias] -like 'BSS-*'}
$staff = Get-UnifiedGroupLinks -Identity FletcherAssociates -LinkType Members

foreach ($group in $groups) {
    Write-Host "Checking for rogue users in" $group.DisplayName $group.SharePointSiteUrl -ForegroundColor Green
    Get-SPOUser -Site $group.SharePointSiteUrl |
        Where-Object -FilterScript { 
        $_.LoginName -notin $staff.WindowsLiveID -and 
        $_.LoginName -notlike 'SHAREPOINT\system' -and
        $_.LoginName -notlike $group.ExternalDirectoryObjectId -and
        $_.LoginName -notlike $group.ExternalDirectoryObjectId + '_o' -and
        $_.DisplayName -notmatch 'Everyone' -and
        $_.DisplayName -notmatch 'Everyone except external users' -and
        $_.DisplayName -notmatch 'SharePoint App' -and
        $_.DisplayName -notlike '*_spocrwl_*' -and
        $_.DisplayName -notlike '*_spocrawler_*'
    } #end filterscript
} #end foreach