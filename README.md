# Cute Story Closed SNS App

## 프로젝트 개요

- Cute Story는 MZ세대의 트렌드에 맞춘 "지역 기반 폐쇄형 SNS"입니다.
- 본인 근처 사용자들과 대화를 나눌 수 있습니다.
- 익숙한 세로 스크롤 UX와 직관적인 미디어 업로드, 실시간 반영 기능을 제공합니다.

## 주요 기능

- 회원가입/로그인 (Google 연동)
- 위치 기반 게시글 업로드 및 피드
- 이미지/동영상/텍스트 게시물 작성
- 좋아요, 댓글(실시간 반영)
- 마이페이지(내 게시물 관리)

## 기술 스택

- **플랫폼/프레임워크:** Flutter
- **상태관리:** flutter_riverpod, hooks_riverpod, flutter_hooks
- **백엔드:** Firebase (Auth, Firestore, Storage)
- **인증:** Google Sign-In
- **미디어:** image_picker, video_player, firebase_storage
- **위치:** geolocator, VWorld API
- **로컬저장:** shared_preferences
- **기타:** freezed_annotation, build_runner, flutter_lints, cupertino_icons, flutter_spinkit, dio

## 시스템 구조 및 구현

- 미디어 업로드 전 미리보기 및 처리 로직
- 게시물 업로드 시 Storage와 Firestore 연동
- 좋아요/댓글 등 주요 액션 실시간 반영
- 온보딩/닉네임 관리, UI 동기화, 필터링 등 다양한 UX 개선

## 실행 방법

1. Flutter SDK 및 의존성 설치
2. Firebase 연동 (google-services.json, GoogleService-Info.plist 필요)
3. 터미널에서 `flutter pub get` 실행
4. `flutter run`으로 앱 실행

---

자세한 내용은 Figma 및 PPT 자료를 참고해 주세요.
