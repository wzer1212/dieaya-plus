@echo off
REM Build script for Dieaya Plus - Flutter Web Apps
REM This script builds both User App and Business App with correct base-href

setlocal enabledelayedexpansion

echo.
echo ========================================
echo Building Dieaya Plus Flutter Web Apps
echo ========================================
echo.

REM Get the current directory
set PROJECT_ROOT=%cd%

echo [1/4] Building User App (/app)...
echo.

cd "%PROJECT_ROOT%"
if exist "lib\main_dev.dart" (
    echo Building user app with dev configuration...
    call flutter build web --release --base-href /app/
) else (
    call flutter build web --release --base-href /app/
)

if errorlevel 1 (
    echo.
    echo ERROR: Failed to build User App
    pause
    exit /b 1
)

echo.
echo ✓ User App built successfully
echo.

echo [2/4] Building Business App (/businessapp)...
echo.

cd "%PROJECT_ROOT%\businessapp"
if exist "lib\main.dart" (
    call flutter build web --release --base-href /businessapp/
) else (
    echo ERROR: Business app lib/main.dart not found
    cd "%PROJECT_ROOT%"
    pause
    exit /b 1
)

if errorlevel 1 (
    echo.
    echo ERROR: Failed to build Business App
    cd "%PROJECT_ROOT%"
    pause
    exit /b 1
)

echo.
echo ✓ Business App built successfully
echo.

cd "%PROJECT_ROOT%"

echo [3/4] Verifying base-href in index.html files...
echo.

REM Check User App index.html
findstr "<base href=\"/app/\">" "build\web\index.html" >nul
if errorlevel 1 (
    echo WARNING: User App index.html does not contain correct base href
) else (
    echo ✓ User App base-href verified: /app/
)

REM Check Business App index.html
findstr "<base href=\"/businessapp/\">" "businessapp\build\web\index.html" >nul
if errorlevel 1 (
    echo WARNING: Business App index.html does not contain correct base href
) else (
    echo ✓ Business App base-href verified: /businessapp/
)

echo.
echo [4/4] Build Summary
echo ========================================
echo User App:
echo   - Location: %PROJECT_ROOT%\build\web
echo   - Base URL: https://site.tcore.site/app
echo   - Entry: index.html
echo.
echo Business App:
echo   - Location: %PROJECT_ROOT%\businessapp\build\web
echo   - Base URL: https://site.tcore.site/businessapp
echo   - Entry: businessapp/index.html
echo.
echo ========================================
echo Next steps:
echo 1. Commit changes: git add . && git commit -m "Build both apps"
echo 2. Push to GitHub: git push origin main
echo 3. On server pull: git pull origin main
echo 4. Copy files: cp -r build/web/* . && cp -r businessapp/build/web/* businessapp/
echo 5. Reload Nginx: sudo systemctl reload nginx
echo ========================================
echo.

pause
