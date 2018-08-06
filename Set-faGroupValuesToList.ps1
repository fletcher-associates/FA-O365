<#
.SYNOPSIS
Writes values from client Unified Group properties back to the client list. i.e. SharePoint Site URL.
.DESCRIPTION
Give a more detailed and fuller description of what it does. Elaborate on usage scenarios, limitations, prerequisites and cross-refer to other similar scripts as necessary where there could be confusion.
.PARAMETER ParameterName
Give details of parameter and how its used.
.PARAMETER ParameterName
(repeat as required)
.EXAMPLE
Give a usage example with explanation.
.EXAMPLE
(repeat as required)
#>

#Gets all unifiedgroups excluding main 'admin' site.
$groups = Get-UnifiedGroup -Filter {[Alias] -like "BSS-*"}
$clients = Get-PnPListItem -List 'Clients' | Where-Object {$_.FieldValues.Client_x0020_Site -eq $null}

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