# AWS Amplify 배포 빠른 참조 카드

## 🚀 5분 안에 배포하기

### 1단계: AWS Amplify 콘솔 접속
```
https://console.aws.amazon.com/amplify/
```

### 2단계: 앱 생성
1. **"New app"** 버튼 클릭
2. **"Host web app"** 선택
3. **"GitHub"** 선택

### 3단계: GitHub 연동
1. **"Authorize AWS Amplify"** 클릭
2. GitHub 로그인 (필요시)
3. AWS Amplify 권한 부여

### 4단계: 저장소 선택
- **Repository**: `doogiesdj/NewRIDE`
- **Branch**: `main`
- **"Next"** 클릭

### 5단계: 빌드 설정 확인
자동으로 `amplify.yml` 감지:
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
- **"Next"** 클릭

### 6단계: 배포 시작
- App name: `RIDE-Website` (원하는 이름)
- **"Save and deploy"** 클릭

### 7단계: 배포 진행 (3-5분)
- ⏳ Provision (30초)
- ⏳ Build (1-2분)
- ⏳ Deploy (1-2분)
- ✅ Verify (완료!)

### 8단계: URL 확인
```
https://main.xxxxxxxxxxxxxx.amplifyapp.com
```

---

## 🔄 자동 배포 (배포 후)

```bash
git add .
git commit -m "업데이트"
git push origin main
```
→ 1-2분 후 자동 배포 완료!

---

## 🌐 커스텀 도메인 연결 (선택사항)

1. Amplify 콘솔 → **"Domain management"**
2. **"Add domain"** 클릭
3. 도메인 입력 (예: ride.or.kr)
4. DNS 설정에 CNAME 레코드 추가

---

## ✅ 배포 확인 사항

- [ ] 메인 페이지 로드
- [ ] "사업 관리" 버튼 → 로그인 모달
- [ ] 로그인 (내부 관리자에게 정보 문의)
- [ ] 관리자 페이지 기능 테스트

---

## 🆘 트러블슈팅

### 배포 실패 시
- Amplify 콘솔 → "Build logs" 확인
- `amplify.yml` 설정 확인

### 페이지 안 보임 (404)
- Rewrites and redirects 설정
- Source: `</^[^.]+$|\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|woff2|ttf|map|json)$)([^.]+$)/>`
- Target: `/index.html`
- Type: `200 (Rewrite)`

### 캐시 문제
- Ctrl + Shift + R (강력 새로고침)
- 시크릿 모드로 접속
- Amplify 콘솔 → "Invalidate cache"

---

## 📊 비용

- **프리티어**: 1년 무료
- **이후**: 무료 ~ $5/월
- **포함 사항**:
  - 빌드 시간: 월 1,000분
  - 데이터 전송: 월 15GB
  - 호스팅: 무제한

---

## 📞 지원

- **Amplify 콘솔**: https://console.aws.amazon.com/amplify/
- **문서**: https://docs.aws.amazon.com/amplify/
- **프리티어**: https://aws.amazon.com/free/
- **GitHub**: https://github.com/doogiesdj/NewRIDE

---

## 🎉 완료!

**배포 URL**: `https://main.xxxxxxxxxxxxxx.amplifyapp.com`

**다음 단계**:
1. URL 확인 및 테스트
2. 팀원들과 공유
3. (선택) 커스텀 도메인 연결
