<#
.SYNOPSIS
Writes values from client Unified Group properties back to the client list. i.e. SharePoint Site URL.
.DESCRIPTION
TODO 
.PARAMETER ParameterName
TODO
.PARAMETER ParameterName
(repeat as required)
.EXAMPLE
TODO
.EXAMPLE
(repeat as required)
#>

#Gets all unifiedgroups excluding main 'admin' site.
$groups = Get-UnifiedGroup #-Filter {[Alias] -like "BSS-*"}
$clients = Get-PnPListItem -List "Clients"

Foreach ($client in $clients) {
    if ($groups.Alias -contains $client.FieldValues.BSS_x0020_No_x002e_) {
        $parameters = @{
            'List' = "Clients" ;
            'Identity' = $client ;
            'Values' = @{ "Client_x0020_Site" = 
                (Get-UnifiedGroup -Identity $client.FieldValues.BSS_x0020_No_x002e_ |
                    Select-Object -ExpandProperty SharepointSiteURL)}
        }# end parameters
        Set-PnPListItem @parameters
    }# end if  
}#end foreach