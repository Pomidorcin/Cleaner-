@echo off
set "titleName=CLEANER - made by Pomidorckin"

:: 1. Проверка прав админа
chcp 65001 >nul
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] ЗАПУСТИТЕ ОТ ИМЕНИ АДМИНИСТРАТОРА!
    pause
    exit
)

:: 2. Хак для шрифта
reg add "HKCU\Console\%titleName%" /v "FaceName" /t REG_SZ /d "Consolas" /f >nul
reg add "HKCU\Console\%titleName%" /v "FontSize" /t REG_DWORD /d 0x00120000 /f >nul

if "%~1" neq "restarted" (
    start "CLEANER - made by Pomidorckin" cmd /c "%~f0" restarted
    exit
)

:: --- ОСНОВНОЙ КОД ---
chcp 65001 >nul
title %titleName%
mode con: cols=115 lines=48
color 0F

:: Пути Baritone
set "b1=C:\Celestial\Beta 1.16.5\baritone"
set "b2=C:\DeltaClient\game\baritone"
set "b3=C:\Sk3dGuardNew\clients\Britva\versions\yxBhhIOyIQ\baritone"
set "b4=C:\Sk3dGuardNew\clients\Britva\versions\J0SKKUIBaM\baritone"
set "b5=C:\Nursultan\1.16.5\baritone"
set "b6=C:\Expensive\game\baritone"
set "b7=C:\Velka\baritone"

:: Пути Logs
set "l1=C:\Celestial\Beta 1.16.5\logs"
set "l2=C:\DeltaClient\game\logs"
set "l3=C:\Sk3dGuardNew\clients\Britva\versions\yxBhhIOyIQ\logs"
set "l4=C:\Sk3dGuardNew\clients\Britva\versions\J0SKKUIBaM\logs"
set "l5=C:\Nursultan\1.16.5\logs"
set "l6=C:\Expensive\game\logs"
set "l7=C:\Velka\logs"

:client_select
cls
echo.
powershell -Command "Write-Host '    ██████╗██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ ' -ForegroundColor Magenta"
powershell -Command "Write-Host '    ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗' -ForegroundColor Magenta"
powershell -Command "Write-Host '    ██║     ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██████╔╝' -ForegroundColor Magenta"
powershell -Command "Write-Host '    ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██╔══██╗' -ForegroundColor Magenta"
powershell -Command "Write-Host '    ╚██████╗███████╗███████╗██║  ██║██║ ╚████║███████╗██║  ██║' -ForegroundColor Magenta"
powershell -Command "Write-Host '     ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝' -ForegroundColor Magenta"
echo                      made by Pomidorckin
powershell -Command "Write-Host '                      ds: pomidorckin00 ' -ForegroundColor Blue"
echo.
echo    =================================================================================
echo    1. Celestial (Beta)           3. Britva (yxB)           5. Nursultan
echo    2. Delta Client               4. Britva (J0S)           6. Expensive
echo    7. Velka
echo    ---------------------------------------------------------------------------------
echo    [A] ВЫБРАТЬ ВСЕ КЛИЕНТЫ СРАЗУ (1-7)
echo    [C] Ввести пути ВРУЧНУЮ (Baritone + Logs)
echo    [R] Восстановить время (Sync)
powershell -Command "Write-Host '   [N] Выход' -ForegroundColor Red"
echo    =================================================================================
set "choice=A"
set /p "choice=   Выбор >> "

if /i "%choice%"=="N" exit
if /i "%choice%"=="R" goto sync_time
if /i "%choice%"=="C" goto manual_input

set "selB="
set "selL="

