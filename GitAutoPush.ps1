# ===== GIT AUTO PUSH - WINDOW ẨN =====
# Chạy lần đầu: powershell -ExecutionPolicy Bypass -File "đường_dẫn\GitAutoPush.ps1"

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Window {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

# Ẩn window (0 = ẩn, 1 = hiện)
$consolePtr = [Window]::GetConsoleWindow()
[Window]::ShowWindow($consolePtr, 0) | Out-Null

# ===== CẤU HÌNH =====
$repo = "C:\Users\AD\Downloads\note_git_hub"
$checkInterval = 10  # Giây
$logFile = "$repo\git_auto_push.log"

# ===== HÀM GHI LOG =====
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Add-Content -Path $logFile -Value $logMessage -Encoding UTF8
}

# ===== KHỞI TẠO LOG =====
Write-Log "============================================"
Write-Log "Git Auto Push Started"
Write-Log "Repository: $repo"
Write-Log "============================================"

# ===== VÒNG LẶP CHÍNH =====
while ($true) {
    try {
        Set-Location $repo
        
        # Kiểm tra thay đổi
        $changes = git status --porcelain 2>$null
        
        if ($changes) {
            Write-Log "Detected changes"
            
            # Add files
            git add . 2>&1 | Out-Null
            
            # Commit
            $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $commitMsg = "auto update $time"
            git commit -m $commitMsg 2>&1 | Out-Null
            
            # Push
            $pushResult = git push 2>&1
            Write-Log "Pushed: $commitMsg"
            Write-Log "Push result: $pushResult"
        }
    }
    catch {
        Write-Log "ERROR: $_"
    }
    
    # Chờ trước khi kiểm tra lại
    Start-Sleep -Seconds $checkInterval
}
