# 🚀 RIDE 웹사이트 AWS 배포 완료 가이드

## ✅ 현재 상태

- ✅ **GitHub 저장소**: https://github.com/doogiesdj/NewRIDE
- ✅ **코드 업로드 완료**
- ✅ **배포 스크립트 준비 완료**
- ⬜ **AWS 배포 대기 중**

---

## 🎯 배포 방법 선택

### 방법 1: AWS Amplify (추천! ⭐⭐⭐⭐⭐)

**장점**:
- 🚀 **가장 쉬움**: 클릭 5번이면 완료!
- 🔄 **자동 배포**: GitHub push → 자동 배포
- 🔒 **무료 SSL**: HTTPS 자동 적용
- 💰 **저렴함**: 프리티어 1년 무료
- ⚡ **빠름**: 전 세계 CDN 자동 적용

**배포 시간**: 약 5분

**배포 가이드**: [AWS_AMPLIFY_SETUP.md](./AWS_AMPLIFY_SETUP.md)

**빠른 시작**:
1. https://console.aws.amazon.com/amplify/ 접속
2. "New app" → "Host web app" → "GitHub" 선택
3. 저장소 선택: `doogiesdj/NewRIDE`, 브랜치: `main`
4. "Save and deploy" 클릭
5. 3-5분 후 배포 완료!

---

### 방법 2: AWS S3 + CloudFront

**장점**:
- 💰 **저렴함**: 월 $1-3
- ⚡ **빠름**: 전 세계 CDN
- 🔧 **유연함**: 완전한 제어 가능

**배포 시간**: 약 15분

**배포 가이드**: [AWS_HOSTING_GUIDE.md](./AWS_HOSTING_GUIDE.md)

**빠른 시작** (로컬 PC에서):
```bash
# 1. 저장소 클론
git clone https://github.com/doogiesdj/NewRIDE.git
cd NewRIDE

# 2. 배포 스크립트 실행
./deploy_to_s3.sh

# 3. 안내에 따라 버킷 이름 입력
# 예: newride-website

# 4. 완료! 웹사이트 URL 출력됨
```

---

### 방법 3: AWS Lightsail

**장점**:
- 🖥️ **완전한 제어**: 가상 서버
- 🔧 **유연함**: 원하는 대로 설정 가능
- 💻 **SSH 접근**: 직접 서버 관리

**배포 시간**: 약 20분

**월 비용**: $3.5부터

**배포 가이드**: [AWS_HOSTING_GUIDE.md](./AWS_HOSTING_GUIDE.md) 참조

---

## 📊 배포 방법 비교

| 항목 | Amplify | S3 + CloudFront | Lightsail |
|------|---------|----------------|-----------|
| **난이도** | ⭐ (매우 쉬움) | ⭐⭐ (쉬움) | ⭐⭐⭐ (보통) |
| **배포 시간** | 5분 | 15분 | 20분 |
| **월 비용** | 무료~$5 | $1~3 | $3.5~ |
| **자동 배포** | ✅ | ❌ | ❌ |
| **SSL 인증서** | ✅ 자동 | ✅ 수동 | ✅ 수동 |
| **커스텀 도메인** | ✅ 쉬움 | ✅ 보통 | ✅ 쉬움 |
| **추천도** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |

---

## 🎯 추천 순서

### 초보자 또는 빠른 배포를 원하는 경우:
👉 **AWS Amplify** 사용

**이유**:
- 클릭 몇 번이면 완료
- GitHub 연동 자동
- SSL 인증서 자동
- 무료 프리티어 1년

### 비용을 최소화하고 싶은 경우:
👉 **S3 + CloudFront** 사용

**이유**:
- 월 $1-3로 저렴
- 성능 우수 (CDN)
- 트래픽 무제한

### 완전한 제어가 필요한 경우:
👉 **Lightsail** 사용

**이유**:
- 가상 서버 완전 제어
- SSH 접근 가능
- 추가 서비스 설치 가능

---

## 📝 배포 후 체크리스트

### ✅ 기본 기능 테스트

- [ ] 메인 페이지 접속 확인
- [ ] 조직도 표시 확인
- [ ] 프로젝트 목록 표시 확인
- [ ] "사업 관리" 버튼 클릭 → 로그인 모달 팝업 확인

### ✅ 관리자 기능 테스트

- [ ] 로그인 (내부 관리자에게 정보 문의)
- [ ] 프로젝트 등록 테스트
- [ ] 프로젝트 수정 테스트
- [ ] 프로젝트 삭제 테스트
- [ ] 파일 업로드 테스트

### ✅ 반응형 테스트

- [ ] PC 브라우저 (Chrome, Firefox, Edge)
- [ ] 스마트폰 (iOS, Android)
- [ ] 태블릿

### ✅ 성능 테스트

- [ ] 페이지 로딩 속도 (3초 이내)
- [ ] 이미지 로딩 확인
- [ ] 모달 팝업 속도

---

