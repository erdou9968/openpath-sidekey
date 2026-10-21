#Requires AutoHotkey v2.0
#SingleInstance Force
; 选中路径一键打开（普通版）
; 选中一段文件路径（或文件名）后按鼠标后退键(XButton1)：资源管理器打开（文件夹打开；文件则打开所在文件夹并选中它）
; 路径有小错（破折号、末尾标点、换行截断、大小写）→ 先逐级纠正；纠正不了 → 交给 Everything 搜索
; 只是文件名、没盘符 → 直接 Everything 搜索
; 没选中路径时后退键照常是“后退”。终端里不启用。

; 开机自启：每次运行都刷新开机启动快捷方式（带 /silent，开机时不弹窗）
lnk := A_Startup "\选中路径一键打开.lnk"
FileCreateShortcut(A_ScriptFullPath, lnk, A_ScriptDir, "/silent")

; 手动双击启动时弹个框，告诉你已经在运行了
if !(A_Args.Length && A_Args[1] = "/silent")
    MsgBox("选中一段文件路径，然后按鼠标后退键：`n资源管理器打开并选中这个文件（文件夹则直接打开）`n`n已设为开机自动运行。右下角托盘里的绿色 H 图标就是它。", "选中路径一键打开（普通版）已启动", "Iconi")

#HotIf !WinActive("ahk_exe WindowsTerminal.exe") && !WinActive("ahk_exe powershell.exe") && !WinActive("ahk_exe cmd.exe")   ; 终端里 Ctrl+C 会中断程序，不启用
XButton1::SideKey("XButton1", "explorer")
#HotIf

SideKey(key, mode) {
    old := ClipboardAll()
    A_Clipboard := ""
    Send("^c")
    got := ClipWait(0.4)
    isFiles := DllCall("IsClipboardFormatAvailable", "UInt", 15)   ; 资源管理器里选中的是文件，不算
    text := (got && !isFiles) ? Trim(A_Clipboard, " `t`r`n") : ""
    A_Clipboard := old            ; 还原剪贴板
    if (text = "" || !LooksLikePath(text)) {
        Send("{" key "}")         ; 不是路径：原样放行“后退/前进”
        return
    }
    HandleText(text, mode)
}

; 像不像路径/文件名：有盘符路径，或单行、不长、带扩展名
LooksLikePath(t) {
    if (CleanPath(t) != "")
        return true
    return !InStr(t, "`n") && StrLen(t) <= 120 && RegExMatch(t, "\.[A-Za-z0-9]{1,6}[`"'``”’]?$")
}

HandleText(text, mode) {
    p := CleanPath(text)
    if (p = "") {                  ; 没有盘符路径：当作文件名交给 Everything
        EverythingSearch(Trim(text, " `t`r`n`"'``“”‘’「」《》<>"))
        return
    }
    real := FileExist(p) ? p : FuzzyResolve(p)
    if (real != "") {
        OpenInExplorer(real)
        return
    }
    ; 纠正不了：最深一层存在的文件夹 + 最后一段模糊词，交给 Everything
    parts := StrSplit(p, "\")
    base := "", rest := []
    for i, seg in parts {
        try_ := (base = "") ? seg "\" : base "\" seg
        if (rest.Length = 0 && DirExist(try_))
            base := RTrim(try_, "\")
        else if (seg != "")
            rest.Push(seg)
    }
    last := rest.Length ? rest[rest.Length] : ""
    fuzzy := RegExReplace(last, "[–—−－\-\s_]+", "*")   ; 710–716 → 710*716
    q := (base != "" ? '"' base '\" ' : "") fuzzy
    ShowMsg("路径不完全对，已交给 Everything 搜索")
    EverythingSearch(q)
}

; 逐级纠正：每一级先精确找，找不到就在上一级里找“去掉破折号/空格/下划线、忽略大小写后相同”的唯一一项
FuzzyResolve(p) {
    parts := StrSplit(p, "\")
    cur := parts[1] "\"            ; 盘符
    if !DirExist(cur)
        return ""
    Loop parts.Length - 1 {
        seg := parts[A_Index + 1]
        if (seg = "")
            continue
        nxt := RTrim(cur, "\") "\" seg
        if FileExist(nxt) {
            cur := nxt
            continue
        }
        key := Norm(seg), hit := "", n := 0
        Loop Files, RTrim(cur, "\") "\*", "FD" {
            if (Norm(A_LoopFileName) = key)
                hit := A_LoopFileFullPath, n++
        }
        if (n != 1)
            return ""
        cur := hit
    }
    return FileExist(cur) ? cur : ""
}

Norm(s) => StrLower(RegExReplace(s, "[\s\-–—−－_·]+", ""))

CleanPath(t) {
    t := RegExReplace(t, "i)^(file:///?|computer://)", "")
    t := StrReplace(t, "/", "\")
    t := RegExReplace(t, "[\r\n]+", "")                     ; 被换行截断的路径拼回去
    if !RegExMatch(t, "[A-Za-z]:\\[^`"<>|*?``“”「」]*", &m)
        return ""
    return RegExReplace(m[0], "[\s。，,.;；:：、)）\]】'’]+$", "")
}

OpenInExplorer(p) {
    if InStr(FileExist(p), "D")
        Run('explorer.exe "' p '"')
    else
        Run('explorer.exe /select,"' p '"')
}

EverythingSearch(q) {
    for exe in [A_ProgramFiles "\Everything\Everything.exe"
              , EnvGet("ProgramFiles(x86)") "\Everything\Everything.exe"
              , A_ProgramFiles "\Everything 1.5a\Everything64.exe"] {
        if FileExist(exe) {
            Run('"' exe '" -s "' StrReplace(q, '"', '""') '"')
            return
        }
    }
    try Run('Everything.exe -s "' StrReplace(q, '"', '""') '"')
    catch
        ShowMsg("没找到 Everything.exe")
}

ShowMsg(text) {
    static g := ""
    if IsObject(g)
        g.Destroy()
    g := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    g.BackColor := "202020"
    g.SetFont("s14 cFFFFFF", "Microsoft YaHei UI")
    g.MarginX := 24, g.MarginY := 14
    g.AddText(, text)
    g.Show("NoActivate AutoSize xCenter yCenter")
    WinSetTransparent(225, g)
    SetTimer(() => (IsObject(g) ? g.Destroy() : 0, g := ""), -1500)
}
