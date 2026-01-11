#!/bin/bash
USER_POOL_ID= "" #your youser pool id 
USERNAME= "" #your youser pool id 
PASSWORD= "" #your youser pool id 
EMAIL= "" #your youser pool id 

echo "Création de l'utilisateur $USERNAME dans le user pool $USER_POOL_ID ..."

aws cognito-idp admin-create-user \
  --user-pool-id "$USER_POOL_ID" \
  --username "$USERNAME" \
  --temporary-password "$PASSWORD" \
  --user-attributes Name=email,Value="$EMAIL" \
  --message-action SUPPRESS \
  || echo "Utilisateur déjà existant, on continue..."

aws cognito-idp admin-set-user-password \
  --user-pool-id "$USER_POOL_ID" \
  --username "$USERNAME" \
  --password "$PASSWORD" \
  --permanent

echo "OK ✅ Utilisateur prêt"
