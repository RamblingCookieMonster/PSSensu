# PSSensu

This is a simple wrapper for the [Sensu Go API](https://docs.sensu.io/sensu-go/latest/api/overview/)

This is still a POC/WIP.  Expect unannounced breaking changes until version 0.1.0.  Use at your own risk : )

Issues and pull requests would be welcome!

## Instructions

* Have PSSensu accessible somewhere

```powershell
# One time setup
    # Download the repository
    # Unblock the zip
    # Extract the PSSensu folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)
# Or, with PowerShell 5 or later or PowerShellGet:
    Install-Module PSSensu

# Import the module.
    Import-Module PSSensu    #Alternatively, Import-Module \\Path\To\PSSensu

# Get commands in the module
    Get-Command -Module PSSensu

# Get help
    Get-Help Get-SensuAccessToken -Full
    Get-Help Get-SensuEvents -Full

# Set up a default baseuri and credential, get a token
    Set-PSSensuConfiguration -BaseUri https://sensu1.fqdn:8080 -Credential $Credential
    Get-SensuAccessToken

# Get all the entities!
    Get-SensuEntities

# Get all the properties - not all are displayed by default
    Get-SensuEntities | Select-Object -Property *

# Get events for dc01
    Get-SensuEvent -Name dc01
```
