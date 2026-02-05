#!/bin/bash

# RIDE 웹사이트 CloudFront 무효화 스크립트
# 사용법: ./invalidate_cloudfront.sh [DISTRIBUTION_ID]

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=================================${NC}"
echo -e "${GREEN}CloudFront 캐시 무효화 스크립트${NC}"
echo -e "${GREEN}=================================${NC}"
echo ""

# AWS CLI 설치 확인
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI가 설치되어 있지 않습니다.${NC}"
    exit 1
fi

# Distribution ID 입력
if [ -z "$1" ]; then
    echo "CloudFront Distribution ID를 찾는 중..."
    echo ""
    echo "CloudFront 콘솔: https://console.aws.amazon.com/cloudfront/"
    echo ""
    read -p "Distribution ID 입력 (예: E1234567890ABC): " DISTRIBUTION_ID
else
    DISTRIBUTION_ID=$1
fi

if [ -z "$DISTRIBUTION_ID" ]; then
    echo -e "${RED}❌ Distribution ID를 입력해야 합니다.${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}🔄 캐시 무효화 중...${NC}"
echo "Distribution ID: $DISTRIBUTION_ID"

# 모든 파일 캐시 무효화
INVALIDATION_ID=$(aws cloudfront create-invalidation \
    --distribution-id $DISTRIBUTION_ID \
    --paths "/*" \
    --query 'Invalidation.Id' \
    --output text)

echo ""
echo -e "${GREEN}✅ 캐시 무효화 요청 완료!${NC}"
echo "Invalidation ID: $INVALIDATION_ID"
echo ""
echo -e "${YELLOW}⏳ 무효화 진행 중... (약 1-2분 소요)${NC}"
echo ""
echo "상태 확인:"
echo "  aws cloudfront get-invalidation --distribution-id $DISTRIBUTION_ID --id $INVALIDATION_ID"
echo ""
echo -e "${GREEN}=================================${NC}"
