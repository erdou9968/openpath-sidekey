# openpath-sidekey：选中文件路径，按一下鼠标侧键就打开

跟 AI 聊天、看文档时经常碰到一串绝对路径，比如 `D:\项目\实验数据\710-716\结果.xlsx`。以前要复制 → 粘贴到 Everything → 挑结果 → 打开；现在**选中路径，按一下鼠标侧键**就行。

Windows 小工具，两个版本任选一个：

| 版本 | 后退键 | 前进键 | 建议另装 |
|---|---|---|---|
| 普通版 | 资源管理器打开并选中文件 | 不改，照常前进 | 无 |
| 进阶版 | **QuickLook 直接预览** | 资源管理器打开并选中文件 | QuickLook |

- 路径是文件夹：直接打开文件夹；是文件：打开所在文件夹并选中它。
- 没装 QuickLook：进阶版的后退键自动改为资源管理器打开。
- 没选中路径时，侧键照常是“后退 / 前进”，不影响上网。按完剪贴板会还原；命令行窗口里不启用。

## 路径有点错也能打开

AI 给的路径偶尔有小毛病：`-` 写成 `–`、末尾多个句号、长路径被换行折断、大小写不一致。脚本会先清理，再从盘符开始逐级核对文件夹名，能唯一对上就照常打开或预览。

实在对不上，就把“最深一层存在的文件夹 + 最后一段的模糊词”交给 [Everything](https://www.voidtools.com/) 搜索（需要装 Everything；在搜索结果里选中按空格，同样能 QuickLook 预览）。只选中了文件名、没有盘符时，也直接用 Everything 搜。

## 下载和使用

**推荐：下载 exe，双击即用，什么都不用装。**

1. 打开 [Releases](https://github.com/erdou9968/openpath-sidekey/releases)，在最新版本的 Assets 里下载 `openpath_进阶版.exe` 或 `openpath_普通版.exe`（**只运行其中一个**）。
2. 双击运行，弹出“已启动”提示框就成功了。之后开机自动运行（开机时不弹框）。
3. 第一次运行如果出现“Windows 已保护你的电脑”：exe 没有数字签名，点“更多信息”→“仍要运行”。
4. 可选：装 [QuickLook](https://github.com/QL-Win/QuickLook)（进阶版预览用）、[Everything](https://www.voidtools.com/)（路径写错时搜索用）。
5. 退出：右下角托盘绿色 H 图标 → 右键 Exit。取消开机启动：Win+R 输入 `shell:startup`，删掉“选中路径一键打开”快捷方式。

**想改按键或看源码**：下载仓库里的 `.ahk` 文件。需要先装 [AutoHotkey v2](https://www.autohotkey.com/)，再双击 `.ahk` 运行。

## 自定义

- 换按键：用记事本打开脚本，改 `XButton1::`（后退键）/ `XButton2::`（前进键）。也可以换成键盘快捷键，如 `^!o::`（Ctrl+Alt+O）。
- 鼠标驱动如果把侧键改成了别的功能，先在驱动里改回默认的“后退 / 前进”。

## 致谢与声明

本工具基于免费开源软件 [AutoHotkey v2](https://www.autohotkey.com/)（[源码](https://github.com/AutoHotkey/AutoHotkey)，GPL-2.0 许可）编写。Releases 里的 exe 用 AutoHotkey 自带的 Ahk2Exe 编译，内含 AutoHotkey 运行环境，所以不用另装。预览和搜索分别调用 [QuickLook](https://github.com/QL-Win/QuickLook) 与 [Everything](https://www.voidtools.com/)，感谢这些作者。

## License

本仓库的脚本以 MIT 许可发布；exe 中包含的 AutoHotkey 运行环境遵循其自身的 GPL-2.0 许可。
