##Add internal users to groups
#Refactor to fetch group owner from each group and exclude from Add-UnifiedGroupLinks

$groups  =  Get-UnifiedGroup -Filter {[Alias] -like "BSS-*"}
$members =  (Get-UnifiedGroupLinks -LinkType Members -Identity FletcherAssociates | 
            Where-Object -Property 'Name' -NE 'mike.kirby').PrimarySmtpAddress 

foreach ($group in $groups) {
    Write-Output "Adding members to $($group.Alias) $($group.DisplayName)" 
    Add-UnifiedGroupLinks -Identity $group.Alias -LinkType Members -Links $members
}


