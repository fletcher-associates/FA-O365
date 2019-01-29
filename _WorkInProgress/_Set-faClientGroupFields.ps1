<#
.SYNOPSIS
Give a breif synopsis of what it does.
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

$clients = Get-PnPListItem -List 'Clients'

foreach ($client in $clients) {
    $group = Get-UnifiedGroup -Identity $client.FieldValues.BSS_x0020_No_x002e_ -ErrorAction SilentlyContinue
    if ($null -eq $group) {
        Write-Host "NO SITE for"$client.FieldValues.Company"" -ForegroundColor Red
    }
    elseif ($client.FieldValues.Company -ne $group.displayname) {
        Set-UnifiedGroup -Identity $client.FieldValues.BSS_x0020_No_x002e_ -DisplayName $client.FieldValues.Company
        Write-Host "NO MATCH for"$client.FieldValues.Company"- Company Name updated" -ForegroundColor Yellow
    }
    elseif ($client.FieldValues.Company -eq $group.displayname) {
        Write-Host "MATCH for"$client.FieldValues.Company" vs "$group.displayname"" -ForegroundColor Green
    }
}


#look at use of Write-Output instead of Write-Host - produce an output log
#improve error handling to call no object found exception explicitly rather than usin silently continue and presumng the error is because no site exists.