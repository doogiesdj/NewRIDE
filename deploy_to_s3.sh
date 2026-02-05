#!/bin/bash

# RIDE 웹사이트 AWS S3 배포 스크립트
# 사용법: ./deploy_to_s3.sh

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=================================${NC}"
echo -e "${GREEN}RIDE 웹사이트 S3 배포 스크립트${NC}"
echo -e "${GREEN}=================================${NC}"
echo ""

# AWS CLI 설치 확인
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI가 설치되어 있지 않습니다.${NC}"
    echo ""
    echo "설치 방법:"
    echo "  - Windows: https://aws.amazon.com/cli/"
    echo "  - Mac: brew install awscli"
    echo "  - Linux: sudo apt install awscli"
    exit 1
fi

echo -e "${GREEN}✅ AWS CLI 확인 완료${NC}"

# AWS 자격증명 확인
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}❌ AWS 자격증명이 설정되지 않았습니다.${NC}"
    echo ""
    echo "다음 명령어로 설정하세요:"
    echo "  aws configure"
    echo ""
    echo "필요한 정보:"
    echo "  - AWS Access Key ID"
    echo "  - AWS Secret Access Key"
    echo "  - Default region: ap-northeast-2 (서울)"
    exit 1
fi

echo -e "${GREEN}✅ AWS 자격증명 확인 완료${NC}"

# 버킷 이름 입력
read -p "S3 버킷 이름 입력 (예: newride-website): " BUCKET_NAME

if [ -z "$BUCKET_NAME" ]; then
    echo -e "${RED}❌ 버킷 이름을 입력해야 합니다.${NC}"
    exit 1
fi

# 리전 설정
REGION="ap-northeast-2"

echo ""
echo -e "${YELLOW}📦 S3 버킷 생성 중...${NC}"

# 버킷 생성 (이미 존재하면 에러 무시)
if aws s3 mb s3://$BUCKET_NAME --region $REGION 2>/dev/null; then
    echo -e "${GREEN}✅ 버킷 생성 완료: s3://$BUCKET_NAME${NC}"
else
    echo -e "${YELLOW}⚠️  버킷이 이미 존재합니다: s3://$BUCKET_NAME${NC}"
fi

# 정적 웹사이트 호스팅 설정
echo ""
echo -e "${YELLOW}🌐 정적 웹사이트 호스팅 설정 중...${NC}"
aws s3 website s3://$BUCKET_NAME \
    --index-document index.html \
    --error-document index.html

echo -e "${GREEN}✅ 웹사이트 호스팅 설정 완료${NC}"

# 퍼블릭 액세스 허용
echo ""
echo -e "${YELLOW}🔓 퍼블릭 액세스 설정 중...${NC}"
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration \
    "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

echo -e "${GREEN}✅ 퍼블릭 액세스 설정 완료${NC}"

# 버킷 정책 생성
echo ""
echo -e "${YELLOW}📝 버킷 정책 생성 중...${NC}"
cat > /tmp/bucket-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::$BUCKET_NAME/*"
    }
  ]
}
EOF

aws s3api put-bucket-policy \
    --bucket $BUCKET_NAME \
    --policy file:///tmp/bucket-policy.json

echo -e "${GREEN}✅ 버킷 정책 설정 완료${NC}"

# 파일 업로드
echo ""
echo -e "${YELLOW}📤 파일 업로드 중...${NC}"

# HTML, CSS, JS 파일 업로드 (캐시 비활성화)
aws s3 sync . s3://$BUCKET_NAME \
    --exclude ".git/*" \
    --exclude "*.md" \
    --exclude "*.sh" \
    --exclude "test_*" \
    --exclude "debug_*" \
    --exclude "clear_*" \
    --exclude "force_*" \
    --exclude "click_test.html" \
    --exclude "*.bak" \
    --exclude "*.log" \
    --exclude "push_to_github.sh" \
    --exclude "PROJECT_MANAGEMENT.md" \
    --cache-control "no-cache, no-store, must-revalidate"

# 이미지 파일 업로드 (장기 캐시)
aws s3 sync ./src s3://$BUCKET_NAME/src \
    --cache-control "max-age=31536000, public"

# JSON 파일 업로드 (짧은 캐시)
aws s3 sync ./data s3://$BUCKET_NAME/data \
    --cache-control "max-age=300, public"

echo -e "${GREEN}✅ 파일 업로드 완료${NC}"

# 웹사이트 URL 표시
WEBSITE_URL="http://$BUCKET_NAME.s3-website.$REGION.amazonaws.com"

echo ""
echo -e "${GREEN}=================================${NC}"
echo -e "${GREEN}🎉 배포 완료!${NC}"
echo -e "${GREEN}=================================${NC}"
echo ""
echo -e "${GREEN}웹사이트 URL:${NC}"
echo -e "${YELLOW}$WEBSITE_URL${NC}"
echo ""
echo -e "${GREEN}다음 단계:${NC}"
echo "1. 위 URL로 접속하여 테스트"
echo "2. CloudFront 배포 (HTTPS + CDN)"
echo "3. 커스텀 도메인 연결"
echo ""
echo -e "${YELLOW}CloudFront 배포 가이드:${NC}"
echo "  https://console.aws.amazon.com/cloudfront/"
echo ""
echo -e "${GREEN}=================================${NC}"

# 웹사이트 URL을 파일에 저장
echo $WEBSITE_URL > s3_website_url.txt
echo -e "${GREEN}✅ URL이 s3_website_url.txt에 저장되었습니다.${NC}"
