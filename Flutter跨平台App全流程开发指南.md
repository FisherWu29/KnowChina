# Flutter 跨平台 App 全流程开发指南

本指南整合了移动端、服务端、官网、运营资料的 Monorepo 管理方式，覆盖从仓库设计、支付订阅、自动发布到官网部署的完整链路，适合个人或小团队快速落地。

---

## 1. 技术栈概览

| 模块 | 技术方案 | 核心工具 |
|------|----------|----------|
| 移动端 | Flutter (iOS + Android) | Dart, RevenueCat, Fastlane |
| 服务端 | Cloudflare Workers | Node.js / Wrangler |
| 官网 | Cloudflare Pages | VitePress / Astro / Next.js |
| 运营资料 | 纯资源目录 | Git LFS |
| CI/CD | GitHub Actions | 路径过滤 + 独立部署 |
| 仓库管理 | Monorepo（混合结构） | Makefile, Shell 脚本 |

---

## 2. 仓库与目录设计

### 2.1 整体思路

- 不引入 pnpm workspace 等 monorepo 工具，各技术栈完全独立管理。
- 根目录仅保留统一的构建/部署脚本，通过 Makefile 串联所有操作。
- 所有模块共处一个 Git 仓库，用路径过滤防止无关提交触发错误部署。

### 2.2 推荐目录结构

```
my-app/
├── mobile/                  # Flutter 应用
│   ├── lib/                 # Dart 代码
│   ├── android/
│   ├── ios/
│   ├── pubspec.yaml
│   └── fastlane/            # Fastlane 发布配置
├── server/                  # Cloudflare Workers (后端)
│   ├── src/
│   ├── package.json
│   └── wrangler.toml
├── website/                 # Cloudflare Pages (官网)
│   ├── src/
│   ├── public/
│   └── package.json
├── marketing/               # 自媒体运营素材
│   ├── images/
│   ├── videos/
│   └── copywriting/
├── scripts/                 # 跨模块辅助脚本
│   ├── build-all.sh
│   └── deploy-website.sh
├── Makefile                 # 统一入口
├── .github/workflows/       # CI/CD 配置
│   ├── deploy-server.yml
│   ├── deploy-website.yml
│   └── mobile-release.yml
└── README.md
```

### 2.3 文件管理注意事项

- **Git LFS：**对 `marketing/` 下的二进制文件（图片、视频、设计源文件）启用 LFS，避免仓库臃肿。
- **环境变量：**各模块自管 `.env` 文件，不提交到仓库（加入 `.gitignore`）。
- **忽略产物：**确保 `.gitignore` 包含 `node_modules/`、`.dart_tool/`、`build/`、`Pods/`、`.env` 等。

---

## 3. 订阅支付（RevenueCat）

### 3.1 后台配置

1. 在 RevenueCat 后台创建项目，在项目设置 → API 密钥中为 iOS 和 Android 分别生成平台专属 API Key。
2. 连接应用商店账户：
   - **iOS：**上传 App Store Connect 的共享密钥或 App-Specific 密码。
   - **Android：**上传 Google Play Console 的服务帐号 JSON 密钥。
3. 配置产品和权益（Entitlements），确定订阅套餐结构。

### 3.2 Flutter 集成（单一代码逻辑）

在 `pubspec.yaml` 中添加 `purchases_flutter` 依赖，初始化时按平台传入不同 Key：

```dart
import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() async {
  if (Platform.isIOS) {
    await Purchases.configure(PurchasesConfiguration('your_revenuecat_ios_api_key'));
  } else if (Platform.isAndroid) {
    await Purchases.configure(PurchasesConfiguration('your_revenuecat_android_api_key'));
  }
  runApp(MyApp());
}
```

购买流程示例：

```dart
try {
  Offerings offerings = await Purchases.getOfferings();
  CustomerInfo customerInfo = await Purchases.purchasePackage(offerings.current!.monthly!);
  // 根据 customerInfo.entitlements 解锁功能
} catch (e) {
  // 处理取消、支付失败等情况
}
```

### 3.3 平台原生权限

- **iOS：**Xcode 中开启 Signing & Capabilities > In-App Purchase。
- **Android：**在 `AndroidManifest.xml` 中添加：
  ```xml
  <uses-permission android:name="com.android.vending.BILLING" />
  ```

---

## 4. 发布自动化（Fastlane）

### 4.1 配置概览

在 `mobile/fastlane/` 下为两个平台分别准备 Fastfile。

iOS 端（使用 match 管理证书）：

