<#Requires -Module AzureAD#>
#Requires -Module AZ.Accounts

param (
    [String[]]$Environments = ('P0'),
    [String]$Prefix = 'AZC1',
    [String]$App = 'ADF'
)

# Runs under Service Principal that is owner
$context = Get-AzContext
$Tenant = $Context.Tenant.Id
$SubscriptionID = $Context.Subscription.Id
$Subscription = $Context.Subscription.Name
$Account = $context.Account.Id

#region Connect to AZDevOps
$Global = Get-Content -Path $PSScriptRoot\..\tenants\$App\Global-Global.json | ConvertFrom-Json -Depth 10 | ForEach-Object Global
$GitHubProject = $Global.GitHubProject
$SPAdmins = $Global.ServicePrincipalAdmins
$AppName = $Global.AppName

Foreach ($Environment in $Environments)
{
    $EnvironmentName = "$($Prefix)-$($AppName)-RG-$Environment"
    $SecretName = $EnvironmentName -replace '-', '_'
    $ServicePrincipalName = "${GitHubProject}_$EnvironmentName"

    #region Create the Service Principal in Azure AD
    $appID = Get-AzADApplication -IdentifierUri "http://$ServicePrincipalName"
    if (! $appID)
    {
        # Create Service Principal
        New-AzADServicePrincipal -DisplayName $ServicePrincipalName -OutVariable sp -EndDate (Get-Date).AddYears(5) -Role Reader -Scope /
        $pw = [pscredential]::new('user', $sp.secret).GetNetworkCredential().Password
    
        $appID = Get-AzADApplication -DisplayName $ServicePrincipalName

        # Only set the GH Secret the first time

        $secret = [ordered]@{
            clientId       = $SP.ApplicationId
            displayName    = $SP.DisplayName
            name           = $SP.ServicePrincipalNames[1]
            clientSecret   = [System.Net.NetworkCredential]::new('', $SP.Secret).Password
            tenantId       = $Tenant
            subscriptionId = $SubscriptionID
        } | ConvertTo-Json -Depth 5 -Compress
        $secret

        gh secret set $SecretName -b $secret
    }
    else
    {
        Get-AzADServicePrincipal -DisplayName $ServicePrincipalName -OutVariable sp
    }
    #endregion

    # #region  Add extra owners on the Service principal
    # Connect-AzureAD -TenantId $Tenant 
    # foreach ($admin in $SPAdmins)
    # {
    #     $adminID = Get-AzADUser -UserPrincipalName $admin
    #     if ($adminID.Id)
    #     {
    #         try
    #         {
    #             Add-AzureADServicePrincipalOwner -ObjectId $sp.id -RefObjectId $adminID.Id -ErrorAction Stop -InformationAction Continue   
    #             Add-AzureADApplicationOwner -ObjectId $appID.ObjectId -RefObjectId $adminid.Id -ErrorAction SilentlyContinue -InformationAction Continue
    #         }
    #         catch
    #         {
    #             Write-Warning $_.Exception.Message
    #         }
    #     }
    #     else
    #     {
    #         Write-Warning "AzADUser [$admin] not found!!!"
    #     }
    # }
    # #endregion
}