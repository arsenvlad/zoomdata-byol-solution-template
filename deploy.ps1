# The following command will open a browser window to perform authentication and will store a Azure Active Directory token for subsequent requests
Add-AzureAccount

# List the subscriptions that the currently logged in user (based on the token) can see
Get-AzureSubscription

# Select and set specific subscription by name (the ones that are returned by the Get-AzureSubscription cmdlet above)
Select-AzureSubscription -SubscriptionName "ArsenVlad MSDN Subscription"
Set-AzureSubscription -SubscriptionName "ArsenVlad MSDN Subscription"

Get-AzureVMUsage -Location "West US"

$AdminPassword = ConvertTo-SecureString -String "MyTest#123" -AsPlainText -Force
$SshPublicKey = "ssh-rsa YOUR SSH PUBLIC KEY HERE"
$ResourceGroupName = "avzoomdata001"
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
    -authenticationType sshPublicKey `
    -sshPublicKey $SshPublicKey `
    -storageAccountNewOrExisting new -storageAccountFromTemplate $ResourceGroupName -storageAccountType "Standard_LRS" `
    -vnetNewOrExisting new `
    -publicIPNewOrExisting new -publicIPAddressName $ResourceGroupName -dnsName $ResourceGroupName `
    -company "MyCompany" -firstName "FirstName" -lastName "LastName" -email "john@example.com" -businessPhone "5556667788" -jobRole "Job Role" -jobFunction "Job Function"
Get-Date

# Existing Storage Account, Existing Virtual Network, Existing Public IP
Get-Date
Write-Host $ResourceGroupName
New-AzureResourceGroupDeployment -Name "mainTemplate" -ResourceGroupName $ResourceGroupName -TemplateFile mainTemplate.json -Force `
    -location $Region `
    -artifactsBaseUrl "https://templocistorage.blob.core.windows.net/zoomdata" `
    -vmName $ResourceGroupName `
    -vmSize Standard_D2 `
    -adminUsername "azureuser" `
    -authenticationType sshPublicKey `
    -sshPublicKey $SshPublicKey `
    -storageAccountNewOrExisting existing -storageAccountResourceGroup "avzoomdata001" -storageAccountFromTemplate "avzoomdata001" -storageAccountType "Standard_LRS" `
    -vnetNewOrExisting existing -vnetResourceGroup "avzoomdata001" -vnetName "vnet-zoomdata" -subnet1Name "default" `
    -publicIPNewOrExisting existing -publicIPAddressName "avzoomdata001" -publicIPAddressResourceGroup "avzoomdata001" `
    -company "MyCompany" -firstName "FirstName" -lastName "LastName" -email "john@example.com" -businessPhone "5556667788" -jobRole "Job Role" -jobFunction "Job Function"
Get-Date