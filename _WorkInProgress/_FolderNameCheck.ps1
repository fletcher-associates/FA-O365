
# Desired folder list:
$desiredfolders = (
    '00 Management',
    '01 Employees',
    '02 Work Activities',
    '03 Work Equipment',
    '04 Substances',
    '05 Workplaces',
    '06 Environmental',
    '07 HR',
    '08 Quality',
    'Forms',
    'Internal Client Admin'
)

$clientlibs = Get-PnPList | Where-Object {$_.Title -like "BSS*"}

foreach ($clientlib in $clientlibs) {
#    Write-Output ("Out of scope folders for " + $clientlib.Title)
    Get-PnPFolderItem -FolderSiteRelativeUrl $clientlib.rootfolder.serverrelativeurl |
    Where-Object {$_.name -notin $desiredfolders} |
    Select-Object -Property serverrelativeurl
}#end foreach