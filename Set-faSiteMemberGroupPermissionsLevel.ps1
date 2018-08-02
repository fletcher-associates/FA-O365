#SITE PAGES
#Contribute permission level still allows create/edit of modern site pages
#Override by setting permissions on 'Site Pages' library

$groups = Get-UnifiedGroup -Filter {[Alias] -like "BSS-*"}
$groupsiteurls = $groups.SharePointsiteUrl

foreach ($groupsiteurl in $groupsiteurls) {
    Connect-PnPOnline -Url $groupsiteurl -UseWebLogin
    Get-PnPGroup -AssociatedMemberGroup | 
    Set-PnPGroupPermissions -AddRole 'Contribute' -RemoveRole 'Edit'
}#end foreach