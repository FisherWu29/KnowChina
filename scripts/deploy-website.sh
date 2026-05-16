#!/bin/bash
# Deploy website to Cloudflare Pages
# Usage: ./scripts/deploy-website.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Building website..."
cd "$ROOT_DIR/website" && npm run build

echo "Deploying to Cloudflare Pages..."
cd "$ROOT_DIR"
wrangler pages deploy website/dist --project-name=knowchina

echo "Deployment complete."
