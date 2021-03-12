BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe "convertTo-BitRevesedString" {
    $testCases = @(
        @{ inputString        = "01011110"
            expectedResult = "10100001"
        }
    )
    It "returns <expectedResult>, when input is <inputString>" -TestCases $testCases {
        param($inputString, $expectedResult)
        convertTo-BitRevesedString $inputString | Should -Be $expectedResult
    }
}