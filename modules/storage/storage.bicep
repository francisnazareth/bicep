resource myStorage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: 'mystorageaccount'
  location: 'qatarcentral'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
```
