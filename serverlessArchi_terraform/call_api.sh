#!/bin/bash

USER_POOL_CLIENT_ID="3nljptlvnhume5tqotstq69vps"
USERNAME="mahdi"
PASSWORD="MahdiMAbrouk2021*"
API_URL="https://9vauhttdse.execute-api.eu-west-3.amazonaws.com/dev/serverless-demo-path"
        

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
