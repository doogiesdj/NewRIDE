# AWS Amplify 배포 가이드

## 🚀 빠른 시작 (5분 안에 완료!)

### 1단계: AWS Amplify 콘솔 접속

**URL**: https://console.aws.amazon.com/amplify/

### 2단계: 새 앱 생성

1. **"New app" 버튼 클릭** → **"Host web app" 선택**
2. **Git provider 선택**: **GitHub** 클릭
3. **GitHub 인증**:
   - "Authorize AWS Amplify" 버튼 클릭
   - GitHub 로그인 (필요한 경우)
   - AWS Amplify에 권한 부여

### 3단계: 저장소 선택

1. **Recently updated repositories** 목록에서:
   - **Repository**: `doogiesdj/NewRIDE` 선택
   - **Branch**: `main` 선택
2. **"Next" 버튼 클릭**

### 4단계: 빌드 설정 확인

자동으로 `amplify.yml` 파일을 감지합니다:

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
  cache:
    paths: []
```

- ✅ 설정이 올바르게 표시되면 **"Next" 클릭**
- ❌ 설정이 보이지 않으면 위 내용을 복사해서 붙여넣기

### 5단계: 검토 및 배포

1. **App name**: `RIDE-Website` (원하는 이름으로 변경 가능)
2. **Environment name**: `production`
3. **"Save and deploy" 버튼 클릭**

### 6단계: 배포 진행 확인

배포는 약 3-5분 소요됩니다:

- ⏳ **Provision**: 리소스 준비 중... (30초)
- ⏳ **Build**: 웹사이트 빌드 중... (1-2분)
- ⏳ **Deploy**: 배포 중... (1-2분)
- ✅ **Verify**: 검증 완료!

### 7단계: 배포 완료!

배포가 완료되면 다음 URL로 접속 가능합니다:

```
https://main.xxxxxxxxxxxxxx.amplifyapp.com
```

**예시 URL**:
```
https://main.d3f4g5h6i7j8k9.amplifyapp.com
```

---

## 🌐 커스텀 도메인 연결 (선택사항)

### 도메인이 있는 경우

1. **Amplify 콘솔** → **왼쪽 메뉴** → **"Domain management"** 클릭
2. **"Add domain"** 버튼 클릭
3. **도메인 입력**:
   - 예: `ride.or.kr` 또는 `www.yourwebsite.com`
4. **DNS 설정**:
   
   Amplify가 자동으로 안내하는 CNAME 레코드를 도메인 관리 페이지에 추가:
   
   ```
   Type: CNAME
   Name: www (또는 @)
   Value: xxxxx.cloudfront.net
   TTL: 300
   ```

5. **"Save"** 버튼 클릭
6. **DNS 전파 대기**: 5분~24시간 (보통 5-10분)
7. **SSL 인증서 자동 발급**: Let's Encrypt (무료)

### 도메인이 없는 경우

Amplify가 제공하는 기본 도메인 사용:
```
https://main.xxxxxxxxxxxxxx.amplifyapp.com
```

---

## 🔄 자동 배포 설정

### GitHub Push → 자동 배포

Amplify는 **GitHub에 푸시하면 자동으로 배포**됩니다!

```bash
# 로컬에서 파일 수정
cd /path/to/NewRIDE

# 변경사항 추가
git add .

# 커밋
git commit -m "웹사이트 업데이트"

