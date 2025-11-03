#!/bin/bash
# Developer Environment Setup Script
# Automates the initial setup for new developers

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "🚀 Setting up development environment..."
echo ""

# Check Node.js version
echo "📦 Checking Node.js version..."
NODE_VERSION=$(node -v | cut -d'.' -f1 | sed 's/v//')
if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${RED}❌ Node.js version 18 or higher is required${NC}"
    echo "Current version: $(node -v)"
    exit 1
fi
echo -e "${GREEN}✓${NC} Node.js version: $(node -v)"

# Check npm version
echo "📦 Checking npm version..."
NPM_VERSION=$(npm -v | cut -d'.' -f1)
if [ "$NPM_VERSION" -lt 9 ]; then
    echo -e "${RED}❌ npm version 9 or higher is required${NC}"
    echo "Current version: $(npm -v)"
    exit 1
fi
echo -e "${GREEN}✓${NC} npm version: $(npm -v)"

# Install root dependencies
echo ""
echo "📦 Installing root dependencies..."
npm install

# Install frontend dependencies
echo ""
echo "📦 Installing frontend dependencies..."
cd frontend
npm install
cd ..

# Install backend dependencies
echo ""
echo "📦 Installing backend dependencies..."
cd backend
npm install
cd ..

# Setup Husky hooks
echo ""
echo "🔧 Setting up Git hooks (Husky)..."
npm run prepare

# Create .env files if they don't exist
echo ""
echo "🔧 Setting up environment variables..."

if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${YELLOW}⚠${NC} Created .env file from .env.example"
    echo "  Please update it with your actual values"
fi

if [ ! -f "frontend/.env.local" ]; then
    echo "# Frontend environment variables" > frontend/.env.local
    echo "NEXT_PUBLIC_APP_URL=http://localhost:3000" >> frontend/.env.local
    echo -e "${GREEN}✓${NC} Created frontend/.env.local"
fi

if [ ! -f "backend/.env" ]; then
    echo "# Backend environment variables" > backend/.env
    echo "PORT=8080" >> backend/.env
    echo "NODE_ENV=development" >> backend/.env
    echo -e "${GREEN}✓${NC} Created backend/.env"
fi

# Validate workflows (if script exists)
echo ""
if [ -f "scripts/validate-config.sh" ]; then
    echo "🔍 Validating GitHub Actions workflows..."
    chmod +x scripts/validate-config.sh
    ./scripts/validate-config.sh
fi

# Setup GitHub Discussions (optional)
echo ""
echo "🎯 GitHub Discussions Setup"
echo ""
echo "This template includes automated feature suggestion workflows that require GitHub Discussions."
echo ""
read -p "Do you want to set up GitHub Discussions now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    if [ -f "scripts/setup-discussions.sh" ]; then
        chmod +x scripts/setup-discussions.sh
        ./scripts/setup-discussions.sh
    else
        echo -e "${YELLOW}⚠${NC} setup-discussions.sh not found"
        echo "You can set it up manually later by running: ./scripts/setup-discussions.sh"
    fi
else
    echo ""
    echo -e "${YELLOW}ℹ${NC} Skipping Discussions setup"
    echo "You can set it up later by running: ./scripts/setup-discussions.sh"
fi

echo ""
echo -e "${GREEN}✅ Development environment setup complete!${NC}"
echo ""
echo "📚 Next steps:"
echo "1. Update .env files with your actual values"
echo "2. Configure GitHub secrets (CLAUDE_CODE_OAUTH_TOKEN)"
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "3. Set up GitHub Discussions: ./scripts/setup-discussions.sh"
    echo "4. Run 'npm run dev' in frontend/ or backend/ to start development"
    echo "5. Read CONTRIBUTING.md for development guidelines"
else
    echo "3. Run 'npm run dev' in frontend/ or backend/ to start development"
    echo "4. Read CONTRIBUTING.md for development guidelines"
fi
echo ""
echo "💡 Useful commands:"
echo "  npm run lint       - Lint all workspaces"
echo "  npm run test       - Test all workspaces"
echo "  npm run build      - Build all workspaces"
echo "  npm run validate   - Lint and test everything"
echo ""
