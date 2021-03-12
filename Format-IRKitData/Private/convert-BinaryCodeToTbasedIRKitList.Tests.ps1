BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe "convert-BinaryCodeToTbasedIRKitList" {
    It "converts 0 -> [1, 1], 1 -> [1, 3]." {
        convert-BinaryCodeToTbasedIRKitList "0110" | Should -Be @(1, 1, 1, 3, 1, 3, 1, 1)
    }
}