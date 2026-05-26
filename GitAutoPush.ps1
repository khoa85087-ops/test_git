Start-Process powershell.exe -WindowStyle Hidden -ArgumentList '-ExecutionPolicy Bypass -Command "& {

$repo = \"C:\Users\AD\Downloads\note_git_hub\"

while ($true) {

    try {

        Set-Location $repo

        $changes = git status --porcelain

        if ($changes) {

            git add *

            $time = Get-Date -Format \"yyyy-MM-dd HH:mm:ss\"

            git commit -m \"auto update $time\"

            git push
        }

    }
    catch {
    }

    Start-Sleep -Seconds 10
}

}"'
