<#
.SYNOPSIS
Adds client unified groups to tenant using values from client list.

.DESCRIPTION
This command retrieves clients from the client list and provisions unified groups for them where one does not already exist for them. Groups are created using values from the client list for name, displayname etc.

.PARAMETER

.EXAMPLE
New-faClientGroup

This command retrieved clients from the client list and creates new unified groups for those that do not have one.

#>


#Note there is a 64-character limit on UnifiedGroup -Name property which need to be set in the list.

$items = (Get-PnPListItem -List "Clients").FieldValues | Select-Object -First 5

Foreach ($item in $items) {

    #If statement to prevent duplicates
    if ((Get-UnifiedGroup).Alias -contains $item.BSS_x0020_No_x002e_) {
        Write-Host OPERATION SKIPPED $item.Client_x0020_No already exists.

    } else {
        $parameters = @{
            'AutoSubscribeNewMembers' = $true ;
            'AccessType' = 'Private' ;
            'Alias' = $item.BSS_x0020_No_x002e_ ;
            'DisplayName' = $item.Company ;
            #'EmailAddresses' = $item.EmailAlias ; <---this column needs adding to the client list - or do with set-unifiedgroup 
            'Language' = (Get-Culture) ; 
            'Name' = $item.Company ;
            #'Notes' = $null ; <---this needs adding
            'Owner' = 'mike.kirby@fletcher-associates.co.uk'
        }#end parameters
        New-UnifiedGroup @parameters         
    }#end if
}#end foreach

