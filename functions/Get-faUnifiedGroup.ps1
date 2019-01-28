<### WORK TO DO ###
Check connection to Exchange online before running command using [ValidateScript()] 
Add additional filter parameters
#AddRequires -Module Microsoft.Exchange.Management.ExoPowershellModule
Make it work without specifying -Filter parameter
##################>

Function Get-faUnifiedGroup {
<#
.SYNOPSIS
    This returns Unified Groups according to custom filter criteria.

.DESCRIPTION
    This cmdlet modifies 'Get-UnifiedGroup' to use custom filtering criteria appropriate to our organisation. 
    
    It can be used to return UnifiedGroup objects against the most commonly used filter criteria - refer to the Filter parameter help for acceptable values.  

.PARAMETER Filter
    Specify the required filter criteria. Avaliable values are:
        Clients         - will return all client groups
        Other           - will return all groups that are not client groups
        Dev             - will return all groups used for testing and development
    
    ADDITIONAL VALUES COMING SOON:
        FirstRelease    - will return groups used for first release
        ActiveClients   - will return client groups that are marked as active in the client list
        InactiveClients - will return client groups that are marked as inactive in the client list
#>

    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('Clients', 'Other', 'Dev')]
        [string]$Filter
    )

    BEGIN{}#begin

    PROCESS{
        try {
            if ($PSBoundParameters.ContainsKey('Filter')) {
                
                switch ($Filter) {
                    'Clients' { $filterscript = '{Alias -like "BSS-*"}' }
                    'Other' { $filterscript = '{Alias -notlike "BSS-*"}' }
                    'Dev' { $filterscript = '{Alias -like "DEV-*"}' }
#                   'ActiveClients' { } 
#                   'InactiveClients' { }
#                   'FirstRelease' { }
                }#switch
                
                $groups = Get-UnifiedGroup -Filter $filterscript

            } else {

                $groups = Get-UnifiedGroup
                
            }#if/esle

            Write-Output $groups
    
        } catch {
    
            Write-Error -Message 'This is an error'
    
        }#try/catch

    }#process

    END{}#end

}#function