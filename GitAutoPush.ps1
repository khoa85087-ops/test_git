Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

# 0 = hidden
$hwnd = [Win32]::GetConsoleWindow()
[Win32]::ShowWindow($hwnd, 0)

$repo = "C:\Users\AD\Downloads\note_git_hub"

Write-Host ""
Write-Host "=== Git Auto Push Started ==="
Write-Host "Watching: $repo"
Write-Host ""

while ($true) {

    try {

        Set-Location $repo

        $changes = git status --porcelain

        if ($changes) {

            Write-Host ""
            Write-Host "Detected changes..."

            git add .

            $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

            git commit -m "auto update $time"

            git push

            Write-Host "Pushed at $time"
        }

    }
    catch {

        Write-Host ""
        Write-Host "ERROR:"
        Write-Host $_
    }

    Start-Sleep -Seconds 10
}