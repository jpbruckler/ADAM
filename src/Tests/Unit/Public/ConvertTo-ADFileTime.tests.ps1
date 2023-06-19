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
    Describe 'ConvertTo-ADFileTime Function Tests' -Tag Unit {

        Context 'Success' {

            It 'should return the expected results' {
                $DateTime   = '2023-06-18T22:56:14.5597685-04:00'
                $ADFileTime = ConvertTo-ADFileTime -DateTime $DateTime
                $ADFileTime | Should -BeExactly 133316169745597685
            } #it

        }
    }
} #inModule
