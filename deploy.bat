@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title WorkBuddy PoJia Deploy

echo ============================================
echo   WorkBuddy 破甲部署脚本
echo ============================================
echo.

rem ---- 自动探测 WorkBuddy 安装目录 ----
set "WB="
for %%D in (D C E F) do (
    if exist "%%D:\WorkBuddy\resources\app.asar.unpacked\resources\templates" (
        set "WB=%%D:\WorkBuddy"
    )
)
if not defined WB (
    if exist "%LOCALAPPDATA%\Programs\WorkBuddy\resources\app.asar.unpacked\resources\templates" (
        set "WB=%LOCALAPPDATA%\Programs\WorkBuddy"
    )
)
if not defined WB (
    if exist "%LOCALAPPDATA%\WorkBuddy\resources\app.asar.unpacked\resources\templates" (
        set "WB=%LOCALAPPDATA%\WorkBuddy"
    )
)
if not defined WB (
    echo [错误] 未找到 WorkBuddy 安装目录。
    echo        请手动把本脚本放到 WorkBuddy 根目录下运行，或检查安装路径。
    pause
    exit /b 1
)

set "TPL=%WB%\resources\app.asar.unpacked\resources\templates"
echo [信息] 检测到 WorkBuddy 目录: %WB%
echo [信息] 模板目录: %TPL%
echo.

if not exist "%TPL%" (
    echo [错误] 模板目录不存在: %TPL%
    pause
    exit /b 1
)

rem ---- 备份原始模板（仅首次，避免覆盖已有备份）----
set "BAK_DIR=%TPL%"
set "first=1"
for %%f in ("%TPL%\*.tpl") do (
    set "name=%%~nxf"
    set "bak=%%f.pojia-bak"
    if not exist "!bak!" (
        copy /y "%%f" "!bak!" >nul
        if !first!==1 (
            echo [备份] 原始模板已备份为 *.pojia-bak
            set "first=0"
        )
    )
)

rem ---- 覆盖写入破甲模板 ----
echo [部署] 正在写入破甲模板...
set "count=0"
for %%f in ("%~dp0templates\*.tpl") do (
    copy /y "%%f" "%TPL%\" >nul
    set /a count+=1
)
echo [部署] 已写入 %count% 个模板文件。
echo.

echo [完成] 破甲部署成功！
echo.
echo   下一步:
echo   1. 完全退出 WorkBuddy（含右下角托盘图标）
echo   2. 重新打开 WorkBuddy，新建会话
echo   3. 发送"自检"验证，应返回 POJIA-MARK-7f3a
echo.
pause
