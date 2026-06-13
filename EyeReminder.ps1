# Chạy ẩn
if (-not $env:EYE_REMINDER_HIDDEN)
{
    $env:EYE_REMINDER_HIDDEN = "1"

    Start-Process powershell.exe `
        -WindowStyle Hidden `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""

    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

while ($true)
{
    # Đếm sau khi popup trước đã đóng
    Start-Sleep -Seconds 30

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Eye Reminder"
    $form.Size = New-Object System.Drawing.Size(300,120)
    $form.StartPosition = "CenterScreen"
    $form.TopMost = $true

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Look into the distance"
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(70,20)
    $form.Controls.Add($label)

    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 10000   # popup tồn tại 10 giây

    $timer.Add_Tick({
        $timer.Stop()
        $form.Close()
    })

    $timer.Start()

    [void]$form.ShowDialog()

    $timer.Dispose()
    $form.Dispose()
}