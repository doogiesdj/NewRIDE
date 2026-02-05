# 🔐 보안 가이드

## ⚠️ 중요: 관리자 계정 보안

### 관리자 로그인 정보

관리자 계정 정보는 **절대 공개 저장소에 포함하지 마세요**.

- **현재 상태**: 소스 코드에 하드코딩되어 있음 (임시 방편)
- **운영 환경**: 반드시 환경 변수 또는 서버 측 인증으로 변경 필요

---

## 🚨 보안 권장 사항

### 1. 비밀번호 변경

**즉시 변경이 필요한 경우**:

1. `index.html` 파일에서 비밀번호 변경:
   ```javascript
   // 246번째 줄 근처
   const ADMIN_PASSWORD = '새로운_강력한_비밀번호';
   ```

2. `admin.js` 파일에서도 동일하게 변경:
   ```javascript
   // 6번째 줄 근처
   password: '새로운_강력한_비밀번호'
   ```

3. 변경 후 즉시 GitHub에 푸시:
   ```bash
   git add index.html admin.js
   git commit -m "security: 관리자 비밀번호 변경"
   git push origin main
   ```

---

### 2. 환경 변수 사용 (권장)

**방법 1: AWS Amplify 환경 변수**

1. AWS Amplify 콘솔 접속
2. **Environment variables** 메뉴 선택
3. 다음 변수 추가:
   ```
   ADMIN_USERNAME = your_admin_username
   ADMIN_PASSWORD = your_secure_password
   ```
4. 코드에서 환경 변수 사용:
   ```javascript
   const ADMIN_USERNAME = process.env.ADMIN_USERNAME || 'admin';
   const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD || 'default_password';
   ```

**방법 2: .env 파일 사용 (로컬 개발)**

1. `.env` 파일 생성:
   ```bash
   ADMIN_USERNAME=admin
   ADMIN_PASSWORD=your_secure_password
   ```

2. `.gitignore`에 추가:
   ```
   .env
   .env.local
   .env.production
   ```

3. 코드에서 읽기 (빌드 도구 사용 시)

---

### 3. 서버 측 인증 구현 (가장 안전)

**권장 솔루션**:

프론트엔드에서 비밀번호를 하드코딩하는 대신, 백엔드 API를 구축:

1. **AWS Cognito 사용** (추천):
   - AWS Amplify + Cognito 통합
   - 사용자 인증/권한 관리 자동화
   - 비밀번호 암호화 자동 처리

2. **AWS Lambda + API Gateway**:
   - REST API 엔드포인트 생성
   - 로그인 요청을 Lambda 함수에서 처리
   - JWT 토큰 발급 및 검증

3. **Firebase Authentication**:
   - Google의 Firebase Auth 사용
   - 간단한 통합
   - 무료 티어 제공

---

## 🔒 현재 보안 상태

### ✅ 완료된 보안 조치

- ✅ 테스트 파일 `.gitignore`에 추가 (test_*, debug_*, clear_*, force_*)
- ✅ 문서에서 로그인 정보 제거 (README.md, 가이드 문서)
- ✅ 세션 관리: localStorage 기반 임시 세션 (홈으로 버튼 클릭 시 삭제)

### ⚠️ 개선 필요 사항

- ❌ 소스 코드에 비밀번호 하드코딩 (index.html, admin.js)
- ❌ 클라이언트 측에서만 인증 처리 (서버 측 검증 없음)
- ❌ HTTPS 강제 적용 필요 (배포 환경에서)
- ❌ 비밀번호 복잡도 검증 없음

---

## 📋 보안 체크리스트

### 배포 전 필수 확인

- [ ] **기본 비밀번호 변경**: `ride2025!@` 변경 완료
- [ ] **HTTPS 적용**: 배포 환경에서 HTTPS 사용 확인
- [ ] **환경 변수 설정**: AWS Amplify 또는 .env 파일 설정
- [ ] **Git 히스토리 확인**: 민감 정보가 커밋 히스토리에 없는지 확인

### 정기 보안 점검

- [ ] **비밀번호 주기적 변경**: 3개월마다 변경 권장
- [ ] **접근 로그 확인**: 비정상적인 로그인 시도 모니터링
- [ ] **세션 타임아웃**: 장시간 미사용 시 자동 로그아웃 구현
- [ ] **의존성 업데이트**: 보안 패치 적용

---

## 🚨 보안 사고 대응

### 비밀번호 유출 시 즉시 조치

1. **즉시 비밀번호 변경**:
   ```bash
   # 소스 코드 수정
   vim index.html admin.js
   
   # 변경 사항 커밋 및 푸시
   git add index.html admin.js
   git commit -m "SECURITY: Emergency password reset"
   git push origin main
   ```

2. **AWS Amplify 재배포 확인**:
   - Amplify 콘솔에서 자동 배포 확인
   - 배포 완료까지 1-2분 소요

3. **이전 세션 무효화**:
   - 사용자에게 localStorage 초기화 안내
   - 또는 세션 관리 코드 업데이트

4. **GitHub 히스토리에서 삭제** (필요시):
   ```bash
   # Git 히스토리에서 민감 정보 완전 삭제
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch [파일명]" \
     --prune-empty --tag-name-filter cat -- --all
   
   git push origin --force --all
   ```

---

## 🔐 강력한 비밀번호 생성

### 비밀번호 요구사항

- **최소 길이**: 12자 이상
- **대소문자**: 대문자 + 소문자 혼합
- **숫자 포함**: 최소 2개
- **특수문자**: 최소 2개 (!@#$%^&*)
- **예측 불가**: 사전 단어, 생일, 순차 번호 금지

### 비밀번호 생성 도구

```bash
# Linux/Mac에서 강력한 비밀번호 생성
openssl rand -base64 16

# 또는
pwgen -sy 16 1
```

**예시 강력한 비밀번호**:
- `K7!mP2@nQ9$wR5#x`
- `Zx8@tY3!vB9$nM2&`
- `Jq4!wE7@rT2$yU9#`

---

## 📞 보안 문의

보안 관련 문제 발견 시:

1. **긴급**: 내부 보안 담당자에게 즉시 연락
2. **이메일**: [보안팀 이메일]
3. **GitHub**: Private Security Advisory 생성

---

## 📚 참고 자료

- [OWASP 비밀번호 보안 가이드](https://owasp.org/www-community/Authentication_Cheat_Sheet)
- [AWS Amplify 인증 문서](https://docs.aws.amazon.com/amplify/latest/userguide/authentication.html)
- [AWS Cognito 시작하기](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-identity-pools.html)
- [MDN Web Security](https://developer.mozilla.org/en-US/docs/Web/Security)

---

## ⚡ 빠른 보안 개선 (5분)

즉시 할 수 있는 최소한의 보안 조치:

```bash
# 1. 비밀번호 변경
vim index.html  # ADMIN_PASSWORD 값 변경
vim admin.js    # password 값 동일하게 변경

# 2. 커밋 및 푸시
git add index.html admin.js
git commit -m "security: 관리자 비밀번호 변경"
git push origin main

# 3. 완료! (Amplify 자동 재배포 1-2분)
```

---

**⚠️ 중요: 이 파일(`SECURITY.md`)도 공개 저장소에 포함되므로, 실제 비밀번호나 민감한 정보는 절대 기재하지 마세요!**
