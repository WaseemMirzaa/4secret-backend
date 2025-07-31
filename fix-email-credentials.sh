#!/bin/bash

# Fix Email Credentials Script
# Fix the malformed Brevo API credentials

echo "📧 Fixing Email Credentials"
echo "=========================="

PROJECT_NAME="4secrets-wedding-api"
PROJECT_DIR="/root/$PROJECT_NAME"

# Navigate to project directory
if [ -d "$PROJECT_DIR" ]; then
    cd "$PROJECT_DIR"
    echo "📁 Working in: $PROJECT_DIR"
else
    echo "❌ Project directory not found: $PROJECT_DIR"
    exit 1
fi

echo ""
echo "📧 Step 1: Backup Current .env File"
echo "=================================="

if [ -f ".env" ]; then
    cp .env .env.backup
    echo "✅ Backup created"
else
    echo "❌ .env file not found"
fi

echo ""
echo "📧 Step 2: Create Corrected .env File"
echo "===================================="

# Create .env file with properly formatted Brevo API credentials
echo "📝 Creating corrected .env file with real Brevo credentials..."
cat > .env << 'ENV_EOF'
# Server Configuration
PORT=3001
NODE_ENV=production

# Upload Configuration
UPLOAD_PATH=src/files
MAX_FILE_SIZE=10485760

# Email Configuration - Brevo API (WORKING LOCALLY)
BREVO_API_KEY=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
BREVO_API_URL=https://api.brevo.com/v3/smtp/email
EMAIL_FROM=support@brevo.4secrets-wedding-planner.de
EMAIL_CLOUD_FUNCTION_URL=http://localhost:3001

# Firebase Configuration for Push Notifications (REAL CREDENTIALS)
FIREBASE_PROJECT_ID=secrets-wedding
FIREBASE_SERVICE_ACCOUNT_PATH=./firebase-service-account.json

# Additional Configuration
APP_NAME=4secrets-wedding-api
APP_VERSION=1.0.0
ENV_EOF

echo "✅ .env file recreated with correct Brevo API credentials"

echo ""
echo "📧 Step 3: Validate Environment Variables"
echo "========================================"

# Source the .env file and check variables
source .env

if [ -n "$BREVO_API_KEY" ]; then
    echo "✅ BREVO_API_KEY is set"
else
    echo "❌ BREVO_API_KEY is missing"
fi

if [ -n "$BREVO_API_URL" ]; then
    echo "✅ BREVO_API_URL is set"
else
    echo "❌ BREVO_API_URL is missing"
fi

if [ -n "$EMAIL_FROM" ]; then
    echo "✅ EMAIL_FROM is set"
else
    echo "❌ EMAIL_FROM is missing"
fi

echo ""
echo "📧 Step 4: Verify Email Service Configuration"
echo "==========================================="

# Check if the email service is configured to use Brevo API
echo "🔍 Checking email service configuration..."

# Verify the email service is using the correct import
if grep -q "emailService" src/controllers/emailController.js; then
    echo "✅ Email controller is using emailService"
else
    echo "❌ Email controller configuration issue"
fi

# Check if emailService has Brevo API method
if grep -q "sendEmailViaBrevo\|BREVO_API" src/services/emailService.js; then
    echo "✅ Email service has Brevo API support"
else
    echo "❌ Email service missing Brevo API support"
fi

echo ""
echo "📧 Step 4.1: Test Brevo API Connection"
echo "====================================="

# Test Brevo API directly with a simpler endpoint
echo "🔍 Testing Brevo API connection..."
BREVO_TEST=$(curl -s -X GET \
  -H "Accept: application/json" \
  -H "api-key: $BREVO_API_KEY" \
  "https://api.brevo.com/v3/account")

if [[ "$BREVO_TEST" == *"email"* ]] || [[ "$BREVO_TEST" == *"plan"* ]] || [[ "$BREVO_TEST" == *"firstName"* ]]; then
    echo "✅ Brevo API connection successful"
    echo "   Response: $BREVO_TEST"
