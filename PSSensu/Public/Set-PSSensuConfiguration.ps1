function Set-PSSensuConfiguration {
    <#
    .SYNOPSIS
       Set PSSensu configuration values

    .DESCRIPTION
       Set PSSensu configuration values

    .EXAMPLE
        Set-PSSensuConfiguration -Credential $Credential

        # Specify a default credential to use for PSSensu commands

    .PARAMETER UpdateConfig
        Whether to update the configuration file on top of the live module values

        Defaults to $True

    .PARAMETER BaseUri
        BaseUri to build REST endpoint Uris from

    .PARAMETER Credential
        PSCredential to use when generating an access token

        We default to the value specified by Set-PSSensuConfiguration (Initially, admin:P@ssw0rd!)

    .PARAMETER Token
        Token to use when hitting the API

    .FUNCTIONALITY
        Sensu
    #>
    [cmdletbinding()]
    param(
        [ValidateNotNull()]
        [System.Management.Automation.Credential()]
        [PSCredential]$Credential,
        [string]$BaseUri,
        [string]$Token,

        [bool]$UpdateConfig = $True
    )
    Switch ($PSBoundParameters.Keys)
    {
        'Credential' { $Script:PSSensuConfig.Credential = $Credential }
        'BaseUri' { $Script:PSSensuConfig.BaseUri = $BaseUri }
        'Token' { $Script:PSSensuConfig.Token = $Token }
    }

    if($UpdateConfig)
    {
        if($SkipCred) {
            $Script:PSSensuConfig |
                Select-Object -Property * -ExcludeProperty Credential |
                Export-Configuration @Script:ConfigParams
        }
        else {
            $Script:PSSensuConfig | Export-Configuration @Script:ConfigParams
        }
    }
}
