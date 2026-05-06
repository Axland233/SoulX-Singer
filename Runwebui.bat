@echo off
setlocal EnableExtensions EnableDelayedExpansion

cd /d "%~dp0"

set "PORT=7860"
set "WEB_URL=http://localhost:%PORT%"
set "RUNTIME_DIR=%~dp0runtime"
set "PY_DIR=%RUNTIME_DIR%\python310"
set "PY_EXE=%PY_DIR%\python.exe"
set "HF_EXE=%PY_DIR%\Scripts\hf.exe"
set "PY_INSTALLER=%RUNTIME_DIR%\python-3.10.11-amd64.exe"
set "PY_URL=https://mirrors.tuna.tsinghua.edu.cn/python/3.10.11/python-3.10.11-amd64.exe"
set "PIP_INDEX=https://pypi.tuna.tsinghua.edu.cn/simple"
set "HF_ENDPOINT=https://hf-mirror.com"
set "MODEL_DIR=%~dp0pretrained_models\SoulX-Singer"
set "DEPS_MARKER=%RUNTIME_DIR%\.requirements-installed"

if not exist "%RUNTIME_DIR%" mkdir "%RUNTIME_DIR%"
if not exist "%~dp0pretrained_models" mkdir "%~dp0pretrained_models"

call :CheckModel
if exist "%PY_EXE%" if exist "%DEPS_MARKER%" if "!MODEL_READY!"=="1" goto Launch

echo.
echo [1/4] Preparing portable Python 3.10.11...
if not exist "%PY_EXE%" (
    if not exist "%PY_INSTALLER%" (
        echo Downloading Python from Tsinghua mirror...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri '%PY_URL%' -OutFile '%PY_INSTALLER%'"
        if errorlevel 1 goto Error
    )

    echo Installing Python into runtime\python310...
    "%PY_INSTALLER%" /quiet InstallAllUsers=0 TargetDir="%PY_DIR%" Include_pip=1 Include_launcher=0 PrependPath=0 Shortcuts=0 SimpleInstall=1
    if errorlevel 1 goto Error
)

if not exist "%PY_EXE%" (
    echo Python installation failed: "%PY_EXE%" was not found.
    goto Error
)

echo.
echo [2/4] Configuring mirrors...
set "HF_ENDPOINT=https://hf-mirror.com"
setx HF_ENDPOINT "https://hf-mirror.com" >nul
"%PY_EXE%" -m pip config set global.index-url "%PIP_INDEX%"
"%PY_EXE%" -m pip config set global.trusted-host "pypi.tuna.tsinghua.edu.cn"
if errorlevel 1 goto Error

echo.
echo [3/4] Installing Python packages...
"%PY_EXE%" -m pip install --upgrade pip -i "%PIP_INDEX%"
if errorlevel 1 goto Error
"%PY_EXE%" -m pip install -r requirements.txt -i "%PIP_INDEX%"
if errorlevel 1 goto Error
type nul > "%DEPS_MARKER%"

echo.
echo [4/4] Downloading pretrained models from Hugging Face mirror...
call :CheckModel
if not "!MODEL_READY!"=="1" (
    if exist "%HF_EXE%" (
        "%HF_EXE%" download Soul-AILab/SoulX-Singer --local-dir "%MODEL_DIR%"
        if errorlevel 1 goto Error
    ) else (
        "%PY_EXE%" -m huggingface_hub.commands.huggingface_cli download Soul-AILab/SoulX-Singer --local-dir "%MODEL_DIR%"
        if errorlevel 1 goto Error
    )
)

:Launch
echo.
echo Starting SoulX-Singer WebUI at %WEB_URL%
powershell -NoProfile -ExecutionPolicy Bypass -Command "$c = New-Object Net.Sockets.TcpClient; try { $c.Connect('127.0.0.1', %PORT%); $c.Close(); exit 0 } catch { exit 1 }"
if not errorlevel 1 (
    echo WebUI is already running.
    call :OpenBrowserNow
    goto End
)
call :OpenBrowserDelayed
set "HF_ENDPOINT=https://hf-mirror.com"
"%PY_EXE%" webui.py --port %PORT%
goto End

:OpenBrowserNow
start "" /min powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process '%WEB_URL%'"
goto :eof

:OpenBrowserDelayed
start "" /min powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Sleep -Seconds 5; Start-Process '%WEB_URL%'"
goto :eof

:CheckModel
set "MODEL_READY=0"
if exist "%MODEL_DIR%\model.pt" if exist "%MODEL_DIR%\config.yaml" set "MODEL_READY=1"
goto :eof

:Error
echo.
echo Deployment failed. Please check the error message above.
pause
exit /b 1

:End
endlocal
