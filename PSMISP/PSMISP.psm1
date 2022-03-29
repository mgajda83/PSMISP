Get-ChildItem -Path $PSScriptRoot | Unblock-File
Get-ChildItem -Path $PSScriptRoot\*.ps1 | Foreach-Object{ . $_.FullName }

Export-ModuleMember -Cmdlet * -Alias * -Function *

Function Convert-FromUnixDate
{
    Param
    (
        $UnixDate
    )

    Return [TimeZone]::CurrentTimeZone.ToLocalTime(([DateTime]'1/1/1970').AddSeconds($UnixDate))
}
