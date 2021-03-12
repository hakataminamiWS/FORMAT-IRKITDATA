#Requires -Version 7.1

function convertTo-NearestT {
    param (
        [Int]$a
    ) 
    $T = 562
    if (($a % $T) -ge ($T / 2)) {
        [math]::Truncate($a + $T - ($a % $T))
    }
    else {
        [math]::Truncate($a - ($a % $T))
    } 
}