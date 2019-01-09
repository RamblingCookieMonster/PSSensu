function Get-SensuEvents {
    <#
    .SYNOPSIS
       Get Sensu Events

    .DESCRIPTION
       Get Sensu Events

    .EXAMPLE
        Get-SensuEvents

        # Get Sensu Events based BaseUri and Credential or Token from Get-PSSensuConfiguration

    .EXAMPLE
        Set-SensuEvents -Token $Token -BaseUri $BaseUri

        # Get Sensu Events

    .EXAMPLE
        Set-SensuEvents -Token $Token -BaseUri $BaseUri -Name DC01

        # Get Sensu Events for DC01

    .PARAMETER Name
        If specified, get Events for this specific Entity

        Use Get-SensuEntities to list valid entity names

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
        [string]$Token = $Script:PSSensuConfig.Token
    )
    if(-not $Token) {
        $Token = Get-SensuAccessToken -BaseUri $BaseUri -Credential $Credential
    }
    $Uri = Join-Parts -Separator '/' -Parts $BaseUri, 'api/core/v2/namespaces/default/events', $Name
    $o = Invoke-RestMethod -Uri $Uri -ContentType application/json -Headers @{Authorization = $Token}
    if($o.count -gt 0){
        if($Raw){
            $o
        }
        else {
            ConvertFrom-SensuOutput -InputObject $o -PSTypeName Sensu.Event
        }
    }
}