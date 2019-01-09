function Initialize-PSSensuConfiguration {
    <#
    .SYNOPSIS
       Initializes PSSensu configuration values

    .DESCRIPTION
       Initializes PSSensu configuration values

       In cases where we've updated configuration schema, this will bring new values in line with the defaults

       Default types and values are stored in PSSensu.ConfigSchema.ps1 in the module root

    .PARAMETER All
        Initialize all values to their defaults as set in PSSensu.ConfigSchema.ps1

    .PARAMETER BaseUri
        Whether to initialize BaseUri back to 'http://127.0.0.1:7474'

    .PARAMETER Credential
        Whether to initialize Credential back to username: Sensu password: Sensu

    .PARAMETER CheckExisting
        If specified, check existing configuration types and reset anything that doesn't make sense

    .PARAMETER Passthru
        If specified, return configuration

    .PARAMETER UpdateConfig
        Whether to update the configuration file on top of the live module values

        Defaults to $True

    .FUNCTIONALITY
        Sensu
    #>
    [cmdletbinding()]
    param(
        [switch]$All,
        [switch]$Credential,
        [switch]$BaseUri,
        [bool]$CheckExisting = $True,
        [object]$ConfigSchema = $Script:ConfigSchema,
        [switch]$Passthru,
        [bool]$UpdateConfig = $True
    )
    $ConfigKeys = $ConfigSchema.PSObject.Properties.Name
    Write-Host "Exporting config:`n$($PSSensuConfig | Out-String) with params $($Script:ConfigParams | Out-String)"

    if($CheckExisting) {
        foreach($Property in $ConfigKeys) {
            if($Script:PSSensuConfig.$Property -isnot $ConfigSchema.$Property.Type) {
                $Script:PSSensuConfig.$Property = $ConfigSchema.$Property.Default
            }
        }
    }
    if($All) {
        foreach($Key in $ConfigKeys) {
            $Script:PSSensuConfig.$Key = $ConfigSchema.$Key.Default
        }
    }
    else {
        foreach($Key in $PSBoundParameters.Keys) {
            if($ConfigKeys -contains $Key) {
                $Script:PSSensuConfig.$Key = $ConfigSchema.$Key.Default
            }
        }
    }

    if($UpdateConfig) {
        if($SkipCred) {
            $Script:PSSensuConfig |
                Select-Object -Property * -ExcludeProperty Credential |
                Export-Configuration @Script:ConfigParams
        }
        else {
            $Script:PSSensuConfig | Export-Configuration @Script:ConfigParams
        }
    }
    if($Passthru) {
        [pscustomobject]$Script:PSSensuConfig | Select-Object $ConfigSchema.PSObject.Properties.Name
    }
}