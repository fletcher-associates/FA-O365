#add help
#needs parameterising
#add Read-Host for $existing variable value.

#$existing = "name of existing folder"

# Desired folder names:

# "00 Management"
# "01 Employees"
# "02 Work Activities"
# "03 Work Equipment"
# "04 Substances"
#$renamed = "05 Workplaces"
# "06 Environmental"
# "07 HR"
# "08 Quality"
# "Forms"
#"Internal Client Admin"

$clientlibs = Get-PnPList | Where-Object {$_.Title -like "BSS*"}

foreach ($clientlib in $clientlibs) {
#    Write-Output ("Checking " + $clientlib.Title + " for folder with title " + $existing)
    $folder = Get-PnPFolderItem -FolderSiteRelativeUrl $clientlib.rootfolder.serverrelativeurl |
    Where-Object {$_.name -eq $existing}
    if ($null -ne $folder) {
        Write-Output ("Renaming " + $folder.name + " folder to " + $renamed)
        Rename-PnPFolder -Folder ($clientlib.Title.Substring(0,6) + "/" +$existing) -TargetFolderName $renamed
    }#end if
}#end foreach