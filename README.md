# Format-IRkitData

Formats IRkit get-mathod data.

- [Format-IRkitData](#format-irkitdata)
  - [How to install](#how-to-install)
  - [Usage](#usage)
    - [Read-CustomerCodeAndData_fromNECformated_IRKitGetData](#read-customercodeanddata_fromnecformated_irkitgetdata)
    - [Convert-IRKitPostData_OnNECFomat_fromCustomerCodeAndData](#convert-irkitpostdata_onnecfomat_fromcustomercodeanddata)
  - [Lisence](#lisence)

## How to install

You can install from [PowerShell Gallery](https://www.powershellgallery.com/packages/Format-IRKitData).

## Usage

### Read-CustomerCodeAndData_fromNECformated_IRKitGetData

Read Customer code(16bit) and Data(8bit) on NEC Format, from a [IRKit get-method data](https://getirkit.com/en/#toc_10).

Use pipeline.

```PowerShell
PS C:\> curl -s -i "http://192.168.0.1/messages" -H "X-Requested-With: curl" | Read-CustomerCodeAndData_fromNECformated_IRKitGetData

CustomerCode     Data
------------     ----
1111111100000000 00001111
```

Or specifies "data" string from a IRKit get-method data. 

```PowerShell
PS C:\> Read-CustomerCodeAndData_fromNECformated_IRKitGetData "[17984,8992,1124,3372,..,3372,1124]"

CustomerCode     Data
------------     ----
1111111100000000 00001111
```

### Convert-IRKitPostData_OnNECFomat_fromCustomerCodeAndData
Convert Customer code(16bit) and Data(8bit) on NEC Format to a data of [IRKit IR signal JSON](https://getirkit.com/en/#toc_10).

```PowerShell
PS C:\> Convert-IRKitPostData_OnNECFomat_fromCustomerCodeAndData -CustomerCode "0000111100001111" -Data "11110000"
[17984,8992,1124,1124,1124,1124,1124,1124,1124,1124,1124,3372,1124,3372,1124,3372,1124,3372,1124,1124,1124,1124,1124,1124,1124,1124,1124,3372,1124,3372,1124,3372,1124,3372,1124,3372,1124,3372,1124,3372,1124,3372,1124,1124,1124,1124,1124,1124,1124,1124,1124,1124,1124,1124,1124,1124,1124,1124,1124,3372,1124,3372,1124,3372,1124,3372,1124]
```

## Lisence
MIT
