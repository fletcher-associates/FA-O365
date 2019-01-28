#Note there is a 64-character limit on UnifiedGroup -Name property. This limit has been set in the list settings and should not be exceeded.
function New-faClientSite {

    <#
    .SYNOPSIS
    Creates client site on tenant using values from client list.
    
    .DESCRIPTION
    This command retrieves clients from the client list and provisions a group-connect client site for them where one does not already exist for them. Sites are created using values from the client list for 'title' and 'alias'.
    
    The default 'TeamSite' site template is used, no customisations, site designs or provisioning templates are applied to the site.
    
    .EXAMPLE
    Get-faClientListItem -NoClientSiteLink | New-faPnPSite
    Creates a new unified group for all clients where there is no client site link in the client list.
    
    #>
    
        Param (
            [Parameter(ValueFromPipelineByPropertyName=$true)]
            [string]$ClientNumber,
    
            [Parameter(ValueFromPipelineByPropertyName=$true)]
            [string]$CompanyName
           
#            [string]$Lcid = 2057                           #Parameter not working as of 22/10/2019
        )
    
        BEGIN{}#begin
    
        PROCESS{
    
            Foreach ($Client in $ClientNumber) {
  
                try {

                    Write-Verbose "[PROCESS] Creating new Site for $Client $CompanyName"
    
                    $parameters = @{
                        'Type' = 'TeamSite' ;
                        'Title' = $CompanyName ;
                        'Alias' = $ClientNumber ;
                        'ErrorAction' = 'Stop'
                    #    'Lcid' = $Lcid ;                   #Parameter not working as of 22/10/2019
                    #    'AllowFileSharingForGuestUsers' = ;
                    #    'Classification' = ;
                    #    'Description' = ;
                    }#parameters
                    
                    $sites = New-PnPSite @parameters
                    Write-Output = $sites
                
                } catch {
                    
                    #More sophisticated error handling required to trap specific exceptions
                    Write-Verbose "[PROCESS] Item Skipped : A site for $Client $CompanyName probably already exists."

                }#try/catch

            }#foreach
    
        }#process
    
        END{}#end
    
    }#function