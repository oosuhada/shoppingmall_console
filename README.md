# Shopping Mall Console · Dart OOP Practice

Dart로 만든 초기 콘솔 쇼핑몰 프로젝트입니다. 상품 조회와 장바구니 조작, 간단한 로그인/계정 변경을 구현하면서 **객체 지향 모델링과 콘솔 입력 흐름**을 연습한 기록입니다.

An early Dart console project for practicing **object-oriented modeling, state changes, and interactive CLI flows** through a small shopping-mall domain.

<p align="center">
  <img src=".github/assets/portfolio/terminal-demo.gif" width="100%" alt="Shopping Mall Console interactive terminal demo" />
</p>

<p align="center">
  <a href="https://replit.com/github.com/oosuhada/shoppingmall_console"><strong>▶ Run in Replit / 브라우저에서 직접 실행</strong></a>
</p>

## 한국어

### 구현 기능

- 로그인 및 사용자 이름/비밀번호 변경
- 상품 목록 조회
- 성별·사이즈 기준 상품 구분
- 상품 추가/삭제와 동적 상품 코드
- 장바구니 추가/삭제
- 장바구니 수량 직접 변경
- 장바구니 상세 조회 및 초기화
- 상품별 최대 구매 수량 제한

### 코드 구조

```text
shoppingmall_main.dart          # 콘솔 진입점과 메뉴 흐름
lib/
├── authentication.dart        # 로그인/계정 관련 로직
├── shoppingmall_class.dart    # 쇼핑몰 동작과 상태 관리
└── shoppingmall_models.dart   # 상품/장바구니 도메인 모델
```

이 저장소는 현재 제품 프로젝트라기보다 Dart를 처음 학습할 때 **클래스 분리, 상태 변경, 사용자 입력 검증**을 직접 구현한 학습 기록으로 유지합니다.

## English

### Implemented features

- Login and basic account credential updates
- Product browsing and category/size handling
- Product creation/removal with generated codes
- Cart add/remove/update flows
- Cart detail view and reset
- Maximum purchase-quantity rules

### What this project demonstrates

The project predates my Flutter and full-stack work and is intentionally kept as a small learning artifact. Its value is in showing the transition from single-file exercises toward separated domain models, authentication logic, and mutable application state.

## Run locally

Install the Dart SDK, then run:

```bash
dart run shoppingmall_main.dart
```

## Try in browser / 브라우저에서 실행

The Replit link above imports this public repository with the Dart runtime configured so the Run action launches the same interactive shopping-mall CLI.

위 **Run in Replit** 링크를 열면 공개 저장소를 브라우저 환경으로 가져오며, Run을 누르면 동일한 쇼핑몰 터미널 프로그램을 직접 조작할 수 있습니다.
