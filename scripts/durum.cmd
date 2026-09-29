@echo off
REM Hangi model acik, ne kadar kaynak kullaniyor?
REM Windows araclari tam yolla cagriliyor - PATH'teki unix araclari (Git Bash vb.) golgelemesin.
setlocal
set "TL=%SystemRoot%\System32\tasklist.exe"
set "FS=%SystemRoot%\System32\findstr.exe"
set "NS=%SystemRoot%\System32\netstat.exe"

echo ============================================
echo   Yerel modeller - DURUM
echo ============================================
echo.

"%TL%" /FI "IMAGENAME eq llama-server.exe" /NH | "%FS%" /I "llama-server.exe" >nul
if errorlevel 1 (
    echo   Calisan model : YOK  ^(ikisi de kapali^)
    echo.
    echo   Baslatmak icin:
    echo     start-qwen.cmd   - KODLAMA,  port 8080
    echo     start-plan.cmd   - PLANLAMA, port 8081
    echo.
    pause
    exit /b 0
)

REM hangi port dinleniyor?
"%NS%" -ano | "%FS%" /C:"127.0.0.1:8080" | "%FS%" /I "LISTENING" >nul
if not errorlevel 1 echo   Calisan model : KODLAMA   ^(Qwen3.6-35B-A3B, port 8080^)

"%NS%" -ano | "%FS%" /C:"127.0.0.1:8081" | "%FS%" /I "LISTENING" >nul
if not errorlevel 1 echo   Calisan model : PLANLAMA  ^(Qwen3.5-9B, port 8081^)

echo.
echo   Surec ^(PID ve RAM^):
"%TL%" /FI "IMAGENAME eq llama-server.exe"
echo.
echo   VRAM ^(kullanilan / toplam^):
nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader
echo.
echo   Durdurmak icin: stop-qwen.cmd
echo.
pause
