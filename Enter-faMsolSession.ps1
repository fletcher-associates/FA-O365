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

# Connect to Office 365
Connect-MsolService
# Verification: Get-MsolDomain

# Connect to Exchange Online
# Call Connect-faEXOPSSession.ps here!

# Connect to SharePoint Online
Connect-SPOService -Url https://fletchersonline-admin.sharepoint.com -Credential $credential
# Verification: Get-SPOSite

# Connect to Skype for Business Online
#Import-Module SkypeOnlineConnector
#$sfboSession = New-CsOnlineSessioN -Credential $credential
#Import-PSSession $sfboSession

# Connect to Security & Compliance Centre
$ccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $credential -Authentication Basic -AllowRedirection
Import-PSSession $ccSession -Prefix cc