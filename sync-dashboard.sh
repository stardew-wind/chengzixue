#!/bin/bash
# =====================================================
# 橙子学数据看板 - 一键更新并部署脚本
# =====================================================
# 用法：
#   1. 更新 Excel 源数据
#   2. 运行本脚本： bash sync-dashboard.sh
#   3. 等待 Vercel 自动部署完成
#   4. 刷新线上链接查看新数据
# =====================================================

set -e

# 颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 路径配置
SOURCE_DIR="数据分析/橙子学数据看板"
OUTPUT_DIR="$SOURCE_DIR/outputs"
DEPLOY_DIR="橙子学数据看板-web"
UPDATE_SCRIPT="$SOURCE_DIR/update.py"

echo -e "${YELLOW}🍊 橙子学数据看板 - 一键更新${NC}"
echo ""

# 步骤1：运行 update.py 生成最新数据
echo -e "${YELLOW}步骤 1/5：运行 $UPDATE_SCRIPT 生成最新数据...${NC}"
if [ -f "$UPDATE_SCRIPT" ]; then
    python "$UPDATE_SCRIPT"
else
    echo -e "${RED}❌ 找不到 $UPDATE_SCRIPT，请确认路径正确${NC}"
    exit 1
fi

# 步骤2：复制最新 JSON 到部署目录
echo -e "${YELLOW}步骤 2/5：复制 dashboard-data.json 到部署目录...${NC}"
if [ -f "$OUTPUT_DIR/dashboard-data.json" ]; then
    cp "$OUTPUT_DIR/dashboard-data.json" "$DEPLOY_DIR/dashboard-data.json"
    echo -e "${GREEN}✅ 已复制：$OUTPUT_DIR/dashboard-data.json -> $DEPLOY_DIR/dashboard-data.json${NC}"
else
    echo -e "${RED}❌ 找不到 $OUTPUT_DIR/dashboard-data.json，数据处理可能失败${NC}"
    exit 1
fi

# 步骤3：进入部署目录
echo -e "${YELLOW}步骤 3/5：进入部署目录...${NC}"
cd "$DEPLOY_DIR"

# 步骤4：Git 提交并推送
echo -e "${YELLOW}步骤 4/5：提交到 Git...${NC}"
git add .

# 检查是否有变更
echo -e "${YELLOW}步骤 4/5：提交到 Git...${NC}"
git add .

if git diff --cached --quiet; then
    echo -e "${YELLOW}⚠️ 没有文件变更，无需推送${NC}"
    exit 0
fi

COMMIT_MSG="update data: $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG"

echo -e "${YELLOW}步骤 5/5：推送到 GitHub...${NC}"
git push

echo ""
echo -e "${GREEN}🎉 完成！Vercel 将在 30 秒内自动重新部署。${NC}"
echo -e "${GREEN}🔗 请访问你的 Vercel 链接查看最新数据。${NC}"
