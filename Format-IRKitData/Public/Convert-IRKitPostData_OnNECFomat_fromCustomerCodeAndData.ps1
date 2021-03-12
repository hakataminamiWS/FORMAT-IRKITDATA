#Requires -Version 7.1

<#
  .SYNOPSIS
  Convert Customer code(16bit) and Data(8bit) on NEC Format to a data of [IRKit IR signal JSON].
  (https://getirkit.com/en/#toc_10)

  .INPUTS
  CustomerCode (needs 16 digit binary character), Data (needs 8 digit binary character)
  This accepts from a property of a pipeline object.

  .OUTPUTS
  String.

  .EXAMPLE
  PS> Convert-IRKitPostData_OnNECFomat_fromCustomerCodeAndData -CustomerCode "0000111100001111" -Data "11110000"

#>
function global:Convert-IRKitPostData_OnNECFomat_fromCustomerCodeAndData {
    [CmdletBinding()]
    [OutputType([String])]
    Param (
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [ValidatePattern("^[01]+$")]
        [ValidateLength(16, 16)] 
        [String]
        $CustomerCode,
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [ValidatePattern("^[01]+$")]
        [ValidateLength(8, 8)] 
        [String]
        $Data
    )
    Begin {
        Get-ChildItem　(Get-Item $PSScriptRoot).parent -Include "*.ps1" -Recurse |
        Where-Object { $_.Name -notmatch "\.Tests\." } |
        Where-Object FullName -Like "*\Private\*" |
        ForEach-Object { & $_.PSPath }
    }
    Process {
        if ($CustomerCode -And $Data) {

            # bit-reversed Data.
            $bitReversedData = convertTo-BitRevesedString $Data

            [Int[]]$tBasedIRKitList = [Int[]]@(16, 8) # Leader
            $tBasedIRKitList += convert-BinaryCodeToTbasedIRKitList ($CustomerCode + $Data + $bitReversedData)

            # last of IRKit data, for Signal Off
            $tBasedIRKitList += @(1)
            
            # 2 * 562: becuase IRKit counter use 2MHz.
            $result = "[" + (($tBasedIRKitList | ForEach-Object { $_ * 2 * 562 }) -join ",") + "]"
            $result        
        }
    }
    End {
    }
}