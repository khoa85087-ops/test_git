$repo = "C:\Users\AD\Downloads\f2z"

while ($true) {

    try {

        Set-Location $repo

        # reset delete stage
        git restore --staged .

        # add/update toàn bộ file còn tồn tại
        Get-ChildItem -Recurse -File | ForEach-Object {
            git add -- $_.FullName
        }

        # check có thay đổi không
        $changes = git diff --cached --name-only

        if ($changes) {

            $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

            git commit -m "auto backup $time"

            git push origin main
        }

    }
    catch {
    }

    Start-Sleep -Seconds 5
}