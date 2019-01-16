<### WORK TO DO ###
Add additional filter parameters - try and use CAML for improved performance.
Error handling - see comments in code

.TODO_PARAMETER NoUnifiedGroup
    Specifying this parameter will return all client list items where there is no matching Unified Group

.TODO_PARAMETER Sector
    Acceptable values: Construction, Manufacturing, Service.

.TODO_PARAMETER Services
    Acceptable values: HSW, HR, Quality
##################>

Function Get-faClientListItem {
<#
.SYNOPSIS
    This returns clients list items from the client list according to custom filter criteria.

.DESCRIPTION
    This cmdlet modifies 'Get-PnpListItem' cmdlet to use custom filtering criteria appropriate to our organisation. 
    
    Refer to the parameter help for details and items that will be returned.  

.PARAMETER NoClientSiteLink
    Specifying this parameter will return all client list items where there is no client site link.

.PARAMETER NoUnifiedGroup
    Specifying this parameter will return all client list items where there is no associated Unified Group. (Group alias matching BSS- number).

#>
    [CmdletBinding()]

    Param(
        [switch]$NoClientSiteLink,
        [switch]$NoUnifiedGroup
    )

    BEGIN{}#begin

    PROCESS{

        $SiteUrl = 'https://fletchersonline.sharepoint.com'
        $ListName = 'Clients'

        #Establish connection to site
        if ((Get-PnPConnection).Url -match $SiteUrl) {
            Write-Verbose "Already connected to $SiteUrl"
        } else {
        Connect-PnPOnline -Url $siteurl -UseWebLogin
        }
        
        #Build filter array
        $FilterArray = New-Object -TypeName System.Collections.Generic.List[string]

        Switch ($PSBoundParameters.GetEnumerator().Where({$_.Value -eq $true}).Key) {
            'NoClientSiteLink'  {$FilterArray.Add('$_.FieldValues.Client_x0020_Site -eq $null')}
            'NoUnifiedGroup'    {$ClientGroups = Get-UnifiedGroup -Filter {[Alias] -like 'BSS-*'}
                                #TODO Error handling for no connection to Exchange Online
                                $FilterArray.Add('$_.FieldValues.BSS_x0020_No_x002e_ -notin $ClientGroups.Alias')}
        }#switch     
        
        $ScriptBlock = [scriptblock]::Create($FilterArray -join ' -and ')

        $ClientListItem = Get-PnPListItem -List $ListName | Where-Object -FilterScript $ScriptBlock

        Write-Output $ClientListItem

    }#process

    END{}#end

}#function