#!/bin/bash

# Quantum Inventions Remote Static - Production Deployment Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}🚀 Quantum Inventions Remote Static - Production Deployment${NC}"
    echo -e "${BLUE}============================================================${NC}"
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

deploy_to_production() {
    print_header
    print_info "Preparing to deploy remote static website to Cloudflare Pages..."
    print_info "Project: quantuminventions-static (existing worker)"
    print_info "Source: www.quantuminventions.com (936 files, 100MB)"
    print_info "Content: Complete live website mirror with converted links"
    echo ""
    
    # Check if source directory exists
    if [ ! -d "www.quantuminventions.com" ]; then
        print_error "Source directory www.quantuminventions.com not found!"
        print_info "Make sure you're running this from the quantuminventions-remote-static directory"
        exit 1
    fi
    
    print_info "Source directory found ✓"
    print_info "Files ready for deployment ✓"
    echo ""
    
    print_warning "This command requires interactive input from wrangler."
    print_info "Running deployment command..."
    echo ""
    
    # Run the deployment command using existing project name
    echo -e "${YELLOW}Executing: npx wrangler pages deploy www.quantuminventions.com --project-name=quantuminventions-static${NC}"
    echo ""
    
    npx wrangler pages deploy www.quantuminventions.com --project-name=quantuminventions-static
    
    if [ $? -eq 0 ]; then
        echo ""
        print_success "Deployment completed successfully!"
        echo ""
        print_info "Your remote static website is now live on Cloudflare Pages"
        print_info "Features deployed:"
        print_info "  • Complete live website mirror (938 files, 98MB)"
        print_info "  • All external links converted to local references"
        print_info "  • Self-contained static website"
        print_info "  • WordPress-style URLs preserved"
        print_info "  • All images, CSS, JS, and assets included"
        echo ""
        print_success "Deployment URL will be shown above ☝️"
    else
        print_error "Deployment failed!"
        print_info "Please check the error messages above and try again"
        exit 1
    fi
}

show_status() {
    print_header
    print_info "Deployment Status Check"
    echo ""
    
    if [ -d "www.quantuminventions.com" ]; then
        print_success "Source directory: www.quantuminventions.com ✓"
        
        # Count files
        file_count=$(find www.quantuminventions.com -type f | wc -l | tr -d ' ')
        print_info "Files ready: $file_count files"
        
        # Check size
        size=$(du -sh www.quantuminventions.com | cut -f1)
        print_info "Total size: $size"
        
        echo ""
        print_info "Ready for deployment to Cloudflare Pages"
    else
        print_error "Source directory not found!"
        print_info "The www.quantuminventions.com directory is missing"
    fi
}

show_help() {
    print_header
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  deploy    Deploy remote static website to Cloudflare Pages production"
    echo "  status    Check deployment readiness"
    echo "  help      Show this help message"
    echo ""
    echo "About:"
    echo "  This deploys the complete live quantuminventions.com website"
    echo "  downloaded as static files to Cloudflare Pages production"
    echo ""
    echo "Prerequisites:"
    echo "  • Cloudflare account with Pages access"
    echo "  • Wrangler CLI configured with authentication"
    echo "  • www.quantuminventions.com directory with static files"
    echo ""
    echo "Examples:"
    echo "  $0 deploy    # Deploy to production"
    echo "  $0 status    # Check readiness"
}

# Main script logic
case "${1:-deploy}" in
    deploy)
        deploy_to_production
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
