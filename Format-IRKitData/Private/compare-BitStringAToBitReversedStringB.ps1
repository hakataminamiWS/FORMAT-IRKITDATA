#Requires -Version 7.1

function global:compare-BitStringAToBitReversedStringB {
    param (
        [string]$a, [string]$b
    ) 
    [char[]]$c = @()
    $b.ToCharArray() | ForEach-Object { if ($_ -eq "0") { $c += "1" } else { $c += "0" } }
    $a -eq (-join $c)
}