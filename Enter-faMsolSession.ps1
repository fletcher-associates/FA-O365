<#
.SYNOPSIS
DOES NOT WORK WITH MULTI-FACTOR AUTHENTICATION.

Connects to Microsoft O365 Online Servcies for tenant fletchersonline.onmicrosoft.com.
.DESCRIPTION
Hard-coded script to connect to O365 online services for fletchersonline.onmicrosoft.com tenant. 

Connects to Azure Active Directory, SharePoint Online, Skype for Business and Exchange Online and Security & Compliance Centre.
.PARAMETER ParameterName
Give details of parameter and how its used.
.PARAMETER ParameterName
(repeat as required)
.EXAMPLE
Give a usage example with explanation.
.EXAMPLE
(repeat as required)
#>

# Create credentials object
$credential = Get-Credential

# Connect to Office 365
Import-Module MsOnline
Connect-MsolService -Credential $credential
# Verification: Get-MsolDomain

# Connect to SharePoint Online
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Connect-SPOService -Url https://fletchersonline-admin.sharepoint.com -Credential $credential
# Verification: Get-SPOSite

# Connect to Skype for Business Online
#Import-Module SkypeOnlineConnector
#$sfboSession = New-CsOnlineSessioN -Credential $credential
#Import-PSSession $sfboSession

# Connect to Exchange Online
$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid" -Credential $credential -Authentication Basic -AllowRedirection
Import-PSSession $exchangeSession -DisableNameChecking
# Verification: Get-AcceptedDomain | Format-List -Property DomainName

# Connect to Security & Compliance Centre
$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $credential -Authentication Basic -AllowRedirection
Import-PSSession $ccSession -Prefix cc