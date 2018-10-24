#Get the unwanted web-parts from the page:

$sites = Get-UnifiedGroup -Filter {[Alias] -like "BSS-*"}
$page = 'home.aspx'

foreach ($site in $sites) {
Write-Output ("Connecting to " + $site)
Connect-PnPOnline -Url $site.SharePointSiteUrl -UseWebLogin
Write-Output "Removing unwanted WebParts"
$unwantedwebparts =     Get-PnPClientSideComponent -Page $page | 
                        Where-Object {$_.Title -eq "Quick links" -or $_.Title -eq "Document library" }
    foreach ($unwantedwebpart in $unwantedwebparts) {
        Write-Output ("Removing " + $unwantedwebpart.Title)
        $removeparams = @{
            Page = $page ;
            InstanceId = $unwantedwebpart.InstanceId ;
            Force = $true
        }
        Remove-PnPClientSideComponent @removeparams
    }#end foreach webpart
}#end foreach site


foreach ($webpart in $webparts) {
    Write-Output ("Removing " + $webpart.Title)
    $removeparams = @{
        Page = $page.PageTitle ;
        InstanceId = $webpart.InstanceId ;
        Force = $true
    }
    Remove-PnPClientSideComponent @removeparams
}