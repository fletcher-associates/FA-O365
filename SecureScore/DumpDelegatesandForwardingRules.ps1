##Import the right module to talk with AAD
#import-module MSOnline
#
##Let's get us an admin cred!
#$userCredential = Get-Credential
#
#This connects to Azure Active Directory
Connect-MsolService
#.\Connect-faEXOPSSession.ps1 - need to learn how to invoke ps.1 in another location.

#$ExoSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $userCredential -Authentication Basic -AllowRedirection
#Import-PSSession $ExoSession

##This connects to Exchange Online service using Exchange Online Management Shell
##Use this when connecting with accounts which have MFA enabled
#Connect-EXOPSSession -UserPrincipalName mike.kirby@fletcher-associates.co.uk

$allUsers = @()
$AllUsers = Get-MsolUser -All -EnabledFilter EnabledOnly | 
    Select-Object ObjectID, UserPrincipalName, FirstName, LastName, StrongAuthenticationRequirements, StsRefreshTokensValidFrom, StrongPasswordRequired, LastPasswordChangeTimestamp | 
    Where-Object {($_.UserPrincipalName -notlike "*#EXT#*")}
$UserInboxRules = @()
$UserDelegates = @()

foreach ($User in $allUsers)
{
    Write-Host "Checking inbox rules and delegates for user: " $User.UserPrincipalName;
    $UserInboxRules += Get-InboxRule -Mailbox $User.UserPrincipalname | 
    Select-Object Name, Description, Enabled, Priority, ForwardTo, ForwardAsAttachmentTo, RedirectTo, DeleteMessage | 
    Where-Object {($_.ForwardTo -ne $null) -or ($_.ForwardAsAttachmentTo -ne $null) -or ($_.RedirectsTo -ne $null)}
    
    $UserDelegates += Get-MailboxPermission -Identity $User.UserPrincipalName | 
    Where-Object {($_.IsInherited -ne "True") -and ($_.User -notlike "*SELF*")}
}

$SMTPForwarding = Get-Mailbox -ResultSize Unlimited | Select-Object DisplayName,ForwardingAddress,ForwardingSMTPAddress,DeliverToMailboxandForward | Where-Object {$_.ForwardingSMTPAddress -ne $null}

$UserInboxRules | Export-Csv MailForwardingRulesToExternalDomains.csv
$UserDelegates | Export-Csv MailboxDelegatePermissions.csv
$SMTPForwarding | Export-Csv Mailboxsmtpforwarding.csv



