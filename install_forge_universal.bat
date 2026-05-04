@echo off
setlocal enabledelayedexpansion
title SD Forge Universal Installer

cd /d "%~dp0"

:menu
cls
echo ========================================================
echo   SD WebUI Forge - Universal Installer
echo ========================================================
echo   Features:
echo    - Portable Install (Git, Python, UV included)
echo    - Fast Setup (UV + VENV)
echo    - Auto-Fix (Installs InsightFace correctly)
echo ========================================================
echo.
echo   Select Edition to Install:
echo.
echo   [1] Forge NEO (Branch: neo)
echo       - Experimental, latest features.
echo       - Folder: sd-webui-forge-neo
echo.
echo   [2] Forge CLASSIC (Default Branch)
echo       - Stable, includes InsightFace fix.
echo       - Folder: sd-webui-forge-classic
echo.
echo ========================================================
set /p "CHOICE=Enter choice [1] or [2]: "

if "%CHOICE%"=="1" (
    set "MODE=NEO"
    set "FOLDER_NAME=sd-webui-forge-neo"
    set "RUN_SCRIPT=run_neo.bat"
    set "UPDATE_SCRIPT=update_neo.bat"
    goto :config
)
if "%CHOICE%"=="2" (
    set "MODE=CLASSIC"
    set "FOLDER_NAME=sd-webui-forge-classic"
    set "RUN_SCRIPT=run_classic.bat"
    set "UPDATE_SCRIPT=update_classic.bat"
    goto :config
)

echo Invalid choice. Please try again.
pause
goto :menu

:: ----------------------------------------------------------
:: Configuration
:: ----------------------------------------------------------
:config
set "REPO_URL=https://github.com/Haoming02/sd-webui-forge-classic"
set "PYTHON_URL=https://www.python.org/ftp/python/3.13.12/python-3.13.12-embed-amd64.zip"
set "GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.54.0.windows.1/MinGit-2.54.0-64-bit.zip"
set "UV_URL=https://releases.astral.sh/github/uv/releases/download/0.11.8/uv-x86_64-pc-windows-msvc.zip"

:: InsightFace Configuration (Must keep original filename for UV)
set "IF_FILENAME=insightface-0.7.3-cp313-cp313-win_amd64.whl"
set "IF_URL=https://github.com/Gourieff/Assets/raw/refs/heads/main/Insightface/%IF_FILENAME%"

echo.
echo [SELECTED] %FOLDER_NAME%
echo.

:: ----------------------------------------------------------
:: Step 1: Download Tools
:: ----------------------------------------------------------
:check_tools
echo [INFO] Checking tools...

if not exist "git.zip" (
    echo [DOWNLOAD] Downloading Portable Git...
    curl -L -o git.zip "%GIT_URL%"
    if !errorlevel! neq 0 goto :error_download
)

if not exist "uv.zip" (
    echo [DOWNLOAD] Downloading Portable UV...
    curl -L -o uv.zip "%UV_URL%"
    if !errorlevel! neq 0 goto :error_download
)

if not exist "python.zip" (
    echo [DOWNLOAD] Downloading Portable Python...
    curl -L -o python.zip "%PYTHON_URL%"
    if !errorlevel! neq 0 goto :error_download
)

:: ----------------------------------------------------------
:: Step 2: Clone Repository
:: ----------------------------------------------------------
:prepare_clone
if not exist "git_temp" mkdir "git_temp"
if not exist "git_temp\cmd\git.exe" (
    echo [EXTRACT] Preparing temporary Git...
    powershell -Command "Expand-Archive -Path 'git.zip' -DestinationPath 'git_temp' -Force"
)

set "GIT_CMD=%~dp0git_temp\cmd\git.exe"

if exist "%FOLDER_NAME%" (
    echo [INFO] Folder %FOLDER_NAME% already exists. Skipping clone.
) else (
    echo [CLONE] Cloning Repository...
    
    if "%MODE%"=="NEO" (
        "%GIT_CMD%" clone "%REPO_URL%" "%FOLDER_NAME%" --branch neo
    )
    if "%MODE%"=="CLASSIC" (
        "%GIT_CMD%" clone "%REPO_URL%" "%FOLDER_NAME%"
    )
    
    if !errorlevel! neq 0 goto :error_clone
)

:: ----------------------------------------------------------
:: Step 3: Setup Internal System
:: ----------------------------------------------------------
:setup_system
echo [SETUP] Configuring internal system for %FOLDER_NAME%...

if not exist "%FOLDER_NAME%\system" mkdir "%FOLDER_NAME%\system"

:: Install Git
if not exist "%FOLDER_NAME%\system\git" (
    echo   - Installing Git...
    powershell -Command "Expand-Archive -Path 'git.zip' -DestinationPath '%FOLDER_NAME%\system\git' -Force"
)

:: Install UV
if not exist "%FOLDER_NAME%\system\uv" (
    echo   - Installing UV...
    powershell -Command "Expand-Archive -Path 'uv.zip' -DestinationPath '%FOLDER_NAME%\system\uv' -Force"
)

