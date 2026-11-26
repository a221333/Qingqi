# 轻启 (Qingqi)

**简体中文** | [English](README.en.md)

**仅 326 KB 的 Windows 原生中文极速启动器，内置 OneCommander 多选中键一键批量重命名增强。**  
*A 326 KB native Windows launcher for Chinese Pinyin search, with non-intrusive middle-click batch rename for OneCommander.*

![Version](https://img.shields.io/badge/version-1.1.0-blue)
![Platform](https://img.shields.io/badge/platform-Windows-0078D6)
![Runtime](https://img.shields.io/badge/.NET%20Framework-4.8-512BD4)
![Size](https://img.shields.io/badge/size-326%20KB-brightgreen)
![Tests](https://img.shields.io/badge/tests-58%2F58%20passed-success)

轻启是一款追求**极简、克制、可靠**的 Windows 桌面效率工具：日常按 `Alt + Space` 即可通过中文拼音秒速启动程序、目录与网页搜索；在 v1.1 中新增 **OneCommander 多选中键批量重命名**，让高频改名从多层菜单缩短为一次滚轮点击。

---

## 核心特色

- **极致轻量，单文件绿色便携**
  主程序 `Qingqi.exe` 仅 **326 KB**（334,336 字节），基于 Windows 自带的 `.NET Framework 4.8` 与 WPF 原生构建。无需安装额外运行时，支持高 DPI 缩放，复制到任意目录即可作为便携版运行。
- **为中文环境打磨的极速搜索（`Alt + Space`）**
  内置宽字符集拼音表，原生支持**中文子串、全拼、拼音首字母、有序模糊首字母**以及**中英混输**；按「精确别名 > 完整名称 > 使用频率」智能排序，并支持裸域名直达、网站搜索模板、启动参数、置顶 / 最近 / 隐藏条目管理，同时主动拦截不安全协议。
- **OneCommander 多选中键唤起原生重命名（v1.1 新特性）**
  在 OneCommander 经典单面板选中多个文件后，只需在列表内**按一下鼠标中键**，即可直接打开 OneCommander 原生 **File Automator** 批量重命名预览窗口。
- **克制、零侵入、绝不误触**
  严格门控校验：只在「单面板 + 多选 + 列表区域 + 无修饰键」时介入；单选、双面板、拖拽、覆盖浮窗或其他应用均完整透传原有中键行为。**不读写剪贴板，不自动点击“处理”**，把最终确认权完全留给用户。
- **工程级配置安全与可验证交付**
  配置采用 UTF-8 原子写入与保存事务机制，写入异常时自动回滚内存与磁盘并保留损坏现场、回退备份。全量构建开启 `warnaserror`，**58 项自动化测试全通过**并附带完整的真机验收与 SHA-256 校验记录。

---

## 快速上手

### 1. 运行程序

1. 前往 [Releases](https://github.com/a221333/Qingqi/releases) 下载最新版本压缩包并解压（确保 `Qingqi.exe` 与 `Qingqi.exe.config` 位于同一目录即可便携运行）。
2. 以**普通用户权限**运行 `Qingqi.exe`（请保持轻启与 OneCommander 权限级别一致）。
3. 程序常驻系统托盘，右键托盘图标可随时开启或关闭 **“OneCommander 多选中键重命名”**，也可管理条目与设置。

### 2. 日常启动与搜索

- 按下 **`Alt + Space`** 呼出搜索框，直接输入中文、全拼、首字母或英文即可实时匹配本机应用、目录与自定义条目。
- 支持直接输入网址 / 裸域名跳转，或配置带参数编码的网站搜索模板与快捷别名。
- 支持对常用项进行置顶、隐藏与参数配置，自动目录扫描与手动条目合并互补。

### 3. OneCommander 多选中键批量重命名

1. 在 OneCommander 的 **“经典／单一”** 文件面板布局中，选中 **至少两个** 文件。
2. 松开 `Ctrl`、`Shift` 等修饰键，将鼠标停留在文件列表区域内，**按一下鼠标中键（滚轮按下）**。
3. 在自动打开的原生 **File Automator** 窗口中设定规则，核对新旧文件名预览后点击 **“处理”**（仅打开预览不会修改任何文件）。

> **规则示例**：选择 `Simple rename`，在文件命名规则中填写 `资料_##`，勾选“将 # 转换为序号”，起始值设为 `1`，强制扩展名留空以保留原扩展名，即可一键预览 `资料_01.txt`、`资料_02.txt`……

---

## 触发与透传边界

为避免干扰日常操作，OneCommander 中键入口遵循严格的场景边界：

| 场景 | 行为 | 说明 |
|---|---|---|
| 经典单文件面板 + 选中 ≥ 2 个文件 + 无修饰键 + 列表内中键 | **打开 File Automator 预览** | 仅打开原生预览，不自动执行处理 |
| 单选文件或未选中文件 | 原样透传中键 | 不改变 OneCommander 默认行为 |
| 双文件面板 | 原样透传中键 | 避免全局处理按钮产生面板歧义 |
| 分栏布局 | 尚未适配（透传） | 当前仅支持单一可见文件列表 |
| 按住 `Ctrl` / `Shift` 等修饰键或拖拽中 | 原样透传 / 取消触发 | 防止组合操作误触 |
| 其他应用窗口或文件列表上方存在覆盖浮窗 | 原样透传中键 | 同时校验前台窗口与鼠标命中窗口 |
| 托盘右键关闭该功能 | 原样透传中键 | 随时热切换，不影响 `Alt + Space` 主功能 |

---

## 运行环境与校验信息

| 项目 | 详情 |
|---|---|
| 程序文件 | `Qingqi.exe`（版本 `1.1.0.0`，`334,336` 字节 / 约 `326 KB`） |
| SHA-256 | `decf6bf5dc1f524dbed3d9a9f79eb03fe0abf407e1a43bdf0cc2c722cb23f4d1` |
| 运行依赖 | Windows + `.NET Framework 4.8`（Windows 10/11 系统自带） |
| 实测 OneCommander 版本 | `3.108.0.0`（经典单文件面板） |
| 自动化测试 | **58 / 58 通过**（核心搜索与配置 37 + WPF 事务与弹窗 11 + 中键门控回归 10） |

完整的测试日志、静态元数据检查、真机验收过程与限制说明，请参阅 [verification.md](verification.md) 及 `verification/` 目录。

---

<details>
<summary>本机升级部署与旧版回退说明（仅适用于原部署环境）</summary>

- 原部署环境中，开始菜单快捷方式与登录自启项指向本目录中的 `Qingqi.exe`，复制程序到其他目录可作为便携版运行，不会改写现有入口。
- 如需在原部署机器恢复旧版，可运行 `RestorePrevious.cmd`；它会依据 `previous-entrypoints.json` 与 `previous-entrypoints-20261109-162345/` 中的备份恢复快捷方式、自启项并启动旧程序，原有个人配置保持不变。

</details>

---

## 致谢与声明

- 拼音检索数据衍生自 [mozillazg/pinyin-data](https://github.com/mozillazg/pinyin-data)（MIT License），详见 [THIRD-PARTY-NOTICES.txt](THIRD-PARTY-NOTICES.txt)。
