# Установка кодировки UTF8 для кириллицы
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Установка кодировки для корректного отображения кириллицы
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Конфигурация путей
$clients = @{
    "1" = @{ Name = "Celestial (Beta 1.16.5)"; Path = "C:\Celestial\Beta 1.16.5\baritone" }
    "2" = @{ Name = "Delta Client"; Path = "C:\DeltaClient\game\baritone" }
    "3" = @{ Name = "Britva Beta"; Path = "C:\Sk3dGuardNew\clients\Britva\versions\yxBhhIOyIQ\baritone" }
    "4" = @{ Name = "Britva Main"; Path = "C:\Sk3dGuardNew\clients\Britva\versions\J0SKKUIBaM\baritone" }
    "5" = @{ Name = "Nursultan"; Path = "C:\Nursultan\1.16.5\baritone" }
    "6" = @{ Name = "Expensive"; Path = "C:\Expensive\game\baritone" }
}

$serverNames = @(
    'play.funtime.su','play2.funtime.su','mc.funtime.su','test-tcp.funtime.sh',
    'test-neo.funtime.sh','tcpshield.funtime.me','neoprotect.funtime.me',
    'neoprotect.funtime.su','tcpshield.funtime.su','tcpshield-ovh.funtime.su',
    'tcp.funtime.sh','neo.funtime.sh','funtime.su','connect.funtime.su',
    'tt.funtime.su','play.expensive.su'
)

function Show-Menu {
    Clear-Host
    Write-Host "`n    ██████╗██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ " -ForegroundColor Magenta
    Write-Host "    ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗" -ForegroundColor Magenta
    Write-Host "    ██║     ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██████╔╝" -ForegroundColor Magenta
    Write-Host "    ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██╔══██╗" -ForegroundColor Magenta
    Write-Host "    ╚██████╗███████╗███████╗██║  ██║██║ ╚████║███████╗██║  ██║" -ForegroundColor Magenta
    Write-Host "     ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝" -ForegroundColor Magenta
    Write-Host "                      made by Pomidorckin (PS1 Edition)" -ForegroundColor Gray
    Write-Host "  ================================================================================="
    Write-Host "   1. Celestial          3. Britva Beta       5. Nursultan"
    Write-Host "   2. Delta Client       4. Britva Main       6. Expensive"
    Write-Host "  ---------------------------------------------------------------------------------"
    Write-Host "   [A] ВСЕ КЛИЕНТЫ      [C] СВОЙ ПУТЬ        [N] ВЫХОД" -ForegroundColor Cyan
    Write-Host "  ================================================================================="
}

while ($true) {
    Show-Menu
    $choice = Read-Host "   Выбор"
    if ($choice -eq "N") { break }

    $targetPaths = @()
    $title = ""

    if ($choice -eq "A") {
        $clients.Values | ForEach-Object { $targetPaths += $_.Path }
        $title = "ВСЕ КЛИЕНТЫ"
    } elseif ($choice -eq "C") {
        $targetPaths += Read-Host "   Введите путь к baritone"
        $title = "РУЧНОЙ ПУТЬ"
    } elseif ($clients.ContainsKey($choice)) {
        $targetPaths += $clients[$choice].Path
        $title = $clients[$choice].Name
    } else { continue }

    # НАСТРОЙКА ДАТЫ (Сразу после выбора клиента)
    Write-Host "`n   НАСТРОЙКА ДАТЫ ДЛЯ: $title" -ForegroundColor Yellow
    $y = Read-Host "   Год (напр. 2026)"
    $m1 = Read-Host "   Месяц ОТ (1-12)"
    $m2 = Read-Host "   Месяц ДО (1-12)"
    $d1 = Read-Host "   День ОТ (1-31)"
    $d2 = Read-Host "   День ДО (1-31)"

    Write-Host "`n   1. ИЗМЕНИТЬ ДАТУ    2. УДАЛИТЬ ПАПКИ    [B] НАЗАД" -ForegroundColor Cyan
    $mode = Read-Host "   Режим"
    if ($mode -eq "B") { continue }

    foreach ($p in $targetPaths) {
        Write-Host "`n-- Проверка: $p" -ForegroundColor Gray
        if (Test-Path $p) {
            Get-ChildItem $p -Directory | Where-Object { $_.Name -in $serverNames } | ForEach-Object {
                try {
                    if ($mode -eq "1") {
                        $dt = Get-Date -Year $y -Month (Get-Random -Min $m1 -Max ([int]$m2+1)) -Day (Get-Random -Min $d1 -Max ([int]$d2+1)) -Hour (Get-Random -Min 9 -Max 21) -Minute (Get-Random -Min 10 -Max 59)
                        $_.LastWriteTime = $dt
                        $_.CreationTime = $dt.AddMinutes(-20)
                        Get-ChildItem $_.FullName -Recurse | ForEach-Object { $_.LastWriteTime = $dt; $_.CreationTime = $dt }
                        Write-Host " [  OK  ] " -NoNewline -BackgroundColor Green; Write-Host " $($_.Name) ($($dt.ToShortDateString()))"
                    } else {
                        Remove-Item $_.FullName -Recurse -Force
                        Write-Host " [ DEL  ] " -NoNewline -BackgroundColor Cyan; Write-Host " $($_.Name)"
                    }
                } catch {
                    Write-Host " [ ERR  ] " -NoNewline -BackgroundColor Red; Write-Host " $($_.Name) (Занято)"
                }
            }
        }
    }
    Write-Host "`nОперация завершена. Нажмите Enter..."
    Read-Host
}
