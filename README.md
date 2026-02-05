# RIDE 웹사이트

디지털경제사회연구원(RIDE) 공식 웹사이트

## 🌐 주요 기능

- **홈페이지**: 연구원 소개, 조직도, 주요 사업 소개
- **프로젝트 관리 시스템**: 관리자 인증 기반 프로젝트 등록/수정/삭제
- **사업 요약 파일 뷰어**: PDF 파일 온라인 열람 및 다운로드
- **반응형 디자인**: 모바일, 태블릿, 데스크톱 대응

## 📂 프로젝트 구조

```
webapp/
├── index.html          # 메인 페이지
├── admin.html          # 관리자 페이지 (인증 필요)
├── admin.js            # 관리자 페이지 로직
├── projects.js         # 프로젝트 데이터 관리
├── script.js           # 공통 스크립트
├── styles.css          # 스타일시트
├── data/
│   └── projects.json   # 프로젝트 데이터
└── src/
    └── images/         # 이미지 리소스
```

## 🔐 관리자 로그인

관리자 로그인 정보는 보안상 공개하지 않습니다.
- **접근 경로**: 메인 페이지 → "사업 관리" 버튼 클릭
- **로그인 정보 문의**: 내부 관리자에게 문의하세요.

> ⚠️ **보안 주의사항**  
> 관리자 계정 정보는 반드시 안전하게 보관하고, 정기적으로 비밀번호를 변경하세요.

## 🚀 로컬 개발

### 1. 저장소 클론
```bash
git clone https://github.com/YOUR_USERNAME/RIDE-website.git
cd RIDE-website
```

### 2. 로컬 서버 실행
```bash
# Python 3
python -m http.server 8080

# 또는 Node.js
npx http-server -p 8080
```

### 3. 브라우저 접속
```
http://localhost:8080
```

## 📦 배포

### AWS S3 + CloudFront
1. S3 버킷 생성 및 정적 웹사이트 호스팅 활성화
2. 파일 업로드
3. CloudFront 배포 생성 (선택사항)

### AWS Amplify
1. GitHub 저장소 연결
2. 자동 빌드 및 배포 설정
3. 커스텀 도메인 설정 (선택사항)

### Vercel / Netlify
```bash
# Vercel
vercel deploy

# Netlify
netlify deploy
```

## 🔧 기술 스택

- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Storage**: JSON 파일 기반 (localStorage 활용)
- **Icons**: Font Awesome 6.0
- **Hosting**: AWS S3/CloudFront, AWS Amplify, Vercel, Netlify

## 📝 주요 업데이트

- **2025-02-05**: 관리자 인증 시스템 추가
- **2025-02-04**: 프로젝트 파일 뷰어 개선
- **2025-02-04**: 반응형 디자인 적용

## 📄 라이선스

Copyright © 2025 디지털경제사회연구원(RIDE). All rights reserved.

## 🤝 기여

이 프로젝트는 내부 관리용이며, 외부 기여는 받지 않습니다.

## 📞 문의

- **웹사이트**: [Your Website URL]
- **이메일**: [Your Email]
