BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe "convertTo-NearestT" {
    $T = 562
    $testCases = @(
        @{ inputInt        = [math]::Truncate($T / 2) - 1
            expectedResult = 0
        }
        @{ inputInt        = [math]::Truncate($T / 2) + 1
            expectedResult = $T
        }
        @{ inputInt        = $T + [math]::Truncate($T / 2) - 1
            expectedResult = $T
        }
        @{ inputInt        = $T + [math]::Truncate($T / 2) + 1
            expectedResult = 2 * $T
        }
    )
    It "returns <expectedResult>, when input is <inputInt>" -TestCases $testCases {
        param($inputInt, $expectedResult)
        convertTo-NearestT $inputInt | Should -Be $expectedResult
    }
}