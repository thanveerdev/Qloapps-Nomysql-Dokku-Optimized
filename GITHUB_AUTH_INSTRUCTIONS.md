# GitHub Authentication Setup

GitHub no longer accepts passwords for Git operations. You have two options:

## Option 1: Use Personal Access Token (HTTPS) - Recommended for quick setup

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate a new token with `repo` scope
3. Copy the token
4. Use it as password when pushing:

```bash
git push -u origin main
# Username: thanveerdev
# Password: <paste your token here>
```

Or set it in the URL:
```bash
git remote set-url origin https://thanveerdev:YOUR_TOKEN@github.com/thanveerdev/Qloapps-Nomysql-Dokku-Optimized.git
git push -u origin main
```

## Option 2: Use SSH (More secure, recommended for long-term)

1. Generate SSH key (if you don't have one):
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub
```

2. Add the public key to GitHub:
   - Go to GitHub → Settings → SSH and GPG keys
   - Click "New SSH key"
   - Paste your public key

3. Change remote to SSH:
```bash
git remote set-url origin git@github.com:thanveerdev/Qloapps-Nomysql-Dokku-Optimized.git
git push -u origin main
```

## Quick Fix (Using Token in URL)

If you have a token ready, run:
```bash
git remote set-url origin https://thanveerdev:YOUR_TOKEN@github.com/thanveerdev/Qloapps-Nomysql-Dokku-Optimized.git
git push -u origin main
```

Replace YOUR_TOKEN with your actual personal access token.
