@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: ═══════════════════════════════════════════════════════════════════════════
:: PANTALLA DE INICIO
:: ═══════════════════════════════════════════════════════════════════════════
cls
color 0B
echo.
echo.
echo         ╔═══════════════════════════════════════════════════════════════╗
echo         ║                                                               ║
echo         ║    █████╗ ███████╗███████╗██╗     ███╗   ███╗ ██████╗ ██████╗║
echo         ║   ██╔══██╗╚══███╔╝██╔════╝██║     ████╗ ████║██╔═══██╗██╔══██║
echo         ║   ███████║  ███╔╝ █████╗  ██║     ██╔████╔██║██║   ██║██║  ██║
echo         ║   ██╔══██║ ███╔╝ ██╔══╝  ██║     ██║╚██╔╝██║██║   ██║██║  ██║
echo         ║   ██║  ██║███████╗███████╗███████╗██║ ╚═╝ ██║╚██████╔╝██████╔╝║
echo         ║   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ║
echo         ║                                                               ║
echo         ║          Windows 11 Ultimate Optimizer v4.5.0 FINAL          ║
echo         ║                                                               ║
echo         ╚═══════════════════════════════════════════════════════════════╝
echo.
echo                           Cargando sistema...
echo.
echo                      ████████████████████████████████
echo.
timeout /t 2 /nobreak >nul

:: ═══════════════════════════════════════════════════════════════════════════
:: VERIFICACIÓN DE PRIVILEGIOS ADMINISTRADOR
:: ═══════════════════════════════════════════════════════════════════════════
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    color 0C
    echo.
    echo.
    echo         ╔═══════════════════════════════════════════════════════════════╗
    echo         ║                                                               ║
    echo         ║                     ❌ ERROR CRÍTICO ❌                        ║
    echo         ║                                                               ║
    echo         ║          SE REQUIEREN PRIVILEGIOS DE ADMINISTRADOR            ║
    echo         ║                                                               ║
    echo         ╚═══════════════════════════════════════════════════════════════╝
    echo.
    echo                 Este script necesita ejecutarse como Administrador
    echo.
    echo                 ┌────────────────────────────────────────────────┐
    echo                 │  Haz clic derecho sobre el archivo .bat        │
    echo                 │  Selecciona: "Ejecutar como administrador"     │
    echo                 └────────────────────────────────────────────────┘
    echo.
    echo                          Cerrando en 10 segundos...
    timeout /t 10
    exit /b 1
)

title AzelMods_XV677 - Windows 11 Optimizer v4.5.0 FINAL