if /i "%choice%"=="A" (
    set "selB='%b1%','%b2%','%b3%','%b4%','%b5%','%b6%','%b7%'"
    set "selL='%l1%','%l2%','%l3%','%l4%','%l5%','%l6%','%l7%'"
) else (
    if "%choice%"=="1" set "selB='%b1%'" & set "selL='%l1%'"
    if "%choice%"=="2" set "selB='%b2%'" & set "selL='%l2%'"
    if "%choice%"=="3" set "selB='%b3%'" & set "selL='%l3%'"
    if "%choice%"=="4" set "selB='%b4%'" & set "selL='%l4%'"
    if "%choice%"=="5" set "selB='%b5%'" & set "selL='%l5%'"
    if "%choice%"=="6" set "selB='%b6%'" & set "selL='%l6%'"
    if "%choice%"=="7" set "selB='%b7%'" & set "selL='%l7%'"
)

if not defined selB goto client_select
goto process

:manual_input
cls
echo.
echo    НАСТРОЙКА КАСТОМНЫХ ПУТЕЙ:
echo    ---------------------------------------------------------------------------------
set /p "uB=   1. Введите путь к Baritone: "
set /p "uL=   2. Введите путь к Logs: "
set "selB='%uB%'"
set "selL='%uL%'"
goto process

:process
cls
echo.
echo    ЗАПУСК ОБРАБОТКИ...
echo    ---------------------------------------------------------------------------------
echo    [!] Смена системного времени на 2026...
net stop w32time >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v Type /t REG_SZ /d NoSync /f >nul
powershell -NoProfile -ExecutionPolicy Bypass -Command "$dt=Get-Date -Year 2026 -Month (Get-Random -Min 1 -Max 4) -Day (Get-Random -Min 1 -Max 28) -Hour (Get-Random -Min 10 -Max 20); Set-Date $dt"
timeout /t 1 >nul

echo    [!] Обработка BARITONE:
powershell -NoProfile -ExecutionPolicy Bypass -Command "$paths=@(%selB%); $names=@('play.funtime.su','play2.funtime.su','mc.funtime.su','test-tcp.funtime.sh','test-neo.funtime.sh','tcpshield.funtime.me','neoprotect.funtime.me','neoprotect.funtime.su','tcpshield.funtime.su','tcpshield-ovh.funtime.su','tcp.funtime.sh','neo.funtime.sh','funtime.su','connect.funtime.su','tt.funtime.su','play.expensive.su'); foreach ($p in $paths) { if (Test-Path $p) { $found = Get-ChildItem -Path $p -Directory; foreach ($dir in $found) { if ($names -contains $dir.Name -or $dir.Name -like '*funtime*' -or $dir.Name -like '*expensive*') { $dt = Get-Date -Year 2026 -Month (Get-Random -Min 1 -Max 4) -Day (Get-Random -Min 1 -Max 28) -Hour (Get-Random -Min 9 -Max 21) -Minute (Get-Random -Min 0 -Max 59); try { (Get-Item $dir.FullName).LastWriteTime = $dt; (Get-Item $dir.FullName).CreationTime = $dt.AddMinutes(-10); Get-ChildItem $dir.FullName -Recurse | ForEach-Object { try { $_.LastWriteTime = $dt; $_.CreationTime = $dt } catch {} }; Write-Host ('  [+] ' + $dir.Name.PadRight(25) + ' [OK]') -ForegroundColor Green } catch {} } } } }"

echo.
echo    [!] Очистка LOGS (список удаленных файлов):
powershell -NoProfile -ExecutionPolicy Bypass -Command "$paths=@(%selL%); foreach ($p in $paths) { if (Test-Path $p) { Write-Host (' >> ' + $p) -ForegroundColor Gray; $files = Get-ChildItem -Path $p -File -Recurse; foreach ($f in $files) { try { Remove-Item $f.FullName -Force; Write-Host ('  [-] ' + $f.Name) -ForegroundColor Cyan } catch {} } } }"

:sync_time
echo.
echo    [!] Синхронизация времени...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v Type /t REG_SZ /d NTP /f >nul
net start w32time >nul 2>&1
w32tm /resync /force >nul 2>&1

echo.
echo    ГОТОВО.
pause
goto client_select
