BeforeDiscovery {
    # for errorTestCases
    function conv([int[]]$intar) { "[" + (($intar | ForEach-Object { $_ * 2 * 562 }) -join ",") + ",1124]" }
}
BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    function conv([int[]]$intar) { "[" + (($intar | ForEach-Object { $_ * 2 * 562 }) -join ",") + ",1124]" }
}

Describe "Read-CustomerCodeAndData_fromNECformated_IRKitGetData" {

    Context "with no error message" {
        It "returns Customer Code and Data from NEC formated IRKit get-data." {
            $validLeaderData = @(16, 8)
            $validCustomerCode = @(1, 1) * 8 + @(1, 3) * 8
            $validDataandRevData = @(1, 3) * 8 + @(1, 1) * 8      
            $inputString = conv ($validLeaderData + $validCustomerCode + $validDataandRevData)

            [PSCustomObject]$return = Read-CustomerCodeAndData_fromNECformated_IRKitGetData $inputString
            @($return.CustomerCode, $return.Data) | Should -Be @("0000000011111111", "11111111")
        }
        It "returns null, when the input has no []." {
            Read-CustomerCodeAndData_fromNECformated_IRKitGetData "test" | Should -Be $null
        }
    }
    
    Context "with error message" {
        $validLeaderData = @(16, 8)
        $inValidLeaderData = @(9, 8)
        $validCustomerCode = @(1, 1) * 8 + @(1, 3) * 8
        $inValidCustomerCode = @(1, 4) * 8 + @(1, 3) * 8
        $validDataandRevData = @(1, 3) * 8 + @(1, 1) * 8   
        $inValidDataandRevData = @(1, 3) * 8 + @(1, 3) * 8   

        $errorTestCases = @(
            @{
                inputData      = "[test]"
                expectedResult = "Input data do not has minimum required length." 
            }
            @{
                inputData      = conv ( $inValidLeaderData + $validCustomerCode + $validDataandRevData )
                expectedResult = "Leader data mismatch (12-20T:On, 6-10T:Off)."
            }
            @{
                inputData      = conv ( $validLeaderData + $inValidCustomerCode + $validDataandRevData )
                expectedResult = "Wrong Customer code. 2T based IRKit data=1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,4,1,3,1,3,1,3,1,3,1,3,1,3,1,3,1,3."
            }
            @{
                inputData      = conv ( $validLeaderData + $validCustomerCode + $inValidDataandRevData )
                expectedResult = "Data(8bit) is not equal to the bit reversed Reverse Data(8bits). 11111111 <=> bit-reversed (11111111)." 
            }
        )
        It "returns error: <expectedResult>, when input is <inputData>." -TestCases $errorTestCases {
            param ($inputData, $expectedResult)

            { Read-CustomerCodeAndData_fromNECformated_IRKitGetData $inputData } | Should -Throw $expectedResult
        }
    }
}
