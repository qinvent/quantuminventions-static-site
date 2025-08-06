#!/bin/bash

# Quantum Inventions Remote Static - GitHub Pages Deployment Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}🚀 Quantum Inventions Remote Static - GitHub Pages Deployment${NC}"
    echo -e "${BLUE}================================================================${NC}"
    echo ""
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Configuration
REPO_NAME="quantuminventions-static-site"
SOURCE_DIR="../www.quantuminventions.com"
DEPLOY_DIR="./deploy"

prepare_deployment() {
    print_header
    print_info "Preparing GitHub Pages deployment..."
    print_info "Repository: $REPO_NAME"
    print_info "Source: $SOURCE_DIR (936 files, 100MB)"
    print_info "Target: GitHub Pages (Free hosting)"
    echo ""
    
    # Check if source directory exists
    if [ ! -d "$SOURCE_DIR" ]; then
        print_error "Source directory $SOURCE_DIR not found!"
        exit 1
    fi
    
    print_info "Creating deployment directory..."
    rm -rf "$DEPLOY_DIR"
    mkdir -p "$DEPLOY_DIR"
    
    print_info "Copying website files..."
    cp -r "$SOURCE_DIR"/* "$DEPLOY_DIR"/
    
    # Create .nojekyll file to prevent Jekyll processing
    touch "$DEPLOY_DIR/.nojekyll"
    
    # Create CNAME file if custom domain is needed (optional)
    # echo "your-domain.com" > "$DEPLOY_DIR/CNAME"
    
    # Create README for the repository
    cat > "$DEPLOY_DIR/README.md" << 'EOF'
# Quantum Inventions - Static Website

This is a static version of the Quantum Inventions website, deployed on GitHub Pages.

## About

- **936 files** - Complete website mirror
- **100MB** - All assets included
- **Static hosting** - Fast, reliable, and secure
- **GitHub Pages** - Free hosting with global CDN

## Features

- Complete mirror of quantuminventions.com
- All external links converted to local references
- WordPress-style URLs preserved
- Self-contained - works completely offline
- Optimized for static hosting

## Deployment

This site is automatically deployed to GitHub Pages from the main branch.

Visit: https://[username].github.io/quantuminventions-static-site

## Technical Details

- **Source**: Downloaded from live quantuminventions.com
- **Processing**: All external links converted to local
- **Structure**: Complete WordPress directory structure preserved
- **Assets**: All images, CSS, JS, fonts, and media included
- **Performance**: Static files serve instantly via GitHub's CDN

© 2024 Quantum Inventions. All rights reserved.
EOF
    
    # Initialize git repository
    cd "$DEPLOY_DIR"
    git init
    git add .
    git commit -m "Initial deployment of Quantum Inventions static website

- 936 files from live quantuminventions.com
- Complete website mirror with all assets
- External links converted to local references
- WordPress structure preserved
- Optimized for GitHub Pages hosting"
    
    cd ..
    
    print_success "Deployment prepared successfully!"
    echo ""
    print_info "Next steps:"
    print_info "1. Create a new GitHub repository: $REPO_NAME"
    print_info "2. Push the prepared files to GitHub"
    print_info "3. Enable GitHub Pages in repository settings"
    echo ""
    print_info "Files ready in: $DEPLOY_DIR"
}

create_github_repo() {
    print_header
    print_info "Creating GitHub repository and deploying..."
    
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) not found!"
        print_info "Please install GitHub CLI: https://cli.github.com/"
        print_info "Or create the repository manually on GitHub"
        exit 1
    fi
    
    cd "$DEPLOY_DIR"
    
    print_info "Creating GitHub repository..."
    gh repo create "$REPO_NAME" --public --description "Static version of Quantum Inventions website - 936 files, complete mirror with local links"
    
    print_info "Adding remote and pushing..."
    git branch -M main
    git remote add origin "https://github.com/$(gh api user --jq .login)/$REPO_NAME.git"
    git push -u origin main
    
    print_info "Enabling GitHub Pages..."
    gh api repos/$(gh api user --jq .login)/$REPO_NAME/pages \
        --method POST \
        --field source.branch=main \
        --field source.path=/
    
    cd ..
    
    print_success "GitHub repository created and deployed!"
    echo ""
    print_info "Your website will be available at:"
    print_info "https://$(gh api user --jq .login).github.io/$REPO_NAME"
    echo ""
    print_info "It may take a few minutes for GitHub Pages to build and deploy."
}

manual_instructions() {
    print_header
    print_info "Manual GitHub Pages Deployment Instructions"
    echo ""
    
    print_info "If you prefer to create the repository manually:"
    echo ""
    echo "1. Go to https://github.com/new"
    echo "2. Repository name: $REPO_NAME"
    echo "3. Description: Static version of Quantum Inventions website"
    echo "4. Make it Public"
    echo "5. Don't initialize with README (we have one prepared)"
    echo "6. Click 'Create repository'"
    echo ""
    echo "Then run these commands:"
    echo ""
    echo "cd $DEPLOY_DIR"
    echo "git remote add origin https://github.com/YOUR_USERNAME/$REPO_NAME.git"
    echo "git branch -M main"
    echo "git push -u origin main"
    echo ""
    echo "Finally:"
    echo "7. Go to repository Settings > Pages"
    echo "8. Source: Deploy from a branch"
    echo "9. Branch: main"
    echo "10. Folder: / (root)"
    echo "11. Click Save"
    echo ""
    print_info "Your site will be available at: https://YOUR_USERNAME.github.io/$REPO_NAME"
}

show_status() {
    print_header
    print_info "GitHub Pages Deployment Status"
    echo ""
    
    if [ -d "$SOURCE_DIR" ]; then
        print_success "Source directory found ✓"
        
        file_count=$(find "$SOURCE_DIR" -type f | wc -l | tr -d ' ')
        print_info "Files ready: $file_count files"
        
        size=$(du -sh "$SOURCE_DIR" | cut -f1)
        print_info "Total size: $size"
        
        echo ""
        if [ -d "$DEPLOY_DIR" ]; then
            print_success "Deployment directory prepared ✓"
            print_info "Ready to push to GitHub"
        else
            print_info "Run 'prepare' to create deployment directory"
        fi
    else
        print_error "Source directory not found!"
    fi
}

show_help() {
    print_header
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  prepare     Prepare files for GitHub Pages deployment"
    echo "  deploy      Create GitHub repo and deploy (requires GitHub CLI)"
    echo "  manual      Show manual deployment instructions"
    echo "  status      Check deployment readiness"
    echo "  help        Show this help message"
    echo ""
    echo "About:"
    echo "  Deploy the complete quantuminventions.com static website to GitHub Pages"
    echo "  GitHub Pages is free and includes global CDN"
    echo ""
    echo "Prerequisites:"
    echo "  • GitHub account"
    echo "  • Git installed"
    echo "  • GitHub CLI (optional, for automated deployment)"
    echo ""
    echo "Examples:"
    echo "  $0 prepare   # Prepare files for deployment"
    echo "  $0 deploy    # Auto-create repo and deploy"
    echo "  $0 manual    # Show manual instructions"
}

# Main script logic
case "${1:-help}" in
    prepare)
        prepare_deployment
        ;;
    deploy)
        if [ ! -d "$DEPLOY_DIR" ]; then
            prepare_deployment
        fi
        create_github_repo
        ;;
    manual)
        if [ ! -d "$DEPLOY_DIR" ]; then
            prepare_deployment
        fi
        manual_instructions
        ;;
    status)
        show_status
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
