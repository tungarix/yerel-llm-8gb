@echo off
REM KODLAMA modelinin hafif hali: 32K baglam, daha az RAM / daha cok GPU.
REM Tarayici vb. acikken ya da bos RAM 1.5 GB altina dustugunde bunu kullan.
setlocal
set "CTX=32768"
set "NCMOE=20"
call "%~dp0start-qwen.cmd"
endlocal
