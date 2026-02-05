#!/bin/bash

echo "📦 GitHub에 푸시 준비 중..."
echo ""
echo "저장소 URL을 입력하세요 (예: https://github.com/doogiesdj/RIDE-website.git):"
read REPO_URL

if [ -z "$REPO_URL" ]; then
    echo "❌ 저장소 URL이 입력되지 않았습니다."
    exit 1
fi

echo ""
echo "🔄 원격 저장소 추가 중..."
cd /home/user/webapp
git remote add origin "$REPO_URL"

echo ""
echo "🚀 푸시 중..."
git push -u origin main

echo ""
echo "✅ 푸시 완료!"
echo ""
echo "🌐 저장소 확인:"
echo "$REPO_URL"
