Function ConvertFrom-SensuOutput {
    [cmdletbinding()]
    param(
        $InputObject,
        $PSTypeName
    )

    foreach($Record in $InputObject) {
        switch($PSTypeName){
            'Sensu.Check' {
                [pscustomobject]@{
                    PSTypeName = $PSTypeName
                    CheckName = $Record.metadata.name
                    Command = $Record.command
                    Interval = $Record.Interval
                    Publish = $Record.Publish
                    Raw = $Record
                }
            }
            'Sensu.Entity' {
                [pscustomobject]@{
                    PSTypeName = $PSTypeName
                    Hostname = $Record.metadata.name
                    EntityClass = $Record.Entity_Class
                    OS = $Record.system.OS
                    Platform = $Record.system.platform
                    LastSeen = ConvertFrom-UnixDate $Record.last_seen
                    Raw = $Record
                }
            }
            'Sensu.Event' {
                [pscustomobject]@{
                    PSTypeName = $PSTypeName
                    Hostname = $Record.entity.system.hostname
                    Checkname = $Record.check.metadata.name
                    State = $Record.check.state
                    Output = "$($Record.check.output)".trim()
                    Executed = ConvertFrom-UnixDate $Record.check.Executed
                    Check = $Record.check
                    Entity = $Record.entity
                    Metadata = $Record.metadata
                    Raw = $Record
                }
            }
        }
    }
}