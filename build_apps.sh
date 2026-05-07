#!/bin/bash

# Build script for Dieaya Plus - Flutter Web Apps
# This script builds both User App and Business App with correct base-href

set -e  # Exit on error

echo ""
echo "========================================"
echo "Building Dieaya Plus Flutter Web Apps"
echo "========================================"
echo ""

PROJECT_ROOT=$(pwd)

# Build User App
echo "[1/4] Building User App (/app)..."
echo ""

cd "$PROJECT_ROOT"
flutter build web --release --base-href /app/

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ User App built successfully"
    echo ""
else
    echo ""
    echo "ERROR: Failed to build User App"
    exit 1
fi

# Build Business App
echo "[2/4] Building Business App (/businessapp)..."
echo ""

cd "$PROJECT_ROOT/businessapp"
flutter build web --release --base-href /businessapp/

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Business App built successfully"
    echo ""
else
    echo ""
    echo "ERROR: Failed to build Business App"
    exit 1
fi

cd "$PROJECT_ROOT"

# Verify base-href
echo "[3/4] Verifying base-href in index.html files..."
echo ""

if grep -q '<base href="/app/">' "build/web/index.html"; then
    echo "✓ User App base-href verified: /app/"
else
    echo "WARNING: User App index.html does not contain correct base href"
fi

if grep -q '<base href="/businessapp/">' "businessapp/build/web/index.html"; then
    echo "✓ Business App base-href verified: /businessapp/"
else
    echo "WARNING: Business App index.html does not contain correct base href"
fi

echo ""
echo "[4/4] Build Summary"
echo "========================================"
echo "User App:"
echo "   - Location: $PROJECT_ROOT/build/web"
echo "   - Base URL: https://site.tcore.site/app"
echo "   - Entry: index.html"
echo ""
echo "Business App:"
echo "   - Location: $PROJECT_ROOT/businessapp/build/web"
echo "   - Base URL: https://site.tcore.site/businessapp"
echo "   - Entry: businessapp/index.html"
echo ""
echo "========================================"
echo "Next steps:"
echo "1. Commit changes: git add . && git commit -m \"Build both apps\""
echo "2. Push to GitHub: git push origin main"
echo "3. On server pull: git pull origin main"
echo "4. Copy files:"
echo "   - cp -r build/web/* /www/wwwroot/dieaya-plus/"
echo "   - cp -r businessapp/build/web/* /www/wwwroot/dieaya-plus/businessapp/"
echo "5. Reload Nginx: sudo systemctl reload nginx"
echo "========================================"
echo ""
