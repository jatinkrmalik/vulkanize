@echo off
setlocal enabledelayedexpansion

:: S23 Vulkan Graphics Enabler for Windows
:: This script forces Samsung S23 series devices to use Vulkan graphics API

echo Starting S23 Vulkan Graphics Enabler...
echo.

:: Check if ADB is installed
echo Checking for ADB installation...
where adb >nul 2>&1
if %errorlevel% neq 0 (
    echo ADB not found in PATH. Attempting to install...
    
    :: Try using winget to install ADB
    echo Checking for Windows Package Manager (winget)...
    where winget >nul 2>&1
    if !errorlevel! equ 0 (
        echo Found Windows Package Manager. Attempting to install Android Platform Tools...
        echo This may take a few moments...
        
        :: Try to install Google.AndroidSDK.PlatformTools package
        echo Running: winget install Google.AndroidSDK.PlatformTools
        winget install Google.AndroidSDK.PlatformTools --accept-source-agreements --accept-package-agreements
        
        :: Check if installation was successful
        echo Checking if ADB was installed successfully...
        where adb >nul 2>&1
        if !errorlevel! equ 0 (
            echo Android Platform Tools installed successfully!
            echo.
            goto ADB_INSTALLED
        ) else (
            echo Automatic installation failed.
        )
    ) else (
        echo Windows Package Manager (winget) not found.
    )
    
    :: If automatic installation failed, show manual instructions
    echo.
    echo Please install Android Platform Tools manually:
    echo 1. Visit: https://developer.android.com/studio/releases/platform-tools
    echo 2. Download the platform-tools package for Windows
    echo 3. Extract the ZIP file to a folder (e.g., C:\platform-tools)
    echo 4. Add the folder to your PATH environment variable
    echo 5. Run this script again
    echo.
    echo Press any key to exit...
    pause >nul
    exit /b 1
) else (
    echo ADB is already installed. Continuing...
)

:ADB_INSTALLED

:: Command-line mode detection
set SIMPLE_MODE=0
set LOGGING=0
set LOG_FILE=%~dp0vulkanize.log

:PARSE_ARGS
if "%~1"=="" goto CHECK_ARGS
if /i "%~1"=="--simple" set SIMPLE_MODE=1
if /i "%~1"=="--log" set LOGGING=1
if /i "%~1"=="--help" goto SHOW_HELP
if /i "%~1"=="--normal" goto RUN_NORMAL
if /i "%~1"=="--aggressive" goto RUN_AGGRESSIVE
shift
goto PARSE_ARGS

:CHECK_ARGS
if %SIMPLE_MODE%==1 (
    echo Simple mode enabled. Reduced prompts will be shown.
)
if %LOGGING%==1 (
    echo Logging enabled. Log will be saved to: %LOG_FILE%
    echo Starting log at %date% %time% > "%LOG_FILE%"
)

:MENU
cls
echo ===================================================
echo     S23 VULKAN GRAPHICS ENABLER - WINDOWS
echo ===================================================
echo.
echo  1. Check device connection
echo  2. Enable Vulkan (Normal mode - fewer app restarts)
echo  3. Enable Vulkan (Aggressive mode - restart all apps)
echo  4. Verify Vulkan status
echo  5. Help and information
echo  6. Exit
echo.
echo ===================================================
echo.

set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto CHECKDEVICE
if "%choice%"=="2" goto NORMAL
if "%choice%"=="3" goto AGGRESSIVE
if "%choice%"=="4" goto VERIFY
if "%choice%"=="5" goto HELP
if "%choice%"=="6" goto EXIT

echo Invalid choice. Please try again.
timeout /t 2 >nul
goto MENU

:CHECKDEVICE
cls
echo Checking for connected devices...
adb devices | findstr "device$" >nul
if %errorlevel% equ 0 (
    echo Device connected successfully!
    echo.
    adb devices
    set DEVICE_CONNECTED=1
) else (
    echo No device found or not authorized.
    echo Please ensure:
    echo  - USB debugging is enabled on your phone
    echo  - The device is connected via USB
    echo  - You've authorized the computer on your device
    set DEVICE_CONNECTED=0
)
if %LOGGING%==1 (
    echo [%date% %time%] Device check performed >> "%LOG_FILE%"
    adb devices >> "%LOG_FILE%"
)
if %SIMPLE_MODE%==0 pause
goto MENU

:NORMAL
cls
call :CHECK_DEVICE_BEFORE_ACTION
if %DEVICE_CONNECTED%==0 goto MENU
call :RUNVULKAN normal
goto MENU

:AGGRESSIVE
cls
call :CHECK_DEVICE_BEFORE_ACTION
if %DEVICE_CONNECTED%==0 goto MENU
call :RUNVULKAN aggressive
goto MENU

:CHECK_DEVICE_BEFORE_ACTION
echo Checking device connection before proceeding...
adb devices | findstr "device$" >nul
if %errorlevel% equ 0 (
    set DEVICE_CONNECTED=1
    return 0
) else (
    echo No device found or not authorized.
    echo Please connect your device first.
    echo.
    set DEVICE_CONNECTED=0
    if %SIMPLE_MODE%==0 pause
    return 1
)

