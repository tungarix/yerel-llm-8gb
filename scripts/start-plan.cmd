@echo off
REM ============================================================
REM  PLANLAMA modeli - Qwen3.5-9B (UD-Q4_K_XL)
REM  Tamami GPU'da, dusunme ACIK, port 8081, SADECE localhost
REM
REM  Degistirilebilir (cagirmadan once set ile ez):
REM    LLAMA_DIR  llama-server.exe'nin klasoru   (C:\llama.cpp)
REM    MODEL      .gguf dosyasinin tam yolu       (%LLAMA_DIR%\models\...)
REM    CTX        baglam uzunlugu                 (32768)
REM    PORT       dinlenen port                   (8081)
REM ============================================================
setlocal
set "TL=%SystemRoot%\System32\tasklist.exe"
set "FS=%SystemRoot%\System32\findstr.exe"

REM --- iki model ayni anda VRAM'e sigmaz: once digerini kontrol et ---
"%TL%" /FI "IMAGENAME eq llama-server.exe" /NH | "%FS%" /I "llama-server.exe" >nul
if not errorlevel 1 (
    echo.
    echo   UYARI: Zaten calisan bir model sunucusu var.
    echo   Iki model ayni anda 8 GB VRAM'e SIGMAZ.
    echo.
    echo   Once stop-qwen.cmd ile onu kapat,
    echo   sonra bunu tekrar calistir.
    echo.
    pause
    exit /b 1
)

if not defined LLAMA_DIR set "LLAMA_DIR=C:\llama.cpp"
if not defined MODEL set "MODEL=%LLAMA_DIR%\models\Qwen3.5-9B-UD-Q4_K_XL.gguf"
if not defined CTX set "CTX=32768"
if not defined PORT set "PORT=8081"

if not exist "%MODEL%" goto :modelyok

echo ============================================
echo   PLANLAMA modeli baslatiliyor
echo   Qwen3.5-9B ^| ctx=%CTX% ^| port=%PORT% ^| dusunme ACIK
echo ============================================
echo.
echo   Bu pencereyi KAPATMA - kapatirsan sunucu da durur.
echo.

"%LLAMA_DIR%\llama-server.exe" ^
  --model "%MODEL%" ^
  --alias qwen3.5-9b-plan ^
  --host 127.0.0.1 ^
  --port %PORT% ^
  --api-key local ^
  --ctx-size %CTX% ^
  --n-gpu-layers 99 ^
  --load-mode none ^
  --flash-attn on ^
  --cache-type-k q8_0 --cache-type-v q8_0 ^
  --threads 8 ^
  --batch-size 2048 ^
  --ubatch-size 512 ^
  --parallel 1 ^
  --cache-ram 1024 ^
  --jinja ^
  --reasoning on ^
  --reasoning-format deepseek ^
  --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.0 ^
  --presence-penalty 0.0

endlocal
goto :eof

:modelyok
echo   HATA: model dosyasi bulunamadi: "%MODEL%"
echo   MODEL veya LLAMA_DIR degiskenini ayarla.
pause
endlocal
exit /b 1
