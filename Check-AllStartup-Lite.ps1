Get-CimInstance Win32_StartupCommand |
Select-Object Name, Command, Location

Get-ScheduledTask |
Where-Object State -ne Disabled |
Select-Object TaskName, TaskPath

Get-CimInstance Win32_Service |
Where-Object StartMode -eq "Auto" |
Select-Object DisplayName, Name