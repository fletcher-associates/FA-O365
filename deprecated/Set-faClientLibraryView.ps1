<#
.SYNOPSIS
Sets the default view for document libraries.
.DESCRIPTION
This replaces the default view with a view which adds the Enterprise Keyword column.
.PARAMETER ParameterName
Give details of parameter and how its used
.PARAMETER ParameterName
(repeat as required)
.EXAMPLE
Give a usage example with explanation
.EXAMPLE
(repeat as required)
#>

$sites = Get-UnifiedGroup -Filter {[Alias] -like "BSS-*"}

foreach ($site in $sites) {

Write-Output "Connecting to $site"
Connect-PnPOnline -Url $site.SharePointSiteUrl -UseWebLogin

$libraries = ('Management',
              'Employees',
              'WorkActivities',
              'WorkEquipment',
              'Substances',
              'Workplaces',
              'HR',
              'Quality')

foreach ($library in $libraries) {
    Write-Output ("Removing old views from " + $library)
    $views = Get-PnPView -List $library | Where-Object -Property Hidden -eq $false

    foreach ($view in $views) {
        Write-Output ("Removing views " + $view.title)
        Remove-PnPView -List $library -Identity $view.id  -Force
    }#end foreach view

    Write-Output ("Adding new view to " + $library)
    $viewparameters = @{
        'List' = $library ;
        'Title' = "All Documents" ;
        'Fields' =  "DocIcon", "LinkFilename", "TaxKeyword", "Modified", "Editor" ;
        'SetAsDefault' = $true ;
        'Paged' = $true }
    Add-PnPView @viewparameters

}#end foreach library
}#end foreach site