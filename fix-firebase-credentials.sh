#!/bin/bash

# Fix Firebase Credentials Script
# Fix the malformed Firebase private key

echo "🔧 Fixing Firebase Credentials"
echo "=============================="

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
echo "🔧 Step 1: Backup Current Firebase File"
echo "======================================"

if [ -f "firebase-service-account.json" ]; then
    cp firebase-service-account.json firebase-service-account.backup.json
    echo "✅ Backup created"
else
    echo "❌ Firebase file not found"
fi

echo ""
echo "🔧 Step 2: Create Corrected Firebase Service Account"
echo "=================================================="

# Create Firebase service account file with properly formatted private key
echo "📝 Creating corrected Firebase service account file..."
cat > firebase-service-account.json << 'FIREBASE_EOF'
{
  "type": "service_account",
  "project_id": "secrets-wedding",
  "private_key_id": "80f5c6b912b41fb7a293dece4338200f16eb7d4a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDC3FT+We+5ob8s\nlxcteKAgcHVMAo2XFZTSDu+B13qdX4VhWDLs3bgGJcX8wLxlnQ8nHTQ9HjRfV7cn\nAyHxWRNbtIMZS032NexrhwhmxRIX+iRrHzUEPfbbpFW8yB7gMDa1vYummGkXv5m8\nHrlzuBNN9sCSDUajY9vhmPF/cT7WKSlwMeNe3+qOlsBHhlcZMa0Dm0d11ZweFCZM\n73CeYdZ88epFJBi5vFibnw+ctXgf36chkxMQePrEN/6tRGZ5BouJL8ROFNp7IrlT\neDvDeASuJAkBDsu+fPWeVRDHauoh39SEsg4ZWvghm9YFxpayvnvsWIrWNIhne1Q1\n3z6ER+tDAgMBAAECggEAGkNaDUIP5mQfgSIIFK/aXSTrGkiJzuAww7MRot1pAEb8\nkicyDezAPcvfiHZtrgBiJ3JvNQGaK3OGEvMAIyhPTJ/iv4j/w/x2lfOINVnAW4zy\nVaHKIn07hVT73UrXpn25EfuvE9Ac8f939/voIOmhaHOmdsjlSWZPH3PesL+RqYl8\neeAXbFuW4+7493TQV+S6Vw533MjqR2pkiSoM0aWoW0qHpfJsozalv3c2H7m4Wbtg\no6LD2O1kM8JWOnH2FI4IjpLzlm0b8GMntFsTjVAKF/s6UP+Ld63s7kJmlME/34V9\ngoyWa1bY3EtxY8xICny+45bsYtnDohf0zRO+sk0RgQKBgQDmAzqLJL2VryeuSBx9\nhjfT4Y0j2iMk8v+/831xDQ4+PiREL2FN3bsZEl2elWcVHB5YqOHeE4tXrr2k+3Gx\npuo5F9gmDwE6uAYv3nDLZiNqSfLeQ2wlhYYh3SCg1iaRUZ9+Qe+4BENfW2uqNfn4\nfRv+eqcht6wTJf4c2VRzfr7RAwKBgQDY4GLNVMwhlowr3czqvXY7rci6oJKVTNp+\npjsxg0kLicEwK+a2o+p/jfsdEaDeNHtrbJ+3eZLrPsp8kQnm+Vlp0FTNXEyt8vVZ\nrfxIj4ofGbLLuwCCXXD/oOFKuYoAguMhE8avO9zYETbgC5H2cCfxN+hralifkvDq\nliwHGbbIwQKBgAxgBBhUY7bX86SW0KGYRQyrR/Kz28wzHrtvGEKq1ydWJJFekzej\nRFu29z5+/0rNdnyCqZRPLOIMzrs/pABQ4K0tsT1q9T/5gqu0phDrb+BaFi0LJ5hl\nNLBBu22r1+tdnt0mIwWdhRpuSr6fpNFPud/ZLYDM5v8oviFDOB32pcGNAoGBAJkV\nqigt1vlOfxrnsSFxIuf1P18cwNtKKGCFjfrhJMpULl2GX5BEG951pe9a5iZy/TtS\nrVqhIieTZvKOnmK/V3HtcC6VHDsc6DqpKQ8+4swZI6/TDAT5WC3Yra5FUTgTK6fJ\ngdFne/e4DvgOsrU1bbxDLnfD1VKuMggkgGdyqycBAoGBANgHTk34MQaPMvCIEAhk\n0LM7Lx/XUXXsSEx/Z5OmuDU8rAnDCd0xvcZjNt1sMk9Rctl7voQO2BVvCsdY8UVT\njxmMswxhFvZrVewxDcMtaf2qJZem8qm714Gr0U4bK4YRdcveLrcd9T5PsplDitpw\np50mFJ+nBc6n47ewrqkECwcW\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-fbsvc@secrets-wedding.iam.gserviceaccount.com",
  "client_id": "100124235240975477019",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40secrets-wedding.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
FIREBASE_EOF

# Set proper permissions
chmod 600 firebase-service-account.json

echo "✅ Firebase service account file recreated with correct formatting"

echo ""
echo "🔧 Step 3: Validate JSON Format"
echo "=============================="

# Validate the JSON format
if node -e "JSON.parse(require('fs').readFileSync('firebase-service-account.json', 'utf8'))" 2>/dev/null; then
    echo "✅ Firebase JSON is valid"
else
    echo "❌ Firebase JSON is invalid"
    exit 1
fi

echo ""
echo "🔧 Step 4: Restart Application"
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
echo "⏳ Step 5: Wait for Initialization"
echo "================================="

echo "⏳ Waiting 10 seconds for Firebase to initialize..."
sleep 10

echo ""
echo "🧪 Step 6: Test Firebase Connection"
echo "=================================="

PORT=3001

# Test Firebase connection
echo "🔍 Testing Firebase connection..."
FIREBASE_TEST=$(curl -s http://localhost:$PORT/api/notifications/test)
echo "Response: $FIREBASE_TEST"

echo ""

# Test notification status
echo "🔍 Testing notification status..."
NOTIF_STATUS=$(curl -s http://localhost:$PORT/api/notifications/status)
echo "Response: $NOTIF_STATUS"

echo ""

# Test real notification sending
echo "🔍 Testing real notification sending..."
FCM_TOKEN="fYZUgAHuTX-mAvjjWoLnHk:APA91bGBwjNs0EzbfFYBWffdgD3V86YNWryNg1oP-gpoZ7zEmIdf3CXIWjYZgHqto-3v5uzbYUisUyA8tu5gyJl6fV5S6LowCXhVFG2-lyhOtJwVIHqKHZw"

NOTIF_SEND=$(curl -s -X POST -H "Content-Type: application/json" -d "{\"token\":\"$FCM_TOKEN\",\"title\":\"Firebase Fixed!\",\"body\":\"Firebase notifications are now working from your server!\"}" http://localhost:$PORT/api/notifications/send)

echo "Response: $NOTIF_SEND"

echo ""
echo "🎉 FIREBASE FIX COMPLETE!"
echo "========================"

echo ""
echo "📊 Current PM2 Status:"
pm2 status

echo ""
echo "🎯 Test Commands:"
echo "   curl http://localhost:$PORT/api/notifications/status"
echo "   curl http://localhost:$PORT/api/notifications/test"
echo ""

if [[ "$FIREBASE_TEST" == *"success"* ]] && [[ "$NOTIF_SEND" == *"success"* ]]; then
    echo "🎉 SUCCESS! Firebase notifications are now working!"
    echo "📱 Check your device for the test notification!"
else
    echo "⚠️ Firebase may still have issues. Check the responses above."
    echo "📋 Check application logs: pm2 logs $PROJECT_NAME"
fi

echo ""
echo "✅ Firebase credentials fix completed!"