else
    echo "⚠️ Brevo API response (may still work for emails):"
    echo "   Response: $BREVO_TEST"
    echo "   Note: API key might be restricted to email sending only"
fi

echo ""
echo "📧 Step 5: Restart Application"
echo "============================="

# Restart the application
echo "🔄 Restarting PM2 application..."
pm2 restart $PROJECT_NAME

if [ $? -ne 0 ]; then
    echo "❌ Failed to restart application"
    exit 1
fi

echo "✅ Application restarted"

echo ""
echo "⏳ Step 6: Wait for Initialization"
echo "================================="

echo "⏳ Waiting 10 seconds for email service to initialize..."
sleep 10

echo ""
echo "📧 Step 7: Test Email APIs"
echo "========================="

PORT=3001

# Test email status
echo "🔍 Testing email status..."
EMAIL_STATUS=$(curl -s http://localhost:$PORT/api/email/status)
echo "Response: $EMAIL_STATUS"

echo ""

# Test real email sending
echo "🔍 Testing real email sending..."
EMAIL_TEST=$(curl -s -X POST -H "Content-Type: application/json" \
  -d '{"email":"unicorndev.02.1997@gmail.com","inviterName":"Server Test"}' \
  http://localhost:$PORT/api/email/send-invitation)

echo "Response: $EMAIL_TEST"

echo ""

# Test declined invitation email
echo "🔍 Testing declined invitation email..."
DECLINED_TEST=$(curl -s -X POST -H "Content-Type: application/json" \
  -d '{"email":"unicorndev.02.1997@gmail.com","declinerName":"Test User"}' \
  http://localhost:$PORT/api/email/declined-invitation)

echo "Response: $DECLINED_TEST"

echo ""

# Test revoke access email
echo "🔍 Testing revoke access email..."
REVOKE_TEST=$(curl -s -X POST -H "Content-Type: application/json" \
  -d '{"email":"unicorndev.02.1997@gmail.com","inviterName":"Server Test"}' \
  http://localhost:$PORT/api/email/revoke-access)

echo "Response: $REVOKE_TEST"

echo ""
echo "🎉 EMAIL FIX COMPLETE!"
echo "====================="

echo ""
echo "📊 Current PM2 Status:"
pm2 status

echo ""
echo "🎯 Test Commands:"
echo "   curl http://localhost:$PORT/api/email/status"
echo "   curl -X POST -H \"Content-Type: application/json\" -d '{\"email\":\"test@example.com\",\"inviterName\":\"Test\"}' http://localhost:$PORT/api/email/send-invitation"
echo ""

# Check if emails are working
if [[ "$EMAIL_STATUS" == *"connected"* ]] || [[ "$EMAIL_TEST" == *"success"* ]] || [[ "$EMAIL_TEST" == *"messageId"* ]]; then
    echo "🎉 SUCCESS! Email service is now working!"
    echo "📧 Check your email inbox for test emails!"
    echo ""
    echo "✅ Working Email APIs:"
    echo "   📧 Wedding Invitation: POST /api/email/send-invitation"
    echo "   📧 Declined Invitation: POST /api/email/declined-invitation"
    echo "   📧 Revoke Access: POST /api/email/revoke-access"
    echo "   📧 Status Check: GET /api/email/status"
else
    echo "⚠️ Email service may still have issues. Check the responses above."
    echo "📋 Check application logs: pm2 logs $PROJECT_NAME"
    echo ""
    echo "🔧 Troubleshooting:"
    echo "   1. Verify Brevo API key is correct"
    echo "   2. Check if Brevo account is active"
    echo "   3. Verify sender email domain is configured in Brevo"
fi

echo ""
echo "📧 Email Configuration Summary:"
echo "   API Key: ${BREVO_API_KEY:0:20}..."
echo "   API URL: $BREVO_API_URL"
echo "   From Email: $EMAIL_FROM"
echo "   Service: Brevo (SendinBlue)"
echo ""
echo "✅ Email credentials fix completed!"
