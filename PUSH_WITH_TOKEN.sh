#!/bin/bash
# Script to push to GitHub using Personal Access Token

echo "To push to GitHub, you need a Personal Access Token."
echo ""
echo "1. Go to: https://github.com/settings/tokens"
echo "2. Click 'Generate new token (classic)'"
echo "3. Name it: 'QloApps Docker Push'"
echo "4. Select scope: 'repo'"
echo "5. Generate and copy the token"
echo ""
read -p "Enter your Personal Access Token: " TOKEN

if [ -z "$TOKEN" ]; then
    echo "Token is required. Exiting."
    exit 1
fi

# Set token in remote URL
git remote set-url origin https://thanveerdev:${TOKEN}@github.com/thanveerdev/Qloapps-Nomysql-Dokku-Optimized.git

# Push
echo "Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅ Push complete!"
echo ""
echo "Note: The token is stored in the remote URL. For security, you may want to:"
echo "  git remote set-url origin https://github.com/thanveerdev/Qloapps-Nomysql-Dokku-Optimized.git"
echo "  git config --global credential.helper store"
echo "  (Then use token as password on next push)"
