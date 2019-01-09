function Remove-SensuEvents {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)]
        $Name,
        [parameter(Mandatory = $true)]
        $Hostname,
        $BaseUri = $Script:PSSensuConfig.BaseUri,
        [ValidateNotNull()]
        [System.Management.Automation.Credential()]
        [PSCredential]$Credential = $Script:PSSensuConfig.Credential,
        $Token = $Script:PSSensuConfig.Token
    )
    if(-not $Token) {
        $Token = Get-SensuAccessToken -BaseUri $BaseUri -Credential $Credential
    }
    $Uri = Join-Parts -Separator '/' -Parts $BaseUri, 'api/core/v2/namespaces/default/events', $Hostname, $Name
    $o = Invoke-RestMethod -Method Delete -Uri $Uri -ContentType application/json -Headers @{Authorization = $Token}
    $o
}