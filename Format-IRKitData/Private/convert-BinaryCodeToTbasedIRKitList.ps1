#Requires -Version 7.1

function convert-BinaryCodeToTbasedIRKitList {
    # binary code -> IRKit T(T: modulation unit) based data. like 0 -> [1,1] or 1 -> [1,3].
    # example: "01" -> [1,1,1,3]
    [OutputType([Int[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^[01]+$")]
        [String]$stbin
    )
    [int[]]$intary = @()
    $stbin.ToCharArray() | ForEach-Object { if ($_ -eq "0") { $intary += @(1, 1) } else { $intary += @(1, 3) } }
    $intary
}