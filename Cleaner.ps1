# Принудительная кодировка UTF8 для работы с кириллицей
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 1. Самовозвышение до админа
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $p = $PSCommandPath
    if (!$p) { $p = "$env:TEMP\c.ps1" } # Если запущен из памяти, берем путь из темпа
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$p`"" -Verb RunAs
    exit
}

$titleName = "CLEANER - made by Pomidorckin"
$host.UI.RawUI.WindowTitle = $titleName

# Настройка окна
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
    Write-Host "                      made by Pomidorckin | ds: pomidorckin00 `n" -ForegroundColor Blue
    Write-Host "    1. Celestial    3. Britva (yxB)    5. Nursultan"
    Write-Host "    2. Delta        4. Britva (J0S)    6. Expensive    7. Velka"
    Write-Host "    ---------------------------------------------------------------------------------"
    Write-Host "    [A] ВЫБРАТЬ ВСЕ    [C] ВРУЧНУЮ    [R] SYNC TIME    [N] EXIT" -ForegroundColor Yellow
}

while ($true) {
    Show-Menu
    $choice = Read-Host "   Выбор "
    if ($choice -eq 'N') { exit }
    if ($choice -eq 'R') { 
        w32tm /resync /force
        continue 
    }

    $selB = @(); $selL = @()
    if ($choice -eq 'A') { $selB = $bPaths; $selL = $lPaths }
    elseif ($choice -match '^[1-7]$') { $selB = @($bPaths[$choice-1]); $selL = @($lPaths[$choice-1]) }
    elseif ($choice -eq 'C') { 
        $selB = @(Read-Host "   Path Baritone"); $selL = @(Read-Host "   Path Logs") 
    } else { continue }

    Write-Host "`n   [!] Processing..." -ForegroundColor Cyan
    # Смена времени
    Set-Date (Get-Date -Year 2026 -Month (Get-Random -Min 1 -Max 4))

    # Baritone
    foreach ($path in $selB) {
        if (Test-Path $path) {
            Get-ChildItem $path -Directory | ForEach-Object {
                $dir = $_
                foreach ($mask in $serverNames) {
                    if ($dir.Name -like $mask) {
                        $newTime = (Get-Date).AddHours((Get-Random -Min 1 -Max 5))
                        $dir.LastWriteTime = $newTime; $dir.CreationTime = $newTime
                        Get-ChildItem $dir.FullName -Recurse | ForEach-Object { $_.LastWriteTime = $newTime; $_.CreationTime = $newTime }
                        Write-Host "      [+] $($dir.Name) [OK]" -ForegroundColor Green
                    }
                }
            }
        }
    }

    # Logs
    foreach ($path in $selL) {
        if (Test-Path $path) {
            Get-ChildItem $path -File -Recurse | ForEach-Object {
                Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
                Write-Host "      [-] $($_.Name)" -ForegroundColor Cyan
            }
        }
    }
    Write-Host "`n   DONE. Press Enter." -ForegroundColor Green
    Read-Host
}
