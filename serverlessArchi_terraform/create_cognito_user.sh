#!/bin/bash
USER_POOL_ID="${1:-eu-west-3_mMRDuHSF6}"           
USERNAME="${2:-mahdi}"                              
PASSWORD="${3:-MahdiMAbrouk2021*}"                 
EMAIL="${4:-mabroukmahdielec@gmail.com}"          

echo "Création de l'utilisateur '$USERNAME' dans le user pool '$USER_POOL_ID' ..."


# Création de l'utilisateur avec mot de passe temporaire
CREATE_OUTPUT=$(aws cognito-idp admin-create-user \
    --user-pool-id "$USER_POOL_ID" \
    --username "$USERNAME" \
    --temporary-password "$PASSWORD" \
    --user-attributes Name=email,Value="$EMAIL" \
    --message-action SUPPRESS \
    --query "User.Username" \
    --output text 2>/dev/null) || true

if [ "$CREATE_OUTPUT" = "$USERNAME" ]; then
    echo "Utilisateur créé : $CREATE_OUTPUT"
else
    echo "Utilisateur déjà existant, on continue..."
fi

#  Définir le mot de passe en permanent
aws cognito-idp admin-set-user-password \
    --user-pool-id "$USER_POOL_ID" \
    --username "$USERNAME" \
    --password "$PASSWORD" \
    --permanent \
    --output text >/dev/null 2>&1

echo "✅ Utilisateur '$USERNAME' prêt avec mot de passe permanent."
