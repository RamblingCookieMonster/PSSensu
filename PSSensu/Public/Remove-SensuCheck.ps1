function Remove-SensuCheck {
    [cmdletbinding()]
    param (
        [string]$Name,
        $BaseUri = $Script:PSSensuConfig.BaseUri,
        $Credential = $Script:PSSensuConfig.Credential,
        $Token = $Script:PSSensuConfig.Token
    )
    $Uri = Join-Parts -Separator '/' -Parts $BaseUri, 'api/core/v2/namespaces/default/checks', $Name
    if(-not $Token) {
        $Token = Get-SensuAccessToken -BaseUri $BaseUri -Credential $Credential
    }
    $o = Invoke-RestMethod -Method Delete -Uri $Uri -ContentType application/json -Headers @{Authorization = $Token}
    $o
}