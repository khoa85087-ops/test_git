#Requires AutoHotkey v2.0
A_MaxHotkeysPerInterval := 999999
#Requires AutoHotkey v2.0

#`::Send "#+s"

; Alt + C = đóng app
!c::Send("!{F4}")





























 
   
   
   
   
   
   
   
   
   
   
   
   
   
!q::
{
    A_Clipboard := "[Nhiệm vụ]:`n[điều kiện quan trọng]:`n[kiểu output]: "
    Send("^v")
}




!f::Send("!{Tab}")


!w::SendInput("{Up}")
!s::SendInput("{Down}")
!a::SendInput("{Left}")
!d::SendInput("{Right}")

; Copilot -> Ctrl (chuẩn giữ/nhả)
^+!r:: Reload        ; Ctrl+Shift+Alt+R to reload the script

; rebind copilot to rCtrl
*<+<#f23:: {
    Send("{Blind}{LShift Up}{LWin Up}{RControl Down}")
    KeyWait("F23")
    Send("{RControl up}")
}










































#Requires AutoHotkey v2.0
#Requires AutoHotkey v2.0

global last := ""

; ===== Danh sách app =====
; viết thường hết để compare nhanh + ổn định

englishApps := Map(
    "notepad.exe", 1,
    "pcw.exe", 1,
    "pds.exe", 1,
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

; 500ms vẫn rất nhẹ
SetTimer(CheckApp, 3000)

CheckApp()
{
    global last
    global englishApps
    global vietnameseApps

    try proc := StrLower(WinGetProcessName("A"))
    catch
        return

    ; ===== Early Exit =====
    ; app không đổi -> thoát luôn
    if (proc = last)
        return

    last := proc

    hwnd := WinExist("A")

    ; ===== English =====
    if englishApps.Has(proc)
    {
        PostMessage(0x50, 0, 0x0409, , hwnd)
    }

    ; ===== Vietnamese =====
    else if vietnameseApps.Has(proc)
    {
        PostMessage(0x50, 0, 0x042A, , hwnd)
    }
}

!r::
{
      KeyWait("RAlt")
    Send("!{Space}")
}


!v::Send("^{``}")

#Requires AutoHotkey v2.0

^Enter::Send("^f")