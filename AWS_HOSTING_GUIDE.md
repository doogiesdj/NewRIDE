# AWS 호스팅 가이드

GitHub에 업로드 완료: https://github.com/doogiesdj/NewRIDE

---

## 🎯 AWS 호스팅 3가지 방법

### 방법 1: AWS Amplify (가장 쉬움, 추천!) ⭐

#### 장점
- ✅ 가장 간단함 (클릭 몇 번으로 완료)
- ✅ GitHub 자동 연동
- ✅ 코드 푸시하면 자동 배포
- ✅ 무료 SSL 인증서 제공
- ✅ 커스텀 도메인 연결 쉬움
- ✅ 프리티어 사용 가능

#### 배포 단계

1. **AWS Amplify 콘솔 접속**
   ```
   https://console.aws.amazon.com/amplify/
   ```

2. **새 앱 생성**
   - "New app" → "Host web app" 클릭
   - "GitHub" 선택
   - GitHub 로그인 및 권한 허용

3. **저장소 선택**
   - Repository: `doogiesdj/NewRIDE`
   - Branch: `main`
   - "Next" 클릭

4. **빌드 설정**
   ```yaml
   version: 1
   frontend:
     phases:
       build:
         commands: []
     artifacts:
       baseDirectory: /
       files:
         - '**/*'
     cache:
       paths: []
   ```
   - "Next" 클릭

5. **검토 및 배포**
   - "Save and deploy" 클릭
   - 5분 정도 기다리면 배포 완료!

6. **URL 확인**
   ```
   https://main.xxxxxx.amplifyapp.com
   ```

7. **커스텀 도메인 연결 (선택사항)**
   - 좌측 메뉴 "Domain management" 클릭
   - "Add domain" 클릭
   - 도메인 입력 (예: ride.or.kr)
   - DNS 설정 안내에 따라 설정

---

### 방법 2: AWS S3 + CloudFront (빠르고 저렴)

#### 장점
- ✅ 매우 저렴 (월 $1-5)
- ✅ 빠른 속도 (CDN)
- ✅ 무제한 트래픽
- ✅ 프리티어 사용 가능

#### 배포 단계

**1단계: S3 버킷 생성**

```bash
# AWS CLI 설치 (로컬 PC에서)
# Windows: https://aws.amazon.com/cli/
# Mac: brew install awscli
# Linux: sudo apt install awscli

# AWS 자격증명 설정
aws configure
# AWS Access Key ID: [입력]
# AWS Secret Access Key: [입력]
# Default region: ap-northeast-2 (서울)
# Default output format: json
```

**S3 버킷 생성**
```bash
# 버킷 이름 (전 세계에서 고유해야 함)
BUCKET_NAME="newride-website"

# 버킷 생성
aws s3 mb s3://$BUCKET_NAME --region ap-northeast-2

# 정적 웹사이트 호스팅 활성화
aws s3 website s3://$BUCKET_NAME \
  --index-document index.html \
  --error-document index.html

# 퍼블릭 액세스 허용
aws s3api put-public-access-block \
  --bucket $BUCKET_NAME \
  --public-access-block-configuration \
  "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

# 버킷 정책 설정
cat > bucket-policy.json << 'POLICY'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::newride-website/*"
    }
  ]
}
POLICY

aws s3api put-bucket-policy \
  --bucket $BUCKET_NAME \
  --policy file://bucket-policy.json
```

**2단계: 파일 업로드**

```bash
# GitHub에서 클론
git clone https://github.com/doogiesdj/NewRIDE.git
cd NewRIDE

# S3에 업로드
aws s3 sync . s3://$BUCKET_NAME \
  --exclude ".git/*" \
  --exclude "*.md" \
  --exclude "*.sh" \
  --cache-control "max-age=31536000"

# index.html은 캐시 안 함
aws s3 cp index.html s3://$BUCKET_NAME/index.html \
  --cache-control "no-cache"
```

**3단계: 웹사이트 URL 확인**
```
http://newride-website.s3-website.ap-northeast-2.amazonaws.com
```

**4단계: CloudFront 배포 (선택사항, HTTPS + 빠른 속도)**

AWS 콘솔에서:
1. CloudFront 콘솔 접속
2. "Create distribution" 클릭
3. Origin domain: S3 버킷 선택
4. Viewer protocol policy: Redirect HTTP to HTTPS
5. "Create distribution" 클릭
6. 10-15분 후 배포 완료

---

### 방법 3: AWS Lightsail (가상 서버, 개발자용)

