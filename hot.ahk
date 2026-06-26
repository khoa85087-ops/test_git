#Requires AutoHotkey v2.0
#SingleInstance Force

A_MaxHotkeysPerInterval := 999999

#`::Send "#+s"

; Alt + C = đóng app
!c::Send("!{F4}")

!q::
{
    A_Clipboard := "[Nhiệm vụ]:`n[điều kiện quan trọng]:`n[kiểu output]: "
    Send("^v")
}



; Alt + F = Alt + Tab
!f::Send("!{Tab}")

; WASD = Arrow Keys
!w::Send("{Up}")
!s::Send("{Down}")
!a::Send("{Left}")
!d::Send("{Right}")



*<+<#f23::
{
    Send("{Blind}{LShift Up}{LWin Up}")
    Send("{Ctrl Down}")
    KeyWait("F23")
    Send("{Ctrl Up}")
}





!v::SendInput("^{``}")


!p::SendText('git commit --allow-empty -m "NOTE: " && git push')

^Enter::
{
    Send("^f")
}
`::Send("#+s")





#Requires AutoHotkey v2.0

!Space::
{
    SendInput("{Blind}!{Space}")

    if WinWait("ahk_exe lookapp.exe", , 0.3)
        WinMaximize("ahk_exe lookapp.exe")
}