:: Install Python
if not exist "%FOLDER_NAME%\system\python" (
    echo   - Installing Python...
    if not exist "%FOLDER_NAME%\system\python" mkdir "%FOLDER_NAME%\system\python"
    powershell -Command "Expand-Archive -Path 'python.zip' -DestinationPath '%FOLDER_NAME%\system\python' -Force"
)

:: ----------------------------------------------------------
:: Step 4: Python Patching
:: ----------------------------------------------------------
:patch_python
cd "%FOLDER_NAME%\system\python"
if exist "python313._pth" (
    (
        echo python313.zip
        echo .
        echo ..\..
        echo import site
    ) > python313._pth
)
cd ..\..\..

:: ----------------------------------------------------------
:: Step 5: Create VENV using UV
:: ----------------------------------------------------------
:create_venv
set "UV_EXE=%~dp0%FOLDER_NAME%\system\uv\uv.exe"
set "BASE_PYTHON=%~dp0%FOLDER_NAME%\system\python\python.exe"
set "VENV_PYTHON=%~dp0%FOLDER_NAME%\system\venv\Scripts\python.exe"

if exist "%VENV_PYTHON%" goto :preinstall_fixes

echo [VENV] Creating High-Performance Virtual Environment...
"%UV_EXE%" venv "%FOLDER_NAME%\system\venv" --python "%BASE_PYTHON%" --seed
if !errorlevel! neq 0 (
    echo [ERROR] Failed to create VENV.
    pause
    exit /b
)

:: ----------------------------------------------------------
:: Step 5.5: Pre-Install Fixes (Classic Only)
:: ----------------------------------------------------------
:preinstall_fixes
if "%MODE%"=="CLASSIC" (
    echo.
    echo [FIX] Applying InsightFace Fix for Classic...
    
    if exist "%FOLDER_NAME%\system\venv\Lib\site-packages\insightface" (
        echo [INFO] InsightFace is already installed.
    ) else (
        echo [DOWNLOAD] Downloading pre-compiled InsightFace wheel...
        :: Using the full filename so UV accepts it
        curl -L -o "%IF_FILENAME%" "%IF_URL%"
        
        if !errorlevel! neq 0 (
            echo [WARNING] Failed to download InsightFace wheel. Skipping.
        ) else (
            echo [INSTALL] Installing InsightFace via UV...
            "%UV_EXE%" pip install "%IF_FILENAME%" --python "%VENV_PYTHON%"
            
            if !errorlevel! neq 0 (
                echo [ERROR] InsightFace install failed!
            ) else (
                echo [SUCCESS] InsightFace installed successfully.
                del "%IF_FILENAME%"
            )
        )
    )
)

:: ----------------------------------------------------------
:: Step 6: Create Launchers
:: ----------------------------------------------------------
:create_launchers
echo [CONFIG] Creating Launchers (%RUN_SCRIPT%)...

:: 1. webui-user.bat
(
echo @echo off
echo.
echo :: --- SD FORGE UNIVERSAL CONFIG ---
echo set VENV_DIR=system\venv
echo set PYTHON=system\venv\Scripts\python.exe
echo set GIT=system\git\cmd\git.exe
echo set PATH=%%~dp0system\uv;%%PATH%%
echo set COMMANDLINE_ARGS=--uv
echo.
echo call webui.bat
) > "%FOLDER_NAME%\webui-user.bat"

:: 2. Run Script
(
echo @echo off
echo title SD Forge %MODE% Launcher
echo cd /d "%%~dp0%FOLDER_NAME%"
echo call webui-user.bat
) > "%RUN_SCRIPT%"

:: 3. Update Script
(
echo @echo off
echo title SD Forge %MODE% Updater
echo cd /d "%%~dp0"
echo set "GIT_CMD=%%~dp0%FOLDER_NAME%\system\git\cmd\git.exe"
echo cd "%FOLDER_NAME%"
echo echo Updating %FOLDER_NAME%...
echo "%%GIT_CMD%%" pull
echo pause
) > "%UPDATE_SCRIPT%"

goto :cleanup

:: ----------------------------------------------------------
:: Errors
:: ----------------------------------------------------------
:error_download
echo [ERROR] Download failed. Check internet connection.
pause
exit /b

:error_clone
echo [ERROR] Git Clone failed.
pause
exit /b

:: ----------------------------------------------------------
:: Cleanup
:: ----------------------------------------------------------
:cleanup
echo.
echo [CLEANUP] Cleaning up installation files...
if exist "git_temp" rmdir /s /q "git_temp"
if exist "git.zip" del "git.zip"
if exist "python.zip" del "python.zip"
if exist "uv.zip" del "uv.zip"
if exist "%IF_FILENAME%" del "%IF_FILENAME%"

echo.
echo ========================================================
echo   Installation Complete!
echo ========================================================
echo.
echo   [READY] Folder:  %FOLDER_NAME%
echo   [READY] Runner:  %RUN_SCRIPT%
echo.

pause