## 🌐 커스텀 도메인 연결

### 도메인이 있는 경우

**Amplify**:
1. Amplify 콘솔 → "Domain management"
2. "Add domain" 클릭
3. 도메인 입력 (예: ride.or.kr)
4. DNS 설정 안내에 따라 CNAME 레코드 추가

**S3 + CloudFront**:
1. CloudFront 콘솔 → 배포 선택
2. "Alternate domain names" 추가
3. Route 53 또는 도메인 등록업체에서 CNAME 추가

**Lightsail**:
1. Lightsail 콘솔 → "Networking" 탭
2. "Create static IP" 클릭
3. 도메인 등록업체에서 A 레코드 추가

---

## 🔄 업데이트 방법

### Amplify (자동 배포)

```bash
# 로컬에서 파일 수정
cd /path/to/NewRIDE

# 변경사항 추가
git add .
git commit -m "업데이트 내용"
git push origin main

# 1-2분 후 자동 배포 완료! ✅
```

### S3 (수동 배포)

```bash
# 저장소 업데이트
git pull origin main

# S3에 다시 업로드
./deploy_to_s3.sh

# CloudFront 캐시 무효화
./invalidate_cloudfront.sh [DISTRIBUTION_ID]
```

### Lightsail (SSH 업데이트)

```bash
# SSH 접속
ssh -i LightsailDefaultKey.pem ubuntu@[고정IP]

# 코드 업데이트
cd /var/www/html
sudo git pull origin main

# 완료!
```

---

## 🚨 트러블슈팅

### 문제 1: 페이지가 안 보임

**해결책**:
1. Ctrl + Shift + R (강력 새로고침)
2. 시크릿 모드로 접속
3. 다른 브라우저에서 테스트

### 문제 2: 로그인 모달이 안 뜸

**해결책**:
1. 브라우저 콘솔 확인 (F12)
2. JavaScript 에러 확인
3. localStorage 허용 확인

### 문제 3: 파일 업로드가 안 됨

**원인**: localStorage 기반이라 브라우저에만 저장됨

**해결책**:
- 현재 설계대로 localStorage 사용 (추후 서버 업로드로 변경 가능)

---

## 📞 지원 리소스

### 공식 문서
- **AWS Amplify**: https://docs.aws.amazon.com/amplify/
- **AWS S3**: https://docs.aws.amazon.com/s3/
- **AWS CloudFront**: https://docs.aws.amazon.com/cloudfront/
- **AWS Lightsail**: https://docs.aws.amazon.com/lightsail/

### GitHub 저장소
- **프로젝트**: https://github.com/doogiesdj/NewRIDE
- **Issues**: https://github.com/doogiesdj/NewRIDE/issues

### AWS 프리티어
- **가입**: https://aws.amazon.com/free/
- **사용량 확인**: https://console.aws.amazon.com/billing/

---

## 🎉 배포 완료 후

### 1. 팀원들과 공유
```
안녕하세요!

RIDE 웹사이트가 배포되었습니다!

🌐 URL: https://[your-domain].amplifyapp.com

📝 관리자 로그인:
- 로그인 정보는 내부 관리자에게 문의하세요.

> ⚠️ **보안**: 관리자 계정 정보는 공개하지 않습니다.

기능:
- 프로젝트 등록/수정/삭제
- 파일 업로드/다운로드
- 조직도 관리

문제 발생 시 연락 주세요!
```

### 2. 정기 백업 설정
```bash
# GitHub에 정기적으로 백업
git add .
git commit -m "백업: $(date +%Y-%m-%d)"
git push origin main
```

### 3. 모니터링 설정
- AWS CloudWatch 알림 설정
- Google Analytics 연동 (선택사항)
- 에러 로그 모니터링

---

## ✅ 다음 단계

- [ ] AWS 배포 방법 선택
- [ ] 배포 가이드 따라하기
- [ ] 배포 완료 확인
- [ ] 기능 테스트
- [ ] 팀원들과 URL 공유
- [ ] (선택) 커스텀 도메인 연결
- [ ] (선택) 모니터링 설정

---

## 💡 추가 개선 사항 (선택)

### 보안 강화
- [ ] 관리자 비밀번호 암호화
- [ ] 세션 타임아웃 설정
- [ ] HTTPS 강제 리다이렉트

### 성능 최적화
- [ ] 이미지 최적화 (WebP 변환)
- [ ] CSS/JS 압축
- [ ] Lazy loading 적용

### 기능 추가
- [ ] 프로젝트 검색 기능
- [ ] 프로젝트 필터링 (연도별, 카테고리별)
- [ ] 관리자 역할 관리 (다중 사용자)
- [ ] 실제 파일 서버 업로드 (S3 연동)

---

**🎊 축하합니다! 배포 준비가 완료되었습니다!**

원하는 배포 방법을 선택하고 가이드를 따라하세요.

**추천**: 시간이 없다면 → **AWS Amplify** (5분 완료!)
