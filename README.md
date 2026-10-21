# openpath-sidekey：选中文件路径，按一下鼠标侧键就打开

跟 AI 聊天、看文档时经常碰到一串绝对路径，比如 `D:\项目\实验数据\710-716\结果.xlsx`。以前要复制 → 粘贴到 Everything → 挑结果 → 打开；现在**选中路径，按一下鼠标侧键**就行。

Windows + AutoHotkey v2 脚本，两个版本任选一个：

| 版本 | 后退键 | 前进键 | 需要 |
|---|---|---|---|
| `openpath_普通版.ahk` | 资源管理器打开并选中文件 | 不改，照常前进 | AutoHotkey v2 |
| `openpath_进阶版.ahk` | **QuickLook 直接预览** | 资源管理器打开并选中文件 | AutoHotkey v2，建议装 QuickLook |

- 路径是文件夹：直接打开文件夹；是文件：打开所在文件夹并选中它。
- 没装 QuickLook：进阶版的后退键自动改为资源管理器打开。
- 没选中路径时，侧键照常是“后退 / 前进”，不影响上网。按完剪贴板会还原；命令行窗口里不启用。

## 路径有点错也能打开

AI 给的路径偶尔有小毛病：`-` 写成 `–`、末尾多个句号、长路径被换行折断、大小写不一致。脚本会先清理，再从盘符开始逐级核对文件夹名，能唯一对上就照常打开或预览。

实在对不上，就把“最深一层存在的文件夹 + 最后一段的模糊词”交给 [Everything](https://www.voidtools.com/) 搜索（需要装 Everything；在搜索结果里选中按空格，同样能 QuickLook 预览）。只选中了文件名、没有盘符时，也直接用 Everything 搜。

## 安装

1. 装 [AutoHotkey v2](https://www.autohotkey.com/)（必装）。
2. 可选：装 [QuickLook](https://github.com/QL-Win/QuickLook)（进阶版预览用）、[Everything](https://www.voidtools.com/)（路径写错时搜索用）。
3. 下载 `openpath_普通版.ahk` 或 `openpath_进阶版.ahk`（**只运行其中一个**），双击运行。弹出“已启动”提示框就成功了，右下角托盘会出现绿色 H 图标。
4. 脚本会自动设为开机启动（开机时不弹框）。换版本时，退出旧的、双击新的即可，开机启动会跟着换。

## 自定义

- 换按键：用记事本打开脚本，改 `XButton1::`（后退键）/ `XButton2::`（前进键）。也可以换成键盘快捷键，如 `^!o::`（Ctrl+Alt+O）。
- 鼠标驱动如果把侧键改成了别的功能，先在驱动里改回默认的“后退 / 前进”。
- 取消开机启动：Win+R 输入 `shell:startup`，删掉“选中路径一键打开”快捷方式。

## License

MIT
