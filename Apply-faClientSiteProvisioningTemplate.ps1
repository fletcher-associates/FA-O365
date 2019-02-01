function Apply-faClientSiteProvisioningTemplate {
    [CmdletBinding()]
    #Test to make sure pipeline input works
    param(
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]$Site,

        [Parameter(Mandatory=$true)]
        [string]$TemplatePath
    )

    BEGIN{}#begin

    PROCESS{

        foreach ($S in $Site) {

            Write-Verbose "Connecting to $S.Url"

            Connect-PnPOnline -Url $S.Url -UseWebLogin

            Write-Verbose "Applying provisioning template to $S.Url"

            $parameters = @{
                'Path' = $TemplatePath ;
                'ClearNavigation' = $true ;
                'ExcludeHandlers' = 'SiteSecurity'
            }#parameters

            Apply-PnPProvisioningTemplate @parameters
        
        }#foreach

    }#process

    END{}#end

}#function