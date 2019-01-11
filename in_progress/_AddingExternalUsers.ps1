<#Requires:
    Connection to Exchange Online
    Connection to AzureAD

    ERROR HANDLING:
    Permission level already exists
    Group already exists
    User already exists
    
#>


######
SPLIT THIS OUT TO SITE PROVISIONING SCRIPT

#Get the group
$group = Get-UnifiedGroup -Filter { Alias -like "DEV-108" }

#Connect to group site
Connect-PnPOnline -Url $group.SharePointSiteUrl -UseWebLogin

#Add new permission level
Add-PnPRoleDefinition -RoleName 'Limited Read' -Clone Read -Exclude ViewVersions -Description 'Based on Read but excludes ViewVersions'

#Add new group and assign permission level
New-PnPGroup -Title ($group.DisplayName + ' Client Users') -Description 'Group for Client users'
Set-PnPGroupPermissions -Identity ($group.DisplayName +' Client Users') -AddRole 'Limited Read'

######

#Get users from list
$users = Get-PnPListItem -List 'User Access Request (Custom List)'

#Add external users to SharePoint Group
#NEEDS A MESSAGE FOR THE EMAIL BODY#
foreach ($user in $users) {
    Add-PnPUserToGroup -EmailAddress $user.FieldValues.EMail -Identity "$($group.DisplayName) Client Users" -SendEmail $true -EmailBody 'Message'
}#end foreach

######


<#
#### Might need this later to add users to AzureAD so they can be given Unified Group membership for other O365 services.

Connect-AzureAD

#Add users to Azure AD
foreach ($user in $users) {
    New-AzureADMSInvitation -InvitedUserDisplayName $user.FieldValues.FullName -InvitedUserEmailAddress $user.FieldValues.EMail -SendInvitationMessage $False -InviteRedirectUrl $group.SharePointSiteUrl
    While (!(Get-AzureADUser -Filter "Mail eq `'$($user.FieldValues.EMail)`'")) {Start-Sleep -Seconds 5}
}#end foreach

#Add AzureAD users to SharePoint site user list
foreach ($user in $users) {
    New-PnPUser -LoginName $user.FieldValues.EMail
    While (!(Get-PnPUser | Where-Object -Property Email -eq $user.FieldValues.EMail)) {Start-Sleep -Seconds 5}
}#end foreach
    
#Send email to user.
#Set user list item to done.
#>