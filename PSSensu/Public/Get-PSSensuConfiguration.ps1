function Get-PSSensuConfiguration {
    <#
    .SYNOPSIS
       Get PSSensu configuration values

    .DESCRIPTION
       Get PSSensu configuration values

    .EXAMPLE
        Get-PSSensuConfiguration

    .PARAMETER Source
        Get PSSensu configuration from the module variable, or config file.  Defaults to variable

    .FUNCTIONALITY
        Sensu
    #>
    param(
        [validateset('Variable','Config')]
        [string]$Source = "Variable"
    )
    if($Source -eq 'Config') {
        $Config = Import-Configuration @Script:ConfigParams
        [pscustomobject]$Config | Select-Object $Script:ConfigSchema.PSObject.Properties.Name
    }
    if($Source -eq 'Variable') {
        $Script:PSSensuConfig
    }
}