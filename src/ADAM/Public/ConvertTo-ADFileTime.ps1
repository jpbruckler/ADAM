function ConvertTo-ADFileTime {
    <#
    .SYNOPSIS
        Converts a DateTime object to an Active Directory FileTime value.

    .DESCRIPTION
        The ConvertTo-ADFileTime function takes a DateTime object as input,
        and converts it to an Active Directory FileTime value, which represents
        the number of 100-nanosecond intervals since January 1, 1601 (UTC).

    .PARAMETER DateTime
        The DateTime object to convert to an Active Directory FileTime value.

    .EXAMPLE
        $dateTime = Get-Date
        $ADFileTime = ConvertTo-ADFileTime -DateTime $dateTime
        Write-Host $ADFileTime

        Converts the current DateTime to an Active Directory FileTime value and displays it.

    .EXAMPLE
        $dateTime = Get-Date
        $ADFileTime = $dateTime | ConvertTo-ADFileTime
        Write-Host $ADFileTime

        Demonstrates how to use pipeline input with ConvertTo-ADFileTime.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [DateTime]$DateTime
    )

    process {
        $ADFileTime = $DateTime.ToFileTimeUtc()
        return $ADFileTime
    }
}
