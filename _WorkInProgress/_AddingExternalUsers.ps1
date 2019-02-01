<#Requires:
    Connection to Exchange Online
    Connection to AzureAD

    ERROR HANDLING:
    Permission level already exists
    Group already exists
    User already exists
    
#>

######
#SPLIT THIS OUT TO SITE PROVISIONING SCRIPT
#Use provisioning template to add access request list
$templatepath = '.\provisioning\2019-01-15_UserAccessRequestsList.xml'

foreach ($group in $groups) {
    Connect-PnPOnline -Url $group.SharePointSiteUrl -UseWebLogin
    Apply-PnPProvisioningTemplate -Path $templatepath
}

######
#Get the group
#$group = Get-UnifiedGroup -Filter { [Alias] -like "DEV-108" }
#Use Get-faUnifiedGroup

#Connect to group site
Connect-PnPOnline -Url $group.SharePointSiteUrl -UseWebLogin

#Get users from list
$users = Get-PnPListItem -List 'User Access Requests'

#Add external users to SharePoint Group
#NEEDS A MESSAGE FOR THE EMAIL BODY#
foreach ($user in $users) {
    Add-PnPUserToGroup -Identity "$($group.DisplayName) Client Users" -EmailAddress $user.FieldValues.EMail -SendEmail
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