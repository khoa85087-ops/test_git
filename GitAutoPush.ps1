$repo = "C:\Users\AD\Downloads\f2z"

while ($true) {

    cd $repo

    git add -A

    $changes = git status --porcelain

    if ($changes) {

        $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        git commit -m "auto sync $time"

        git push
    }

    Start-Sleep 5
}