#### 장점
- ✅ 완전한 서버 제어
- ✅ 고정 IP
- ✅ SSH 접근 가능
- ✅ 월 $3.5부터

#### 배포 단계

1. **Lightsail 인스턴스 생성**
   - Lightsail 콘솔 접속
   - "Create instance" 클릭
   - Platform: Linux/Unix
   - Blueprint: OS Only → Ubuntu 22.04 LTS
   - Instance plan: $3.5/month
   - Instance name: ride-website
   - "Create instance" 클릭

2. **SSH 접속**
   ```bash
   # Lightsail 콘솔에서 "Connect using SSH" 클릭
   # 또는 로컬에서:
   ssh -i LightsailDefaultKey.pem ubuntu@[고정IP]
   ```

3. **웹 서버 설치**
   ```bash
   # Nginx 설치
   sudo apt update
   sudo apt install -y nginx git

   # 방화벽 설정
   sudo ufw allow 'Nginx Full'
   sudo ufw enable

   # 웹사이트 디렉토리로 이동
   cd /var/www/html
   sudo rm -rf *

   # GitHub에서 클론
   sudo git clone https://github.com/doogiesdj/NewRIDE.git .

   # 권한 설정
   sudo chown -R www-data:www-data /var/www/html
   sudo chmod -R 755 /var/www/html

   # Nginx 재시작
   sudo systemctl restart nginx
   ```

4. **웹사이트 접속**
   ```
   http://[Lightsail 고정 IP]
   ```

5. **HTTPS 설정 (Let's Encrypt)**
   ```bash
   # Certbot 설치
   sudo apt install -y certbot python3-certbot-nginx

   # SSL 인증서 발급 (도메인이 있을 경우)
   sudo certbot --nginx -d yourdomain.com

   # 자동 갱신 설정
   sudo systemctl enable certbot.timer
   ```

---

## 📊 비용 비교

| 방법 | 월 비용 | 프리티어 | 난이도 | 추천도 |
|------|---------|----------|--------|--------|
| **Amplify** | 무료~$5 | ✅ 1년 | ⭐ | ⭐⭐⭐⭐⭐ |
| **S3 + CloudFront** | $1~3 | ✅ 1년 | ⭐⭐ | ⭐⭐⭐⭐ |
| **Lightsail** | $3.5~ | ❌ | ⭐⭐⭐ | ⭐⭐⭐ |

---

## 🔧 자동 배포 설정 (Amplify)

Amplify는 GitHub에 푸시하면 자동으로 배포됩니다!

```bash
# 로컬에서 수정
git add .
git commit -m "프로젝트 업데이트"
git push origin main

# 1-2분 후 자동 배포 완료!
```

---

## 🌐 커스텀 도메인 연결

### Amplify에서 도메인 연결
1. Amplify 콘솔 → Domain management
2. "Add domain" 클릭
3. 도메인 입력 (예: ride.or.kr)
4. DNS 설정:
   ```
   Type: CNAME
   Name: www
   Value: [Amplify가 제공하는 CNAME]
   ```

### CloudFront에서 도메인 연결
1. CloudFront 배포 선택
2. "Edit" → Alternate domain names (CNAMEs) 추가
3. Route 53 또는 도메인 등록업체에서 CNAME 추가

---

## 📝 배포 후 확인 사항

- [ ] 메인 페이지 로드 확인
- [ ] "사업 관리" 버튼 → 로그인 모달 확인
- [ ] 관리자 로그인 (내부 관리자에게 정보 문의)
- [ ] 프로젝트 등록/수정/삭제 테스트
- [ ] 파일 보기 기능 확인
- [ ] 모바일 반응형 확인

---

## 🚨 트러블슈팅

### 문제: 페이지가 안 보임 (404 에러)
- S3: 버킷 정책 확인
- Amplify: 빌드 로그 확인
- CloudFront: 캐시 무효화

### 문제: 관리자 페이지 인증이 안 됨
- localStorage가 차단되어 있는지 확인
- 브라우저 쿠키 설정 확인

### 문제: 파일 업로드가 안 됨
- 브라우저에서만 작동 (서버 업로드 불가)
- localStorage 용량 제한 확인

---

## 📞 지원

- AWS 프리티어: https://aws.amazon.com/free/
- Amplify 문서: https://docs.aws.amazon.com/amplify/
- S3 문서: https://docs.aws.amazon.com/s3/

---

## ✅ 다음 단계

1. ✅ GitHub 업로드 완료
2. ⬜ AWS Amplify 배포 (추천!)
3. ⬜ 커스텀 도메인 연결
4. ⬜ 실제 데이터 입력 및 테스트

