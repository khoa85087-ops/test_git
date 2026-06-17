$repo = "C:\Users\AD\Downloads\f2z"

while ($true)
{
    try
    {
        Set-Location $repo

        $changes = git status --porcelain

        if (-not $changes)
        {
            Start-Sleep -Seconds 18
			
            continue
        }

        $deletedCount = @($changes | Select-String "^ D").Count

        if ($deletedCount -gt 5)
        {
            git restore .
            git clean -fd

            "$(Get-Date) BLOCKED - Deleted $deletedCount files" |
            Out-File "$repo\autogit.log" -Append

            Start-Sleep -Seconds 1
            continue
        }

        git add -A

        $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        git commit -m "auto update $time"

        git push origin main
    }
    catch
    {
        $_ |
        Out-File "$repo\autogit_error.log" -Append
    }

    Start-Sleep -Seconds 18
	
}