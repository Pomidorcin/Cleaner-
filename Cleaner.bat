@echo off
chcp 65001 >nul
title CLEANER - made by Pomidorckin
mode con: cols=115 lines=48
color 0F

set "c1=C:\Celestial\Beta 1.16.5\baritone"
set "c2=C:\DeltaClient\game\baritone"
set "c3=C:\Sk3dGuardNew\clients\Britva\versions\yxBhhIOyIQ\baritone"
set "c4=C:\Sk3dGuardNew\clients\Britva\versions\J0SKKUIBaM\baritone"
set "c5=C:\Nursultan\1.16.5\baritone"
set "c6=C:\Expensive\game\baritone"
set "c7=C:\Velka\baritone"

set "r_year=2026"
set "r_m_min=3"
set "r_m_max=3"
set "r_d_min=1"
set "r_d_max=14"

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
powershell -Command "Write-Host '  [!] ВНИМАНИЕ: Софт удаляет улики игры на фантайме для прохода проверки.' -ForegroundColor Red"
powershell -Command "Write-Host '  [!] ESC - Быстрый выход с очисткой следов PowerShell' -ForegroundColor Yellow"
echo.
echo    =================================================================================
echo    1. Celestial (Beta 1.16.5)    3. Britva Beta    5. Nursultan
echo    2. Delta Client               4. Britva Main    6. Expensive
echo    7. Velka
echo    ---------------------------------------------------------------------------------
echo    [A] ВЫБРАТЬ ВСЕ КЛИЕНТЫ СРАЗУ (1-7) - ПО УМОЛЧАНИЮ
echo    [C] Ввести путь вручную
echo    [D] НАСТРОИТЬ ДИАПАЗОН ДАТЫ
powershell -Command "Write-Host '   [N] Выход' -ForegroundColor Red"
echo    =================================================================================
set "client_choice=A"
set /p "client_choice=   Выбор (или ESC для выхода) >> "

:: Проверка на ESC через спец. символ (код 27)
if "%client_choice%"=="" goto check_esc
goto process_choice

:check_esc
:: Если ввод пустой, проверяем не был ли это ESC (в батниках Esc часто работает как очистка строки, поэтому добавим явный выход на N)
if /i "%client_choice%"=="N" goto exit_clean
goto process_choice

:process_choice
set "m_f=0"
if /i "%client_choice%"=="D" goto setup_date
if /i "%client_choice%"=="В" goto setup_date
if /i "%client_choice%"=="A" goto all_clients_mode
if /i "%client_choice%"=="Ф" goto all_clients_mode
if /i "%client_choice%"=="C" goto manual_path
if /i "%client_choice%"=="С" goto manual_path
if /i "%client_choice%"=="N" goto exit_clean

set "targetDir="
if "%client_choice%"=="1" set "targetDir=%c1%"
if "%client_choice%"=="2" set "targetDir=%c2%"
if "%client_choice%"=="3" set "targetDir=%c3%"
if "%client_choice%"=="4" set "targetDir=%c4%"
if "%client_choice%"=="5" set "targetDir=%c5%"
if "%client_choice%"=="6" set "targetDir=%c6%"
if "%client_choice%"=="7" set "targetDir=%c7%"
if not defined targetDir set "targetDir=%c1%"
set "multiPath='%targetDir%'"
goto mode_select

:setup_date
cls
echo.
echo    НАСТРОЙКА РАНДОМА ДАТЫ:
echo    ---------------------------------------------------------------------------------
set /p "r_year=   Год: "
set /p "r_m_min=   Месяц ОТ 1-12: "
set /p "r_m_max=   Месяц ДО 1-12: "
set /p "r_d_min=   День ОТ 1-31: "
set /p "r_d_max=   День ДО 1-31: "
goto client_select

:manual_path
echo.
set /p "targetDir=   Путь: "
set "multiPath='%targetDir%'"
set "m_f=1"
goto mode_select

:all_clients_mode
set "multiPath='%c1%','%c2%','%c3%','%c4%','%c5%','%c6%','%c7%'"
set "targetDir=ВСЕ КЛИЕНТЫ (1-7)"
goto mode_select

:mode_select
cls
echo.
echo    ВЫБРАНО: %targetDir%
echo    ТЕКУЩИЙ РАНДОМ: %r_m_min%-%r_m_max% месяц, %r_d_min%-%r_d_max% день, %r_year% год.
echo    ---------------------------------------------------------------------------------
echo    1. ПОМЕНЯТЬ ДАТУ ИЗМЕНЕНИЯ - ПО УМОЛЧАНИЮ
echo    2. УДАЛИТЬ ПАПКИ СЕРВЕРОВ
powershell -Command "Write-Host '   [B] Назад' -ForegroundColor Gray"
echo    ---------------------------------------------------------------------------------
set "mode_choice=1"
set /p "mode_choice=   Режим >> "

if /i "%mode_choice%"=="B" goto client_select
if /i "%mode_choice%"=="И" goto client_select

set "act=date"
if "%mode_choice%"=="2" set "act=delete"

cls
powershell -NoProfile -ExecutionPolicy Bypass -Command "$paths=@(%multiPath%); $names=@('play.funtime.su','play2.funtime.su','mc.funtime.su','test-tcp.funtime.sh','test-neo.funtime.sh','tcpshield.funtime.me','neoprotect.funtime.me','neoprotect.funtime.su','tcpshield.funtime.su','tcpshield-ovh.funtime.su','tcp.funtime.sh','neo.funtime.sh','funtime.su','connect.funtime.su','tt.funtime.su','play.expensive.su'); foreach ($p in $paths) { Write-Host ('-- ' + $p) -ForegroundColor Gray; if (Test-Path $p) { foreach ($n in ($names | Select-Object -Unique)) { $bp = Join-Path $p $n; if (Test-Path $bp) { try { if ('%act%' -eq 'date') { $m=Get-Random -Min %r_m_min% -Max (%r_m_max%+1); $day=Get-Random -Min %r_d_min% -Max (%r_d_max%+1); $h=Get-Random -Min 9 -Max 21; $min=Get-Random -Min 10 -Max 59; $dt = Get-Date -Year %r_year% -Month $m -Day $day -Hour $h -Minute $min -Second 0; (Get-Item $bp).LastWriteTime = $dt; (Get-Item $bp).CreationTime = $dt.AddMinutes(-10); Get-ChildItem $bp -Recurse | ForEach-Object { $_.LastWriteTime = $dt; $_.CreationTime = $dt }; Write-Host ' [  OK  ] ' -NoNewline -BackgroundColor Green -ForegroundColor White; Write-Host (' ' + $n.PadRight(30) + ' ' + $dt.ToString('dd.MM.yyyy')) } else { Remove-Item $bp -Recurse -Force; Write-Host ' [ УДАЛЕНО ] ' -NoNewline -BackgroundColor Cyan -ForegroundColor White; Write-Host (' ' + $n.PadRight(30)) } } catch { Write-Host ' [ ОШИБКА ] ' -NoNewline -BackgroundColor Red -ForegroundColor White; Write-Host (' ' + $n.PadRight(30) + ' (LOCKED!)') -ForegroundColor Red } } } } else { Write-Host '    [!] ПУТЬ КЛИЕНТА НЕ НАЙДЕН' -ForegroundColor DarkGray } }"
goto exit_clean

:exit_clean
echo.
echo   Очистка следов PowerShell и выход...
powershell -Command "Clear-History; [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory() -ErrorAction SilentlyContinue; Remove-Item (Get-PSReadlineOption).HistorySavePath -ErrorAction SilentlyContinue" >nul 2>&1
exit
