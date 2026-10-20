@echo off
setlocal
cd /d "%~dp0"

if not exist ".env" (
    echo .env is missing. Create it with a line: DEEPSEEK_API_KEY=your key
    pause
    exit /b 1
)

powershell.exe -NoProfile -Command "$ErrorActionPreference='Stop'; try { $health=Invoke-RestMethod -Uri 'http://127.0.0.1:5000/api/health' -TimeoutSec 1 } catch { exit 0 }; if ($health.service -ne 'veritas-media-lab') { $page=(& curl.exe --noproxy '*' -fsS --max-time 2 'http://127.0.0.1:5000/') -join ''; if ($page -notmatch '<title>Veritas Media Lab</title>') { Write-Error 'Port 5000 is used by another service; it was not stopped.'; exit 2 } }; $listener=Get-NetTCPConnection -LocalPort 5000 -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1; if ($listener) { $process=Get-CimInstance Win32_Process -Filter \"ProcessId = $($listener.OwningProcess)\"; if (-not $process -or $process.CommandLine -notmatch 'app\.py') { Write-Error 'The Veritas listener process could not be verified; it was not stopped.'; exit 3 }; Stop-Process -Id $listener.OwningProcess -Force }"
if errorlevel 1 (
    echo Could not safely restart Veritas on port 5000. No other application was stopped.
    pause
    exit /b 1
)
timeout /t 2 /nobreak >nul
start "Veritas Media Lab Server" /min py -X utf8 -u app.py

for /L %%i in (1,1,30) do (
    curl.exe -fsS --max-time 1 http://127.0.0.1:5000/api/health >nul 2>&1
    if not errorlevel 1 goto open_site
    timeout /t 1 /nobreak >nul
)

echo Veritas could not start. Check that Python, Flask, and requests are installed.
pause
exit /b 1

:open_site
start "" http://127.0.0.1:5000/
endlocal
