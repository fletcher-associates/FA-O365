# Credit to Mark Kraus for most of this script
# https://gist.github.com/markekraus/6fd7218b8eac225cbbf4d7c31018331b#file-add-sharepointsiteexternaluser-ps1

<#
.SYNOPSIS

    Invites an external user or list of external users to a SharePoint site.

.DESCRIPTION

    Invites an external user or list of external users to a SharePoint site. 

    External users can be granted View, Edit, or Owner permissions within the site. A custom e-mail message can be included or the invitation email can be suppressed.

.PARAMETER SiteURL

    URL string of the SharePoint site to which the user(s) will be invited.

.PARAMETER Crednetial

    A PowerShell Crednetial obejcet for the ShaerPoint site admin credentials. 

    Crednetials will be prompted if the paramaerter is ommited.

.PARAMETER User

    Either a string, list of strings, net.mail.mailaddress object, or list of net.mail.mailaddress objects for the user or user to invte. Strings must be valid email addresses.

.PARAMETER Permission

    Either View, Edit, or Owner. This permission level will be granted to the invited user whtint the SharePoint site.

.PARAMETER Message

    Optional message to include with the e-mail invideation to the user. A null or empty message will resutlt in the default invitation e-mail.

.PARAMETER SendNotificationEmail

    Switch to enable or suppress the e-mail invitaion tot he user. Default is to send the message.

.EXAMPLE

    $SPCredentials = Get-Credential
    $SPSite = "https://contoso.sharepoint.com/sites/SharedSite"
    $User = "Bob.Testerton@fabrikam.com"
    $Message = "Hey Bob! Welcome to Contoso's Shared Site!"

    Add-SharePointSiteExternalUser -SiteURL $SPSite -Credential $SPCredentials -User $User -Permission View -Message $Message

.EXAMPLE

    $SPCredentials = Get-Credential
    $SPSite = "https://contoso.sharepoint.com/sites/SharedSite"
    $Users = "Bob.Testerton@fabrikam.com","Jill.Deverson@adatum.com"
    $Message = "Welcome to Contoso's Shared Site!"

    Add-SharePointSiteExternalUser -SiteURL $SPSite -Credential $SPCredentials -User $Users -Permission View -Message $Message

.EXAMPLE

    $SPCredentials = Get-Credential
    $SPSite = "https://contoso.sharepoint.com/sites/SharedSite"
    $ListFile = "C:\scripts\Lost_Of_Email_addresses.txt"
    $Message = "Welcome to Contoso's Shared Site!"

    Get-Content $ListFile | Add-SharePointSiteExternalUser -SiteURL $SPSite -Credential $SPCredentials -Permission View -SendNotificationEmail:$false

.INPUTS

    System.String. List of e-mail addresses.

    Net.Mail.Mailaddress. List of e-mail addresses.

.OUTPUTS

    System.Management.Automation.PSObject. Contains the SiteURL, User, Permission, Success, and StatusMessage. StatusMessage may be null if successful.

.NOTES

    Requires the SharePoint Client Libraries. These can be installed either with a SharePoint on-prem system or with the SharePoint Online Management Shell.

    https://www.microsoft.com/en-us/download/details.aspx?id=35588

    External Sharing must be turned on for both the Tenant and the Site Collection. 
    
    Depending on the sharing option configured, the user may also need to already exist in tenant's Azure AD.

    https://support.office.com/en-us/article/Manage-external-sharing-for-your-SharePoint-Online-environment-c8a462eb-0723-4b0b-8d0a-70feafe4be85


.LINK    

    https://www.microsoft.com/en-us/download/details.aspx?id=35588

.LINK

    https://gist.github.com/markekraus/6fd7218b8eac225cbbf4d7c31018331b#file-add-sharepointsiteexternaluser-ps1

.LINK

    https://support.office.com/en-us/article/Manage-external-sharing-for-your-SharePoint-Online-environment-c8a462eb-0723-4b0b-8d0a-70feafe4be85

#>

Function Add-SharePointSiteExternalUser {

    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $true)]
        [ValidateScript( {[system.uri]::IsWellFormedUriString($_, [System.UriKind]::Absolute)})]
        [string]$SiteURL,
        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]$Credential,
        [Parameter(Mandatory = $true, ValueFromPipeline = $True)]
        [net.mail.mailaddress[]]$User,        
        [Parameter(Mandatory = $true)]
        [ValidateSet("View", "Edit", "Owner")]
        [string]$Permission,
        [Parameter(Mandatory = $false)]
        [string]$Message = $null,
        [Parameter(Mandatory = $false)]
        [switch]$SendNotificationEmail = $true
    )

    begin {

        $StatusOK = $True
        Write-Verbose "Initializing SharePoint Client Libraries"

        try {
            $loadInfo1 = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
            $loadInfo2 = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")
        
        }
        catch {
            Write-Error "Failed to load SharePoint Client Libraries."
            $StatusOK = $False
            break
        }

        Write-Verbose "Initializing SharePoint context object."

        try {
            $ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
            $SharePointCreds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Credential.UserName, $Credential.Password)
            $ctx.Credentials = $SharePointCreds
            $SharingManager = [Microsoft.SharePoint.Client.Sharing.WebSharingManager]
        
        }
        catch {

            Write-Error "Failed to initialize SharePoint context object. Ensure you have the correct permissions on the sharepoint site."
            $StatusOK = $False
            break

        }

        switch ($Permission) {
            "View" {$SetPermission = [Microsoft.SharePoint.Client.Sharing.Role]::View}
            "Edit" {$SetPermission = [Microsoft.SharePoint.Client.Sharing.Role]::Edit}
            "Owner" {$SetPermission = [Microsoft.SharePoint.Client.Sharing.Role]::Owner}
        } 
    }

    process {

        if (!$StatusOK) {return}

        $User | ForEach-Object {

            $CurUser = $_.Address.ToString()
            Write-Verbose "Granting '$CurUser' '$Permission' access to '$SiteURL'."
            $userList = New-Object "System.Collections.Generic.List``1[Microsoft.SharePoint.Client.Sharing.UserRoleAssignment]"
            $userRoleAssignment = New-Object Microsoft.SharePoint.Client.Sharing.UserRoleAssignment
            $userRoleAssignment.UserId = $CurUser
            $userRoleAssignment.Role = $SetPermission
            $userList.Add($userRoleAssignment)

            try {
                $res = $SharingManager::UpdateWebSharingInformation($ctx, $ctx.Web, $userList, $SendNotificationEmail, $message, $true, $true)
                $ctx.ExecuteQuery()
                $Success = $res.Status
                $StatusMessage = $res.message

            }
            catch {
                write-error "Error granting '$CurUser' '$Permission' access to '$SiteUR'."
                $Success = $False
                $StatusMessage = "Error granting '$CurUser' '$Permission' access to '$SiteUR'."
            }

            $ObjProperties = @{
                SiteURL       = $SiteURL
                Permission    = $Permission
                User          = $CurUser
                Success       = $Success
                StatusMessage = $StatusMessage
            }

            $OutObj = new-object psobject -Property $ObjProperties
            Write-Output $OutObj
        }
    }
}