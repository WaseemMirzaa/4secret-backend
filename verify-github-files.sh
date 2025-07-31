#!/bin/bash

# Verify GitHub Files Script
# Check if all required files are available on GitHub

echo "🔍 Verifying GitHub Repository Files"
echo "===================================="

REPO_URL="https://github.com/WaseemMirzaa/image_uploading_node_api.git"
TEMP_DIR="/tmp/github-verify-$(date +%s)"

echo "📥 Cloning repository to temporary directory..."
git clone "$REPO_URL" "$TEMP_DIR"

if [ $? -ne 0 ]; then
    echo "❌ Failed to clone repository"
    exit 1
fi

cd "$TEMP_DIR"

echo ""
echo "🔍 Checking Required Files:"
echo "=========================="

# Check server.js
if [ -f "server.js" ]; then
    echo "✅ server.js found"
else
    echo "❌ server.js missing"
fi

# Check src/app.js
if [ -f "src/app.js" ]; then
    echo "✅ src/app.js found"
else
    echo "❌ src/app.js missing"
fi

# Check notification controller
if [ -f "src/controllers/notificationController.js" ]; then
    echo "✅ Notification controller found"
else
    echo "❌ Notification controller missing"
fi

# Check notification routes
if [ -f "src/routes/notificationRoutes.js" ]; then
    echo "✅ Notification routes found"
else
    echo "❌ Notification routes missing"
fi

# Check email controller
if [ -f "src/controllers/emailController.js" ]; then
    echo "✅ Email controller found"
else
    echo "❌ Email controller missing"
fi

# Check email routes
if [ -f "src/routes/emailRoutes.js" ]; then
    echo "✅ Email routes found"
else
    echo "❌ Email routes missing"
fi

# Check file controller
if [ -f "src/controllers/fileController.js" ]; then
    echo "✅ File controller found"
else
    echo "❌ File controller missing"
fi

# Check package.json
if [ -f "package.json" ]; then
    echo "✅ package.json found"
else
    echo "❌ package.json missing"
fi

# Check deployment script
if [ -f "fresh-deploy-from-github.sh" ]; then
    echo "✅ Deployment script found"
else
    echo "❌ Deployment script missing"
fi

echo ""
echo "📁 Directory Structure:"
echo "======================"
echo "📁 Root files:"
ls -la | grep -E "^-" | awk '{print "   " $9}'

echo ""
echo "📁 src/ directory:"
if [ -d "src" ]; then
    find src -type f | head -20 | while read file; do
        echo "   ✅ $file"
    done
else
    echo "   ❌ src/ directory missing"
fi

echo ""
echo "🧹 Cleaning up..."
cd /
rm -rf "$TEMP_DIR"

echo "✅ Verification complete!"
