# Deployment Workflow Examples

This directory contains ready-to-use deployment workflow examples for various platforms. Choose the platform that best fits your project needs and copy the corresponding workflow file to `.github/workflows/`.

> **Quick Tip**: Not sure which platform to choose? See the [Platform Selection Guide](#platform-selection-guide) below.

## 📁 Available Deployment Examples

### Frontend Deployments

| Platform | File | Free Tier | Best For | Setup Time |
|----------|------|-----------|----------|------------|
| **Vercel** | [`frontend/deploy-vercel.yml`](frontend/deploy-vercel.yml) | ✅ Yes | Next.js, React, modern frameworks | 5 min |
| **Netlify** | [`frontend/deploy-netlify.yml`](frontend/deploy-netlify.yml) | ✅ Yes | Static sites, JAMstack | 5 min |
| **AWS S3 + CloudFront** | [`frontend/deploy-aws-s3.yml`](frontend/deploy-aws-s3.yml) | 💰 Pay-as-go | High traffic, CDN needed | 15 min |
| **AWS Amplify** | [`frontend/deploy-aws-amplify.yml`](frontend/deploy-aws-amplify.yml) | 💰 Pay-as-go | AWS ecosystem, fullstack | 10 min |
| **GitHub Pages** | [`frontend/deploy-github-pages.yml`](frontend/deploy-github-pages.yml) | ✅ Free | Simple static sites, docs | 2 min |

### Backend Deployments

| Platform | File | Free Tier | Best For | Setup Time |
|----------|------|-----------|----------|------------|
| **Railway** | [`backend/deploy-railway.yml`](backend/deploy-railway.yml) | ✅ Limited | Quick deploy, databases included | 5 min |
| **Render** | [`backend/deploy-render.yml`](backend/deploy-render.yml) | ✅ Yes | Free tier, automatic SSL | 5 min |
| **Fly.io** | [`backend/deploy-flyio.yml`](backend/deploy-flyio.yml) | ✅ Limited | Global edge deployment | 10 min |
| **AWS ECS** | [`backend/deploy-aws-ecs.yml`](backend/deploy-aws-ecs.yml) | 💰 Pay-as-go | Scalable containers, enterprise | 20 min |
| **GCP Cloud Run** | [`backend/deploy-gcp-cloud-run.yml`](backend/deploy-gcp-cloud-run.yml) | ✅ Limited | Serverless containers | 10 min |

### Fullstack / BaaS

| Platform | File | Free Tier | Best For | Setup Time |
|----------|------|-----------|----------|------------|
| **Supabase** | [`fullstack/deploy-supabase.yml`](fullstack/deploy-supabase.yml) | ✅ Yes | PostgreSQL + Auth + Storage | 10 min |
| **Azure Web App** | [`fullstack/deploy-azure-webapp.yml`](fullstack/deploy-azure-webapp.yml) | ✅ Limited | Microsoft ecosystem | 15 min |

### Docker Registries

| Registry | File | Free | Best For | Setup Time |
|----------|------|------|----------|------------|
| **GitHub Container Registry** | [`docker/deploy-docker-ghcr.yml`](docker/deploy-docker-ghcr.yml) | ✅ Free | GitHub integration | 3 min |
| **AWS ECR** | [`docker/deploy-docker-ecr.yml`](docker/deploy-docker-ecr.yml) | 💰 Pay-as-go | AWS ecosystem | 10 min |
| **Docker Hub** (Current) | See `../deploy.yml` | ✅ Limited | Universal compatibility | 5 min |

---

## 🎯 Platform Selection Guide

### Choose Based on Your Project Type

#### Static Website / Documentation
```
Recommended: GitHub Pages (free, simple)
Alternative: Netlify, Vercel
```

#### Next.js / React Application
```
Recommended: Vercel (optimized for Next.js)
Alternative: Netlify, AWS Amplify
```

#### Node.js / Python / Go API
```
Recommended: Railway (easiest), Render (free tier)
Alternative: Fly.io (global), GCP Cloud Run (scalable)
```

#### Full-Stack Application
```
Recommended: Vercel (frontend) + Railway/Render (backend)
Alternative: AWS (full control), Supabase (BaaS)
```

#### Enterprise / High-Traffic
```
Recommended: AWS ECS + CloudFront
Alternative: GCP Cloud Run, Azure Web App
```

### Choose Based on Priority

#### 💰 **Cost-Conscious** (Free or cheap)
1. GitHub Pages (frontend)
2. Vercel / Netlify (frontend)
3. Render (backend)
4. Supabase (database + auth)

#### ⚡ **Speed of Setup** (Get running fast)
1. Vercel (frontend) - 5 min
2. Railway (backend) - 5 min
3. GitHub Pages - 2 min

#### 📈 **Scalability** (Growth potential)
1. AWS ECS
2. GCP Cloud Run
3. Vercel with serverless functions

#### 🌍 **Global Performance** (Low latency)
1. Vercel (CDN built-in)
2. Fly.io (edge deployment)
3. AWS CloudFront + S3

#### 🔧 **Full Control** (Customization)
1. AWS EC2 / ECS
2. Self-hosted
3. GCP Compute Engine

---

## 📚 How to Use These Examples

### Step 1: Choose Your Platform

Review the tables above and select a platform that matches your needs.

### Step 2: Copy the Workflow File

```bash
# Example: Using Netlify for frontend
cp .github/workflows/deployment-examples/frontend/deploy-netlify.yml \
   .github/workflows/deploy-netlify.yml
```

### Step 3: Configure Required Secrets

Each workflow file lists required secrets at the top. Add them in:

**Settings → Secrets and variables → Actions → New repository secret**

### Step 4: Customize the Workflow

Open the copied file and adjust:
- Project paths (`working-directory`)
- Build commands
- Branch names
- Environment variables

### Step 5: Push and Deploy

```bash
git add .github/workflows/deploy-netlify.yml
git commit -m "feat: add Netlify deployment"
git push
```

The workflow will trigger automatically on the next push to `main`.

---

## 🔄 Using Multiple Platforms

You can deploy frontend and backend to different platforms:

```yaml
# Example: Vercel (frontend) + Railway (backend)

1. Copy frontend/deploy-vercel.yml
2. Copy backend/deploy-railway.yml
3. Configure secrets for both
4. Both deploy automatically on push
```

**Recommended combinations:**
- Vercel + Railway (easiest)
- Netlify + Render (free tiers)
- AWS S3 + AWS ECS (unified AWS)
- Vercel + Supabase (modern stack)

---

## 💡 Platform-Specific Tips

### Vercel
- ✅ Best for Next.js (built by same team)
- ✅ Automatic preview deployments for PRs
- ✅ Built-in analytics and performance monitoring
- ⚠️  Serverless functions have cold starts

### Netlify
- ✅ Great free tier
- ✅ Form handling, A/B testing built-in
- ✅ Easy custom domains
- ⚠️  Slower build times vs Vercel

### Railway
- ✅ Super simple setup
- ✅ Database included (PostgreSQL, Redis, etc.)
- ✅ $5/month free credit
- ⚠️  Free tier limited to 500 hours/month

### Render
- ✅ True free tier (doesn't expire)
- ✅ Automatic SSL
- ⚠️  Free tier spins down after inactivity (slow cold starts)

### Fly.io
- ✅ Deploy to 30+ regions globally
- ✅ Low latency worldwide
- ✅ Free allowance: 3 shared VMs
- ⚠️  Requires Dockerfile

### AWS
- ✅ Complete control and flexibility
- ✅ Massive scalability
- ✅ Integrated services (RDS, S3, etc.)
- ⚠️  Steeper learning curve
- ⚠️  More expensive

### Supabase
- ✅ PostgreSQL database included
- ✅ Authentication, Storage, Edge Functions
- ✅ Great free tier
- ⚠️  Less control over infrastructure

---

## 🆘 Troubleshooting

### Workflow Not Running

1. Check workflow file is in `.github/workflows/` (not in `deployment-examples/`)
2. Verify file has `.yml` extension
3. Check GitHub Actions are enabled (Settings → Actions)
4. Ensure branch name matches trigger (usually `main`)

### Authentication Errors

1. Verify all required secrets are set in repository settings
2. Check secrets haven't expired (regenerate if needed)
3. Ensure secret names match exactly (case-sensitive)

### Build Failures

1. Test build locally first: `npm run build`
2. Check Node.js version matches
3. Verify environment variables are set
4. Review workflow logs for specific errors

---

## 📖 Additional Resources

### Official Documentation

- [Vercel Docs](https://vercel.com/docs)
- [Netlify Docs](https://docs.netlify.com/)
- [Railway Docs](https://docs.railway.app/)
- [Render Docs](https://render.com/docs)
- [Fly.io Docs](https://fly.io/docs/)
- [AWS Docs](https://docs.aws.amazon.com/)
- [GCP Docs](https://cloud.google.com/docs)
- [Supabase Docs](https://supabase.com/docs)
- [GitHub Actions](https://docs.github.com/en/actions)

### Comparison Articles

- [Vercel vs Netlify Comparison](https://vercel.com/blog/vercel-vs-netlify)
- [Railway vs Render vs Fly.io](https://railway.app/blog/railway-vs-render-vs-fly)
- [AWS vs GCP vs Azure Comparison](https://cloud.google.com/docs/get-started)

---

## 🤝 Contributing

Have a deployment workflow for a platform not listed here? Feel free to:

1. Add the workflow file to the appropriate directory
2. Update this README with platform information
3. Submit a pull request

**Suggested platforms to add:**
- DigitalOcean App Platform
- Heroku (if still relevant)
- Cloudflare Pages
- Firebase Hosting
- Custom self-hosted setups

---

## 📝 Notes

- All workflows are tested and working as of November 2025
- Free tier limits may change - check platform documentation
- Pricing information is approximate and may vary by region
- Most platforms offer student/startup credits

---

**Questions or Issues?**

If you encounter problems with any workflow:
1. Check the troubleshooting section above
2. Review workflow logs in Actions tab
3. Consult platform-specific documentation
4. Open an issue in this repository

**Last Updated**: 2025-11-03
