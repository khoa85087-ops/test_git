Start-Process powershell.exe -WindowStyle Hidden -ArgumentList '-ExecutionPolicy Bypass -Command "& {

$repo = "C:\Users\AD\Downloads\note_git_hub"
$logFile = "$repo\sync.log"

while ($true) {

    try {

        Set-Location $repo

        $status = git status --porcelain

        $deletedCount = @($status | Select-String "^ D").Count

        if ($deletedCount -gt 5) {

            $msg = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] SKIP massive delete ($deletedCount)"

            Write-Host $msg

            $msg | Out-File -Append $logFile

            Start-Sleep -Seconds 10

            continue
        }

        if ($status) {

            git pull origin main --rebase

            git add .

            # tránh commit rỗng
            if (-not (git diff --cached --name-only)) {
                Start-Sleep -Seconds 10
                continue
            }

            $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

            git commit -m "auto update $time"

            git push origin main

            $msg = "[$time] Sync complete"

            Write-Host $msg

            $msg | Out-File -Append $logFile
        }

    }
    catch {

        $msg = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] ERROR: $($_.Exception.Message)"

        Write-Host $msg

        $msg | Out-File -Append $logFile
    }

    Start-Sleep -Seconds 10
}
