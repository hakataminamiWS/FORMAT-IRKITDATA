#Requires -Version 7.1

function convert-TbasedIRKitListToBinaryCode {
    # IRKit T(T: modulation unit) based data [1,1] -> 0 or [1,3] -> 1.
    # example: [1,1,1,3] -> "01", [1,4,1,1] -> null
    param (
        [int[]]$list_T
    )
    [string]$stbin = ""
    for ($i = 0; $i -lt $list_T.Count; $i += 2) {
        if (($list_T[$i] -eq 1) -and ($list_T[$i + 1] -eq 1)) {
            $stbin += "0"
        }
        elseif (($list_T[$i] -eq 1) -and ($list_T[$i + 1] -eq 3)) {
            $stbin += "1"            
        }
    }
    if (($list_T.Length / 2) -eq $stbin.Length) {
        $stbin
    }
}