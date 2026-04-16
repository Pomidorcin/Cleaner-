# 1. Самовозвышение до админа (красивое окно)
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$titleName = "CLEANER - made by Pomidorckin"
$host.UI.RawUI.WindowTitle = $titleName
chcp 65001 | Out-Null

# Настройка консоли (шрифт и размер)
$config = "HKCU:\Console\$titleName"
if (!(Test-Path $config)) { New-Item $config -Force | Out-Null }
Set-ItemProperty $config -Name "FaceName" -Value "Consolas"
Set-ItemProperty $config -Name "FontSize" -Value 0x00120000
$Host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(115, 48)

# Пути
$bPaths = @("C:\Celestial\Beta 1.16.5\baritone", "C:\DeltaClient\game\baritone", "C:\Sk3dGuardNew\clients\Britva\versions\yxBhhIOyIQ\baritone", "C:\Sk3dGuardNew\clients\Britva\versions\J0SKKUIBaM\baritone", "C:\Nursultan\1.16.5\baritone", "C:\Expensive\game\baritone", "C:\Velka\baritone")
$lPaths = @("C:\Celestial\Beta 1.16.5\logs", "C:\DeltaClient\game\logs", "C:\Sk3dGuardNew\clients\Britva\versions\yxBhhIOyIQ\logs", "C:\Sk3dGuardNew\clients\Britva\versions\J0SKKUIBaM\logs", "C:\Nursultan\1.16.5\logs", "C:\Expensive\game\logs", "C:\Velka\logs")
$serverNames = @('play.funtime.su','play2.funtime.su','mc.funtime.su','*funtime*','*expensive*','play.expensive.su')

function Show-Menu {
    Clear-Host
    $logo = @"
    ██████╗██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
    ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
    ██║     ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██████╔╝
    ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██╔══██╗
    ╚██████╗███████╗███████╗██║  ██║██║ ╚████║███████╗██║  ██║
     ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
"@
    Write-Host $logo -ForegroundColor Magenta
    Write-Host "                      made by Pomidorckin"
    Write-Host "                      ds: pomidorckin00 `n" -ForegroundColor Blue
    Write-Host "    ================================================================================="
    Write-Host "    1. Celestial (Beta)           3. Britva (yxB)           5. Nursultan"
    Write-Host "    2. Delta Client               4. Britva (J0S)           6. Expensive"
    Write-Host "    7. Velka"
    Write-Host "    ---------------------------------------------------------------------------------"
    Write-Host "    [A] ВЫБРАТЬ ВСЕ КЛИЕНТЫ СРАЗУ (1-7)"
    Write-Host "    [C] Ввести пути ВРУЧНУЮ (Baritone + Logs)"
    Write-Host "    [R] Восстановить время (Sync)"
    Write-Host "    [N] Выход" -ForegroundColor Red
    Write-Host "    ================================================================================="
}

while ($true) {
    Show-Menu
    $choice = Read-Host "   Выбор "
    
    if ($choice -eq 'N') { exit }
    if ($choice -eq 'R') { 
        Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "Type" -Value "NTP"
        Start-Service w32time -ErrorAction SilentlyContinue
        w32tm /resync /force
        continue 
    }

    $selB = @(); $selL = @()
    if ($choice -eq 'A') { $selB = $bPaths; $selL = $lPaths }
    elseif ($choice -match '^[1-7]$') { $selB = @($bPaths[$choice-1]); $selL = @($lPaths[$choice-1]) }
    elseif ($choice -eq 'C') { 
        $selB = @(Read-Host "   Введите путь к Baritone"); $selL = @(Read-Host "   Введите путь к Logs") 
    } else { continue }

    # Обработка
    Write-Host "`n   [!] Смена времени на 2026..." -ForegroundColor Cyan
    Stop-Service w32time -ErrorAction SilentlyContinue
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "Type" -Value "NoSync"
    $dt = Get-Date -Year 2026 -Month (Get-Random -Min 1 -Max 4) -Day (Get-Random -Min 1 -Max 28)
    Set-Date $dt

    Write-Host "   [!] Обработка BARITONE..." -ForegroundColor Yellow
    foreach ($path in $selB) {
        if (Test-Path $path) {
            Get-ChildItem $path -Directory | ForEach-Object {
                $dir = $_
                foreach ($mask in $serverNames) {
                    if ($dir.Name -like $mask) {
                        $newTime = $dt.AddHours((Get-Random -Min 9 -Max 21))
                        $dir.LastWriteTime = $newTime; $dir.CreationTime = $newTime.AddMinutes(-10)
                        Get-ChildItem $dir.FullName -Recurse | ForEach-Object { $_.LastWriteTime = $newTime; $_.CreationTime = $newTime }
                        Write-Host "      [+] $($dir.Name.PadRight(25)) [OK]" -ForegroundColor Green
                        break
                    }
                }
            }
        }
    }

    Write-Host "   [!] Очистка LOGS..." -ForegroundColor Red
    foreach ($path in $selL) {
        if (Test-Path $path) {
            Write-Host "      >> $path" -ForegroundColor Gray
            Get-ChildItem $path -File -Recurse | ForEach-Object {
                $name = $_.Name
                Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
                Write-Host "      [-] $name" -ForegroundColor Cyan
            }
        }
    }

    Write-Host "`n   ГОТОВО. Нажми Enter для меню." -ForegroundColor Green
    Read-Host
}
