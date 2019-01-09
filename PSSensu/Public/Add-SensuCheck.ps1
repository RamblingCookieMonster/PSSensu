function Add-SensuCheck {
    [cmdletbinding()]
    param (
        [string]$Command,
        [boolean]$Publish = $true,
        [int]$Interval = 300,
        [string]$Name,
        [string]$Namespace = 'default',
        [string[]]$Subscriptions,
        [int]$TTL = 601,
        [int]$Timeout = 30,
        [string]$BaseUri = $Script:PSSensuConfig.BaseUri,
        [ValidateNotNull()]
        [System.Management.Automation.Credential()]
        [PSCredential]$Credential = $Script:PSSensuConfig.Credential,
        [string]$Token = $Script:PSSensuConfig.Token
    )
    $Uri = Join-Parts -Separator '/' -Parts $BaseUri, 'api/core/v2/namespaces/default/checks', $Name

    $Check = [pscustomobject]@{
        command = $Command
        publish = $Publish
        interval = $Interval
        metadata = @{
            name = $Name
            namespace = $Namespace
        }
        subscriptions = $Subscriptions
        ttl = $ttl
        timeout = $Timeout
    }

    if(-not $Token) {
        $Token = Get-SensuAccessToken -BaseUri $BaseUri -Credential $Credential
    }
    $CheckJson = $Check | ConvertTo-Json
    $o = Invoke-RestMethod -Method Put -Uri $Uri -ContentType application/json -Headers @{Authorization = $Token} -Body $CheckJson
    $o
}