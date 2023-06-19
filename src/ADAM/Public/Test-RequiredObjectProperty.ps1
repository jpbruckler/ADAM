function Test-RequiredObjectProperty {
    <#
    .SYNOPSIS
        Tests whether the properties of an object or the headers of a CSV file match a specified set of required properties/headers.
    
    .DESCRIPTION
        The Test-RequiredObjectProperty function checks if the properties of an object or the headers in the specified CSV file match the required properties/headers.
        If the object or CSV file does not contain all of the required properties/headers, a warning is displayed, and the function returns false.
        If all required properties/headers are present, the function returns true.
    
    .PARAMETER InputObject
        The object that needs to be checked for required properties. This parameter accepts pipeline input.
    
    .PARAMETER FilePath
        The path to the CSV file that needs to be checked for required headers.
    
    .PARAMETER RequiredProperties
        An array of property/header names that are required in the object/CSV file. 
    
    .PARAMETER Delimiter
        The delimiter character used in the CSV file. Default is ','.
    
    .EXAMPLE
        Test-RequiredObjectProperty -InputObject $object
    
        Tests if the specified object contains all of the default required properties.
    
    .EXAMPLE
        Test-RequiredObjectProperty -FilePath 'C:\Users\Public\test.csv' -RequiredProperties @('Column1', 'Column2', 'Column3')
    
        Tests if the specified CSV file contains the custom required headers: Column1, Column2, and Column3.
    
    .INPUTS
        System.Management.Automation.PSCustomObject
        System.String
    
    .OUTPUTS
        System.Boolean
    
    .NOTES
        The function assumes that the first line of the CSV file contains the headers.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Object')]
    param (
        [Parameter( Mandatory = $true, 
                    ValueFromPipeline = $true,
                    ParameterSetName = 'Object' )]
        [ValidateNotNullOrEmpty()]
        [PSObject]$InputObject,

        [Parameter( Mandatory = $true, 
                    ParameterSetName = 'File')]
        [ValidateScript({
                if (-Not (Test-Path -Path $_ -PathType Leaf)) {
                    throw "File '$_' not found"
                }
                return $true
            })]
        [string]$FilePath,

        [Parameter( Mandatory = $false,
                    ParameterSetName = 'File')]
        [string] $Delimiter = ',',

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$RequiredProperties
    )
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Object' {
                $objectProperties = $InputObject.PsObject.Properties.Name
            }
            'File' {
                try {
                    $headerLine = Get-Content -Path $FilePath -TotalCount 1 -ErrorAction Stop
                    $objectProperties = $headerLine.Split($Delimiter) | ForEach-Object { $PSItem.Trim('"') }
                }
                catch {
                    throw "Unable to read CSV file: $PSItem"
                }
            }
        }

        $missingProperties = $RequiredProperties | Where-Object { $_ -notin $objectProperties }

        if ($missingProperties) {
            Write-Warning "The following properties are missing: $($missingProperties -join ', ')"
            return $false
        }
        else {
            Write-Verbose "All required properties are present."
            return $true
        }
    }
}
