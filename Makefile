.PHONY: help install-all \
        dev-mobile dev-server dev-website \
        build-mobile-ios build-mobile-android \
        release-ios release-android \
        deploy-server deploy-website \
        lint-mobile lint-server lint-website \
        test-mobile test-server

help:
	@echo "KnowChina - Available commands:"
	@echo ""
	@echo "  Setup:"
	@echo "    install-all              Install all dependencies"
	@echo ""
	@echo "  Development:"
	@echo "    dev-mobile               Run Flutter app"
	@echo "    dev-server               Run Cloudflare Worker locally"
	@echo "    dev-website              Run website dev server"
	@echo ""
	@echo "  Build:"
	@echo "    build-mobile-ios         Build Flutter iOS"
	@echo "    build-mobile-android     Build Flutter Android"
	@echo ""
	@echo "  Release:"
	@echo "    release-ios              Release to App Store (Fastlane)"
	@echo "    release-android          Release to Play Store (Fastlane)"
	@echo "    deploy-server            Deploy Cloudflare Worker"
	@echo "    deploy-website           Deploy to Cloudflare Pages"
	@echo ""
	@echo "  Lint:"
	@echo "    lint-mobile              Run Flutter analyze"
	@echo "    lint-server              Run ESLint"
	@echo ""
	@echo "  Test:"
	@echo "    test-mobile              Run Flutter tests"
	@echo "    test-server              Run server tests"

# ==================== Setup ====================

install-all:
	@echo "Installing mobile dependencies..."
	cd mobile && flutter pub get
	@echo "Installing server dependencies..."
	cd server && npm install
	@echo "Installing website dependencies..."
	cd website && npm install
	@echo "All dependencies installed."

# ==================== Development ====================

dev-mobile:
	cd mobile && flutter run

dev-server:
	cd server && npm run dev

dev-website:
	cd website && npm run dev

# ==================== Build ====================

build-mobile-ios:
	cd mobile && flutter build ios --release --no-codesign

build-mobile-android:
	cd mobile && flutter build apk --release

# ==================== Release ====================

release-ios:
	cd mobile/ios && fastlane release

release-android:
	cd mobile/android && fastlane release

deploy-server:
	cd server && npm run deploy

deploy-website:
	cd website && npm run build
	@echo "Deploy website via: wrangler pages deploy website/dist"

# ==================== Lint ====================

lint-mobile:
	cd mobile && flutter analyze

lint-server:
	cd server && npx eslint src/ || echo "ESLint not configured yet"

lint-website:
	cd website && echo "Add linter to website later"

# ==================== Test ====================

test-mobile:
	cd mobile && flutter test

test-server:
	cd server && npm test