```ruby
# mobile/ios/fastlane/Fastfile
platform :ios do
  lane :release do
    match(type: "appstore", readonly: true)
    build_ios_app(scheme: "Runner", export_method: "app-store")
    upload_to_app_store
  end
end
```

Android 端（使用 supply 上传）：

```ruby
# mobile/android/fastlane/Fastfile
platform :android do
  lane :release do
    gradle(task: "assembleRelease")
    upload_to_play_store(
      track: 'internal',
      json_key: "path/to/play-store-key.json"
    )
  end
end
```

### 4.2 密钥与证书管理

- **iOS 证书：**通过 match 自动同步到私有 Git 仓库或 GitHub Secrets。
- **Android 签名：**将 Keystore 和 Play Store 密钥文件存放于 CI 环境变量中，不在仓库明文存储。
- **环境变量：**使用 `.env` 或 CI Secrets 注入 `TEAM_ID`、`KEYSTORE_PASSWORD` 等敏感信息。

### 4.3 CI 触发发布（GitHub Actions）

在 `.github/workflows/mobile-release.yml` 中配置 Fastlane 执行环境，可按需手动触发或打 Tag 触发，避免每次提交都发版。

---

## 5. 服务端与官网部署方案

### 5.1 部署隔离原则

在同一 Monorepo 下，通过 GitHub Actions 的路径过滤实现独立部署：

- 仅 `server/**` 变更 → 部署 Workers
- 仅 `website/**` 或 `marketing/**` 变更 → 部署 Pages
- 修改 Flutter 代码完全不触发这两个部署

### 5.2 Server (Cloudflare Workers) 部署配置

```yaml
# .github/workflows/deploy-server.yml
name: Deploy Server (Worker)
on:
  push:
    branches: [main]
    paths:
      - 'server/**'
      - '.github/workflows/deploy-server.yml'
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm ci
        working-directory: ./server
      - uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          workingDirectory: 'server'
          command: 'deploy'
```

### 5.3 Website (Cloudflare Pages) 部署配置

```yaml
# .github/workflows/deploy-website.yml
name: Deploy Website (Pages)
on:
  push:
    branches: [main]
    paths:
      - 'website/**'
      - 'marketing/**'
      - '.github/workflows/deploy-website.yml'
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm ci
        working-directory: ./website
      - run: npm run build
        working-directory: ./website
      - uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          projectName: 'your-pages-project-name'
          directory: 'website/dist'
          gitHubToken: ${{ secrets.GITHUB_TOKEN }}
```

注意：`projectName` 和 `directory`（构建产物目录）需根据实际项目替换。

### 5.4 Git 集成模式备选方案

如果不想维护 Actions，可在 Cloudflare 控制台直接关联仓库，并设置 Build watch paths：

- **server 项目：**Include `server/*`，Exclude `website/*`, `mobile/*`
- **website 项目：**Include `website/*`, `marketing/*`，Exclude `server/*`, `mobile/*`

---

## 6. 日常开发与操作

### 6.1 统一命令入口（Makefile）

```makefile
dev-mobile:
	cd mobile && flutter run
dev-server:
	cd server && npm run dev
dev-website:
	cd website && npm run dev
build-mobile-ios:
	cd mobile && flutter build ios
build-mobile-android:
	cd mobile && flutter build apk
release-ios:
	cd mobile/ios && fastlane release
release-android:
	cd mobile/android && fastlane release
install-all:
	cd mobile && flutter pub get
	cd server && npm install
	cd website && npm install
```

### 6.2 跨模块脚本（scripts/ 目录）

编写 Shell 或 Node.js 脚本完成复杂任务，例如自动把 `marketing/` 中的图片压缩后同步到 `website/public/` 下供官网使用。

---

## 7. 链路全览

```
代码提交 (Git push)
  ├─ 路径 server/** 变更
  │    └─ GitHub Actions → Wrangler → Cloudflare Workers 部署
  ├─ 路径 website/** / marketing/** 变更
  │    └─ GitHub Actions → 构建 → Cloudflare Pages 部署
  └─ 手动触发 / Tag (mobile 发布)
       └─ GitHub Actions → Fastlane → App Store / Google Play 提交

订阅支付
  用户购买 → RevenueCat SDK (Flutter)
               ├─ 验证凭证 → Apple / Google 服务器
               └─ 回调 → 解锁权益
```

整个流程中，不同模块开发互不干扰，提交、部署、审核完全自动化，维护一个仓库即可掌控全部产品代码与资料。
