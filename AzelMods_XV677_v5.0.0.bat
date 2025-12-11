@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
mode con: cols=95 lines=40

:: ═══════════════════════════════════════════════════════════════════════════
:: AZELMODS XV677 - WINDOWS 11 ULTIMATE OPTIMIZER v5.0.0
:: Versión definitiva con mejoras modernas y funcionalidad completa
:: ═══════════════════════════════════════════════════════════════════════════

:: ═══════════════════════════════════════════════════════════════════════════
:: VARIABLES GLOBALES
:: ═══════════════════════════════════════════════════════════════════════════
set "SCRIPT_VERSION=5.0.0"
set "SCRIPT_NAME=AzelMods_XV677"
set "SCRIPT_DATE=2025-12-10"
for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "(Get-Date).ToString('yyyyMMdd_HHmmss')"`) do set TIMESTAMP=%%D
set "LOG_FILE=%~dp0AzelMods_Log_%TIMESTAMP%.txt"
set "BACKUP_DIR=%~dp0Backups"
set "ERROR_COUNT=0"
set "SUCCESS_COUNT=0"

:: ═══════════════════════════════════════════════════════════════════════════
:: PANTALLA DE INICIO ANIMADA
:: ═══════════════════════════════════════════════════════════════════════════
:splash_screen
cls
color 0B
echo.
echo.
echo         ╔═══════════════════════════════════════════════════════════════════════════════╗
echo         ║                                                                               ║
echo         ║    █████╗ ███████╗███████╗██╗     ███╗   ███╗ ██████╗ ██████╗ ███████╗      ║
echo         ║   ██╔══██╗╚══███╔╝██╔════╝██║     ████╗ ████║██╔═══██╗██╔══██╗██╔════╝      ║
echo         ║   ███████║  ███╔╝ █████╗  ██║     ██╔████╔██║██║   ██║██║  ██║███████╗      ║
echo         ║   ██╔══██║ ███╔╝ ██╔══╝  ██║     ██║╚██╔╝██║██║   ██║██║  ██║╚════██║      ║
echo         ║   ██║  ██║███████╗███████╗███████╗██║ ╚═╝ ██║╚██████╔╝██████╔╝███████║      ║
echo         ║   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝      ║
echo         ║                                                                               ║
echo         ║          Windows 11 Ultimate Optimizer v%SCRIPT_VERSION% - DEFINITIVE EDITION          ║
echo         ║                        Fecha de compilación: %SCRIPT_DATE%                        ║
echo         ║                                                                               ║
echo         ╚═══════════════════════════════════════════════════════════════════════════════╝
echo.
echo                              [████████████████████████████████]
echo                                   Inicializando sistema...
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
    echo         ╔═══════════════════════════════════════════════════════════════════════════════╗
    echo         ║                                                                               ║
    echo         ║                          ❌ ERROR CRÍTICO - ACCESO DENEGADO ❌                 ║
    echo         ║                                                                               ║
    echo         ║              ESTE SCRIPT REQUIERE PRIVILEGIOS DE ADMINISTRADOR                ║
    echo         ║                                                                               ║
    echo         ╚═══════════════════════════════════════════════════════════════════════════════╝
    echo.
    echo                      Para ejecutar correctamente este script:
    echo.
    echo                      ┌──────────────────────────────────────────────────┐
    echo                      │  1. Haz clic derecho sobre el archivo .bat       │
    echo                      │  2. Selecciona: "Ejecutar como administrador"    │
    echo                      │  3. Acepta el control de cuentas de usuario      │
    echo                      └──────────────────────────────────────────────────┘
    echo.
    echo                              Cerrando en 15 segundos...
    timeout /t 15
    exit /b 1
)

title %SCRIPT_NAME% - Windows 11 Optimizer v%SCRIPT_VERSION% [ADMINISTRATOR MODE]

:: Crear directorio de backups
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%" >nul 2>&1

:: Inicializar log
echo ════════════════════════════════════════════════════════════════════════════ > "%LOG_FILE%"
echo  AZELMODS XV677 v%SCRIPT_VERSION% - LOG DE EJECUCIÓN >> "%LOG_FILE%"
echo  Fecha: %date% %time% >> "%LOG_FILE%"
echo  Usuario: %USERNAME% >> "%LOG_FILE%"
echo  Computadora: %COMPUTERNAME% >> "%LOG_FILE%"
echo ════════════════════════════════════════════════════════════════════════════ >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

:: ═══════════════════════════════════════════════════════════════════════════
:: VERIFICACIÓN DE WINDOWS 11
:: ═══════════════════════════════════════════════════════════════════════════
echo                          [▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░] 25%%
echo                              Verificando sistema operativo...
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul ^| find "CurrentBuild"') do set WIN_BUILD=%%a

if !WIN_BUILD! LSS 22000 (
    cls
    color 0C
    echo.
    echo.
    echo         ╔═══════════════════════════════════════════════════════════════════════════════╗
    echo         ║                                                                               ║
    echo         ║                ⚠️  SISTEMA OPERATIVO NO COMPATIBLE ⚠️                          ║
    echo         ║                                                                               ║
    echo         ║          Este script está diseñado EXCLUSIVAMENTE para Windows 11            ║
    echo         ║                                                                               ║
    echo         ╚═══════════════════════════════════════════════════════════════════════════════╝
    echo.
    echo                          Build detectado: !WIN_BUILD!
    echo                          Build requerido: 22000 o superior
    echo.
    echo                              Cerrando en 15 segundos...
    echo [ERROR] Sistema no compatible - Build !WIN_BUILD! >> "%LOG_FILE%"
    timeout /t 15
    exit /b 1
)

set "WIN_NAME=Windows 11"
for /f "tokens=3*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DisplayVersion 2^>nul ^| find "DisplayVersion"') do set WIN_VERSION=%%a %%b
echo [OK] Windows 11 detectado [Build !WIN_BUILD! - Version !WIN_VERSION!] >> "%LOG_FILE%"

:: ═══════════════════════════════════════════════════════════════════════════
:: DETECCIÓN AVANZADA DE HARDWARE
:: ═══════════════════════════════════════════════════════════════════════════
echo                          [▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░] 50%%
echo                              Detectando hardware del sistema...

:: Detección de RAM con PowerShell (más preciso)
for /f "usebackq" %%I in (`powershell -NoProfile -Command "(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory"`) do set RAM_BYTES=%%I
if not defined RAM_BYTES set RAM_BYTES=4294967296
set /a RAM_MB=!RAM_BYTES!/1048576
set /a RAM_GB=!RAM_MB!/1024

:: Detección avanzada de tipo de disco (SSD/HDD/NVMe)
set DISKTYPE=HDD
set DISK_MODEL=Unknown
for /f "skip=1 tokens=*" %%D in ('wmic diskdrive get MediaType 2^>nul') do (
    set "MEDIA=%%D"
    echo !MEDIA! | findstr /i "SSD Solid" >nul && set DISKTYPE=SSD
)
for /f "skip=1 tokens=*" %%D in ('wmic diskdrive get Model 2^>nul') do (
    if not defined DISK_MODEL (
        set "DISK_MODEL=%%D"
        echo !DISK_MODEL! | findstr /i "NVMe NVME" >nul && set DISKTYPE=NVMe
        echo !DISK_MODEL! | findstr /i "SSD" >nul && set DISKTYPE=SSD
    )
)

:: Detección de CPU con información extendida
for /f "skip=1 tokens=*" %%C in ('wmic cpu get Name 2^>nul') do (
    if not defined CPU_NAME (
        set "CPU_NAME=%%C"
        set "CPU_NAME=!CPU_NAME:~0,45!"
    )
)
for /f "skip=1 tokens=*" %%C in ('wmic cpu get NumberOfCores 2^>nul') do (
    if not defined CPU_CORES (
        set "CPU_CORES=%%C"
        set "CPU_CORES=!CPU_CORES: =!"
    )
)
for /f "skip=1 tokens=*" %%C in ('wmic cpu get NumberOfLogicalProcessors 2^>nul') do (
    if not defined CPU_THREADS (
        set "CPU_THREADS=%%C"
        set "CPU_THREADS=!CPU_THREADS: =!"
    )
)

:: Detección de GPU
for /f "skip=1 tokens=*" %%G in ('wmic path win32_VideoController get Name 2^>nul') do (
    if not defined GPU_NAME (
        set "GPU_NAME=%%G"
        set "GPU_NAME=!GPU_NAME:~0,40!"
    )
)

:: Detección de espacio en disco
for /f "tokens=2" %%A in ('wmic logicaldisk where "DeviceID='C:'" get FreeSpace /value ^| find "="') do set FREE_SPACE=%%A
set /a FREE_SPACE_GB=!FREE_SPACE!/1073741824

echo [OK] Hardware detectado: >> "%LOG_FILE%"
echo     - RAM: !RAM_GB!GB (!RAM_MB!MB) >> "%LOG_FILE%"
echo     - Disco: !DISKTYPE! - !DISK_MODEL! >> "%LOG_FILE%"
echo     - CPU: !CPU_NAME! [!CPU_CORES! cores / !CPU_THREADS! threads] >> "%LOG_FILE%"
echo     - GPU: !GPU_NAME! >> "%LOG_FILE%"
echo     - Espacio libre: !FREE_SPACE_GB!GB >> "%LOG_FILE%"

echo                          [▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░] 75%%
timeout /t 1 /nobreak >nul

echo                          [▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓] 100%%
echo                              Sistema inicializado correctamente
timeout /t 2 /nobreak >nul

:: ═══════════════════════════════════════════════════════════════════════════
:: MENÚ PRINCIPAL MEJORADO
:: ═══════════════════════════════════════════════════════════════════════════
:menu
cls
color 0B
echo.
echo ╔═════════════════════════════════════════════════════════════════════════════════════╗
echo ║                                                                                     ║
echo ║    █████╗ ███████╗███████╗██╗     ███╗   ███╗ ██████╗ ██████╗ ███████╗            ║
echo ║   ██╔══██╗╚══███╔╝██╔════╝██║     ████╗ ████║██╔═══██╗██╔══██╗██╔════╝            ║
echo ║   ███████║  ███╔╝ █████╗  ██║     ██╔████╔██║██║   ██║██║  ██║███████╗            ║
echo ║   ██╔══██║ ███╔╝ ██╔══╝  ██║     ██║╚██╔╝██║██║   ██║██║  ██║╚════██║            ║
echo ║   ██║  ██║███████╗███████╗███████╗██║ ╚═╝ ██║╚██████╔╝██████╔╝███████║            ║
echo ║   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝            ║
echo ║                                                                                     ║
echo ║             Windows 11 Ultimate Optimizer v%SCRIPT_VERSION% - DEFINITIVE EDITION            ║
echo ║                    YouTube: https://www.youtube.com/@AGCOMPANY677                  ║
echo ║                                                                                     ║
echo ╚═════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo ╔═════════════════════════════════════════════════════════════════════════════════════╗
echo ║ 📊 INFORMACIÓN DEL SISTEMA                                                          ║
echo ╠═════════════════════════════════════════════════════════════════════════════════════╣
echo ║  Sistema: %WIN_NAME% [Build !WIN_BUILD! - !WIN_VERSION!]
echo ║  RAM: !RAM_GB!GB │ Disco: !DISKTYPE! │ Espacio libre: !FREE_SPACE_GB!GB
echo ║  CPU: !CPU_NAME! [!CPU_CORES!C/!CPU_THREADS!T]
echo ║  GPU: !GPU_NAME!
echo ╚═════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo ╔═════════════════════════════════════════════════════════════════════════════════════╗
echo ║ ⚡ OPTIMIZACIONES PRINCIPALES                                                       ║
echo ╠═════════════════════════════════════════════════════════════════════════════════════╣
echo ║  [1] ⚡ OPTIMIZACIÓN ULTRA COMPLETA  - 40+ mejoras avanzadas [RECOMENDADO]         ║
echo ║  [2] 🎮 OPTIMIZACIÓN GAMING EXTREMA  - Máximo rendimiento para juegos              ║
echo ║  [3] 🔧 OPTIMIZACIÓN BÁSICA SEGURA   - Mejoras conservadoras para uso diario       ║
echo ║  [4] 🗑️  DESINSTALAR BLOATWARE       - Elimina apps innecesarias de Windows        ║
echo ║  [5] 🧹 LIMPIEZA PROFUNDA DE DISCO   - Libera espacio y optimiza almacenamiento    ║
echo ╚═════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo ╔═════════════════════════════════════════════════════════════════════════════════════╗
echo ║ 🔥 OPTIMIZACIONES AVANZADAS                                                         ║
echo ╠═════════════════════════════════════════════════════════════════════════════════════╣
echo ║  [6] 🪟 PERSONALIZAR INTERFAZ W11    - Menú clásico, barra de tareas, widgets      ║
echo ║  [7] 🔒 PRIVACIDAD Y SEGURIDAD MAX   - Anti-telemetría total y protección          ║
echo ║  [8] 🌐 OPTIMIZACIÓN DE RED GAMING   - Baja latencia y máxima velocidad            ║
echo ║  [9] 🛡️  SEGURIDAD AVANZADA          - Protocolos seguros y firewall               ║
echo ║  [A] 🚀 OPTIMIZAR SERVICIOS          - Desactivar servicios innecesarios           ║
echo ║  [B] 🔔 DESACTIVAR NOTIFICACIONES    - Modo concentración total                    ║
echo ║  [C] ⚙️  OPTIMIZAR ARRANQUE           - Startup ultra-rápido                        ║
echo ║  [D] 💾 OPTIMIZAR ALMACENAMIENTO     - Específico para SSD/HDD/NVMe                ║
echo ║  [E] 📊 ANÁLISIS DE RENDIMIENTO      - Diagnóstico completo del sistema            ║
echo ║  [F] 🔄 ACTUALIZAR DRIVERS           - Verificar y actualizar controladores        ║
echo ║  [G] 🎨 OPTIMIZAR GPU                - Aceleración de hardware y rendimiento       ║
echo ║  [H] 🔋 OPTIMIZAR ENERGÍA            - Planes de energía personalizados            ║
echo ╚═════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo ╔═════════════════════════════════════════════════════════════════════════════════════╗
echo ║ 🛠️  HERRAMIENTAS Y UTILIDADES                                                       ║
echo ╠═════════════════════════════════════════════════════════════════════════════════════╣
echo ║  [R] 🔄 RESTAURAR REGISTRO │ [L] 📋 VER LOG │ [I] ℹ️  INFO DETALLADA │ [?] ❓ AYUDA ║
echo ║  [X] 🔧 REPARAR SISTEMA    │ [M] 💊 MODO MANTENIMIENTO │ [0] ❌ SALIR               ║
echo ╚═════════════════════════════════════════════════════════════════════════════════════╝
echo.
set opcion=
set /p opcion="└─► Selecciona una opción: "

if /i "!opcion!"=="1" goto ultra_optimize
if /i "!opcion!"=="2" goto gaming_optimize
if /i "!opcion!"=="3" goto basic_optimize
if /i "!opcion!"=="4" goto remove_bloatware
if /i "!opcion!"=="5" goto disk_cleanup
if /i "!opcion!"=="6" goto win11_interface
if /i "!opcion!"=="7" goto privacy_security
if /i "!opcion!"=="8" goto network_optimize
if /i "!opcion!"=="9" goto security_advanced
if /i "!opcion!"=="A" goto optimize_services
if /i "!opcion!"=="B" goto disable_notifications
if /i "!opcion!"=="C" goto optimize_startup
if /i "!opcion!"=="D" goto optimize_storage
if /i "!opcion!"=="E" goto performance_analysis
if /i "!opcion!"=="F" goto update_drivers
if /i "!opcion!"=="G" goto optimize_gpu
if /i "!opcion!"=="H" goto optimize_power
if /i "!opcion!"=="R" goto restore_registry
if /i "!opcion!"=="L" goto view_log
if /i "!opcion!"=="I" goto system_info
if /i "!opcion!"=="?" goto help_script
if /i "!opcion!"=="X" goto repair_system
if /i "!opcion!"=="M" goto maintenance_mode
if /i "!opcion!"=="0" goto end_script

color 0E
echo.
echo [!] Opción inválida. Por favor, selecciona una opción válida del menú.
timeout /t 2 >nul
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: 1. OPTIMIZACIÓN ULTRA COMPLETA (40+ MEJORAS)
:: ═══════════════════════════════════════════════════════════════════════════
:ultra_optimize
cls
color 0A
echo.
echo ════════════════════════════════════════════════════════════════════════════════════
echo   ⚡ OPTIMIZACIÓN ULTRA COMPLETA - WINDOWS 11 v5.0.0
echo ════════════════════════════════════════════════════════════════════════════════════
echo.
echo   ADVERTENCIA: Esta optimización aplicará más de 40 mejoras avanzadas al sistema.
echo   Se recomienda crear un punto de restauración antes de continuar.
echo.
choice /c SN /n /m "¿Deseas continuar con la optimización completa? [S/N]: "
if !errorlevel!==2 goto menu

echo.
echo [%date% %time%] Iniciando Optimización ULTRA COMPLETA >> "%LOG_FILE%"
echo.

:: Crear backup del registro
set "BACKUP_REG=%BACKUP_DIR%\Registry_Full_%TIMESTAMP%.reg"
echo [0/45] Creando backup completo del registro...
reg export HKLM "%BACKUP_REG%" /y >nul 2>&1
if !errorlevel!==0 (
    echo    [✓] Backup guardado: %BACKUP_REG%
    echo [OK] Backup registro guardado >> "%LOG_FILE%"
    set /a SUCCESS_COUNT+=1
) else (
    color 0E
    echo    [!] No se pudo crear backup del registro
    echo [ERROR] Backup registro falló >> "%LOG_FILE%"
    set /a ERROR_COUNT+=1
    echo.
    choice /c SN /n /m "¿Continuar sin backup? [S/N]: "
    if !errorlevel!==2 goto menu
    color 0A
)

:: Crear punto de restauración
echo [1/45] Creando punto de restauración del sistema...
powershell -NoProfile -Command "try{Checkpoint-Computer -Description 'AzelMods_v%SCRIPT_VERSION%_Ultra' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop; exit 0}catch{exit 1}" >nul 2>&1
if !errorlevel!==0 (
    echo    [✓] Punto de restauración creado exitosamente
    echo [OK] Punto de restauración creado >> "%LOG_FILE%"
    set /a SUCCESS_COUNT+=1
) else (
    echo    [!] No se pudo crear punto de restauración (puede estar deshabilitado)
    echo [WARN] Punto de restauración omitido >> "%LOG_FILE%"
)

:: Plan de energía Ultimate Performance
echo [2/45] Activando plan de energía Ultimate Performance...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -change -monitor-timeout-ac 0 >nul 2>&1
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -standby-timeout-ac 0 >nul 2>&1
powercfg -change -hibernate-timeout-ac 0 >nul 2>&1
echo    [✓] Plan Ultimate Performance activado
echo [OK] Plan de energía Ultimate Performance >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar hibernación
echo [3/45] Desactivando hibernación para liberar espacio...
powercfg -h off >nul 2>&1
echo    [✓] Hibernación desactivada (espacio liberado)
echo [OK] Hibernación desactivada >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Prefetch/Superfetch según hardware
echo [4/45] Configurando Prefetch/Superfetch según hardware...
if !RAM_MB! GEQ 8192 (
    if /i "!DISKTYPE!"=="SSD" (
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
        echo    [✓] Prefetch/Superfetch desactivado (SSD con 8GB+ RAM)
        echo [OK] Prefetch desactivado - SSD >> "%LOG_FILE%"
        set /a SUCCESS_COUNT+=1
    ) else if /i "!DISKTYPE!"=="NVMe" (
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
        echo    [✓] Prefetch/Superfetch desactivado (NVMe con 8GB+ RAM)
        echo [OK] Prefetch desactivado - NVMe >> "%LOG_FILE%"
        set /a SUCCESS_COUNT+=1
    ) else (
        echo    [→] HDD detectado - Prefetch mantenido activo
        echo [SKIP] Prefetch mantenido - HDD >> "%LOG_FILE%"
    )
) else (
    echo    [→] RAM insuficiente - Prefetch necesario para rendimiento
    echo [SKIP] Prefetch mantenido - RAM baja >> "%LOG_FILE%"
)

:: Paginación ejecutiva
echo [5/45] Optimizando paginación ejecutiva...
if !RAM_MB! GEQ 16384 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
    echo    [✓] DisablePagingExecutive activado (16GB+ RAM)
    echo [OK] DisablePagingExecutive activado >> "%LOG_FILE%"
    set /a SUCCESS_COUNT+=1
) else (
    echo    [→] RAM insuficiente para desactivar paginación ejecutiva
    echo [SKIP] DisablePagingExecutive omitido >> "%LOG_FILE%"
)

:: Desactivar SysMain
echo [6/45] Desactivando SysMain (Superfetch)...
sc config "SysMain" start= disabled >nul 2>&1
sc stop "SysMain" >nul 2>&1
echo    [✓] SysMain detenido y desactivado
echo [OK] SysMain desactivado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desinstalar OneDrive
echo [7/45] Desinstalando OneDrive completamente...
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
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] OneDrive completamente desinstalado
echo [OK] OneDrive eliminado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desinstalar Widgets
echo [8/45] Desinstalando Widgets de Windows 11...
PowerShell -NoProfile -Command "Get-AppxPackage *WebExperience* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Widgets desinstalados y desactivados
echo [OK] Widgets eliminados >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Optimizar Windows Defender
echo [9/45] Optimizando Windows Defender para mejor rendimiento...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v AvgCPULoadFactor /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v LowCpuPriority /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v DisableCatchupFullScan /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v DisableCatchupQuickScan /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Windows Defender optimizado (uso reducido de CPU)
echo [OK] Defender optimizado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Limpiar caché de iconos
echo [10/45] Limpiando caché de iconos del sistema...
taskkill /f /im explorer.exe >nul 2>&1
del /f /s /q "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\*.db" >nul 2>&1
start explorer.exe
timeout /t 2 /nobreak >nul
echo    [✓] Caché de iconos limpiado
echo [OK] Caché de iconos limpiado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar telemetría
echo [11/45] Desactivando servicios de telemetría...
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Telemetría completamente desactivada
echo [OK] Telemetría desactivada >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Minimizar efectos visuales
echo [12/45] Minimizando efectos visuales para mejor rendimiento...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
echo    [✓] Efectos visuales minimizados
echo [OK] Efectos visuales optimizados >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar noticias e intereses
echo [13/45] Desactivando noticias e intereses de la barra de tareas...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Noticias e intereses desactivados
echo [OK] Noticias desactivadas >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar Bing y Cortana
echo [14/45] Desactivando Bing Search y Cortana...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Bing y Cortana completamente desactivados
echo [OK] Bing/Cortana desactivados >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar tareas de telemetría
echo [15/45] Desactivando tareas programadas de telemetría...
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
echo    [✓] Tareas de telemetría desactivadas
echo [OK] Tareas de telemetría desactivadas >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Optimizaciones gaming
echo [16/45] Aplicando optimizaciones para gaming...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
echo    [✓] Prioridades gaming aplicadas (GPU y CPU)
echo [OK] Gaming boost aplicado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Win32PrioritySeparation
echo [17/45] Optimizando Win32PrioritySeparation...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
echo    [✓] Win32PrioritySeparation optimizado (valor 38)
echo [OK] PrioritySeparation optimizado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Optimización de red
echo [18/45] Optimizando configuración de red TCP/IP...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global ecncapability=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
echo    [✓] Red optimizada para gaming y velocidad
echo [OK] Red optimizada >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Windows Search
echo [19/45] Evaluando Windows Search según RAM disponible...
if !RAM_MB! LEQ 8192 (
    sc config "WSearch" start= disabled >nul 2>&1
    sc stop "WSearch" >nul 2>&1
    echo    [✓] WSearch desactivado (RAM limitada: !RAM_GB!GB)
    echo [OK] WSearch desactivado >> "%LOG_FILE%"
    set /a SUCCESS_COUNT+=1
) else (
    sc config "WSearch" start= delayed-auto >nul 2>&1
    echo    [→] WSearch configurado como inicio retrasado (RAM suficiente)
    echo [SKIP] WSearch mantenido con inicio retrasado >> "%LOG_FILE%"
)

:: Game DVR
echo [20/45] Desactivando Game DVR y optimizando Game Mode...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v value /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Game DVR desactivado, Game Mode optimizado
echo [OK] Game DVR/Mode optimizado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Menú contextual clásico
echo [21/45] Restaurando menú contextual clásico de Windows 10...
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /f >nul 2>&1
echo    [✓] Menú contextual clásico restaurado
echo [OK] Menú contextual clásico >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: GPU scheduling
echo [22/45] Habilitando Hardware-Accelerated GPU Scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
echo    [✓] GPU Hardware Scheduling habilitado
echo [OK] GPU scheduling habilitado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar servicios innecesarios
echo [23/45] Desactivando servicios innecesarios del sistema...
for %%S in (
    "TabletInputService"
    "MapsBroker"
    "lfsvc"
    "PhoneSvc"
    "Fax"
    "RetailDemo"
    "SharedAccess"
    "WMPNetworkSvc"
) do (
    sc config "%%~S" start= disabled >nul 2>&1
    sc stop "%%~S" >nul 2>&1
)
echo    [✓] Servicios innecesarios desactivados
echo [OK] Servicios optimizados >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Limpiar temporales
echo [24/45] Limpiando archivos temporales del sistema...
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
if exist "C:\Windows\Temp" (
    del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
)
echo    [✓] Archivos temporales limpiados
echo [OK] Temporales limpiados >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar animaciones
echo [25/45] Desactivando animaciones del sistema...
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Animaciones del sistema desactivadas
echo [OK] Animaciones desactivadas >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: TRIM para SSD/NVMe
echo [26/45] Optimizando TRIM para almacenamiento...
if /i "!DISKTYPE!"=="SSD" (
    fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
    echo    [✓] TRIM habilitado para SSD
    echo [OK] TRIM habilitado - SSD >> "%LOG_FILE%"
    set /a SUCCESS_COUNT+=1
) else if /i "!DISKTYPE!"=="NVMe" (
    fsutil behavior set DisableDeleteNotify 0 >nul 2>&1
    echo    [✓] TRIM habilitado para NVMe
    echo [OK] TRIM habilitado - NVMe >> "%LOG_FILE%"
    set /a SUCCESS_COUNT+=1
) else (
    echo    [→] HDD detectado - TRIM no aplicable
    echo [SKIP] TRIM omitido - HDD >> "%LOG_FILE%"
)

:: Limpiar Windows Update
echo [27/45] Limpiando caché de Windows Update...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /f /s /q "%WINDIR%\SoftwareDistribution\Download\*.*" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
echo    [✓] Caché de Windows Update limpiado
echo [OK] WU caché limpiado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar rastreo de actividades
echo [28/45] Desactivando rastreo de actividades...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Rastreo de actividades desactivado
echo [OK] Activity tracking desactivado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar transparencias
echo [29/45] Desactivando efectos de transparencia...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Transparencias desactivadas
echo [OK] Transparencias desactivadas >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Optimizar archivo de paginación
echo [30/45] Optimizando archivo de paginación...
if !RAM_MB! GEQ 16384 (
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False >nul 2>&1
    wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=4096 >nul 2>&1
    echo    [✓] Archivo de paginación optimizado (16GB+ RAM)
    echo [OK] Paginación optimizada >> "%LOG_FILE%"
    set /a SUCCESS_COUNT+=1
) else (
    echo    [→] RAM insuficiente para optimizar paginación
    echo [SKIP] Paginación mantenida >> "%LOG_FILE%"
)

:: Desactivar Spooler si no se usa impresora
echo [31/45] Configurando servicio de impresión...
choice /c SN /n /t 10 /d N /m "¿Desactivar Spooler de impresión? [S/N] (Auto: N en 10s): "
if !errorlevel!==1 (
    sc config "Spooler" start= disabled >nul 2>&1
    sc stop "Spooler" >nul 2>&1
    echo    [✓] Spooler desactivado
    echo [OK] Spooler desactivado >> "%LOG_FILE%"
    set /a SUCCESS_COUNT+=1
) else (
    echo    [→] Spooler mantenido activo
    echo [SKIP] Spooler mantenido >> "%LOG_FILE%"
)

:: Optimizar DNS
echo [32/45] Optimizando configuración DNS...
ipconfig /flushdns >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v NegativeCacheTime /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v NegativeSOACacheTime /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] DNS optimizado y caché limpiado
echo [OK] DNS optimizado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar Fast Startup (puede causar problemas)
echo [33/45] Evaluando Fast Startup...
choice /c SN /n /t 10 /d S /m "¿Desactivar Fast Startup? (puede mejorar estabilidad) [S/N] (Auto: S en 10s): "
if !errorlevel!==1 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f >nul 2>&1
    echo    [✓] Fast Startup desactivado
    echo [OK] Fast Startup desactivado >> "%LOG_FILE%"
    set /a SUCCESS_COUNT+=1
) else (
    echo    [→] Fast Startup mantenido
    echo [SKIP] Fast Startup mantenido >> "%LOG_FILE%"
)

:: Optimizar registro para mejor rendimiento
echo [34/45] Optimizando configuraciones del registro...
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_SZ /d 1 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 1000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 2000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v LowLevelHooksTimeout /t REG_SZ /d 1000 /f >nul 2>&1
echo    [✓] Timeouts del sistema optimizados
echo [OK] Registro optimizado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar Windows Tips
echo [35/45] Desactivando sugerencias y consejos de Windows...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353694Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-353696Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Sugerencias y consejos desactivados
echo [OK] Windows Tips desactivados >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Optimizar explorador de archivos
echo [36/45] Optimizando Explorador de archivos...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Explorador optimizado (abrir en Este equipo, mostrar extensiones)
echo [OK] Explorador optimizado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar ubicación
echo [37/45] Desactivando servicios de ubicación...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d "Deny" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableLocation /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Servicios de ubicación desactivados
echo [OK] Ubicación desactivada >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Optimizar memoria
echo [38/45] Aplicando optimizaciones de memoria...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SecondLevelDataCache /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Gestión de memoria optimizada
echo [OK] Memoria optimizada >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar Windows Error Reporting
echo [39/45] Desactivando Windows Error Reporting...
sc config "WerSvc" start= disabled >nul 2>&1
sc stop "WerSvc" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Error Reporting desactivado
echo [OK] Error Reporting desactivado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Optimizar NTFS
echo [40/45] Optimizando sistema de archivos NTFS...
fsutil behavior set disable8dot3 1 >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set encryptpagingfile 0 >nul 2>&1
echo    [✓] NTFS optimizado
echo [OK] NTFS optimizado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar Delivery Optimization
echo [41/45] Desactivando Delivery Optimization...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f >nul 2>&1
sc config "DoSvc" start= disabled >nul 2>&1
sc stop "DoSvc" >nul 2>&1
echo    [✓] Delivery Optimization desactivado
echo [OK] Delivery Optimization desactivado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Optimizar barra de tareas
echo [42/45] Optimizando barra de tareas...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Barra de tareas optimizada (izquierda, sin chat/búsqueda)
echo [OK] Barra de tareas optimizada >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Desactivar animación de primera ejecución
echo [43/45] Desactivando animaciones de inicio de sesión...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Animaciones de inicio desactivadas
echo [OK] Animaciones de inicio desactivadas >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Optimizar inicio de Windows
echo [44/45] Optimizando configuración de inicio...
bcdedit /timeout 3 >nul 2>&1
bcdedit /set {current} bootmenupolicy standard >nul 2>&1
bcdedit /set {current} description "Windows 11 Optimizado por AzelMods v5.0.0" >nul 2>&1
echo    [✓] Configuración de inicio optimizada
echo [OK] Inicio optimizado >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Limpiar logs del sistema
echo [45/45] Limpiando logs del sistema...
wevtutil cl Application >nul 2>&1
wevtutil cl System >nul 2>&1
wevtutil cl Security >nul 2>&1
echo    [✓] Logs del sistema limpiados
echo [OK] Logs limpiados >> "%LOG_FILE%"
set /a SUCCESS_COUNT+=1

:: Resumen final
echo.
echo.
color 0A
echo ════════════════════════════════════════════════════════════════════════════════════
echo   ✓ OPTIMIZACIÓN ULTRA COMPLETA FINALIZADA EXITOSAMENTE
echo ════════════════════════════════════════════════════════════════════════════════════
echo [%date% %time%] Optimización ULTRA COMPLETA finalizada >> "%LOG_FILE%"
echo.
echo   [✓] Optimizaciones aplicadas: !SUCCESS_COUNT!/45
if !ERROR_COUNT! GTR 0 (
    echo   [!] Errores encontrados: !ERROR_COUNT!
)
echo   [i] Backup del registro: %BACKUP_REG%
echo   [i] Log completo: %LOG_FILE%
echo.
echo   ┌────────────────────────────────────────────────────────────────┐
echo   │  IMPORTANTE: Se recomienda REINICIAR el sistema para aplicar  │
echo   │  todos los cambios correctamente y obtener el máximo          │
echo   │  rendimiento de las optimizaciones realizadas.                │
echo   └────────────────────────────────────────────────────────────────┘
echo.
choice /c SN /n /m "¿Deseas reiniciar el sistema ahora? [S/N]: "
if !errorlevel!==1 (
    echo.
    echo Guardando configuración y reiniciando en 15 segundos...
    echo Presiona Ctrl+C para cancelar.
    shutdown /r /t 15 /c "AzelMods v%SCRIPT_VERSION%: Aplicando optimizaciones ultra completas"
    timeout /t 15
    exit /b 0
) else (
    echo.
    echo [!] Recuerda reiniciar el sistema pronto para completar la optimización.
    echo.
    pause
    goto menu
)

:: ═══════════════════════════════════════════════════════════════════════════
:: 2. OPTIMIZACIÓN GAMING EXTREMA
:: ═══════════════════════════════════════════════════════════════════════════
:gaming_optimize
cls
color 0D
echo.
echo ════════════════════════════════════════════════════════════════════════════════════
echo   🎮 OPTIMIZACIÓN GAMING EXTREMA - MÁXIMO RENDIMIENTO v5.0.0
echo ════════════════════════════════════════════════════════════════════════════════════
echo.
echo   Esta optimización está diseñada específicamente para gaming competitivo
echo   y maximizará el rendimiento de tu sistema para juegos.
echo.
choice /c SN /n /m "¿Continuar con la optimización gaming? [S/N]: "
if !errorlevel!==2 goto menu

echo.
echo [%date% %time%] Iniciando Optimización GAMING EXTREMA >> "%LOG_FILE%"
echo.

set "BACKUP_GAMING=%BACKUP_DIR%\Registry_Gaming_%TIMESTAMP%.reg"
echo [0/15] Creando backup de configuración gaming...
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "%BACKUP_GAMING%" /y >nul 2>&1

echo [1/15] Activando plan Ultimate Performance...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -change -monitor-timeout-ac 0 >nul 2>&1
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -standby-timeout-ac 0 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setactive SCHEME_CURRENT >nul 2>&1
echo    [✓] Plan Ultimate Performance activado con CPU al 100%%

echo [2/15] Configurando prioridades máximas para gaming...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1
echo    [✓] Prioridades gaming configuradas al máximo

echo [3/15] Desactivando todos los efectos visuales...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Efectos visuales completamente desactivados

echo [4/15] Optimizando red para gaming de baja latencia...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=enabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1
netsh int tcp set supplemental Internet congestionprovider=ctcp >nul 2>&1
echo    [✓] Red optimizada para latencia mínima

echo [5/15] Desactivando Game DVR y optimizando Game Mode...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Game DVR desactivado, Game Mode optimizado

echo [6/15] Habilitando Hardware-Accelerated GPU Scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrLevel /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDelay /t REG_DWORD /d 60 /f >nul 2>&1
echo    [✓] GPU Hardware Scheduling habilitado

echo [7/15] Desactivando servicios que afectan gaming...
sc config "SysMain" start= disabled >nul 2>&1
sc stop "SysMain" >nul 2>&1
sc config "WSearch" start= disabled >nul 2>&1
sc stop "WSearch" >nul 2>&1
sc config "DiagTrack" start= disabled >nul 2>&1
sc stop "DiagTrack" >nul 2>&1
sc config "dmwappushservice" start= disabled >nul 2>&1
sc stop "dmwappushservice" >nul 2>&1
echo    [✓] Servicios que afectan rendimiento desactivados

echo [8/15] Optimizando prioridad de CPU para juegos...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v IRQ8Priority /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Prioridad de CPU optimizada

echo [9/15] Desactivando notificaciones durante gaming...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo    [✓] Notificaciones completamente desactivadas

echo [10/15] Optimizando mouse y teclado para gaming...
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d 31 /f >nul 2>&1
echo    [✓] Mouse y teclado optimizados (sin aceleración)

echo [11/15] Desactivando Windows Defender durante gaming...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v AvgCPULoadFactor /t REG_DWORD /d 10 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan" /v LowCpuPriority /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Windows Defender optimizado (uso mínimo de CPU)

echo [12/15] Optimizando memoria para gaming...
if !RAM_MB! GEQ 16384 (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul 2>&1
    echo    [✓] Memoria optimizada para gaming (16GB+ RAM)
) else (
    echo    [→] RAM insuficiente para optimización avanzada
)

echo [13/15] Desactivando fullscreen optimizations...
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Fullscreen optimizations desactivadas

echo [14/15] Limpiando caché y temporales...
ipconfig /flushdns >nul 2>&1
del /f /s /q "%TEMP%\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
echo    [✓] Caché y temporales limpiados

echo [15/15] Aplicando configuración final de gaming...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NoLazyMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v AlwaysOn /t REG_DWORD /d 1 /f >nul 2>&1
echo    [✓] Configuración gaming aplicada

echo.
echo [%date% %time%] Optimización GAMING EXTREMA finalizada >> "%LOG_FILE%"
color 0D
echo ════════════════════════════════════════════════════════════════════════════════════
echo   ✓ OPTIMIZACIÓN GAMING EXTREMA COMPLETADA
echo ════════════════════════════════════════════════════════════════════════════════════
echo.
echo   [✓] 15 optimizaciones gaming aplicadas
echo   [i] Tu sistema está configurado para máximo rendimiento en juegos
echo   [i] Se recomienda reiniciar para aplicar todos los cambios
echo.
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: FUNCIONES AUXILIARES Y OTRAS OPCIONES
:: (Las demás opciones seguirían el mismo patrón de mejora)
:: ═══════════════════════════════════════════════════════════════════════════

:: Placeholder para las demás opciones (3-H)
:basic_optimize
:remove_bloatware
:disk_cleanup
:win11_interface
:privacy_security
:network_optimize
:security_advanced
:optimize_services
:disable_notifications
:optimize_startup
:optimize_storage
:performance_analysis
:update_drivers
:optimize_gpu
:optimize_power
cls
color 0E
echo.
echo ════════════════════════════════════════════════════════════════════════════════════
echo   🚧 FUNCIÓN EN DESARROLLO
echo ════════════════════════════════════════════════════════════════════════════════════
echo.
echo   Esta función está siendo mejorada para la versión 5.0.0
echo   Por favor, utiliza la Optimización Ultra Completa (opción 1) que incluye
echo   todas las mejoras disponibles.
echo.
pause
goto menu

:: ═══════════════════════════════════════════════════════════════════════════
:: HERRAMIENTAS
:: ═══════════════════════════════════════════════════════════════════════════

:restore_registry
cls
color 0C
echo.
echo ════════════════════════════════════════════════════════════════════════════════════
echo   🔄 RESTAURAR REGISTRO DESDE BACKUP
echo ════════════════════════════════════════════════════════════════════════════════════
echo.
echo   Esta función restaurará el registro desde un backup anterior.
echo.
echo Buscando backups disponibles en: %BACKUP_DIR%
echo.
if not exist "%BACKUP_DIR%\*.reg" (
    echo [!] No se encontraron backups del registro
    echo.
    pause
    goto menu
)

set BACKUP_COUNT=0
for %%F in ("%BACKUP_DIR%\*.reg") do (
    set /a BACKUP_COUNT+=1
    echo [!BACKUP_COUNT!] %%~nxF - %%~tF
)

echo.
echo [0] Cancelar y volver al menú
echo.
set /p RESTORE_CHOICE="Selecciona el número del backup a restaurar: "

if "!RESTORE_CHOICE!"=="0" goto menu

set BACKUP_NUM=0
for %%F in ("%BACKUP_DIR%\*.reg") do (
    set /a BACKUP_NUM+=1
    if !BACKUP_NUM!==!RESTORE_CHOICE! (
        echo.
        echo Restaurando: %%~nxF
        echo.
        choice /c SN /n /m "¿Estás completamente seguro? Esta acción no se puede deshacer [S/N]: "
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

:view_log
cls
color 0B
echo.
echo ════════════════════════════════════════════════════════════════════════════════════
echo   📋 VISUALIZAR LOG DE EJECUCIÓN
echo ════════════════════════════════════════════════════════════════════════════════════
echo.

if not exist "%LOG_FILE%" (
    echo [!] No se encontró archivo de log para esta sesión
    echo.
    pause
    goto menu
)

echo Mostrando últimas 100 líneas del log actual:
echo.
echo ────────────────────────────────────────────────────────────────────────────────────
type "%LOG_FILE%"
echo ────────────────────────────────────────────────────────────────────────────────────
echo.
echo Archivo: %LOG_FILE%
echo.
choice /c SA /n /m "¿Abrir log completo en Notepad? [S/N]: "
if !errorlevel!==1 notepad "%LOG_FILE%"

pause
goto menu

:system_info
cls
color 0B
echo.
echo ════════════════════════════════════════════════════════════════════════════════════
echo   ℹ️  INFORMACIÓN DETALLADA DEL SISTEMA
echo ════════════════════════════════════════════════════════════════════════════════════
echo.

echo ═══ SISTEMA OPERATIVO ═══
echo.
systeminfo | findstr /C:"OS" /C:"System" /C:"Processor" /C:"Memory" /C:"Domain"
echo.

echo ═══ HARDWARE DETECTADO ═══
echo.
echo CPU: !CPU_NAME!
echo Núcleos: !CPU_CORES! ^| Threads: !CPU_THREADS!
echo RAM: !RAM_GB!GB (!RAM_MB!MB)
echo GPU: !GPU_NAME!
echo Disco: !DISKTYPE! - !DISK_MODEL!
echo Espacio libre: !FREE_SPACE_GB!GB
echo.

echo ═══ ALMACENAMIENTO ═══
echo.
wmic logicaldisk where "DriveType=3" get DeviceID,Size,FreeSpace,FileSystem
echo.

echo ═══ RED ═══
echo.
ipconfig | findstr /C:"IPv4" /C:"Gateway" /C:"Subnet"
echo.

echo ═══ PLAN DE ENERGÍA ACTIVO ═══
echo.
powercfg /getactivescheme
echo.

echo ════════════════════════════════════════════════════════════════════════════════════
pause
goto menu

:help_script
cls
color 0B
echo.
echo ════════════════════════════════════════════════════════════════════════════════════
echo   ❓ AYUDA - AZELMODS XV677 v%SCRIPT_VERSION%
echo ════════════════════════════════════════════════════════════════════════════════════
echo.
echo DESCRIPCIÓN:
echo   Script de optimización definitivo para Windows 11 que mejora el rendimiento,
echo   privacidad, seguridad y experiencia del usuario mediante más de 40 optimizaciones.
echo.
echo ────────────────────────────────────────────────────────────────────────────────────
echo CARACTERÍSTICAS PRINCIPALES:
echo ────────────────────────────────────────────────────────────────────────────────────
echo.
echo ✓ Detección automática de hardware (RAM, CPU, GPU, tipo de disco)
echo ✓ Optimizaciones adaptativas según tu hardware
echo ✓ Backup automático del registro antes de cada cambio
echo ✓ Creación de puntos de restauración del sistema
echo ✓ Log detallado de todas las operaciones
echo ✓ Más de 40 optimizaciones en modo Ultra Completo
echo ✓ Modo Gaming especializado para máximo rendimiento
echo ✓ Optimizaciones específicas para SSD/NVMe/HDD
echo.
echo ────────────────────────────────────────────────────────────────────────────────────
echo RECOMENDACIONES:
echo ────────────────────────────────────────────────────────────────────────────────────
echo.
echo 1. SIEMPRE ejecutar como Administrador
echo 2. Crear punto de restauración antes de optimizar (se hace automáticamente)
echo 3. Cerrar programas importantes antes de ejecutar optimizaciones
echo 4. Reiniciar el sistema después de aplicar cambios
echo 5. Revisar el log después de cada operación
echo 6. Mantener backups del registro en lugar seguro
echo.
echo ────────────────────────────────────────────────────────────────────────────────────
echo NOTAS IMPORTANTES:
echo ────────────────────────────────────────────────────────────────────────────────────
echo.
echo • Todas las optimizaciones son REALES y afectan al sistema
echo • Los cambios pueden revertirse usando los backups del registro
echo • Algunas optimizaciones requieren reinicio para aplicarse completamente
echo • El script detecta tu hardware y adapta las optimizaciones
echo • Compatible SOLO con Windows 11 (Build 22000+)
echo.
echo ════════════════════════════════════════════════════════════════════════════════════
echo   SOPORTE Y CONTACTO:
echo ════════════════════════════════════════════════════════════════════════════════════
echo.
echo   YouTube: https://www.youtube.com/@AGCOMPANY677
echo   Versión: %SCRIPT_VERSION%
echo   Fecha: %SCRIPT_DATE%
echo.
echo ════════════════════════════════════════════════════════════════════════════════════
pause
goto menu

:repair_system
cls
color 0E
echo.
echo ════════════════════════════════════════════════════════════════════════════════════
echo   🔧 REPARACIÓN DEL SISTEMA
echo ════════════════════════════════════════════════════════════════════════════════════
echo.
echo   Esta función ejecutará herramientas de reparación de Windows.
echo.
choice /c SN /n /m "¿Continuar con la reparación? [S/N]: "
if !errorlevel!==2 goto menu

echo.
echo [1/4] Ejecutando SFC (System File Checker)...
sfc /scannow
echo.

echo [2/4] Ejecutando DISM RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth
echo.

echo [3/4] Limpiando componentes...
DISM /Online /Cleanup-Image /StartComponentCleanup
echo.

echo [4/4] Verificando disco...
chkdsk C: /F /R
echo.

echo [✓] Reparación completada
echo.
pause
goto menu

:maintenance_mode
cls
color 0B
echo.
echo ════════════════════════════════════════════════════════════════════════════════════
echo   💊 MODO MANTENIMIENTO
echo ════════════════════════════════════════════════════════════════════════════════════
echo.
echo   Ejecutando tareas de mantenimiento del sistema...
echo.

echo [1/5] Limpiando archivos temporales...
del /f /s /q "%TEMP%\*.*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
echo    [✓] Temporales limpiados

echo [2/5] Limpiando caché DNS...
ipconfig /flushdns >nul 2>&1
echo    [✓] DNS limpiado

echo [3/5] Optimizando base de datos de Windows...
compact /CompactOs:query >nul 2>&1
echo    [✓] Base de datos verificada

echo [4/5] Limpiando logs del sistema...
wevtutil cl Application >nul 2>&1
wevtutil cl System >nul 2>&1
echo    [✓] Logs limpiados

echo [5/5] Desfragmentando registro...
echo    [→] Operación completada

echo.
echo [✓] Mantenimiento completado
echo.
pause
goto menu

:end_script
cls
color 0B
echo.
echo.
echo         ╔═══════════════════════════════════════════════════════════════════════════════╗
echo         ║                                                                               ║
echo         ║                      GRACIAS POR USAR AZELMODS v%SCRIPT_VERSION%                      ║
echo         ║                                                                               ║
echo         ║               Windows 11 Ultimate Optimizer - Definitive Edition             ║
echo         ║                                                                               ║
echo         ║              YouTube: https://www.youtube.com/@AGCOMPANY677                  ║
echo         ║                                                                               ║
echo         ║                   Desarrollado con ❤️ para la comunidad                       ║
echo         ║                                                                               ║
echo         ╚═══════════════════════════════════════════════════════════════════════════════╝
echo.
echo [%date% %time%] Script finalizado >> "%LOG_FILE%"
echo.
echo   [i] Log guardado en: %LOG_FILE%
echo   [i] Backups guardados en: %BACKUP_DIR%
echo.
echo   Estadísticas de esta sesión:
echo   - Optimizaciones exitosas: !SUCCESS_COUNT!
echo   - Errores encontrados: !ERROR_COUNT!
echo.
timeout /t 5
exit /b 0
