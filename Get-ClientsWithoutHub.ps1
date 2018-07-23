$clients = Get-SPOSite -Filter {Url -like "*/sites/BSS-*"}

foreach ($client in $clients) {
    $client.HubSiteId
}



# Guid for Fletcher Associates ADMIN HubSite: 502fccfc-3467-48eb-917f-b475e5c7c909

$clientSites = Get-SPOSite -Filter {Url -like "*/sites/BSS-*"}
$hubSites=@()
$inheritingSites=@()
$noninheritingSites=@()

Write-Host "Getting site data..."

foreach($site in $clientSites)

{
    $aSite = Get-SPOSite -id $site.Url  | Select-Object HubSiteId, IsHubSite, title, Url

    if ($aSite.IsHubSite -eq $true)
    {
        #It's a hub site
        Write-Host HubSite: $aSite.Title $aSite.HubSiteId
        $hubSites += $aSite
    }
    elseIf ($aSite.HubSiteId -ne "00000000-0000-0000-0000-000000000000")
    {
        #It's not a hub site and it is using a hubsite
        Write-Host INHERITING: $aSite.Title $aSite.HubSiteId -ForegroundColor Green
        $inheritingSites += $aSite
    }
    elseif ($aSite.HubSiteId -eq "00000000-0000-0000-0000-000000000000") {
         #It's not a hub site and it is not using a hubsite
        Write-Host NOT INHERITING: $aSite.Title $aSite.HubSiteId -ForegroundColor Red
        $noninheritingSites += $aSite
    }#end if
}#end foreach







##THIS IS FAST - BUT I DONT UNDERSTND IT FULLY!!!
## List all sites being a hub site or associate to a hub site
#$results = Submit-PnPSearchQuery -Query 'contentclass=sts_site' -RefinementFilters 'departmentid:string("{*",linguistics=off)' -TrimDuplicates $false -SelectProperties @("Title","Path","DepartmentId","SiteId") -All -RelevantResults
#
## Filter out the hub sites
#$hubSites = $results | Where-Object { $_.DepartmentId.Trim('{','}') -eq $_.SiteId  }
#
## Loop over the hub sites
#foreach( $hub in $hubSites ) {
#    Write-Host $hub.Title - $hub.Path -ForegroundColor Green
#    # Filter out sites associated to the current hub
#    $associatedSites = ($results | Where-Object { $_.DepartmentId -eq $hub.DepartmentId -and $_.SiteId -ne $hub.SiteId })
#    foreach($site in $associatedSites) {
#        Write-Host "`t"$site.Title #- $site.Path -ForegroundColor Yellow
#    }
#}