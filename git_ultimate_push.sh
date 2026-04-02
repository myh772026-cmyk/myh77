#!/bin/bash

# ==============================
# 終極 Git 自動推送腳本
# ==============================

# 顏色設定
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# 檢查是否在 Git 倉庫
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}⚠️ 這裡不是 Git 倉庫，請進入 Git 專案目錄後再執行${RESET}"
    exit 1
fi

# 1️⃣ 暫存所有更改
echo -e "${YELLOW}Staging all changes...${RESET}"
git add -A

# 2️⃣ 自動 commit（如果有更改）
if git diff --cached --quiet; then
    echo -e "${YELLOW}No changes to commit.${RESET}"
else
    echo -e "${YELLOW}Committing changes...${RESET}"
    git commit -m "Auto commit: $(date '+%Y-%m-%d %H:%M:%S')"
fi

# 3️⃣ 抓取遠端更新
echo -e "${YELLOW}Fetching latest changes from origin...${RESET}"
git fetch origin

# 4️⃣ 建立本地備份分支
BACKUP_BRANCH="backup_$(date '+%Y%m%d_%H%M%S')"
echo -e "${YELLOW}Creating backup branch: $BACKUP_BRANCH${RESET}"
git branch "$BACKUP_BRANCH"

# 5️⃣ rebase 本地 main 分支
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
echo -e "${YELLOW}Rebasing $CURRENT_BRANCH on top of origin/$CURRENT_BRANCH...${RESET}"
git rebase origin/$CURRENT_BRANCH

# 6️⃣ 檢查 rebase 是否成功
if [ $? -ne 0 ]; then
    echo -e "${RED}⚠️ Rebase 發生衝突！本地修改已備份到分支 $BACKUP_BRANCH${RESET}"
    while true; do
        read -p "選擇操作: [m] 手動解決衝突, [a] 放棄推送, [s] 暫停: " choice
        case "$choice" in
            m|M)
                echo -e "${YELLOW}請手動解決衝突後再執行 gp${RESET}"
                exit 0
                ;;
            a|A)
                echo -e "${RED}放棄此次推送...${RESET}"
                git rebase --abort
                exit 0
                ;;
            s|S)
                echo -e "${YELLOW}暫停腳本，請稍後手動處理${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}無效選項，請輸入 m、a 或 s${RESET}"
                ;;
        esac
    done
fi

# 7️⃣ 推送到遠端
echo -e "${YELLOW}Pushing $CURRENT_BRANCH to origin/$CURRENT_BRANCH...${RESET}"
git push -u origin $CURRENT_BRANCH

echo -e "${GREEN}✅ 推送完成！本地 $CURRENT_BRANCH 已同步到遠端。${RESET}"
