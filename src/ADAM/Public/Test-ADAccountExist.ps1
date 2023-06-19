function Test-ADAccountExist {
    <#
    .SYNOPSIS
        Tests for the existence of an Active Directory account.
    
    .DESCRIPTION
        The Test-ADAccountExists function checks whether an Active Directory account exists by querying with the specified identity using Get-ADUser.
    
    .PARAMETER Identity
        The identifier for the Active Directory account. This can be one of the following property values:
        - Distinguished Name
        - GUID (objectGUID)
        - Security Identifier (objectSid)
        - Security Account Manager (SAM) Account Name (sAMAccountName)
    
    .EXAMPLE
        Test-ADAccountExists -Identity 'jdoe'
    
        Tests if an Active Directory account exists with the SAM Account Name 'jdoe'.
    
    .EXAMPLE
        Test-ADAccountExists -Identity 'CN=John Doe,OU=Users,DC=contoso,DC=com'
    
        Tests if an Active Directory account exists with the Distinguished Name 'CN=John Doe,OU=Users,DC=contoso,DC=com'.
    
    .INPUTS
        System.String
    
    .OUTPUTS
        System.Boolean
    
    .NOTES
        The function requires the Active Directory PowerShell module.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Identity')]
    param (
        [Parameter( Mandatory = $true,
                    ValueFromPipeline = $true,
                    ParameterSetName = 'Identity')]
        [string]$Identity,


        [Parameter( Mandatory = $true,
                    ParameterSetName = 'Filter')]
        [string]$Filter
    )
    process {
        try {
            $Splat = @{
                ErrorAction = 'Stop'
            }

            if ($PSCmdlet.ParameterSetName -eq 'Identity') {
                $Splat.Identity = $Identity
            }
            else {
                $Splat.Filter = $Filter
            }

            $user = Get-ADUser @Splat
            if ($user -is [Microsoft.ActiveDirectory.Management.ADUser]) {
                return $true
            }
            else {
                return $false
            }
        }
        catch {
            if ($_.Exception -is [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]) {
                return $false
            }
            else {
                Write-Error -Message "An error occurred while querying Active Directory: $($_.Exception.Message)"
                return $false
            }
        }
    }
}
