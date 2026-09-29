@echo off
REM Yerel model sunucusunu durdurur ve RAM/VRAM'i geri verir.
REM Penceresi gorunmeyen (arka planda kalmis) surecleri de yakalar.
REM DIKKAT: calisan TUM llama-server.exe sureclerini kapatir.
REM Windows araclari tam yolla cagriliyor - PATH'teki unix araclari (Git Bash vb.) golgelemesin.
setlocal
set "TL=%SystemRoot%\System32\tasklist.exe"
set "TK=%SystemRoot%\System32\taskkill.exe"
set "FS=%SystemRoot%\System32\findstr.exe"

"%TL%" /FI "IMAGENAME eq llama-server.exe" /NH | "%FS%" /I "llama-server.exe" >nul
if errorlevel 1 (
    echo Yerel model sunucusu zaten kapali.
    echo.
    pause
    exit /b 0
)

echo Calisan llama-server bulundu, durduruluyor...
"%TK%" /F /IM llama-server.exe
echo.
echo Durduruldu. RAM ve VRAM serbest birakildi.
echo.
pause
