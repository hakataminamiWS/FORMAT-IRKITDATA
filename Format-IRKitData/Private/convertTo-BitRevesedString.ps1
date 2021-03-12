#Requires -Version 7.1

function convertTo-BitRevesedString {
    param (
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [ValidatePattern("^[01]+$")]
        [String]$stbin
    ) 
    [char[]]$cary = @()
    $stbin.ToCharArray() | ForEach-Object { if ($_ -eq "0") { $cary += "1" } else { $cary += "0" } }
    -join $cary
}