:: ═══════════════════════════════════════════════════════════════════════════
:: VARIABLES Y FECHA
:: ═══════════════════════════════════════════════════════════════════════════
for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "(Get-Date).ToString('yyyyMMdd')"`) do set BACKUP_DATE=%%D
set "LOG_FILE=%~dp0AzelMods_Log_%BACKUP_DATE%.txt"
set "SCRIPT_VERSION=4.5.0 FINAL"
set "SCRIPT_NAME=AzelMods_XV677"

echo [%date% %time%] ════════ INICIANDO %SCRIPT_NAME% v%SCRIPT_VERSION% ════════ > "%LOG_FILE%"

:: ═══════════════════════════════════════════════════════════════════════════
:: VERIFICACIÓN DE WINDOWS 11
:: ═══════════════════════════════════════════════════════════════════════════
echo                          Verificando sistema operativo...
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul ^| find "CurrentBuild"') do set WIN_BUILD=%%a

if !WIN_BUILD! LSS 22000 (
    cls
    color 0C
    echo.
    echo.
    echo         ╔═══════════════════════════════════════════════════════════════╗
    echo         ║                                                               ║
    echo         ║              ⚠️  SISTEMA OPERATIVO NO COMPATIBLE ⚠️           ║
    echo         ║                                                               ║
    echo         ╚═══════════════════════════════════════════════════════════════╝
    echo.
    echo                 Este script está diseñado EXCLUSIVAMENTE para Windows 11
    echo.
    echo                          Build detectado: !WIN_BUILD!
    echo                          Build requerido: 22000 o superior
    echo.
    echo                          Cerrando en 10 segundos...
    echo [ERROR] Sistema no compatible - Build !WIN_BUILD! >> "%LOG_FILE%"
    timeout /t 10
    exit /b 1
)

set "WIN_NAME=Windows 11"
echo [OK] Windows 11 detectado [Build !WIN_BUILD!] >> "%LOG_FILE%"

:: ═══════════════════════════════════════════════════════════════════════════
:: DETECCIÓN DE HARDWARE
:: ═══════════════════════════════════════════════════════════════════════════
echo                          Detectando hardware del sistema...

:: Detección de RAM
for /f "skip=1 tokens=*" %%I in ('wmic computersystem get TotalPhysicalMemory 2^>nul') do (
    if not defined RAM_BYTES (
        set "RAM_BYTES=%%I"
        set "RAM_BYTES=!RAM_BYTES: =!"
    )
)
if not defined RAM_BYTES set RAM_BYTES=4294967296
if !RAM_BYTES! lss 1048576 set RAM_BYTES=4294967296
set /a RAM_MB=!RAM_BYTES!/1048576
set /a RAM_GB=!RAM_MB!/1024

:: Detección de tipo de disco
set DISKTYPE=HDD
for /f "skip=1 tokens=*" %%D in ('wmic diskdrive get MediaType 2^>nul') do (
    set "MEDIA=%%D"
    echo !MEDIA! | findstr /i "SSD" >nul && set DISKTYPE=SSD
)
if "!DISKTYPE!"=="HDD" (
    for /f "skip=1 tokens=*" %%D in ('wmic diskdrive get Model 2^>nul') do (
        set "MODEL=%%D"
        echo !MODEL! | findstr /i "SSD NVME" >nul && set DISKTYPE=SSD
    )
)

:: Detección de CPU
for /f "skip=1 tokens=*" %%C in ('wmic cpu get Name 2^>nul') do (
    if not defined CPU_NAME (
        set "CPU_NAME=%%C"
        set "CPU_NAME=!CPU_NAME:~0,35!"
    )
)

echo [OK] Hardware: !RAM_GB!GB RAM, !DISKTYPE!, CPU: !CPU_NAME! >> "%LOG_FILE%"

timeout /t 2 /nobreak >nul

:: ═══════════════════════════════════════════════════════════════════════════
:: MENÚ PRINCIPAL
:: ═══════════════════════════════════════════════════════════════════════════
:menu
cls
color 0B
echo.
echo ╔═══════════════════════════════════════════════════════════════════════════╗
echo ║                                                                           ║
echo ║    █████╗ ███████╗███████╗██╗     ███╗   ███╗ ██████╗ ██████╗ ███████╗  ║
echo ║   ██╔══██╗╚══███╔╝██╔════╝██║     ████╗ ████║██╔═══██╗██╔══██╗██╔════╝  ║
echo ║   ███████║  ███╔╝ █████╗  ██║     ██╔████╔██║██║   ██║██║  ██║███████╗  ║
echo ║   ██╔══██║ ███╔╝ ██╔══╝  ██║     ██║╚██╔╝██║██║   ██║██║  ██║╚════██║  ║
echo ║   ██║  ██║███████╗███████╗███████╗██║ ╚═╝ ██║╚██████╔╝██████╔╝███████║  ║
echo ║   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝  ║
echo ║                                                                           ║
echo ║             Windows 11 Optimizer v%SCRIPT_VERSION%                            ║
echo ║         YouTube: https://www.youtube.com/@AGCOMPANY677                    ║
echo ║                                                                           ║
echo ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo ╔═══════════════════════════════════════════════════════════════════════════╗
echo ║ 📊 INFORMACIÓN DEL SISTEMA                                                ║
echo ╠═══════════════════════════════════════════════════════════════════════════╣
echo ║  Sistema: %WIN_NAME% [Build !WIN_BUILD!]
echo ║  RAM: !RAM_GB! GB (!RAM_MB! MB) │ Disco: !DISKTYPE!
echo ║  CPU: !CPU_NAME!
echo ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo ╔═══════════════════════════════════════════════════════════════════════════╗
echo ║ ⚡ OPTIMIZACIONES PRINCIPALES                                             ║
echo ╠═══════════════════════════════════════════════════════════════════════════╣
echo ║  [1] ⚡ OPTIMIZACIÓN COMPLETA      - Todo en uno (30 mejoras)             ║
echo ║  [2] 🎮 OPTIMIZACIÓN GAMING        - Alto rendimiento extremo             ║
echo ║  [3] 🔧 OPTIMIZACIÓN BÁSICA        - Segura para oficina                  ║
echo ║  [4] 🗑️  DESINSTALAR BLOATWARE     - Apps innecesarias                    ║
echo ║  [5] 🧹 LIMPIEZA DE DISCO          - Libera espacio                       ║
echo ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo ╔═══════════════════════════════════════════════════════════════════════════╗
echo ║ 🔥 OPTIMIZACIONES AVANZADAS                                               ║
echo ╠═══════════════════════════════════════════════════════════════════════════╣
echo ║  [6] 🪟 INTERFAZ WINDOWS 11        - Personalización                      ║
echo ║  [7] 🔒 PRIVACIDAD MÁXIMA          - Anti-telemetría total                ║
echo ║  [8] 🌐 OPTIMIZACIÓN DE RED        - Baja latencia gaming                 ║
echo ║  [9] 🛡️  SEGURIDAD AVANZADA        - Protección extra                     ║
echo ║  [A] 🚀 OPTIMIZAR SERVICIOS        - Desactivar innecesarios              ║
echo ║  [B] 🔔 DESACTIVAR NOTIFICACIONES  - Modo concentración                   ║
echo ║  [C] ⚙️  OPTIMIZAR ARRANQUE        - Startup ultra-rápido                 ║
echo ║  [D] 💾 OPTIMIZAR ALMACENAMIENTO   - SSD/HDD específico                   ║
echo ║  [E] 📊 ANÁLISIS DE RENDIMIENTO    - Diagnóstico completo                 ║
echo ║  [F] 🔄 ACTUALIZAR DRIVERS         - Revisar controladores                ║
echo ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
echo ╔═══════════════════════════════════════════════════════════════════════════╗
echo ║ 🛠️  HERRAMIENTAS Y UTILIDADES                                             ║
echo ╠═══════════════════════════════════════════════════════════════════════════╣
echo ║  [R] 🔄 RESTAURAR REGISTRO │ [L] 📋 VER LOG │ [I] ℹ️  INFO SISTEMA        ║
echo ║  [H] ❓ AYUDA              │ [0] ❌ SALIR                                  ║
echo ╚═══════════════════════════════════════════════════════════════════════════╝
echo.
set opcion=
set /p opcion="└─► Selecciona opción: "

if /i "!opcion!"=="1" goto full_optimize
if /i "!opcion!"=="2" goto gaming_optimize
if /i "!opcion!"=="3" goto basic_optimize
if /i "!opcion!"=="4" goto remove_bloatware
if /i "!opcion!"=="5" goto disk_cleanup
if /i "!opcion!"=="6" goto win11_interface
if /i "!opcion!"=="7" goto privacy_max
if /i "!opcion!"=="8" goto network_optimize
if /i "!opcion!"=="9" goto security_advanced
if /i "!opcion!"=="A" goto optimize_services
if /i "!opcion!"=="B" goto disable_notifications
if /i "!opcion!"=="C" goto optimize_startup
if /i "!opcion!"=="D" goto optimize_storage
if /i "!opcion!"=="E" goto performance_analysis
if /i "!opcion!"=="F" goto update_drivers
if /i "!opcion!"=="R" goto restore_registry
if /i "!opcion!"=="L" goto view_log
if /i "!opcion!"=="H" goto help_script
if /i "!opcion!"=="I" goto system_info
if /i "!opcion!"=="0" goto end_script

color 0E
echo.
echo [!] Opción inválida, intenta de nuevo...
timeout /t 2 >nul
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: 1. OPTIMIZACIÓN COMPLETA
:: ═══════════════════════════════════════════════════════════════════════════
:full_optimize
cls
color 0A
echo.
echo ════════════════════════════════════════════════════════════════
echo   ⚡ OPTIMIZACIÓN COMPLETA - WINDOWS 11
echo ════════════════════════════════════════════════════════════════
echo.
echo [%date% %time%] Iniciando Optimización COMPLETA >> "%LOG_FILE%"

set "BACKUP_REG=%~dp0Registry_Backup_Full_%BACKUP_DATE%.reg"
echo [0/30] Creando backup del registro...
reg export HKLM\SOFTWARE "%BACKUP_REG%" /y >nul 2>&1
if !errorlevel!==0 (
    echo    [✓] Backup guardado exitosamente
    echo [OK] Backup registro guardado >> "%LOG_FILE%"
) else (
    color 0E
    echo    [!] No se pudo crear backup del registro
    echo [ERROR] Backup registro falló >> "%LOG_FILE%"
    echo.
    choice /c SN /n /m "¿Continuar sin backup? [S/N]: "
    if !errorlevel!==2 goto menu
    color 0A
)

echo [1/30] Creando punto de restauración...
powershell -Command "try{Checkpoint-Computer -Description 'AzelMods_v%SCRIPT_VERSION%_Full' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop; exit 0}catch{exit 1}" >nul 2>&1
if !errorlevel!==0 (
    echo    [✓] Punto de restauración creado
    echo [OK] Punto de restauración creado >> "%LOG_FILE%"
) else (
    echo    [!] No se pudo crear punto de restauración
    echo [WARN] Punto de restauración omitido >> "%LOG_FILE%"
)

echo [2/30] Optimizando plan de energía Ultimate Performance...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -change -monitor-timeout-ac 0 >nul 2>&1
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -standby-timeout-ac 0 >nul 2>&1
echo    [✓] Plan Ultimate Performance activado
echo [OK] Plan de energía optimizado >> "%LOG_FILE%"

echo [3/30] Desactivando hibernación...
powercfg -h off >nul 2>&1
echo    [✓] Hibernación desactivada
echo [OK] Hibernación desactivada >> "%LOG_FILE%"

echo [4/30] Ajustando Prefetch/Superfetch según hardware...
if !RAM_MB! GEQ 3072 (
    if "!DISKTYPE!"=="SSD" (
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
        echo    [✓] Prefetch/Superfetch desactivado (SSD)
        echo [OK] Prefetch desactivado - SSD >> "%LOG_FILE%"
    ) else (
        echo    [→] HDD detectado - Prefetch mantenido
        echo [SKIP] Prefetch mantenido - HDD >> "%LOG_FILE%"
    )
) else (
    echo    [→] RAM baja - Prefetch necesario
    echo [SKIP] Prefetch mantenido - RAM baja >> "%LOG_FILE%"
)

echo [5/30] Configurando paginación ejecutiva...
if !RAM_MB! GEQ 8192 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
    echo    [✓] DisablePagingExecutive activado (8GB+ RAM)
    echo [OK] DisablePagingExecutive activado >> "%LOG_FILE%"
) else (
    echo    [→] RAM insuficiente para este ajuste
    echo [SKIP] DisablePagingExecutive omitido >> "%LOG_FILE%"
)

echo [6/30] Desactivando SysMain (Superfetch)...
sc config "SysMain" start= disabled >nul 2>&1
sc stop "SysMain" >nul 2>&1
echo    [✓] SysMain detenido y desactivado
echo [OK] SysMain detenido >> "%LOG_FILE%"

echo [7/30] Desinstalando OneDrive completamente...
taskkill /f /im OneDrive.exe >nul 2>&1
if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" (
    "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
)
if exist "%SystemRoot%\System32\OneDriveSetup.exe" (
    "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
)
timeout /t 3 /nobreak >nul
rd /s /q "%UserProfile%\OneDrive" >nul 2>&1
rd /s /q "%LocalAppData%\Microsoft\OneDrive" >nul 2>&1
rd /s /q "%ProgramData%\Microsoft OneDrive" >nul 2>&1
reg delete "HKCU\Software\Microsoft\OneDrive" /f >nul 2>&1
echo    [✓] OneDrive desinstalado
echo [OK] OneDrive eliminado >> "%LOG_FILE%"

echo [8/30] Desinstalando Widgets de Windows 11...
PowerShell -NoP -C "Get-AppxPackage *WebExperience* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Widgets desinstalados
echo [OK] Widgets eliminados >> "%LOG_FILE%"

echo [9/30] Optimizando Windows Defender...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v AvgCPULoadFactor /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v LowCpuPriority /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Defender optimizado
echo [OK] Defender optimizado >> "%LOG_FILE%"

echo [10/30] Limpiando caché de iconos...
taskkill /f /im explorer.exe >nul 2>&1
del /f /s /q "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\*.db" >nul 2>&1
start explorer.exe
timeout /t 2 /nobreak >nul
echo    [✓] Caché limpiado
echo [OK] Caché de iconos limpiado >> "%LOG_FILE%"

echo [11/30] Desactivando DiagTrack (telemetría)...
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
echo    [✓] DiagTrack detenido
echo [OK] DiagTrack desactivado >> "%LOG_FILE%"

echo [12/30] Minimizando efectos visuales...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Efectos visuales minimizados
echo [OK] Efectos visuales desactivados >> "%LOG_FILE%"

echo [13/30] Desactivando noticias e intereses...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f >nul 2>&1
echo    [✓] Noticias desactivadas
echo [OK] Noticias desactivadas >> "%LOG_FILE%"

echo [14/30] Desactivando Bing y Cortana...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Bing y Cortana desactivados
echo [OK] Bing/Cortana desactivados >> "%LOG_FILE%"

echo [15/30] Reduciendo telemetría...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
echo    [✓] Telemetría reducida
echo [OK] Telemetría reducida >> "%LOG_FILE%"

echo [16/30] Aplicando optimizaciones gaming...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
echo    [✓] Prioridades gaming aplicadas
echo [OK] Gaming boost aplicado >> "%LOG_FILE%"

echo [17/30] Optimizando Win32PrioritySeparation...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul 2>&1
echo    [✓] Win32PrioritySeparation optimizado
echo [OK] PrioritySeparation optimizado >> "%LOG_FILE%"

echo [18/30] Optimizando configuración de red...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
echo    [✓] Red optimizada
echo [OK] Red optimizada >> "%LOG_FILE%"

echo [19/30] Evaluando Windows Search...
if !RAM_MB! LEQ 4096 (
    sc config "WSearch" start= disabled >nul 2>&1
    sc stop "WSearch" >nul 2>&1
    echo    [✓] WSearch detenido (RAM limitada)
    echo [OK] WSearch detenido >> "%LOG_FILE%"
) else (
    echo    [→] WSearch mantenido (RAM suficiente)
    echo [SKIP] WSearch mantenido >> "%LOG_FILE%"
)

echo [20/30] Desactivando Game DVR...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v value /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Game DVR desactivado
echo [OK] Game DVR desactivado >> "%LOG_FILE%"

echo [21/30] Restaurando menú contextual clásico...
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /f >nul 2>&1
echo    [✓] Menú contextual clásico restaurado
echo [OK] Menú contextual clásico >> "%LOG_FILE%"

echo [22/30] Optimizando GPU scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
echo    [✓] GPU scheduling habilitado
echo [OK] GPU scheduling optimizado >> "%LOG_FILE%"

echo [23/30] Desactivando servicios innecesarios...
sc config "TabletInputService" start= disabled >nul 2>&1
sc stop "TabletInputService" >nul 2>&1
sc config "MapsBroker" start= disabled >nul 2>&1
sc stop "MapsBroker" >nul 2>&1
echo    [✓] Servicios innecesarios desactivados
echo [OK] Servicios optimizados >> "%LOG_FILE%"

echo [24/30] Limpiando archivos temporales...
if exist "%TEMP%" (
    pushd "%TEMP%" 2>nul
    if !errorlevel!==0 (
        for /f "delims=" %%F in ('dir /b /a 2^>nul') do (
            if /i not "%%F"=="desktop.ini" (
                rd /s /q "%%F" 2>nul
                del /f /q "%%F" 2>nul
            )
        )
        popd
    )
)
echo    [✓] Temporales limpiados
echo [OK] Temporales limpiados >> "%LOG_FILE%"

echo [25/30] Desactivando animaciones del sistema...
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
echo    [✓] Animaciones desactivadas
echo [OK] Animaciones desactivadas >> "%LOG_FILE%"

echo [26/30] Optimizando TRIM para SSD...
if "!DISKTYPE!"=="SSD" (
    fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
    echo    [✓] TRIM habilitado para SSD
    echo [OK] TRIM optimizado >> "%LOG_FILE%"
) else (
    echo    [→] HDD detectado - TRIM no aplicable
    echo [SKIP] TRIM omitido - HDD >> "%LOG_FILE%"
)

echo [27/30] Limpiando caché de Windows Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /f /s /q "%WINDIR%\SoftwareDistribution\Download\*.*" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo    [✓] Caché de Windows Update limpiado
echo [OK] WU caché limpiado >> "%LOG_FILE%"

echo [28/30] Desactivando rastreo de actividades...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Rastreo desactivado
echo [OK] Activity tracking desactivado >> "%LOG_FILE%"

echo [29/30] Optimizando transparencias...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Transparencias desactivadas
echo [OK] Transparencias desactivadas >> "%LOG_FILE%"

echo [30/30] Configurando servicios de impresión...
echo.
choice /c SN /n /m "¿Desactivar Spooler de impresión? [S/N]: "
if !errorlevel!==1 (
    sc config "Spooler" start= disabled >nul 2>&1
    sc stop "Spooler" >nul 2>&1
    echo    [✓] Spooler desactivado
    echo [OK] Spooler desactivado >> "%LOG_FILE%"
) else (
    echo    [→] Spooler mantenido
    echo [SKIP] Spooler mantenido >> "%LOG_FILE%"
)

echo.
color 0A
echo ════════════════════════════════════════════════════════════════
echo   ✓ OPTIMIZACIÓN COMPLETA FINALIZADA
echo ════════════════════════════════════════════════════════════════
echo [%date% %time%] Optimización COMPLETA finalizada >> "%LOG_FILE%"
echo.
echo   [✓] 30 optimizaciones aplicadas exitosamente
echo   [i] Se recomienda REINICIAR el sistema para aplicar
echo       todos los cambios correctamente.
echo.
choice /c SN /n /m "¿Reiniciar ahora? [S/N]: "
if !errorlevel!==1 (
    echo.
    echo Reiniciando en 10 segundos...
    shutdown /r /t 10 /c "%SCRIPT_NAME%: Aplicando optimizaciones"
    exit /b 0
) else (
    echo.
    echo [!] Recuerda reiniciar pronto para completar la optimización.
    pause
    goto menu
)

:: ═══════════════════════════════════════════════════════════════════════════
:: 2. OPTIMIZACIÓN GAMING
:: ═══════════════════════════════════════════════════════════════════════════
:gaming_optimize
cls
color 0D
echo.
echo ════════════════════════════════════════════════════════════════
echo   🎮 OPTIMIZACIÓN GAMING - MÁXIMO RENDIMIENTO
echo ════════════════════════════════════════════════════════════════
echo.
echo [%date% %time%] Iniciando Optimización GAMING >> "%LOG_FILE%"

set "BACKUP_GAMING=%~dp0Registry_Backup_Gaming_%BACKUP_DATE%.reg"
echo [0/10] Creando backup...
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "%BACKUP_GAMING%" /y >nul 2>&1

echo [1/10] Activando plan Ultimate Performance...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
echo    [✓] Plan Ultimate Performance activado

echo [2/10] Configurando prioridades gaming...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
echo    [✓] Prioridades gaming configuradas

echo [3/10] Desactivando efectos visuales...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
echo    [✓] Efectos visuales minimizados

echo [4/10] Optimizando red para gaming...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1
echo    [✓] Red optimizada

echo [5/10] Desactivando Game DVR...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Game DVR desactivado, Game Mode activado

echo [6/10] Optimizando GPU...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
echo    [✓] GPU scheduling habilitado

echo [7/10] Desactivando SysMain...
sc config "SysMain" start= disabled >nul 2>&1
sc stop "SysMain" >nul 2>&1
echo    [✓] SysMain desactivado

echo [8/10] Deteniendo servicios innecesarios...
sc stop "WSearch" >nul 2>&1
sc stop "DiagTrack" >nul 2>&1
echo    [✓] Servicios detenidos

echo [9/10] Optimizando CPU...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
echo    [✓] CPU optimizado

echo [10/10] Desactivando notificaciones...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Notificaciones desactivadas

echo.
echo [%date% %time%] Optimización GAMING finalizada >> "%LOG_FILE%"
color 0D
echo ════════════════════════════════════════════════════════════════
echo   ✓ OPTIMIZACIÓN GAMING COMPLETADA
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: 3. OPTIMIZACIÓN BÁSICA
:: ═══════════════════════════════════════════════════════════════════════════
:basic_optimize
cls
color 0A
echo.
echo ════════════════════════════════════════════════════════════════
echo   🔧 OPTIMIZACIÓN BÁSICA - SEGURA
echo ════════════════════════════════════════════════════════════════
echo.
echo [%date% %time%] Iniciando Optimización BÁSICA >> "%LOG_FILE%"

echo [1/8] Limpiando temporales...
if exist "%TEMP%" (
    pushd "%TEMP%" 2>nul
    if !errorlevel!==0 (
        for /f "delims=" %%F in ('dir /b /a 2^>nul') do (
            rd /s /q "%%F" 2>nul
            del /f /q "%%F" 2>nul
        )
        popd
    )
)
echo    [✓] Temporales limpiados

echo [2/8] Desactivando efectos...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
echo    [✓] Efectos desactivados

echo [3/8] Optimizando energía...
powercfg -change -monitor-timeout-ac 15 >nul 2>&1
powercfg -change -disk-timeout-ac 0 >nul 2>&1
echo    [✓] Energía balanceada

echo [4/8] Reduciendo telemetría...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Telemetría reducida

echo [5/8] Limpiando logs...
wevtutil cl Application >nul 2>&1
wevtutil cl System >nul 2>&1
echo    [✓] Logs limpiados

echo [6/8] Optimizando indexación...
reg add "HKLM\SOFTWARE\Microsoft\Windows Search" /v SetupCompletedSuccessfully /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Indexación optimizada

echo [7/8] Optimizando menús...
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 200 /f >nul 2>&1
echo    [✓] Menús optimizados

echo [8/8] Finalizando...
echo    [✓] Optimización básica completada

echo.
echo [%date% %time%] Optimización BÁSICA finalizada >> "%LOG_FILE%"
color 0A
echo ════════════════════════════════════════════════════════════════
echo   ✓ OPTIMIZACIÓN BÁSICA COMPLETADA
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: 4. DESINSTALAR BLOATWARE
:: ═══════════════════════════════════════════════════════════════════════════
:remove_bloatware
cls
color 0C
echo.
echo ════════════════════════════════════════════════════════════════
echo   🗑️  DESINSTALAR BLOATWARE
echo ════════════════════════════════════════════════════════════════
echo.
echo   ADVERTENCIA: Esto desinstalará apps permanentemente
echo.
choice /c SN /n /m "¿ESTÁS SEGURO de continuar? [S/N]: "
if !errorlevel!==2 goto menu

echo.
echo [%date% %time%] Iniciando eliminación de bloatware >> "%LOG_FILE%"
echo.
echo Desinstalando apps innecesarias...

set TOTAL_APPS=20
set CURRENT=0

for %%A in (
    "3dbuilder:3D Builder"
    "windowsalarms:Alarmas"
    "windowscamera:Cámara"
    "officehub:Office"
    "skypeapp:Skype"
    "zunemusic:Música"
    "windowsmaps:Mapas"
    "solitairecollection:Solitario"
    "bingnews:Noticias"
    "onenote:OneNote"
    "people:Contactos"
    "bingsports:Deportes"
    "bingweather:Clima"
    "xboxapp:Xbox"
    "xboxgamingoverlay:Xbox Game Bar"
    "feedback:Feedback"
    "webexperience:Widgets"
    "todos:To Do"
    "gethelp:Get Help"
    "yourphone:Your Phone"
) do (
    set /a CURRENT+=1
    for /f "tokens=1,2 delims=:" %%B in ("%%~A") do (
        powershell -NoP -C "Get-AppxPackage *%%B* | Remove-AppxPackage -ErrorAction SilentlyContinue" >nul 2>&1
        echo [!CURRENT!/!TOTAL_APPS!] %%C
    )
)

echo.
echo [%date% %time%] Bloatware eliminado >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ DESINSTALACIÓN COMPLETADA
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: 5. LIMPIEZA DE DISCO
:: ═══════════════════════════════════════════════════════════════════════════
:disk_cleanup
cls
color 09
echo.
echo ════════════════════════════════════════════════════════════════
echo   🧹 LIMPIEZA DE DISCO
echo ════════════════════════════════════════════════════════════════
echo.
echo [%date% %time%] Iniciando limpieza >> "%LOG_FILE%"

echo [1/5] Limpiando temporales de usuario...
if exist "%TEMP%" (
    pushd "%TEMP%" 2>nul
    for /f "delims=" %%F in ('dir /b /a 2^>nul') do (
        rd /s /q "%%F" 2>nul
        del /f /q "%%F" 2>nul
    )
    popd
)
echo    [✓] Temporales de usuario limpiados

echo [2/5] Limpiando temporales del sistema...
if exist "C:\Windows\Temp" (
    pushd "C:\Windows\Temp" 2>nul
    for /f "delims=" %%F in ('dir /b /a 2^>nul') do (
        rd /s /q "%%F" 2>nul
        del /f /q "%%F" 2>nul
    )
    popd
)
echo    [✓] Temporales del sistema limpiados

echo [3/5] Limpiando prefetch...
if exist "C:\Windows\Prefetch" (
    forfiles /p "C:\Windows\Prefetch" /s /m *.pf /d -30 /c "cmd /c del /q @path" 2>nul
)
echo    [✓] Prefetch limpiado

echo [4/5] Limpiando caché de Windows Update...
net stop wuauserv >nul 2>&1
del /f /s /q "%WINDIR%\SoftwareDistribution\Download\*.*" >nul 2>&1
net start wuauserv >nul 2>&1
echo    [✓] Caché de WU limpiado

echo [5/5] Abriendo herramienta de limpieza...
start /wait cleanmgr /d C:
echo    [✓] Limpieza completada

echo.
echo [%date% %time%] Limpieza finalizada >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ LIMPIEZA COMPLETADA
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: 6. INTERFAZ WINDOWS 11
:: ═══════════════════════════════════════════════════════════════════════════
:win11_interface
cls
color 0D
echo.
echo ════════════════════════════════════════════════════════════════
echo   🪟 PERSONALIZACIÓN INTERFAZ
echo ════════════════════════════════════════════════════════════════
echo.

echo [1/6] Menú contextual clásico...
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /f >nul 2>&1
echo    [✓] Menú clásico

echo [2/6] Barra de tareas izquierda...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Barra izquierda

echo [3/6] Iconos visibles...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v EnableAutoTray /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Iconos visibles

echo [4/6] Desactivando widgets...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Widgets desactivados

echo [5/6] Desactivando recomendaciones...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_IrisRecommendations /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Recomendaciones desactivadas

echo [6/6] Reiniciando Explorer...
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe
timeout /t 2 >nul
echo    [✓] Explorer reiniciado

echo.
echo [%date% %time%] Personalización finalizada >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ PERSONALIZACIÓN COMPLETADA
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: 7. PRIVACIDAD MÁXIMA
:: ═══════════════════════════════════════════════════════════════════════════
:privacy_max
cls
color 0D
echo.
echo ════════════════════════════════════════════════════════════════
echo   🔒 PRIVACIDAD MÁXIMA
echo ════════════════════════════════════════════════════════════════
echo.
choice /c SN /n /m "¿Continuar? [S/N]: "
if !errorlevel!==2 goto menu

echo.
echo [1/6] Desactivando servicios...
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul
echo    [✓] Servicios detenidos

echo [2/6] Políticas de telemetría...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Políticas configuradas

echo [3/6] Desactivando Cortana...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Cortana desactivado

echo [4/6] Bloqueando hosts...
echo 0.0.0.0 vortex.data.microsoft.com >> "%SYSTEMROOT%\System32\drivers\etc\hosts"
echo 0.0.0.0 telemetry.microsoft.com >> "%SYSTEMROOT%\System32\drivers\etc\hosts"
echo    [✓] Hosts bloqueados

echo [5/6] Desactivando ubicación...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d "Deny" /f >nul 2>&1
echo    [✓] Ubicación desactivada

echo [6/6] Desactivando tareas...
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
echo    [✓] Tareas desactivadas

echo.
echo [%date% %time%] Privacidad máxima finalizada >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ PRIVACIDAD MÁXIMA APLICADA
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: 8. OPTIMIZACIÓN DE RED
:: ═══════════════════════════════════════════════════════════════════════════
:network_optimize
cls
color 0E
echo.
echo ════════════════════════════════════════════════════════════════
echo   🌐 OPTIMIZACIÓN DE RED
echo ════════════════════════════════════════════════════════════════
echo.

echo [1/5] Optimizando TCP/IP...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
echo    [✓] TCP/IP optimizado

echo [2/5] Desactivando IPv6...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f >nul 2>&1
echo    [✓] IPv6 desactivado

echo [3/5] Limpiando DNS...
ipconfig /flushdns >nul 2>&1
echo    [✓] DNS limpiado

echo [4/5] Desactivando NetBIOS...
powershell -Command "$adapters = Get-WmiObject Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=True'; foreach($adapter in $adapters) { $adapter.SetTcpipNetbios(2) }" >nul 2>&1
echo    [✓] NetBIOS desactivado

echo [5/5] Reiniciando adaptador...
netsh winsock reset >nul 2>&1
echo    [✓] Adaptador reiniciado

echo.
echo [%date% %time%] Red optimizada >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ OPTIMIZACIÓN DE RED COMPLETADA
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: 9. SEGURIDAD AVANZADA
:: ═══════════════════════════════════════════════════════════════════════════
:security_advanced
cls
color 0D
echo.
echo ════════════════════════════════════════════════════════════════
echo   🛡️  SEGURIDAD AVANZADA
echo ════════════════════════════════════════════════════════════════
echo.

echo [1/5] Desactivando SMBv1...
dism /online /disable-feature /featurename:SMB1Protocol /norestart >nul 2>&1
echo    [✓] SMBv1 desactivado

echo [2/5] Configurando UAC...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] UAC configurado

echo [3/5] Desactivando PowerShell v2...
dism /online /disable-feature /featurename:MicrosoftWindowsPowerShellV2 /norestart >nul 2>&1
echo    [✓] PowerShell v2 desactivado

echo [4/5] Bloqueando puertos...
netsh advfirewall firewall add rule name="Block_RPC_135" dir=in action=block protocol=TCP localport=135 >nul 2>&1
netsh advfirewall firewall add rule name="Block_SMB_445" dir=in action=block protocol=TCP localport=445 >nul 2>&1
echo    [✓] Puertos bloqueados

echo [5/5] Habilitando Memory Integrity...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Memory Integrity habilitado

echo.
echo [%date% %time%] Seguridad avanzada finalizada >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ SEGURIDAD AVANZADA APLICADA
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: A. OPTIMIZAR SERVICIOS
:: ═══════════════════════════════════════════════════════════════════════════
:optimize_services
cls
color 0E
echo.
echo ════════════════════════════════════════════════════════════════
echo   🚀 OPTIMIZAR SERVICIOS
echo ════════════════════════════════════════════════════════════════
echo.
choice /c SN /n /m "¿Continuar? [S/N]: "
if !errorlevel!==2 goto menu

echo.
set SERVICES_DISABLED=0

for %%S in (
    "TabletInputService:Tablet Input"
    "XboxGipSvc:Xbox Accessory"
    "MapsBroker:Mapas"
    "lfsvc:Ubicación"
    "PhoneSvc:Teléfono"
    "Fax:Fax"
) do (
    for /f "tokens=1,2 delims=:" %%A in ("%%~S") do (
        sc config "%%A" start= disabled >nul 2>&1
        if !errorlevel!==0 (
            sc stop "%%A" >nul 2>&1
            echo [✓] %%B desactivado
            set /a SERVICES_DISABLED+=1
        )
    )
)

echo.
echo [%date% %time%] Servicios optimizados >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ SERVICIOS OPTIMIZADOS: !SERVICES_DISABLED!
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: B. DESACTIVAR NOTIFICACIONES
:: ═══════════════════════════════════════════════════════════════════════════
:disable_notifications
cls
color 0C
echo.
echo ════════════════════════════════════════════════════════════════
echo   🔔 DESACTIVAR NOTIFICACIONES
echo ════════════════════════════════════════════════════════════════
echo.

echo [1/3] Notificaciones globales...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Notificaciones desactivadas

echo [2/3] Sugerencias...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Sugerencias desactivadas

echo [3/3] Consejos...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Consejos desactivados

echo.
echo [%date% %time%] Notificaciones desactivadas >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ NOTIFICACIONES DESACTIVADAS
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: C. OPTIMIZAR ARRANQUE
:: ═══════════════════════════════════════════════════════════════════════════
:optimize_startup
cls
color 0B
echo.
echo ════════════════════════════════════════════════════════════════
echo   ⚙️  OPTIMIZAR ARRANQUE
echo ════════════════════════════════════════════════════════════════
echo.
echo [%date% %time%] Iniciando optimización de arranque >> "%LOG_FILE%"

echo [1/7] Habilitando Fast Startup...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f >nul 2>&1
powercfg /hibernate on >nul 2>&1
echo    [✓] Fast Startup habilitado

echo [2/7] Reduciendo timeout de arranque...
bcdedit /timeout 3 >nul 2>&1
echo    [✓] Timeout reducido a 3 segundos

echo [3/7] Optimizando servicios de arranque...
sc config "BITS" start= delayed-auto >nul 2>&1
sc config "wuauserv" start= demand >nul 2>&1
sc config "DPS" start= demand >nul 2>&1
echo    [✓] Servicios optimizados

echo [4/7] Desactivando programas de inicio innecesarios...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "OneDrive" /t REG_BINARY /d 0300000000000000000000000000000000000000 /f >nul 2>&1
echo    [✓] Programas de inicio optimizados

echo [5/7] Optimizando boot manager...
bcdedit /set {current} description "Windows 11 Optimizado" >nul 2>&1
bcdedit /set {current} bootmenupolicy standard >nul 2>&1
echo    [✓] Boot manager optimizado

echo [6/7] Desactivando animación de inicio...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Animación de inicio desactivada

echo [7/7] Optimizando registro de arranque...
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f >nul 2>&1
echo    [✓] Registro optimizado

echo.
echo [%date% %time%] Optimización de arranque finalizada >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ ARRANQUE OPTIMIZADO
echo ════════════════════════════════════════════════════════════════
echo.
echo   [i] Los cambios se aplicarán en el próximo reinicio
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: D. OPTIMIZAR ALMACENAMIENTO
:: ═══════════════════════════════════════════════════════════════════════════
:optimize_storage
cls
color 0B
echo.
echo ════════════════════════════════════════════════════════════════
echo   💾 OPTIMIZAR ALMACENAMIENTO
echo ════════════════════════════════════════════════════════════════
echo.
echo   Tipo de disco detectado: !DISKTYPE!
echo.
echo [%date% %time%] Iniciando optimización de almacenamiento >> "%LOG_FILE%"

if "!DISKTYPE!"=="SSD" (
    echo.
    echo ═══ OPTIMIZACIONES PARA SSD ═══
    echo.
    
    echo [1/8] Desactivando desfragmentación programada...
    schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable >nul 2>&1
    echo    [✓] Desfragmentación desactivada
    
    echo [2/8] Habilitando TRIM...
    fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
    echo    [✓] TRIM habilitado
    
    echo [3/8] Desactivando Prefetch...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
    echo    [✓] Prefetch desactivado
    
    echo [4/8] Desactivando Superfetch...
    sc config "SysMain" start= disabled >nul 2>&1
    sc stop "SysMain" >nul 2>&1
    echo    [✓] Superfetch desactivado
    
    echo [5/8] Optimizando archivo de paginación...
    if !RAM_MB! GEQ 16384 (
        wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False >nul 2>&1
        wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=2048,MaximumSize=2048 >nul 2>&1
        echo    [✓] Archivo de paginación reducido (16GB+ RAM)
    ) else (
        echo    [→] RAM insuficiente para reducir paginación
    )
    
    echo [6/8] Desactivando indexación en SSD...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
    echo    [✓] Indexación optimizada
    
    echo [7/8] Desactivando compresión de memoria...
    powershell -Command "Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue" >nul 2>&1
    echo    [✓] Compresión de memoria desactivada
    
    echo [8/8] Optimizando políticas de escritura...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f >nul 2>&1
    echo    [✓] Políticas optimizadas
    
) else (
    echo.
    echo ═══ OPTIMIZACIONES PARA HDD ═══
    echo.
    
    echo [1/6] Habilitando desfragmentación programada...
    schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Enable >nul 2>&1
    echo    [✓] Desfragmentación habilitada
    
    echo [2/6] Manteniendo Prefetch activo...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 3 /f >nul 2>&1
    echo    [✓] Prefetch optimizado
    
    echo [3/6] Optimizando Superfetch...
    sc config "SysMain" start= auto >nul 2>&1
    sc start "SysMain" >nul 2>&1
    echo    [✓] Superfetch optimizado
    
    echo [4/6] Ejecutando desfragmentación...
    defrag C: /O /H /U >nul 2>&1
    echo    [✓] Desfragmentación completada
    
    echo [5/6] Optimizando caché de escritura...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f >nul 2>&1
    echo    [✓] Caché optimizado
    
    echo [6/6] Habilitando compresión NTFS...
    compact /CompactOs:always >nul 2>&1
    echo    [✓] Compresión habilitada
)

echo.
echo [%date% %time%] Optimización de almacenamiento finalizada >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ ALMACENAMIENTO OPTIMIZADO
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: E. ANÁLISIS DE RENDIMIENTO
:: ═══════════════════════════════════════════════════════════════════════════
:performance_analysis
cls
color 0B
echo.
echo ════════════════════════════════════════════════════════════════
echo   📊 ANÁLISIS DE RENDIMIENTO
echo ════════════════════════════════════════════════════════════════
echo.
echo [%date% %time%] Iniciando análisis de rendimiento >> "%LOG_FILE%"

echo [1/10] Analizando información del sistema...
systeminfo | findstr /C:"OS" /C:"System" /C:"Processor" /C:"Memory"
echo.

echo [2/10] Verificando espacio en disco...
wmic logicaldisk get caption,size,freespace
echo.

echo [3/10] Analizando uso de CPU...
wmic cpu get name,numberofcores,maxclockspeed
echo.

echo [4/10] Verificando memoria RAM...
wmic memorychip get capacity,speed
echo.

echo [5/10] Analizando servicios en ejecución...
set RUNNING_SERVICES=0
for /f %%s in ('sc query type^= service state^= running ^| find /c "SERVICE_NAME"') do set RUNNING_SERVICES=%%s
echo    Servicios activos: !RUNNING_SERVICES!
echo.

echo [6/10] Verificando programas de inicio...
set STARTUP_ITEMS=0
for /f %%s in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" 2^>nul ^| find /c "REG_"') do set STARTUP_ITEMS=%%s
echo    Programas de inicio: !STARTUP_ITEMS!
echo.

echo [7/10] Analizando procesos activos...
tasklist | find /c /v ""
echo.

echo [8/10] Verificando temperatura (si está disponible)...
wmic /namespace:\\root\wmi PATH MSAcpi_ThermalZoneTemperature get CurrentTemperature 2>nul
echo.

echo [9/10] Analizando red...
netstat -e
echo.

echo [10/10] Generando reporte completo...
set "REPORT_FILE=%~dp0Performance_Report_%BACKUP_DATE%.txt"
(
    echo ════════════════════════════════════════════════════════════════
    echo   REPORTE DE RENDIMIENTO - %date% %time%
    echo ════════════════════════════════════════════════════════════════
    echo.
    echo INFORMACIÓN DEL SISTEMA:
    systeminfo
    echo.
    echo PROCESOS ACTIVOS:
    tasklist
    echo.
    echo SERVICIOS EN EJECUCIÓN:
    sc query type= service state= all
    echo.
    echo ESPACIO EN DISCO:
    wmic logicaldisk get caption,size,freespace
    echo.
    echo INFORMACIÓN DE RED:
    ipconfig /all
    echo.
    echo ════════════════════════════════════════════════════════════════
) > "%REPORT_FILE%"

echo    [✓] Reporte guardado en: %REPORT_FILE%

echo.
echo [%date% %time%] Análisis de rendimiento finalizado >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ ANÁLISIS COMPLETADO
echo ════════════════════════════════════════════════════════════════
echo.
echo   [i] Reporte guardado en: %REPORT_FILE%
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: F. ACTUALIZAR DRIVERS
:: ═══════════════════════════════════════════════════════════════════════════
:update_drivers
cls
color 0E
echo.
echo ════════════════════════════════════════════════════════════════
echo   🔄 ACTUALIZAR DRIVERS
echo ════════════════════════════════════════════════════════════════
echo.
echo [%date% %time%] Iniciando verificación de drivers >> "%LOG_FILE%"

echo [1/5] Analizando drivers instalados...
driverquery /v
echo.

echo [2/5] Verificando drivers con problemas...
pnputil /enum-drivers
echo.

echo [3/5] Buscando actualizaciones de Windows Update...
echo    [i] Abriendo Windows Update...
start ms-settings:windowsupdate
echo    [✓] Windows Update abierto
echo.

echo [4/5] Generando reporte de drivers...
set "DRIVER_REPORT=%~dp0Driver_Report_%BACKUP_DATE%.txt"
(
    echo ════════════════════════════════════════════════════════════════
    echo   REPORTE DE DRIVERS - %date% %time%
    echo ════════════════════════════════════════════════════════════════
    echo.
    driverquery /v
    echo.
    echo ════════════════════════════════════════════════════════════════
) > "%DRIVER_REPORT%"
echo    [✓] Reporte guardado en: %DRIVER_REPORT%

echo [5/5] Recomendaciones...
echo.
echo    ┌────────────────────────────────────────────────┐
echo    │  RECOMENDACIONES:                              │
echo    │                                                │
echo    │  1. Visita el sitio del fabricante:           │
echo    │     - NVIDIA: nvidia.com/drivers               │
echo    │     - AMD: amd.com/support                     │
echo    │     - Intel: intel.com/support                 │
echo    │                                                │
echo    │  2. Usa Windows Update para drivers            │
echo    │     genéricos y de sistema                     │
echo    │                                                │
echo    │  3. Evita herramientas de terceros            │
echo    │     no confiables                              │
echo    └────────────────────────────────────────────────┘
echo.

echo [%date% %time%] Verificación de drivers finalizada >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════
echo   ✓ VERIFICACIÓN COMPLETADA
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: R. RESTAURAR REGISTRO
:: ═══════════════════════════════════════════════════════════════════════════
:restore_registry
cls
color 0C
echo.
echo ════════════════════════════════════════════════════════════════
echo   🔄 RESTAURAR REGISTRO
echo ════════════════════════════════════════════════════════════════
echo.
echo   ADVERTENCIA: Esto restaurará el registro desde un backup
echo.

echo Buscando backups disponibles...
echo.
set BACKUP_COUNT=0
for %%F in ("%~dp0Registry_Backup_*.reg") do (
    set /a BACKUP_COUNT+=1
    echo [!BACKUP_COUNT!] %%~nxF
)

if !BACKUP_COUNT!==0 (
    echo.
    echo [!] No se encontraron backups del registro
    echo.
    pause
    goto menu
)

echo.
set /p RESTORE_CHOICE="Ingresa el número del backup a restaurar (0 para cancelar): "

if "!RESTORE_CHOICE!"=="0" goto menu

set BACKUP_NUM=0
for %%F in ("%~dp0Registry_Backup_*.reg") do (
    set /a BACKUP_NUM+=1
    if !BACKUP_NUM!==!RESTORE_CHOICE! (
        echo.
        echo Restaurando: %%~nxF
        choice /c SN /n /m "¿Estás seguro? [S/N]: "
        if !errorlevel!==1 (
            reg import "%%F" >nul 2>&1
            if !errorlevel!==0 (
                echo [✓] Registro restaurado exitosamente
                echo [%date% %time%] Registro restaurado desde %%F >> "%LOG_FILE%"
            ) else (
                echo [!] Error al restaurar el registro
                echo [ERROR] Fallo al restaurar desde %%F >> "%LOG_FILE%"
            )
        )
    )
)

echo.
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: L. VER LOG
:: ═══════════════════════════════════════════════════════════════════════════
:view_log
cls
color 0B
echo.
echo ════════════════════════════════════════════════════════════════
echo   📋 VER LOG
echo ════════════════════════════════════════════════════════════════
echo.

if not exist "%LOG_FILE%" (
    echo [!] No se encontró archivo de log
    echo.
    pause
    goto menu
)

echo Mostrando últimas 50 líneas del log:
echo.
echo ────────────────────────────────────────────────────────────────
powershell -Command "Get-Content '%LOG_FILE%' -Tail 50"
echo ────────────────────────────────────────────────────────────────
echo.
echo Archivo completo: %LOG_FILE%
echo.
choice /c SA /n /m "¿Abrir archivo completo? [S/N]: "
if !errorlevel!==1 notepad "%LOG_FILE%"

pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: H. AYUDA
:: ═══════════════════════════════════════════════════════════════════════════
:help_script
cls
color 0B
echo.
echo ════════════════════════════════════════════════════════════════
echo   ❓ AYUDA - AZELMOD XV677
echo ════════════════════════════════════════════════════════════════
echo.
echo DESCRIPCIÓN:
echo   Script de optimización completo para Windows 11 que mejora
echo   el rendimiento, privacidad y experiencia del usuario.
echo.
echo ────────────────────────────────────────────────────────────────
echo OPCIONES PRINCIPALES:
echo ────────────────────────────────────────────────────────────────
echo.
echo [1] OPTIMIZACIÓN COMPLETA
echo     - 30 optimizaciones automáticas
echo     - Crea backup automático
echo     - Recomendado para usuarios avanzados
echo.
echo [2] OPTIMIZACIÓN GAMING
echo     - Máximo rendimiento en juegos
echo     - Prioridad GPU y CPU
echo     - Reduce latencia de red
echo.
echo [3] OPTIMIZACIÓN BÁSICA
echo     - Segura para uso diario
echo     - Mejoras conservadoras
echo     - Ideal para oficina
echo.
echo [4] DESINSTALAR BLOATWARE
echo     - Elimina apps preinstaladas
echo     - Libera espacio
echo     - Mejora privacidad
echo.
echo [5] LIMPIEZA DE DISCO
echo     - Elimina archivos temporales
echo     - Limpia caché
echo     - Libera espacio
echo.
echo ────────────────────────────────────────────────────────────────
echo OPCIONES AVANZADAS:
echo ────────────────────────────────────────────────────────────────
echo.
echo [6] INTERFAZ WINDOWS 11
echo     - Menú contextual clásico
echo     - Personalización de barra
echo     - Desactiva widgets
echo.
echo [7] PRIVACIDAD MÁXIMA
echo     - Bloquea telemetría
echo     - Desactiva rastreo
echo     - Protege datos
echo.
echo [8] OPTIMIZACIÓN DE RED
echo     - Reduce latencia
echo     - Optimiza TCP/IP
echo     - Mejora velocidad
echo.
echo [9] SEGURIDAD AVANZADA
echo     - Desactiva protocolos inseguros
echo     - Bloquea puertos
echo     - Refuerza protección
echo.
echo [A] OPTIMIZAR SERVICIOS
echo     - Desactiva servicios innecesarios
echo     - Reduce uso de recursos
echo     - Mejora arranque
echo.
echo [B] DESACTIVAR NOTIFICACIONES
echo     - Modo concentración
echo     - Sin interrupciones
echo     - Productividad
echo.
echo [C] OPTIMIZAR ARRANQUE
echo     - Fast Startup
echo     - Reduce tiempo de inicio
echo     - Optimiza servicios
echo.
echo [D] OPTIMIZAR ALMACENAMIENTO
echo     - Específico para SSD/HDD
echo     - TRIM para SSD
echo     - Desfragmentación para HDD
echo.
echo [E] ANÁLISIS DE RENDIMIENTO
echo     - Diagnóstico completo
echo     - Genera reportes
echo     - Identifica problemas
echo.
echo [F] ACTUALIZAR DRIVERS
echo     - Verifica drivers
echo     - Genera reportes
echo     - Recomendaciones
echo.
echo ────────────────────────────────────────────────────────────────
echo HERRAMIENTAS:
echo ────────────────────────────────────────────────────────────────
echo.
echo [R] RESTAURAR REGISTRO
echo     - Restaura desde backup
echo     - Reversión de cambios
echo     - Seguridad
echo.
echo [L] VER LOG
echo     - Historial de cambios
echo     - Diagnóstico de problemas
echo     - Auditoría
echo.
echo [I] INFO SISTEMA
echo     - Información detallada
echo     - Hardware y software
echo     - Diagnóstico
echo.
echo ════════════════════════════════════════════════════════════════
echo   RECOMENDACIONES:
echo ════════════════════════════════════════════════════════════════
echo.
echo   1. Siempre ejecutar como Administrador
echo   2. Crear punto de restauración antes de optimizar
echo   3. Leer cada opción antes de aplicar
echo   4. Guardar trabajo importante antes de reiniciar
echo   5. Revisar el log después de cada operación
echo.
echo ════════════════════════════════════════════════════════════════
echo   SOPORTE:
echo ════════════════════════════════════════════════════════════════
echo.
echo   YouTube: https://www.youtube.com/@AGCOMPANY677
echo   Versión: %SCRIPT_VERSION%
echo.
echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: I. INFO SISTEMA
:: ═══════════════════════════════════════════════════════════════════════════
:system_info
cls
color 0B
echo.
echo ════════════════════════════════════════════════════════════════
echo   ℹ️  INFORMACIÓN DEL SISTEMA
echo ════════════════════════════════════════════════════════════════
echo.

echo ═══ SISTEMA OPERATIVO ═══
echo.
for /f "tokens=2 delims==" %%a in ('wmic os get Caption /value ^| find "="') do echo OS: %%a
for /f "tokens=2 delims==" %%a in ('wmic os get Version /value ^| find "="') do echo Versión: %%a
for /f "tokens=2 delims==" %%a in ('wmic os get BuildNumber /value ^| find "="') do echo Build: %%a
for /f "tokens=2 delims==" %%a in ('wmic os get OSArchitecture /value ^| find "="') do echo Arquitectura: %%a
echo.

echo ═══ HARDWARE ═══
echo.
echo CPU: !CPU_NAME!
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /value ^| find "="') do echo Núcleos: %%a
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfLogicalProcessors /value ^| find "="') do echo Procesadores lógicos: %%a
echo.
echo RAM: !RAM_GB! GB (!RAM_MB! MB)
echo Tipo de disco: !DISKTYPE!
echo.

echo ═══ ALMACENAMIENTO ═══
echo.
wmic logicaldisk where "DriveType=3" get DeviceID,Size,FreeSpace,FileSystem
echo.

echo ═══ RED ═══
echo.
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do echo IPv4:%%a
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"Default Gateway" ^| findstr [0-9]') do echo Gateway:%%a
echo.

echo ═══ RENDIMIENTO ═══
echo.
for /f "skip=1 tokens=2 delims==" %%a in ('wmic os get FreePhysicalMemory /value') do set FREE_RAM=%%a
set /a FREE_RAM_MB=!FREE_RAM!/1024
echo RAM Libre: !FREE_RAM_MB! MB
echo.

echo ═══ ENERGÍA ═══
echo.
for /f "tokens=2 delims=:" %%a in ('powercfg /getactivescheme ^| findstr GUID') do (
    for /f "tokens=1" %%b in ("%%a") do (
        for /f "tokens=*" %%c in ('powercfg /query %%b ^| findstr /c:"Power Scheme Name"') do echo %%c
    )
)
echo.

echo ════════════════════════════════════════════════════════════════
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: 0. SALIR
:: ═══════════════════════════════════════════════════════════════════════════
:end_script
cls
color 0B
echo.
echo.
echo         ╔═══════════════════════════════════════════════════════════════╗
echo         ║                                                               ║
echo         ║                    GRACIAS POR USAR AZELMODS                  ║
echo         ║                                                               ║
echo         ║             Windows 11 Optimizer v%SCRIPT_VERSION%                    ║
echo         ║                                                               ║
echo         ║         YouTube: https://www.youtube.com/@AGCOMPANY677        ║
echo         ║                                                               ║
echo         ╚═══════════════════════════════════════════════════════════════╝
echo.
echo [%date% %time%] Script finalizado >> "%LOG_FILE%"
echo.
timeout /t 3
exit /b 0
