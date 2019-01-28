function Connect-faEXOPSSession{

    <#
    .SYNOPSIS
    Connects to Exchange Online service using MFA.
    .DESCRIPTION
    Connects to Exchange Online service using MFA. Allows connections from the console without needing to use the Exchange Online Shell.
    .EXAMPLE
    Connect-faEXOPSSession

    A separate login dialog will open for you to enter your Office 365 credentials.
    #>

[CmdletBinding()]
Param()

    BEGIN{
        $location = Get-Location
    }#begin

    PROCESS{

        $modules = @(Get-ChildItem -Path "$($env:LOCALAPPDATA)\Apps\2.0" -Filter "Microsoft.Exchange.Management.ExoPowershellModule.manifest" -Recurse )
        $moduleName =  Join-Path $modules[0].Directory.FullName "Microsoft.Exchange.Management.ExoPowershellModule.dll"
        Import-Module -FullyQualifiedName $moduleName -Force
        $scriptName =  Join-Path $modules[0].Directory.FullName "CreateExoPSSession.ps1"
        . $scriptName
        $null = Connect-EXOPSSession
        $exchangeOnlineSession = (Get-PSSession | Where-Object { ($_.ConfigurationName -eq 'Microsoft.Exchange') -and ($_.State -eq 'Opened') })[0]
        Write-Output $exchangeOnlineSession
    }#process

    END{
        Set-Location $location
    }#end

}#function