:RUN_NORMAL
call :CHECK_DEVICE_BEFORE_ACTION
if %DEVICE_CONNECTED%==0 goto EXIT
call :RUNVULKAN normal
goto EXIT

:RUN_AGGRESSIVE
call :CHECK_DEVICE_BEFORE_ACTION
if %DEVICE_CONNECTED%==0 goto EXIT
call :RUNVULKAN aggressive
goto EXIT

:RUNVULKAN
echo Enabling Vulkan (%~1 mode)...
if %LOGGING%==1 (
    echo [%date% %time%] Enabling Vulkan in %~1 mode >> "%LOG_FILE%"
)
echo.
echo Setting HWUI renderer to skiavk...
adb shell setprop debug.hwui.renderer skiavk >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Failed to set Vulkan property. Make sure your device is properly connected.
    if %LOGGING%==1 (
        echo [%date% %time%] Error: Failed to set Vulkan property >> "%LOG_FILE%"
    )
    if %SIMPLE_MODE%==0 pause
    goto :EOF
)
if %LOGGING%==1 (
    echo [%date% %time%] Set property debug.hwui.renderer to skiavk >> "%LOG_FILE%"
)

echo Forcing crash: System UI
adb shell am crash com.android.systemui >nul 2>&1

echo Forcing stop: Settings
adb shell am force-stop com.android.settings >nul 2>&1

echo Forcing stop: Samsung Launcher
adb shell am force-stop com.sec.android.app.launcher >nul 2>&1

echo Forcing stop: AOD Service
adb shell am force-stop com.samsung.android.app.aodservice >nul 2>&1

if "%~1"=="aggressive" (
    echo.
    echo Checking for Gboard...
    adb shell pm list packages | findstr "com.google.android.inputmethod.latin" >nul
    if !errorlevel! equ 0 (
        echo Forcing crash: Gboard
        adb shell am crash com.google.android.inputmethod.latin >nul 2>&1
        if %LOGGING%==1 (
            echo [%date% %time%] Forced crash: Gboard >> "%LOG_FILE%"
        )
    ) else (
        echo Gboard not installed, skipping.
    )
)

echo.
echo Vulkan should now be enabled!
echo Remember this setting will revert after a reboot.
if %LOGGING%==1 (
    echo [%date% %time%] Vulkan enabling process completed >> "%LOG_FILE%"
)
if %SIMPLE_MODE%==0 pause
exit /b

:VERIFY
cls
echo To verify Vulkan is enabled:
echo  1. On your phone, go to Settings
echo  2. Open Developer Options
echo  3. Enable GPUWatch
echo  4. Open any app (like the dialer)
echo  5. Look for "Vulkan Renderer (skiavk)" in the overlay
echo.
if %LOGGING%==1 (
    echo [%date% %time%] Verification instructions displayed >> "%LOG_FILE%"
)
if %SIMPLE_MODE%==0 pause
goto MENU

:HELP
cls
echo === HELP & INFORMATION ===
echo.
echo This tool forces Samsung S23 phones to use Vulkan graphics API instead of OpenGL.
echo.
echo Benefits:
echo  - Improved performance
echo  - Reduced heat
echo  - Better battery life
echo.
echo Notes:
echo  - The change is temporary and will revert after reboot
echo  - You must run this script again after every reboot
echo  - Some apps may not work properly with Vulkan
echo.
echo Known issues:
echo  - Potential visual artifacts in some apps
echo  - Some apps may not run under Vulkan
echo  - Default browser and keyboard may reset
echo  - Possible loss of WiFi-Calling/VoLTE (fix by toggling SIM in settings)
echo.
echo Command line options:
echo  --simple     : Run in simple mode with fewer prompts
echo  --log        : Enable detailed logging
echo  --normal     : Enable Vulkan in normal mode and exit
echo  --aggressive : Enable Vulkan in aggressive mode and exit
echo  --help       : Show this help information
echo.
if %LOGGING%==1 (
    echo [%date% %time%] Help information displayed >> "%LOG_FILE%"
)
if %SIMPLE_MODE%==0 pause
goto MENU

:SHOW_HELP
echo S23 Vulkan Graphics Enabler for Windows
echo Usage: vulkan-enabler.bat [OPTIONS]
echo.
echo Options:
echo  --simple     : Run in simple mode with fewer prompts
echo  --log        : Enable detailed logging
echo  --normal     : Enable Vulkan in normal mode and exit
echo  --aggressive : Enable Vulkan in aggressive mode and exit
echo  --help       : Show this help information
goto EXIT

:EXIT
if %LOGGING%==1 (
    echo [%date% %time%] Script execution ended >> "%LOG_FILE%"
)
echo Thank you for using S23 Vulkan Graphics Enabler!

:: Prevent the script from closing immediately when run directly
echo.
echo Press any key to exit...
pause >nul
endlocal
exit /b 0
