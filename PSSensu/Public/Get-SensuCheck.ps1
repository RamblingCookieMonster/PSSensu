function Get-SensuCheck {
    <#
    .SYNOPSIS
       Get Sensu Checks

    .DESCRIPTION
       Get Sensu Checks

    .EXAMPLE
        Get-SensuCheck

        # Get Sensu Checks based BaseUri and Credential or Token from Get-PSSensuConfiguration

    .EXAMPLE
        Set-SensuCheck -Token $Token -BaseUri $BaseUri

        # Get Sensu Checks

    .EXAMPLE
        Set-SensuCheck -Token $Token -BaseUri $BaseUri -Name check-some-thing

        # Get Sensu Check data on the check-some-thing check

    .PARAMETER Name
        If specified, get check with this name

    .PARAMETER BaseUri
        BaseUri to build REST endpoint Uris from

    .PARAMETER Credential
        PSCredential to use for auth, if $Token is not specified

        We default to the value specified by Set-PSSensuConfiguration (Initially, admin:P@ssw0rd!)

    .PARAMETER Token
        Sensu Access Token

        Use Get-SensuAccessToken to request one

        Default:  Token from Get-PSSensuConfiguration

    .PARAMETER Raw
        If specified, return raw output from Invoke-RestMethod

    .FUNCTIONALITY
        Sensu
    #>
    [cmdletbinding()]
    param (
        [string]$Name = $null,
        [string]$BaseUri = $Script:PSSensuConfig.BaseUri,
        [ValidateNotNull()]
        [System.Management.Automation.Credential()]
        [PSCredential]$Credential = $Script:PSSensuConfig.Credential,
        [string]$Token = $Script:PSSensuConfig.Token,
        [switch]$Raw
    )
    if(-not $Token) {
        $Token = Get-SensuAccessToken -BaseUri $BaseUri -Credential $Credential
    }
    $Uri = Join-Parts -Separator '/' -Parts $BaseUri, 'api/core/v2/namespaces/default/checks', $Name
    $o = Invoke-RestMethod -Uri $Uri -ContentType application/json -Headers @{Authorization = $Token}
    if($o.count -gt 0){
        if($Raw){
            $o
        }
        else {
            ConvertFrom-SensuOutput -InputObject $o -PSTypeName Sensu.Check
        }
    }
}