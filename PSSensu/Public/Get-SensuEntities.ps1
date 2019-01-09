function Get-SensuEntities {
    <#
    .SYNOPSIS
       Get Sensu Entities

    .DESCRIPTION
       Get Sensu Entities

    .EXAMPLE
        Get-SensuEntities

        # Get Sensu Entities based BaseUri and Credential or Token from Get-PSSensuConfiguration

    .EXAMPLE
        Set-SensuEntities -Token $Token -BaseUri $BaseUri

        # Get Sensu Entities

    .EXAMPLE
        Set-SensuEntities -Token $Token -BaseUri $BaseUri -Name DC01

        # Get Sensu entity details on DC01

    .PARAMETER Name
        If specified, get entity with this name

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
        [string]$BaseUri = $Script:PSSensuConfig.BaseUri,
        [ValidateNotNull()]
        [System.Management.Automation.Credential()]
        [PSCredential]$Credential = $Script:PSSensuConfig.Credential,
        [string]$Token = $Script:PSSensuConfig.Token,
        [string]$Name = $null
    )
    if(-not $Token) {
        $Token = Get-SensuAccessToken -BaseUri $BaseUri -Credential $Credential
    }
    $Uri = Join-Parts -Separator '/' -Parts $BaseUri, 'api/core/v2/namespaces/default/entities', $Name
    $o = Invoke-RestMethod -Uri $Uri -ContentType application/json -Headers @{Authorization = $Token}
    if($o.count -gt 0){
        if($Raw){
            $o
        }
        else {
            ConvertFrom-SensuOutput -InputObject $o -PSTypeName Sensu.Entity
        }
    }
}