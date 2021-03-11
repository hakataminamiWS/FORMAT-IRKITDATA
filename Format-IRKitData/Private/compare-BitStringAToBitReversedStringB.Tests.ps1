BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe "compare-BitStringAToBitReversedStringB" {
    It "compares binary String A to the bit-reversed String B." {
        compare-BitStringAToBitReversedStringB "00010100" "11101011" | Should -Be $true
    }
    It "returns false, when A is not equal to the bit-reversed B." {
        compare-BitStringAToBitReversedStringB "11110000" "00001010" | Should -Be $false
    }
}