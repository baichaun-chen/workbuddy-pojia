@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title WorkBuddy PoJia Restore

echo ============================================
echo   WorkBuddy 破甲还原脚本
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
    pause
    exit /b 1
)

set "TPL=%WB%\resources\app.asar.unpacked\resources\templates"
echo [信息] 模板目录: %TPL%
echo.

rem ---- 用 .pojia-bak 还原 ----
set "count=0"
for %%f in ("%TPL%\*.pojia-bak") do (
    set "name=%%~nf"
    rem %%~nf 去掉 .pojia-bak 后缀，得到原名
    copy /y "%%f" "%TPL%\!name!" >nul
    set /a count+=1
)
echo [还原] 已还原 %count% 个模板文件为官方原始版。
echo.

echo [完成] 破甲已还原！
echo   完全退出并重开 WorkBuddy 即可恢复官方状态。
echo.
pause
