$repo = "C:\Users\AD\Downloads\f2z"

while ($true) {

    try {

        Set-Location $repo

        $changes = git status --porcelain

        if ($changes) {

            git add .

            $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

            git commit -m "auto update $time"

            git push
        }

    }
    catch {
        $_
    }

    Start-Sleep -Seconds 10
}
