# Query Resources JSON raw format.

# Method 1 -----------------------------------------------------

# View log analytics json
$rgName = 'AZC1-ADF-RG-P0'
$Name = 'AZC1-ADF-P0-vmDC01/AzureMonitorWindowsAgent'
$type = 'Microsoft.Compute/virtualMachines/extensions'

$rgName = 'AZC1-ADF-RG-P0'
$Name = 'AZC1-ADF-P0-vmDC01/GuestHealthWindowsAgent'
$type = 'Microsoft.Compute/virtualMachines/extensions'

# View Azure Monitor json
$rgName = 'AZC1-BRW-HUB-RG-P0'
$Name = 'azc1brwhubp0VMInsights'
$type = 'Microsoft.Insights/dataCollectionRules'

# View log analytics json
$rgName = 'AZC1-BRW-HUB-RG-P0'
$Name = 'azc1brwhubp0LogAnalytics'
$type = 'Microsoft.OperationalInsights/workspaces'

# View host pools
$rgName = 'AZC1-BRW-ABC-RG-S1'
$Name = 'AZC1-BRW-ABC-hp01'
$type = 'Microsoft.DesktopVirtualization/hostpools'

# View dashboards json
$rgName = 'AZC1-BRW-ABC-RG-S1'
$Name = 'ABC-S1-Default-Dashboard'
$type = 'Microsoft.Portal/dashboards'

# View logic app json
$rgName = 'AZC1-ADF-RG-S1'
$Name = 'Web-Test-SMTP'
$type = 'Microsoft.Logic/workflows'


# View vm json
$rgName = 'AZC1-BRW-HUB-RG-P0'
$Name = 'AZC1-BRW-HUB-P0-vmDC01'
$type = 'Microsoft.Compute/virtualMachines'

# View host pool json
$rgName = 'AZC1-BRW-ABC-RG-S1'
$Name = 'AZC1-BRW-ABC-S1-wvdhp01'
$type = 'Microsoft.DesktopVirtualization/hostPools'

# View host pool json
$rgName = 'AZC1-ADF-RG-S1'
$Name = 'Benwilk_microsoft.com'
$type = 'Microsoft.Web/connections'

# View the storage account
$rgName = 'AZC1-BRW-ABC-RG-S1'
$Name = 'azc1brwabcs1sadiag'
$type = 'Microsoft.Storage/storageAccounts'

# View the storage account
$rgName = 'AZC1-BRW-ABC-RG-S1'
$Name = 'AZC1-BRW-ABC-S1-vmADC01/AdminCenter'
$type = 'Microsoft.Compute/virtualMachines/extensions'

# View the storage account
$rgName = 'AZC1-BRW-ABC-RG-S1'
$Name = 'azc1brwabcs1sadiag/default'
$type = 'Microsoft.Storage/storageAccounts/blobServices'

# View the keyvault
$rgName = 'ACU1-BRW-AOA-RG-P0'
$Name = 'ACU1-BRW-AOA-P0-kvVLT01'
$type = 'Microsoft.KeyVault/vaults'

# View APIM
$rgName = 'ACU1-BRW-AOA-RG-S1'
$Name = 'ACU1-BRW-AOA-S1-apim01'
$type = 'Microsoft.ApiManagement/service'

# View APIM
$rgName = 'ACU1-BRW-AOA-RG-G1'
$Name = 'ACU1-BRW-AOA-G1-afd03'
$type = 'Microsoft.Network/frontdoors'

$rgName = 'ACU1-BRW-AOA-RG-S1'
$Name = 'ACU1-BRW-AOA-S1-afd01'
$type = 'Microsoft.Network/frontdoors'

$rgName = 'ACU1-BRW-AOA-RG-S1'
$Name = 'ACU1-BRW-AOA-S1-aks01'
$type = 'Microsoft.ContainerService/managedClusters'

$ID = Get-MyAzResourceID -rgName $rgName -Name $Name -type $type

$n = $type -split '/' | Select-Object -First 1
$t = ($type -split '/' | Select-Object -Skip 1) -join '/'
$API = Find-MYAZAPIVersion -ProviderNamespace $n -ResourceTypeName $t | Select-Object -First 1

# full view and format output via json converersion
Write-Verbose "Full view of resource, with latest API Version [$API]" -Verbose
Invoke-AzRestMethod -Method GET -Path ($ID + "?api-version=$API") | 
    ForEach-Object Content | ConvertFrom-Json -Depth 20 | ConvertTo-Json -Depth 20 | clip

