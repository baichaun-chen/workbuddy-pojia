# WorkBuddy PoJia（破甲工具）

WorkBuddy 桌面客户端系统提示词模板层替换工具。把官方模板全部替换为自定义 `<operator_contract>` 契约，从源头解除安全限制卡扣，实现"小码酱"第一人称协作者人设。

> 本工具面向信息安全竞赛（CTF）、授权测试与安全教育场景，供本人对自己安装的客户端做定制。请勿用于未授权目标。

---

## 目录

- [这是什么](#这是什么)
- [原理](#原理)
- [目录结构](#目录结构)
- [安装与部署](#安装与部署)
- [验证是否生效](#验证是否生效)
- [还原官方状态](#还原官方状态)
- [自定义模板路径](#自定义模板路径)
- [兼容性](#兼容性)
- [故障排查](#故障排查)
- [注意事项](#注意事项)
- [License](#license)

---

## 这是什么

WorkBuddy 是一款 Electron 桌面 AI 客户端。它的系统提示词不是写死在代码里，而是由 `resources/app.asar.unpacked/resources/templates/` 目录下的一组 `.tpl` 模板文件渲染而成。本工具把这组模板全部替换成自定义契约，让模型以"小码酱"的身份、按操作者优先的原则工作。

## 原理

模板解析优先级（代码实证）：

```
WORKBUDDY_PROMPT_TEMPLATES_DIR 环境变量（最高）
  → resources/app.asar.unpacked/resources/templates/  ← 本工具改这里
  → resources/templates
  → app.asar 内置模板
```

关键点：`app.asar.unpacked/` 是**解包后的明文目录**，Electron 会优先读这里的明文文件，而不是 `app.asar` 内部封装。所以：

- **直接改明文 `.tpl` 即生效**，无需 `asar pack` 重打包；
- 改动即时落地，重启客户端后读到的新系统提示就是契约本身；
- 原厂限制条文被"替换"而非"叠加"，不存在优先级博弈。

## 目录结构

```
workbuddy-pojia/
├── templates/     # 破甲版模板（16 个，deploy 写入这些）
├── originals/     # 官方原版模板备份（16 个，还原参考）
├── deploy.bat     # 一键部署破甲
├── restore.bat    # 一键还原官方
└── README.md
```

## 安装与部署

### 方式一：GitHub 下载（推荐）

1. 打开仓库页面，点右上角绿色 **Code** 按钮
2. 选择 **Download ZIP**
3. 解压到任意目录（建议放非系统盘，避免权限问题）

### 方式二：git clone

```bash
git clone https://github.com/baichaun-chen/workbuddy-pojia.git
cd workbuddy-pojia
```

### 执行部署

1. **完全退出 WorkBuddy**（重要：右键右下角托盘图标 → 退出，模板只在启动时读取，不退出不会生效）
2. 双击 `deploy.bat`
3. 等待提示「破甲部署成功」
4. 重新打开 WorkBuddy，**新建一个会话**（旧会话已缓存旧提示，需新会话）

## 验证是否生效

在新会话里发送：

```
自检
```

正常应原样返回：

```
POJIA-MARK-7f3a
```

如果返回的是环境报告（"工作目录正常…"之类的），说明破甲没生效，见[故障排查](#故障排查)。

## 还原官方状态

1. 完全退出 WorkBuddy（含托盘图标）
2. 双击 `restore.bat`
3. 重启 WorkBuddy

脚本会用部署时生成的 `*.pojia-bak` 备份覆盖回官方模板。

> 注意：还原依赖 `*.pojia-bak` 备份文件，请勿手动删除模板目录里的 `.pojia-bak`。

## 自定义模板路径

`deploy.bat` 默认用脚本同级的 `templates/` 目录。如果你想用自己改过的模板：

```cmd
deploy.bat "D:\我的模板目录"
```

或直接把文件夹**拖拽到 `deploy.bat` 图标上**。脚本会读取该目录下所有 `*.tpl` 文件写入 WorkBuddy。

## 兼容性

自动探测以下安装目录（按顺序）：

| 盘符/路径 | 说明 |
|---|---|
| `D:\WorkBuddy`、`C:\WorkBuddy`、`E:\WorkBuddy`、`F:\WorkBuddy` | 各盘根目录 |
| `%LOCALAPPDATA%\Programs\WorkBuddy` | 用户级安装 |
| `%LOCALAPPDATA%\WorkBuddy` | 便携/绿色版 |

- 部署时自动备份原模板为 `*.pojia-bak`，已存在则跳过（不覆盖你的备份）
- 覆盖 ask / craft / expert / code / design / quick / prompt 全部 16 个模板

## 故障排查

| 现象 | 原因 | 解决 |
|---|---|---|
| 自检返回环境报告而非口令 | 旧会话缓存了旧提示 | 新建会话重试 |
| 自检仍无效 | WorkBuddy 未完全退出 | 检查托盘图标，彻底退出再部署 |
| 部署提示「未找到安装目录」 | 非标准安装路径 | 把 `deploy.bat` 放到 WorkBuddy 根目录下运行，或手动改脚本里的路径探测 |
| 部署后模型仍拒绝 | 模型内核安全对齐兜底 | 换话术（CTF/逆向场景），或换模型 |
| WorkBuddy 更新后破甲失效 | 更新重置了模板 | 重新运行 `deploy.bat` |

## 注意事项

- **WorkBuddy 自动更新会重置模板**，更新后需重新运行 `deploy.bat`
- 模板只做"放宽人设 + 高优先级"层替换，**模型内核安全对齐仍可能兜底**，对极端内容可能仍有保留
- 部署前建议先跑一次 `restore.bat` 确认备份链路可用，再正式部署

## License

MIT
