# Oosu Mall · 우수몰

**Oosu Mall is the browser-based portfolio evolution of an early Dart shopping mall console project.**

상품 조회, 장바구니 상태 변경, 로그인과 계정 정보 수정 등을 객체 지향 방식으로 구현했던 초기 Dart CLI를 보존하면서, 같은 도메인 흐름을 현대적인 fashion commerce browser demo로 발전시킨 프로젝트입니다.

<p align="center">
  <img src=".github/assets/portfolio/terminal-demo.gif" width="100%" alt="Original Dart shopping mall console interactive terminal demo" />
</p>

<p align="center">
  <a href="https://flutter.oosu.dev/shoppingmall_console/"><strong>▶ Open Oosu Mall / 우수몰 체험하기</strong></a>
</p>

## 주요 기능 / Features

- 원본 Dart CLI의 로그인 및 계정 정보 변경
- 상품 목록과 성별·사이즈 기반 탐색
- 상품 추가/삭제와 동적 상품 코드
- 장바구니 추가/삭제/수량 변경/초기화
- 상품별 최대 구매 수량 규칙
- Oosu Mall 웹 데모의 성별·카테고리·사이즈·검색 필터
- responsive product grid와 mobile navigation
- 장바구니 합계, empty state, 주문 데모 상태
- localStorage 기반 장바구니·로그인·계정 상태 유지
- Playwright 기반 desktop/mobile interaction smoke tests

## Architecture

```text
shoppingmall_console/
├── shoppingmall_main.dart          # Original Dart CLI entry point
├── lib/
│   ├── authentication.dart         # Login / account logic
│   ├── shoppingmall_class.dart     # Store and cart state transitions
│   └── shoppingmall_models.dart    # Product / cart domain models
└── web/                             # Oosu Mall browser portfolio demo
    ├── src/
    ├── tests/                       # Playwright smoke tests
    ├── package.json
    └── vite.config.ts
```

원본 Dart 프로젝트는 초기 학습 단계에서 **도메인 모델, 인증 로직, mutable application state, console input validation**을 파일과 클래스로 분리해 본 기록입니다.

The original Dart CLI documents an early step from single-file exercises toward separated **domain models, authentication logic, mutable application state, and input validation**.

## Run the original CLI

Dart SDK가 설치된 환경에서:

```bash
dart run shoppingmall_main.dart
```

위 terminal GIF는 이 원본 CLI의 실제 interaction을 보여줍니다.

## Oosu Mall Browser Demo

Live: **https://flutter.oosu.dev/shoppingmall_console/**

The web app is a **React/TypeScript browser recreation and design evolution** of the original console interaction model. It does not run the Dart CLI source in the browser. Product browsing, cart mutation, authentication state, and account editing are reimplemented for a responsive browser UI and persisted locally in the browser.

우수몰 웹앱은 기존 Dart 소스를 브라우저에서 직접 실행하는 구조가 아니라, **원본 콘솔 프로젝트의 상품·장바구니·로그인 상태 변경 흐름을 React/TypeScript로 재구성한 포트폴리오 버전**입니다. 초기 Dart OOP 학습 기록은 유지하면서, 실제 commerce product에 가까운 정보 위계와 responsive UX를 덧붙였습니다.

### Web validation

```bash
cd web
npm install
npm run lint
npm run typecheck
npm run build
npm run test:e2e
```

## Topics

[`cli`](https://github.com/topics/cli) · [`dart`](https://github.com/topics/dart) · [`ecommerce`](https://github.com/topics/ecommerce) · [`react`](https://github.com/topics/react) · [`shopping-cart`](https://github.com/topics/shopping-cart) · [`typescript`](https://github.com/topics/typescript) · [`vite`](https://github.com/topics/vite) · [`web-app`](https://github.com/topics/web-app)
