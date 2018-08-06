<#
.SYNOPSIS
Adds internal users from 'FletcherAssociates' group to Members of client groups.
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

##Add internal users to groups
#Refactor to fetch group owner from each group and exclude from Add-UnifiedGroupLinks

$groups  =  Get-UnifiedGroup -Filter {[Alias] -like "BSS-*"}
$members =  (Get-UnifiedGroupLinks -LinkType Members -Identity FletcherAssociates | 
            Where-Object -Property 'Name' -NE 'mike.kirby').PrimarySmtpAddress 

foreach ($group in $groups) {
    Write-Output "Adding members to $($group.Alias) $($group.DisplayName)" 
    Add-UnifiedGroupLinks -Identity $group.Alias -LinkType Members -Links $members
}


