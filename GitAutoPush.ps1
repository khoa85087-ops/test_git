$repo = "C:\Users\AD\Downloads\f2z"

while ($true) {

    try {

        Set-Location $repo

        # bỏ delete khỏi stage
        git restore --staged .

        # chỉ add file còn tồn tại
        Get-ChildItem -File -Recurse | ForEach-Object {
            git add $_.FullName
        }

        $changes = git status --porcelain

        if ($changes) {

            $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

            git commit -m "auto backup $time"

            git push
        }

    }
    catch {
    }

    Start-Sleep -Seconds 10
}