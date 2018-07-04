#Use this script to connect to Exchange Online service with MFA from PowerShell (without needing to use the Exchange Online Shell)

$modules = @(Get-ChildItem -Path "$($env:LOCALAPPDATA)\Apps\2.0" -Filter "Microsoft.Exchange.Management.ExoPowershellModule.manifest" -Recurse )
$moduleName =  Join-Path $modules[0].Directory.FullName "Microsoft.Exchange.Management.ExoPowershellModule.dll"
Import-Module -FullyQualifiedName $moduleName -Force
$scriptName =  Join-Path $modules[0].Directory.FullName "CreateExoPSSession.ps1"
. $scriptName
$null = Connect-EXOPSSession
$exchangeOnlineSession = (Get-PSSession | Where-Object { ($_.ConfigurationName -eq 'Microsoft.Exchange') -and ($_.State -eq 'Opened') })[0]