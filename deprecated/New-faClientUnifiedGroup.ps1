#Note there is a 64-character limit on UnifiedGroup -Name property. This limit has been set in the list settings and should not be exceeded.
function New-faClientUnifiedGroup {

<#
.SYNOPSIS
Adds client unified groups to tenant using values from client list.

.DESCRIPTION
This command retrieves clients from the client list and provisions unified groups for them where one does not already exist for them. Groups are created using values from the client list for name, displayname etc.

.EXAMPLE
Get-faClientListItem -NoClientSiteLink | New-faClientGroup
Creates a new unified group for all clients where there is no client site link in the client list.

#>

    Param (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$ClientNumber,

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$CompanyName,
        
        [Parameter()]
        [string]$Owner = 'mike.kirby@fletcher-associates.co.uk',

        [string]$Language = 'en-GB'
    )

    BEGIN{}#begin

    PROCESS{

        Foreach ($Client in $ClientNumber) {

            Get-UnifiedGroup -Identity $Client

            #If statement to prevent duplicates
            Write-Verbose "[PROCESS] Checking if group with matching alias for $Client already exists"
            if (Get-UnifiedGroup -Identity $Client) {

                Write-Verbose "[PROCESS] Item Skipped : $Client $CompanyName already exists."

            } else {

                Write-Verbose "[PROCESS] Creating new Unified Group for $Client $CompanyName"

#                $parameters = @{
#                    'AutoSubscribeNewMembers' = $true ;
#                    'AccessType' = 'Private' ;
#                    'Alias' = $ClientNumber ;
#                    'DisplayName' = $CompanyName ;
#                    'Language' = $Language ;
#                    'Owner' = $Owner
#                }#parameters
#
#                $groups = New-UnifiedGroup @parameters
#                Write-Output $groups

            }#if/else

        }#foreach

    }#process

    END{

        Write-Verbose '[END    ] This is the end block'

    }#end

}#function