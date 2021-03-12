BeforeDiscovery {
}
BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    function conv([int[]]$intar) { "[" + (($intar | ForEach-Object { $_ * 2 * 562 }) -join ",") + ",1124]" }

    $testModule = "Format-IRKitData"
    Get-Module $testModule | Remove-Module -Force
    Import-Module (Get-ChildItem　(Get-Item $PSScriptRoot).Parent |
        Where-Object { $_.Name -match $testModule } ) -Force
}

Describe "Convert-IRKitPostData_OnNECFomat_fromCustomerCodeAndData" {
    It "returns Customer Code and Data from NEC formated IRKit get-data." {
        $inputCustomerCode = "0000111100001111"
        $inputData = "11110000"

        $validLeaderData = @(16, 8)
        $validCustomerCode = (@(1, 1) * 4 + @(1, 3) * 4) * 2 # (1, 1) -> 0, (1, 3) -> 3 on NCE Format.  
        $validData = @(1, 3) * 4 + @(1, 1) * 4
        $validBitReversedData = @(1, 1) * 4 + @(1, 3) * 4
        $expectedResult = conv ($validLeaderData + $validCustomerCode + $validData + $validBitReversedData)

        Convert-IRKitPostData_OnNECFomat_fromCustomerCodeAndData $inputCustomerCode $inputData |
        Should -Be $expectedResult
    }

    It "returns null, when the input is empty." {
        Convert-IRKitPostData_OnNECFomat_fromCustomerCodeAndData |
        Should -Be $null
    }
}
