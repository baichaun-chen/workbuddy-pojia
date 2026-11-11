# WorkBuddy PoJia（破甲工具）

WorkBuddy 桌面客户端系统提示词模板层替换工具。把官方 15 个模板全部替换为自定义契约，从源头解除安全限制卡扣，实现"小码酱"第一人称协作者人设。

## 原理

WorkBuddy 是 Electron 客户端，系统提示由 `resources/app.asar.unpacked/resources/templates/` 目录下的 `.tpl` 模板渲染。该目录优先级高于 `app.asar` 内部封装，**直接改这里的明文文件即生效，无需重打包 asar**。

本工具将 15 个模板全部替换为 `<operator_contract>` 契约内容，覆盖 ask / craft / expert / code / design / quick / prompt 全部模式。

## 目录结构

```
workbuddy-pojia/
├── templates/     # 破甲版模板（15 个，deploy 写入这些）
├── originals/     # 官方原版模板备份（15 个，参考用）
├── deploy.bat     # 一键部署破甲
├── restore.bat    # 一键还原官方
└── README.md
```

## 快速开始

### 部署

1. 完全退出 WorkBuddy（含右下角托盘图标，模板只在启动时读取）
2. 双击 `deploy.bat`
3. 重新打开 WorkBuddy，新建会话
4. 发送 `自检` 验证，应返回 `POJIA-MARK-7f3a`

### 还原

1. 完全退出 WorkBuddy
2. 双击 `restore.bat`（用 `.pojia-bak` 备份覆盖回官方模板）
3. 重启 WorkBuddy

## 兼容性

- 自动探测安装目录：`D:\WorkBuddy`、`C:\WorkBuddy`、`E:\`、`F:\`、`%LOCALAPPDATA%\Programs\WorkBuddy`、`%LOCALAPPDATA%\WorkBuddy`
- 部署时自动备份原模板为 `*.pojia-bak`（已存在则跳过，不覆盖）

## 注意事项

- WorkBuddy 自动更新会重置模板，更新后需重新运行 `deploy.bat`
- 模板只做"放宽人设 + 高优先级"层替换，模型内核安全对齐仍可能兜底

## License

MIT
