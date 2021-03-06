@{
# Script module or binary module file associated with this manifest.
RootModule = 'PSSensu.psm1'

# Version number of this module.
ModuleVersion = '0.0.1'

# ID used to uniquely identify this module
GUID = 'fac3ab99-ebce-4d45-bc6d-739c9ae9ca10'

# Author of this module
Author = 'Warren Frame'

# Copyright statement for this module
Copyright = '(c) 2019 Warren F. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Simple PowerShell module for working with the Sensu Go API'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '3.0'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @(@{ModuleName=”Configuration”; RequiredVersion="1.3.1"})

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = 'PSSensu.Format.ps1xml'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = '*'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('Sensu', 'Monitoring')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/RamblingCookieMonster/PSSensu/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/RamblingCookieMonster/PSSensu'

        # ReleaseNotes of this module
        ReleaseNotes = 'Initial this-will-have-breaking-changes-without-notice-until-version-0.1.0 release : )'

    } # End of PSData hashtable

} # End of PrivateData hashtable

}