# GitHub에 푸시
git push origin main
```

**자동 배포 시작!**
- 1-2분 후 자동으로 배포 완료
- Amplify 콘솔에서 실시간 로그 확인 가능

---

## 📊 배포 확인 사항

### ✅ 메인 페이지 테스트
- [ ] https://[your-domain].amplifyapp.com 접속
- [ ] 메인 페이지 정상 로드 확인
- [ ] 조직도 표시 확인
- [ ] 프로젝트 목록 표시 확인

### ✅ 사업 관리 기능 테스트
- [ ] **"사업 관리"** 버튼 클릭
- [ ] 로그인 모달 팝업 확인
- [ ] **로그인 정보**: 내부 관리자에게 문의
- [ ] 관리 페이지 이동 확인

### ✅ 관리자 페이지 테스트
- [ ] 프로젝트 등록 테스트
- [ ] 프로젝트 수정 테스트
- [ ] 프로젝트 삭제 테스트
- [ ] 파일 업로드 테스트
- [ ] "홈으로" 버튼 → 로그아웃 확인

### ✅ 모바일 반응형 테스트
- [ ] 스마트폰에서 접속
- [ ] 태블릿에서 접속
- [ ] PC에서 접속

---

## 🚨 트러블슈팅

### 문제 1: 배포가 실패함

**원인**: 빌드 설정 오류

**해결책**:
1. Amplify 콘솔 → "Build settings" 클릭
2. `amplify.yml` 내용 확인:
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
3. "Save" 클릭
4. "Redeploy this version" 클릭

### 문제 2: 페이지가 안 보임 (404 에러)

**원인**: 파일 경로 오류

**해결책**:
1. GitHub 저장소에서 `index.html`이 **루트 디렉토리**에 있는지 확인
2. Amplify 콘솔 → "Rewrites and redirects" 설정:
   ```
   Source: </^[^.]+$|\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|woff2|ttf|map|json)$)([^.]+$)/>
   Target: /index.html
   Type: 200 (Rewrite)
   ```

### 문제 3: 자동 배포가 안 됨

**원인**: GitHub 권한 문제

**해결책**:
1. Amplify 콘솔 → "App settings" → "General"
2. "Service role" 확인
3. GitHub repository access 재인증

### 문제 4: 로그인 모달이 안 뜸

**원인**: 브라우저 캐시

**해결책**:
1. **Ctrl + Shift + R** (강력 새로고침)
2. 또는 시크릿 모드로 접속
3. Amplify 콘솔 → "Invalidate cache" 클릭

---

## 💡 추가 기능

### 환경 변수 설정

관리자 비밀번호를 환경 변수로 관리하려면:

1. Amplify 콘솔 → "Environment variables" 클릭
2. "Manage variables" 클릭
3. 변수 추가:
   ```
   ADMIN_USERNAME = [관리자 사용자명]
   ADMIN_PASSWORD = [관리자 비밀번호]
   ```
   
   > ⚠️ **보안**: 실제 값은 내부 관리자에게 문의하세요.
4. "Save" 클릭

### 알림 설정

빌드 성공/실패 알림 받기:

1. Amplify 콘솔 → "Notifications" 클릭
2. "Create notification" 클릭
3. 이메일 또는 SNS 주제 선택
4. "Save" 클릭

### 성능 모니터링

1. Amplify 콘솔 → "Monitoring" 클릭
2. 다음 지표 확인:
   - 요청 수
   - 데이터 전송량
   - 에러율
   - 응답 시간

---

## 📞 지원 링크

- **AWS Amplify 문서**: https://docs.aws.amazon.com/amplify/
- **AWS Amplify 콘솔**: https://console.aws.amazon.com/amplify/
- **GitHub 저장소**: https://github.com/doogiesdj/NewRIDE
- **AWS 프리티어**: https://aws.amazon.com/free/

---

## ✅ 완료 체크리스트

- [ ] AWS Amplify 콘솔 접속
- [ ] GitHub 저장소 연결
- [ ] 빌드 설정 확인
- [ ] 배포 완료
- [ ] 배포 URL 확인
- [ ] 메인 페이지 테스트
- [ ] 로그인 기능 테스트
- [ ] 관리자 페이지 테스트
- [ ] 모바일 반응형 테스트
- [ ] (선택) 커스텀 도메인 연결
- [ ] (선택) 자동 배포 테스트

---

## 🎉 배포 완료!

**축하합니다!** RIDE 웹사이트가 AWS Amplify에 성공적으로 배포되었습니다!

**다음 단계**:
1. 팀원들과 URL 공유
2. 실제 데이터 입력 및 테스트
3. 커스텀 도메인 연결 (선택사항)
4. 정기적인 백업 설정

**배포 URL**: https://main.xxxxxxxxxxxxxx.amplifyapp.com

---

## 📧 문의

배포 중 문제가 발생하면:
1. Amplify 콘솔의 "Build logs" 확인
2. GitHub Issues 생성
3. AWS Support 문의
