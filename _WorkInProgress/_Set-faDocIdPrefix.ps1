#Run this after applying provisioning template which enables DocId Site Feature

foreach ($group in $groups) {
    Connect-PnPOnline -Url $group.SharePointSiteUrl -UseWebLogin
    $DocIdPropertBagParameters = @{
        'Key'   = 'docid_msft_hier_siteprefix' ;
        'Value' = $group.Alias.Replace('-', '')
    }#end parameters
    Set-PnPPropertyBagValue @DocIdPropertBagParameters
}#end foreach