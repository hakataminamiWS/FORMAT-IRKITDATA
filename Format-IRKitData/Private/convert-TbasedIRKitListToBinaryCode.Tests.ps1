BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe "convert-TbasedIRKitListToBinaryCode" {
    It "converts [1, 1] -> 0, [1, 3] -> 1." {
        convert-TbasedIRKitListToBinaryCode @(1, 1, 1, 3, 1, 3, 1, 1) | Should -Be "0110"
    }
    It "converts neither [1, 1] nor [1, 3], fo example [1, 4], -> null." {
        convert-TbasedIRKitListToBinaryCode @(1, 4, 1, 3) | Should -Be $null
    }
}