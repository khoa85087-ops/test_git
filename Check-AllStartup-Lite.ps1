[CmdletBinding()]
param(
    [switch]$ExportCsv,
    [string]$CsvPath = "$env:USERPROFILE\Desktop\StartupInventory_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
)

$results = [System.Collections.Generic.List[object]]::new()

function Add-Result {
    param($Category, $Name, $Command, $Location, $Extra = "")
    $results.Add([PSCustomObject]@{
        Category = $Category
        Name     = $Name
        Command  = $Command
        Location = $Location
        Extra    = $Extra
    })
}

$runKeys = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunServices",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunServices",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run"
)
foreach ($key in $runKeys) {
    if (Test-Path $key) {
        $props = Get-ItemProperty -Path $key -ErrorAction SilentlyContinue
        if ($props) {
            $props.PSObject.Properties |
                Where-Object { $_.Name -notmatch '^PS(Path|ParentPath|ChildName|Provider)$' } |
                ForEach-Object { Add-Result "Registry Run" $_.Name $_.Value $key }
        }
    }
}

@(
    [Environment]::GetFolderPath("Startup"),
    [Environment]::GetFolderPath("CommonStartup")
) | ForEach-Object {
    if (Test-Path $_) {
        Get-ChildItem -Path $_ -File -ErrorAction SilentlyContinue | ForEach-Object {
            Add-Result "Startup Folder" $_.Name $_.FullName $_.DirectoryName
        }
    }
}

Get-ScheduledTask -ErrorAction SilentlyContinue |
    Where-Object { $_.State -ne 'Disabled' } |
    ForEach-Object {
        $cmd = ($_.Actions | ForEach-Object { "$($_.Execute) $($_.Arguments)" }) -join "; "
        Add-Result "Scheduled Task" $_.TaskName $cmd $_.TaskPath $_.State
    }

Get-CimInstance Win32_Service -ErrorAction SilentlyContinue |
    Where-Object { $_.StartMode -eq 'Auto' } |
    ForEach-Object { Add-Result "Service" $_.DisplayName $_.PathName $_.Name $_.State }

$winlogonPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
if (Test-Path $winlogonPath) {
    $wl = Get-ItemProperty -Path $winlogonPath -ErrorAction SilentlyContinue
    if ($wl.Shell)    { Add-Result "Winlogon" "Shell" $wl.Shell $winlogonPath }
    if ($wl.Userinit) { Add-Result "Winlogon" "Userinit" $wl.Userinit $winlogonPath }
}

$appInitPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows"
if (Test-Path $appInitPath) {
    $ai = Get-ItemProperty -Path $appInitPath -ErrorAction SilentlyContinue
    if ($ai.AppInit_DLLs) { Add-Result "AppInit_DLLs" "AppInit_DLLs" $ai.AppInit_DLLs $appInitPath }
}

$ifeoPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"
if (Test-Path $ifeoPath) {
    Get-ChildItem $ifeoPath -ErrorAction SilentlyContinue | ForEach-Object {
        $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
        if ($props.Debugger) { Add-Result "IFEO Debugger" $_.PSChildName $props.Debugger $_.PSPath }
    }
}

$activeSetupPath = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components"
if (Test-Path $activeSetupPath) {
    Get-ChildItem $activeSetupPath -ErrorAction SilentlyContinue | ForEach-Object {
        $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
        if ($props.StubPath) { Add-Result "Active Setup" $props.'(default)' $props.StubPath $_.PSPath }
    }
}

@(
    "$env:WINDIR\System32\GroupPolicy\Machine\Scripts\Startup",
    "$env:WINDIR\System32\GroupPolicy\User\Scripts\Logon"
) | ForEach-Object {
    if (Test-Path $_) {
        Get-ChildItem -Path $_ -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            Add-Result "GPO Script" $_.Name $_.FullName $_.DirectoryName
        }
    }
}

Get-CimInstance -Namespace root\subscription -ClassName CommandLineEventConsumer -ErrorAction SilentlyContinue |
    ForEach-Object { Add-Result "WMI Subscription" $_.Name $_.CommandLineTemplate "root\subscription" }

$explorerLoad = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows"
if (Test-Path $explorerLoad) {
    $el = Get-ItemProperty -Path $explorerLoad -ErrorAction SilentlyContinue
    if ($el.Load) { Add-Result "Explorer Load" "Load" $el.Load $explorerLoad }
}

$ssodl = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad"
if (Test-Path $ssodl) {
    (Get-ItemProperty -Path $ssodl -ErrorAction SilentlyContinue).PSObject.Properties |
        Where-Object { $_.Name -notmatch '^PS(Path|ParentPath|ChildName|Provider)$' } |
        ForEach-Object { Add-Result "ShellServiceObjectDelayLoad" $_.Name $_.Value $ssodl }
}

@(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
) | ForEach-Object {
    $p = $_
    if (Test-Path $p) {
        (Get-ItemProperty -Path $p -ErrorAction SilentlyContinue).PSObject.Properties |
            Where-Object { $_.Name -notmatch '^PS(Path|ParentPath|ChildName|Provider)$' } |
            ForEach-Object {
                $state = if ($_.Value -and $_.Value[0] -eq 2) { "Disabled" } else { "Enabled" }
                Add-Result "StartupApproved" $_.Name $state $p
            }
    }
}

$results | Sort-Object Category, Name | Format-Table -AutoSize -Wrap

if ($ExportCsv) {
    $results | Sort-Object Category, Name | Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8
    Write-Host $CsvPath
}
