[pscustomobject]@{
    BaseUri = @{
        Type = [string]
        Default = $null
    }
    Credential = @{
        Type = [PSCredential]
        Default = New-Object System.Management.Automation.PSCredential('admin',$(ConvertTo-SecureString 'P@ssw0rd!' -asPlainText -Force))
    }
    Token = @{
       Type = [string]
       Default = $null
    }
}