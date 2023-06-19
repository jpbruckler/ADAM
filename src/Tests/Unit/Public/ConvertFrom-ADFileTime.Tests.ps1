#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'ADAM'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'ADAM' {
    Describe 'ConvertFrom-ADFileTime Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll

        Context 'Success' {

            It 'should return the expected results' {
                $pwdLastSet = 133251702158073284
                Get-Date (ConvertFrom-ADFileTime -ADFileTime $pwdLastSet) -Format o | Should -BeExactly '2023-04-05T08:10:15.8073284-04:00'
            } #it

        }
    }
} #inModule
