#!/bin/bash
# Sync marketing assets to website public directory
# Usage: ./scripts/sync-marketing-assets.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

MARKETING_DIR="$ROOT_DIR/marketing/images"
WEBSITE_PUBLIC_DIR="$ROOT_DIR/website/public/assets"

if [ ! -d "$MARKETING_DIR" ]; then
  echo "Marketing directory not found: $MARKETING_DIR"
  exit 1
fi

mkdir -p "$WEBSITE_PUBLIC_DIR"

echo "Syncing marketing assets..."
rsync -av --exclude=".*" "$MARKETING_DIR/" "$WEBSITE_PUBLIC_DIR/"
echo "Done. Synced to $WEBSITE_PUBLIC_DIR"
