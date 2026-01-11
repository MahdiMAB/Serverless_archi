#!/bin/bash

USER_POOL_CLIENT_ID="5u22te63u8hd5ojheg7l5ee4k3"
USERNAME="Mahdi"
PASSWORD="MahdiMabrouk2026*"
API_URL="https://dsmh7202x6.execute-api.eu-west-3.amazonaws.com/dev/serverless-demo-path"

# 1️⃣ Authentification Cognito
echo "🔐 Authentification Cognito..."

AUTH_RESPONSE=$(aws cognito-idp initiate-auth \
  --auth-flow USER_PASSWORD_AUTH \
  --client-id "$USER_POOL_CLIENT_ID" \
  --auth-parameters USERNAME="$USERNAME",PASSWORD="$PASSWORD")

# 2️⃣ Extraction du IdToken
ID_TOKEN=$(echo "$AUTH_RESPONSE" | jq -r '.AuthenticationResult.IdToken')

if [ "$ID_TOKEN" == "null" ]; then
  echo "❌ Échec authentification"
  exit 1
fi

echo "✅ Token récupéré"

# 3️⃣ Appel API Gateway sécurisé
echo " Appel API Gateway..."

curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ID_TOKEN" \
  -d @test.json \
  "$API_URL"
