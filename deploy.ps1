# The following command will open a browser window to perform authentication and will store a Azure Active Directory token for subsequent requests
Add-AzureAccount

# List the subscriptions that the currently logged in user (based on the token) can see
Get-AzureSubscription

# Select and set specific subscription by name (the ones that are returned by the Get-AzureSubscription cmdlet above)
Select-AzureSubscription -SubscriptionName "ArsenVlad MSDN Subscription"
Set-AzureSubscription -SubscriptionName "ArsenVlad MSDN Subscription"

Get-AzureVMUsage -Location "West US"

$AdminPassword = ConvertTo-SecureString -String "MyTest#123" -AsPlainText -Force
$ResourceGroupName = "avzoomdata002"
$Region = "westus"

New-AzureResourceGroup -Name $ResourceGroupName -Location $Region

# New Storage Account, New Virtual Network, New Public IP
Get-Date
Write-Host $ResourceGroupName
New-AzureResourceGroupDeployment -Name "mainTemplate" -ResourceGroupName $ResourceGroupName -TemplateFile mainTemplate.json -Force `
    -location $Region `
    -artifactsBaseUrl "https://templocistorage.blob.core.windows.net/zoomdata" `
    -vmName $ResourceGroupName `
    -vmSize Standard_D2 `
    -adminUsername "azureuser" `
    -adminPassword $AdminPassword `
    -storageAccountNewOrExisting new -storageAccountFromTemplate $ResourceGroupName -storageAccountType "Standard_LRS" `
    -vnetNewOrExisting new `
    -publicIPNewOrExisting new -publicIPAddressName "avzoomdata" -dnsName $ResourceGroupName
Get-Date
