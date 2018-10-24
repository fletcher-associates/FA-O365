$groups = Get-UnifiedGroup -Identity 'DEV-*'

foreach ($group in $groups) {
    Connect-PnPOnline -Url $group.SharePointSiteUrl -UseWebLogin

    $groupparameters = @{
        'Site' = $group.SharePointSiteUrl ;
        'Group' = $group.DisplayName + ' Client Users' ;
        'PermissionLevels' = 'Read'
    }#end groupparameters
    New-SPOSiteGroup @groupparameters

}#end foreach

###PERMISSION LEVELS - Sample script to create new Permission Level

$roledefinitionparameters = @{
    'RoleName' = 'Contribute (No Delete)' ;
    'Description' = 'Can view, add, and update list items and documents (no delete).' ;
    'Clone' = 'Contribute' ; 
    'Exclude' = 'DeleteListItems, DeleteVersions' 
}    

Add-PnPRoleDefinition @roledefinitionparameters