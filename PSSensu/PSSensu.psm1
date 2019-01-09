#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
    $ModuleRoot = $PSScriptRoot

#Dot source the files
Foreach($import in @($Public + $Private)) {
    try {
        . $import.fullname
    }
    catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# No xplat credential serialization
$SkipCred = $False
if($IsLinux -or $IsOSX -or $IsMacOS) {
    $SkipCred = $True
}

$ConfigParams = @{
    Name = 'PSSensu'
    Author = 'Warren Frame'
}

# Build up config object with expected properties
# Set/Initialize-PSSensuConfiguration needs these properties to exist in order to set them
$ConfigSchema = . "$PSScriptRoot\PSSensu.ConfigSchema.ps1"
$PSSensuConfig = [pscustomobject]@{}
Foreach($Property in $ConfigSchema.PSObject.Properties.Name) {
    Add-Member -MemberType NoteProperty -InputObject $PSSensuConfig -Name $Property -Value $null -Force
}

try {
    $ConfigPath = Join-Path $(Get-StoragePath @ConfigParams) Configuration.psd1
    if(-not (Test-Path $ConfigPath -ErrorAction SilentlyContinue)){
        # Generate config file if it's a first run
        $PSSensuConfig = Initialize-PSSensuConfiguration -Passthru -ConfigSchema $ConfigSchema -All
    }
    $Config = Import-Configuration @ConfigParams -ErrorAction Stop
    $PSSensuConfig = [pscustomobject]$Config | Select-Object $ConfigSchema.PSObject.Properties.Name
}
catch {
    Write-Warning "Could not load PSSensu Config"
    Write-Warning $_
}

Export-ModuleMember -Function $Public.Basename