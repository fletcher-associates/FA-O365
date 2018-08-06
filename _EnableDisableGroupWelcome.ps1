foreach ($group in $groups) {
    Write-Output "Re-enabling Welcome Message $($group.Alias) $($group.DisplayName)"    
    Set-UnifiedGroup -Identity $group.Alias -UnifiedGroupWelcomeMessageEnabled:$true    #<==Change to $false to disable
}

#Allows guest access to site when adding to the group.
#Set-SPOSite -Identity $groupsiteurl -SharingCapability ExternalUserAndGuestSharing