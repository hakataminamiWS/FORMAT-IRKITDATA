#Requires -Version 7.1

<#
  .SYNOPSIS
  Read Customer code(16bit) and Data(8bit) on NEC Format from a [IRKit get-method data].
  (https://getirkit.com/en/#toc_1)

  .INPUTS
  String. It should have a only pair of []. You can pipe objects from a IRKit get-method data.

  .OUTPUTS
  PSCustomObject. Properties are CustomerCode(16bits string) and Data(8bits string).

  .EXAMPLE
  PS> curl -s -i "http://192.168.0.1/messages" -H "X-Requested-With: curl" |
      Read-CustomerCodeAndData_fromNECformated_IRKitGetData

  .EXAMPLE
  PS> Read-CustomerCodeAndData_fromNECformated_IRKitGetData "[17984,8992,1124,1124,..,3372,1124]"
#>
function global:Read-CustomerCodeAndData_fromNECformated_IRKitGetData {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline = $True)]$st
    )
    Begin {
        Get-ChildItem　(Get-Item $PSScriptRoot).parent -Include "*.ps1" -Recurse |
        Where-Object { $_.Name -notmatch "\.Tests\." } |
        Where-Object FullName -Like "*\Private\*" |
        ForEach-Object { & $_.PSPath }
        
        [int]$T = 562 # modulation unit (μs)

        [int]$customerCodeFirstIndexPosition = 2
        [int]$customerCodeLastIndexPosition = 33

        [int]$dataFirstIndexPosition = 34
        [int]$revdataLastIndexPosition = 65

        [int]$minimunRequiedLength = $revdataLastIndexPosition

        $result = [PSCustomObject]@{
            CustomerCode = ""
            Data         = ""
        }
    }
    Process {
        $regex = '\[.+\]'
        if (Select-string -InputObject $st -Pattern $regex -Quiet) {
            $IRKitData = Select-string -InputObject $st -Pattern $regex |
            ForEach-Object { $_.Matches } |
            ForEach-Object { $_.Value }

            # transfer IRKit count data to T(T: modulation unit) based data. 
            # 1 IRKit count is 2MHz(= 2*10^6 /s). T = 562(= 10^-6 /s).
            # Then (IRKit count data/(2*10^6))/T -> T based data.
            # reffer [IR signal JSON represntation.](https://getirkit.com/en/#toc_10)
            # the IRKit count data is rounded to multiple of 2T, because a IRKit data includes a error.
            [Int[]]$listTbasedIRKitData = [Int[]]($IRKitData -replace "([^,0-9])").Split(",") |
            ForEach-Object { (convertTo-NearestT $_  ) / (2 * $T) }

            # check minimum required length of input.
            if ($listTbasedIRKitData.Count -lt $minimunRequiedLength) {
                Write-Error "Input data do not has minimum required length." -ErrorAction Stop
            }

            # Leader data
            # on NEC format, Learder data is [16T:On, 8T:Off] exactly.
            # in this check, we use [12-20T:On, 6-10T:Off] because of a IRKit count data's error.
            if (($listTbasedIRKitData[0] -lt 12) -Or ($listTbasedIRKitData[0] -gt 20) -Or
                ($listTbasedIRKitData[1] -lt 6) -Or ($listTbasedIRKitData[1]) -gt 10 ) {
                Write-Error "Leader data mismatch (12-20T:On, 6-10T:Off)." -ErrorAction Stop
            }

            # customer code(16bit)
            $customerCodeListTbased =
            $listTbasedIRKitData[$customerCodeFirstIndexPosition..$customerCodeLastIndexPosition]
            $cc = convert-TbasedIRKitListToBinaryCode $customerCodeListTbased
            if ($cc) {
                $result.CustomerCode = $cc
            }
            else {
                Write-Error (
                    "Wrong Customer code. 2T based IRKit data=" +
                    ($customerCodeListTbased -join ",") +
                    ".") -ErrorAction Stop
            }

            # data(8bit) and reverse data
            $dataAndReverseDataListTbased =
            $listTbasedIRKitData[$dataFirstIndexPosition..$revdataLastIndexPosition]

            [string]$dAndRv = convert-TbasedIRKitListToBinaryCode $dataAndReverseDataListTbased
            [string]$data = $dAndRv.Substring(0, $dAndRv.Length / 2)
            [string]$reverseData = $dAndRv.Substring($dAndRv.Length / 2, $dAndRv.Length / 2)
            if (-Not(compare-BitStringAToBitReversedStringB $data $reverseData)) {
                Write-Error (
                    "Data(8bit) is not equal to the bit reversed Reverse Data(8bits). " +
                    $data +
                    " <=> bit-reversed (" + $reverseData + ").") -ErrorAction Stop
            }
            if ($data) {
                $result.Data = $data
            }
            $result
        }
    }
    End {
    }
}