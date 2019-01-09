function Get-SensuAccessToken {
    <#
    .SYNOPSIS
       Get a Sensu access token

    .DESCRIPTION
       Get a Sensu access token, and update the $PSSensuConfig.Token used by most commands as a default value for -Token

    .EXAMPLE
        Set-SensuAccessToken

        # Use BaseUri and Credential values from Get-PSSensuConfig to generate a Sensu access token

    .EXAMPLE
        Set-SensuAccessToken -BaseUri $Uri -Credential $Credential

        # Generate a Sensu access token

    .EXAMPLE
        Set-SensuAccessToken -IfCheckFails

        # Generate a Sensu access token, _only_ if Get-PSSensuConfiguration token is not valid

    .EXAMPLE
        Set-SensuAccessToken -IfCheckFails -Token $Token

        # Generate a Sensu access token, _only_ if $Token is not valid


    .PARAMETER UpdateConfig
        Whether to update the configuration file on top of the live module values

        Defaults to $True

    .PARAMETER BaseUri
        BaseUri to build REST endpoint Uris from

    .PARAMETER Credential
        PSCredential to use for auth

        We default to the value specified by Set-PSSensuConfiguration (Initially, admin:P@ssw0rd!)

    .PARAMETER Token
        If IfCheckFails is specified, check validity of this token and only request a new token if this token is not valid

        Default:  Token from Get-PSSensuConfiguration

    .PARAMETER IfCheckFails
        If specified, only request a token if a specified -Token is not valid

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
        [bool]$UpdateConfig = $True,
        [switch]$IfCheckFails
    )

    # If specified, run an arbitrary check.  Ideally something like the 'health' endpoint, but I can't get that working
    if($IfCheckFails -and $PSBoundParameters.ContainsKey('Token')){
        $Uri = Join-Parts -Separator '/' -Parts $BaseUri, 'api/core/v2/users'
        try {
            $o = $null
            $o = Invoke-RestMethod -Uri $Uri -ContentType application/json -Headers @{Authorization = $Token} -ErrorAction SilentlyContinue
            if($o.username.where({$_}).count -gt 0){
                Write-Verbose "Token was valid, no action taken"
                return
            }
        }
        catch {
            if($_.Exception -like '*{"Code":5*' -or $_.Exception -like '*(401)*'){
                Write-Verbose "Token was invalid or expired, generating a new token"
            }
            else {
                Write-Verbose "Token validity could not be determined due to an error"
                Write-Error $_
            }
        }

    }
    $Uri = Join-Parts -Separator '/' -Parts $BaseUri, 'auth'
    $p = $Credential.GetNetworkCredential().Password
    $u = $Credential.UserName
    $Base64Cred = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $u,$p)))
    $o = $null
    $o = Invoke-RestMethod -Uri $Uri -ContentType application/json -Headers @{Authorization = "Basic $Base64Cred"}
    if($UpdateConfig){
        Set-PSSensuConfiguration -Token $o.access_token
    }
    $o.access_token
}