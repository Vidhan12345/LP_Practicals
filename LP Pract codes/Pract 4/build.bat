@echo off
setlocal

REM Define tool paths
set "BISON_DIR=C:\GnuWin32\bin"
set "MINGW_DIR=C:\MinGW\bin"

REM Add tools to PATH
set "PATH=%BISON_DIR%;%MINGW_DIR%;%PATH%"

echo Building parser...
echo Using Bison from: %BISON_DIR%
echo Using GCC from: %MINGW_DIR%

REM Run bison
"%BISON_DIR%\bison.exe" -d parser.y
if errorlevel 1 (
    echo Bison compilation failed
    pause
    exit /b 1
)

REM Compile with gcc
"%MINGW_DIR%\gcc.exe" parser.tab.c -o parser.exe
if errorlevel 1 (
    echo GCC compilation failed
    pause
    exit /b 1
)

echo Build successful!
echo Run parser.exe to test
pause