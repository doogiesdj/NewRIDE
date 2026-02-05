# AWS Amplify GitHub 저장소 변경 가이드

## 🎯 목표
현재: `doogiesdj/RIDE` → 변경: `doogiesdj/NewRIDE`

---

## 방법 1: 기존 앱 설정 변경 (추천! ⭐)

### 장점
- ✅ 배포 히스토리 유지
- ✅ 도메인 설정 유지
- ✅ 환경 변수 유지
- ✅ 빠름 (2분)

### 단계

#### 1. AWS Amplify 콘솔 접속
```
https://console.aws.amazon.com/amplify/
```

#### 2. 기존 앱 선택
- 현재 연결된 앱 (doogiesdj/RIDE) 클릭

#### 3. 저장소 설정 변경
1. 왼쪽 메뉴에서 **"App settings"** 클릭
2. **"General"** 탭 선택
3. **"Repository"** 섹션 찾기
4. **"Edit"** 또는 **"Reconnect repository"** 버튼 클릭

#### 4. 새 저장소 연결
1. **"GitHub"** 선택
2. 권한 확인 (필요시 재인증)
3. **Repository**: `doogiesdj/NewRIDE` 선택
4. **Branch**: `main` 선택
5. **"Save"** 클릭

#### 5. 자동 재배포 확인
- 저장 후 자동으로 새 저장소에서 빌드 시작
- 약 3-5분 소요

---

## 방법 2: 새 앱 생성 (처음부터 다시)

### 사용 시기
- 완전히 새로 시작하고 싶을 때
- 기존 설정을 변경하고 싶을 때

### 단계

#### 1. 기존 앱 삭제 (선택사항)

**⚠️ 주의**: 삭제 전 다음 정보 백업!
- 커스텀 도메인 설정
- 환경 변수
- 빌드 설정

1. AWS Amplify 콘솔 접속
2. 기존 앱 선택 (doogiesdj/RIDE)
3. 우측 상단 **"Actions"** → **"Delete app"**
4. 앱 이름 입력하여 확인
5. **"Delete"** 클릭

#### 2. 새 앱 생성

1. **"New app"** 버튼 클릭
2. **"Host web app"** 선택
3. **"GitHub"** 선택
4. **Repository**: `doogiesdj/NewRIDE` 선택
5. **Branch**: `main` 선택
6. **"Next"** 클릭

#### 3. 빌드 설정 확인
```yaml
version: 1
frontend:
  phases:
    build:
      commands:
        - echo "Building RIDE website..."
  artifacts:
    baseDirectory: /
    files:
      - '**/*'
```

#### 4. 앱 설정
- **App name**: `RIDE-Website` (또는 원하는 이름)
- **Environment**: `production`
- **"Save and deploy"** 클릭

#### 5. 배포 완료 대기 (3-5분)

---

## 방법 3: CLI로 변경 (고급 사용자용)

### 사전 요구사항
```bash
# AWS CLI 설치 확인
aws --version

# Amplify CLI 설치
npm install -g @aws-amplify/cli
```

### 단계

#### 1. 앱 정보 확인
```bash
# 현재 앱 목록 조회
aws amplify list-apps

# 앱 ID 확인 (예: d1234567890abc)
```

#### 2. 앱 업데이트
```bash
# 저장소 변경
aws amplify update-app \
  --app-id d1234567890abc \
  --repository https://github.com/doogiesdj/NewRIDE
```

#### 3. 브랜치 연결
```bash
# 기존 브랜치 삭제 (선택사항)
aws amplify delete-branch \
  --app-id d1234567890abc \
  --branch-name main

# 새 브랜치 연결
aws amplify create-branch \
  --app-id d1234567890abc \
  --branch-name main
```

#### 4. 배포 시작
```bash
# 수동 배포 트리거
aws amplify start-job \
  --app-id d1234567890abc \
  --branch-name main \
  --job-type RELEASE
```

---

## 📋 배포 후 확인 사항

### 1. 빌드 로그 확인
- Amplify 콘솔 → 앱 선택 → "Deployments" 탭
- 빌드 성공 여부 확인

### 2. 웹사이트 접속 테스트
```
https://main.xxxxxxxxxxxxxx.amplifyapp.com
```

### 3. 기능 테스트
- [ ] 메인 페이지 로드
- [ ] 조직도 표시
- [ ] 프로젝트 목록 (29개)
- [ ] "사업 관리" 버튼 → 로그인 모달
- [ ] 관리자 로그인 테스트
- [ ] 파일 업로드/다운로드

### 4. 환경 변수 확인 (있는 경우)
- Amplify 콘솔 → **"Environment variables"**
- 필요한 변수들이 모두 설정되어 있는지 확인

