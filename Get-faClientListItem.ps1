<### WORK TO DO ###
Make work with no params (i.e. retrieve all groups)
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

.PARAMETER DevClients
    Specifying this parameter will return all client list items where they are marked for development use i.e. 'ForDev' field value is 'Yes' (or true).

.PARAMETER NoClientSiteLink
    Specifying this parameter will return all client list items where there is no client site link.

.PARAMETER NoUnifiedGroup
    Specifying this parameter will return all client list items where there is no associated Unified Group. (Group alias matching BSS- number).

#>
    [CmdletBinding()]

    Param(
        [switch]$DevClient,
        [switch]$NoClientSiteLink,
        [switch]$NoUnifiedGroup
    )

    BEGIN{

        Write-Verbose '[BEGIN  ] Setting values for Site URL and List Name'
        $SiteUrl = 'https://fletchersonline.sharepoint.com'
        $ListName = 'Clients'

    }#begin

    PROCESS{

        Write-Verbose "[PROCESS] Establishing connection to $SiteUrl"
        if ((Get-PnPConnection).Url -eq $SiteUrl) {
            Write-Verbose "Already connected to $SiteUrl"
        } else {
            #TODO Might be better using Write-Warning here?
            Write-Verbose "No connection to $SiteUrl - attempting connection"
            Connect-PnPOnline -Url $siteurl -UseWebLogin
        }#if/else
        
        Write-Verbose '[PROCESS] Building filter array for filtescript'
        $FilterArray = New-Object -TypeName System.Collections.Generic.List[string]

        Switch ($PSBoundParameters.GetEnumerator().Where({$_.Value -eq $true}).Key) {
            'DevClient'         {$FilterArray.Add('$_.FieldValues.ForDev -eq $true')}
            'NoClientSiteLink'  {$FilterArray.Add('$_.FieldValues.Client_x0020_Site -eq $null')}
            'NoUnifiedGroup'    {$ClientGroups = Get-UnifiedGroup
                                #TODO Error handling for no connection to Exchange Online
                                $FilterArray.Add('$_.FieldValues.BSS_x0020_No_x002e_ -notin $ClientGroups.Alias')}
        }#switch     
        
        Write-Verbose '[PROCESS] Compiling filter array to filterscript'
        $ScriptBlock = [scriptblock]::Create($FilterArray -join ' -and ')

        Write-Verbose '[PROCESS] Fetching list items'
        $ClientListItems = Get-PnPListItem -List $ListName | Where-Object -FilterScript $ScriptBlock

        Write-Verbose '[PROCESS] Adding members for pipeline output'
        foreach ($ClientListItem in $ClientListItems) {
            Add-Member -InputObject $ClientListItem -MemberType NoteProperty -Name 'ClientNumber' -Value $ClientListItem.FieldValues.BSS_x0020_No_x002e_
            Add-Member -InputObject $ClientListItem -MemberType NoteProperty -Name 'CompanyName' -Value $ClientListItem.FieldValues.Company
        }#foreach 

        Write-Output $ClientListItems

    }#process

    END{
        Write-Verbose '[END    ] '
        #Close PnPConnection?
    }#end

}#function