# Unseen Backend API

Simple authentication backend for the Unseen iOS app.

## Endpoints

- `POST /auth/signup` - Create new user account
- `POST /auth/login` - Login existing user
- `GET /auth/validate` - Validate session token

## Local Development

```bash
npm install
npm start
```

Server runs on http://localhost:3000

## Deploy to Railway

1. Push this folder to GitHub
2. Go to railway.app
3. Create new project from GitHub repo
4. Railway auto-detects and deploys
5. Copy your app URL

## Environment Variables

- `PORT` - Server port (Railway sets automatically)
- `JWT_SECRET` - Secret key for JWT tokens (set in Railway dashboard)
