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



; Rebind Copilot key -> Right Ctrl
*<+<#f23::
{
    Send("{Blind}{LShift Up}{LWin Up}{RControl Down}")
    KeyWait("F23")
    Send("{RControl Up}")
}

; =========================
; Auto switch input method
; =========================

global last := ""

englishApps := Map(
    "notepad.exe", 1,
    "pcw.exe", 1,
    "FluentSearch.exe", 1,
	"lookapp.exe", 1,
	"Listary.exe", 1,
    "matlab.exe", 1,
    "zy_pass.exe", 1,
    "xz pass.exe", 1
)

vietnameseApps := Map(
    "brave.exe", 1,
    "zalo.exe", 1,
    "onenote.exe", 1,
    "winword.exe", 1,
    "windowsterminal.exe", 1,
    "opera.exe", 1
)

SetTimer(CheckApp, 500)

CheckApp()
{
    global last
    global englishApps
    global vietnameseApps

    try proc := WinGetProcessName("A")
    catch
        return

    if (proc = last)
        return

    last := proc

    hwnd := WinExist("A")

    if englishApps.Has(proc)
    {
        ; English US
        PostMessage(0x50, 0, 0x0409, , hwnd)
    }
    else if vietnameseApps.Has(proc)
    {
        ; Vietnamese
        PostMessage(0x50, 0, 0x042A, , hwnd)
    }
}



!v::SendInput("^{``}")


!g::SendText('git commit --allow-empty -m "NOTE: " && git push')

^Enter::
{
    Send("^f")
}