### 5. 커스텀 도메인 확인 (있는 경우)
- Amplify 콘솔 → **"Domain management"**
- 도메인 연결 상태 확인
- DNS 설정 유효성 확인

---

## 🚨 문제 해결

### 문제 1: "Repository not found" 오류

**원인**: GitHub 권한 문제

**해결책**:
1. Amplify 콘솔 → **"App settings"** → **"General"**
2. **"Reconnect repository"** 클릭
3. GitHub 권한 재승인
4. `doogiesdj/NewRIDE` 저장소 선택

### 문제 2: 빌드 실패

**원인**: `amplify.yml` 설정 오류

**해결책**:
1. GitHub에서 `amplify.yml` 파일 확인
2. 올바른 설정인지 검증:
```yaml
version: 1
frontend:
  phases:
    build:
      commands:
        - echo "Building RIDE website..."
  artifacts:
    baseDirectory: /
    files:
      - '**/*'
```
3. Amplify 콘솔 → **"Build settings"**에서 수동 수정 가능

### 문제 3: 이전 저장소로 계속 연결됨

**원인**: 캐시 또는 브라우저 문제

**해결책**:
1. 브라우저 캐시 삭제 (Ctrl+Shift+Delete)
2. 시크릿 모드로 Amplify 콘솔 접속
3. 또는 다른 브라우저 사용

### 문제 4: 환경 변수 사라짐 (방법 2 사용 시)

**원인**: 새 앱 생성으로 설정 초기화

**해결책**:
1. Amplify 콘솔 → **"Environment variables"**
2. 필요한 변수 재설정:
```
ADMIN_USERNAME = admin
ADMIN_PASSWORD = [새로운_비밀번호]
```

---

## 🔄 자동 배포 확인

저장소 변경 후 자동 배포가 작동하는지 테스트:

```bash
# 로컬에서 테스트
cd /path/to/NewRIDE
echo "<!-- Test -->" >> README.md
git add README.md
git commit -m "test: 자동 배포 테스트"
git push origin main
```

**예상 결과**:
- 1-2분 후 Amplify에서 자동 빌드 시작
- 3-5분 후 배포 완료
- 웹사이트에서 변경사항 확인 가능

---

## 📊 저장소 변경 전후 비교

| 항목 | 변경 전 | 변경 후 |
|------|---------|---------|
| **저장소** | doogiesdj/RIDE | doogiesdj/NewRIDE |
| **브랜치** | (설정 확인 필요) | main |
| **파일 수** | ? | 28개 |
| **문서** | ? | 보안 가이드 포함 8개 |
| **보안** | 문서에 비밀번호 노출 | 문서 보안 강화 ✅ |
| **커밋 수** | ? | 7개 |
| **최신 커밋** | ? | a44ebcc |

---

## 💡 추천 방법

### 상황별 추천

**일반적인 경우** → **방법 1 (설정 변경)** ⭐
- 가장 빠르고 안전
- 모든 설정 유지
- 2분 완료

**처음부터 시작하고 싶은 경우** → **방법 2 (새 앱)**
- 깨끗한 시작
- 10분 소요

**CLI 경험이 있는 경우** → **방법 3 (CLI)**
- 자동화 가능
- 스크립트 작성 용이

---

## ✅ 체크리스트

### 저장소 변경 전
- [ ] 기존 앱 URL 백업
- [ ] 커스텀 도메인 설정 백업 (있는 경우)
- [ ] 환경 변수 목록 백업 (있는 경우)
- [ ] 빌드 설정 백업

### 저장소 변경 후
- [ ] 새 저장소 연결 확인
- [ ] 빌드 성공 확인
- [ ] 웹사이트 접속 테스트
- [ ] 모든 기능 작동 확인
- [ ] 자동 배포 테스트
- [ ] 환경 변수 재설정 (필요시)
- [ ] 커스텀 도메인 재연결 (필요시)

---

## 🎯 빠른 시작 (2분 완료)

```
1. https://console.aws.amazon.com/amplify/ 접속
2. 현재 앱 클릭
3. 왼쪽 "App settings" → "General"
4. "Repository" 섹션에서 "Edit" 클릭
5. 저장소 "doogiesdj/NewRIDE" 선택
6. 브랜치 "main" 선택
7. "Save" 클릭
8. 자동 배포 확인 (3-5분)
9. 완료!
```

---

## 📞 추가 도움

- **AWS Amplify 문서**: https://docs.aws.amazon.com/amplify/
- **GitHub 저장소**: https://github.com/doogiesdj/NewRIDE
- **보안 가이드**: SECURITY.md
- **배포 가이드**: DEPLOYMENT_GUIDE.md

---

**행운을 빕니다!** 🚀
