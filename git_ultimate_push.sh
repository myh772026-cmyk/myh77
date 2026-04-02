#!/bin/bash
# ==============================
# 終極 Git 自動推送腳本（Ultimate Interactive Push）
# ==============================

# 顏色設定
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
CYAN="\033[1;36m"
RESET="\033[0m"

# ------------------------------
# 1️⃣ 檢查 Git 倉庫
# ------------------------------
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}⚠️ 這裡不是 Git 倉庫，請進入 Git 專案目錄後再執行${RESET}"
    exit 1
fi

# ------------------------------
# 2️⃣ 設定使用者名稱與 Email（如果沒設定）
# ------------------------------
if ! git config user.name > /dev/null; then
    git config user.name "JI QIANG HE"
fi
if ! git config user.email > /dev/null; then
    git config user.email "myh77@JIs-MacBook-Air.local"
fi

# ------------------------------
# 3️⃣ 選擇分支
# ------------------------------
CURRENT_BRANCH=$(git branch --show-current)
echo -e "${CYAN}當前分支: ${CURRENT_BRANCH}${RESET}"
read -p "輸入要推送的分支 (預設: ${CURRENT_BRANCH}): " TARGET_BRANCH
TARGET_BRANCH=${TARGET_BRANCH:-$CURRENT_BRANCH}

# ------------------------------
# 4️⃣ 暫存 & 提交
# ------------------------------
echo -e "${YELLOW}Staging all changes...${RESET}"
git add .

COMMIT_MSG="Auto commit: $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${YELLOW}Committing changes...${RESET}"
git commit -m "$COMMIT_MSG" 2>/dev/null || echo -e "${GREEN}✅ 沒有新變更需要提交${RESET}"

# ------------------------------
# 5️⃣ 建立備份分支
# ------------------------------
BACKUP_BRANCH="backup_$(date '+%Y%m%d_%H%M%S')"
echo -e "${YELLOW}Creating backup branch: ${BACKUP_BRANCH}${RESET}"
git branch "$BACKUP_BRANCH"

# ------------------------------
# 6️⃣ 取得遠端更新並 rebase
# ------------------------------
echo -e "${YELLOW}Fetching latest changes from origin...${RESET}"
git fetch origin

echo -e "${YELLOW}Rebasing ${TARGET_BRANCH} on top of origin/${TARGET_BRANCH}...${RESET}"
git rebase "origin/${TARGET_BRANCH}"

# ------------------------------
# 7️⃣ 推送到遠端
# ------------------------------
echo -e "${YELLOW}Pushing ${TARGET_BRANCH} to origin/${TARGET_BRANCH}...${RESET}"
git push origin "$TARGET_BRANCH"

echo -e "${GREEN}✅ 推送完成！本地 ${TARGET_BRANCH} 已同步到遠端${RESET}"
#!/bin/bash
# ==============================
# 終極 Git 自動推送腳本（Ultimate Push）
# ==============================

# 顏色設定
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# ------------------------------
# 1️⃣ 檢查 Git 倉庫
# ------------------------------
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}⚠️ 這裡不是 Git 倉庫，請進入 Git 專案目錄後再執行${RESET}"
    exit 1
fi

# ------------------------------
# 2️⃣ 設定使用者名稱與 Email（如果沒設定）
# ------------------------------
if ! git config user.name > /dev/null; then
    git config user.name "JI QIANG HE"
fi
if ! git config user.email > /dev/null; then
    git config user.email "myh77@JIs-MacBook-Air.local"
fi

# ------------------------------
# 3️⃣ 取得當前分支
# ------------------------------
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
echo -e "${YELLOW}目前操作分支: $CURRENT_BRANCH${RESET}"

# ------------------------------
# 4️⃣ 顯示分支與遠端差異
# ------------------------------
echo -e "${YELLOW}🔍 檢查可推送分支...${RESET}"
git fetch origin
git branch -vv | grep '\[origin/' || echo -e "${YELLOW}所有本地分支已與遠端同步${RESET}"

# ------------------------------
# 5️⃣ 自動 add 與 commit 所有變更
# ------------------------------
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo -e "${YELLOW}📝 檢測到變更，自動提交中...${RESET}"
    git add .
    git commit -m "Auto commit: $(date '+%Y-%m-%d %H:%M:%S')"
else
    echo -e "${YELLOW}✅ 無新變更需要提交${RESET}"
fi

# ------------------------------
# 6️⃣ 建立備份分支
# ------------------------------
BACKUP_BRANCH="backup_$(date +%Y%m%d_%H%M%S)"
echo -e "${YELLOW}💾 建立備份分支: $BACKUP_BRANCH${RESET}"
git branch "$BACKUP_BRANCH"

# ------------------------------
# 7️⃣ Rebase 到遠端最新
# ------------------------------
echo -e "${YELLOW}🔄 Rebasing $CURRENT_BRANCH 到 origin/$CURRENT_BRANCH...${RESET}"
git pull --rebase origin "$CURRENT_BRANCH"

# ------------------------------
# 8️⃣ 推送到遠端
# ------------------------------
echo -e "${YELLOW}🚀 推送 $CURRENT_BRANCH 到 origin/$CURRENT_BRANCH...${RESET}"
git push origin "$CURRENT_BRANCH"

echo -e "${GREEN}✅ 推送完成！本地 $CURRENT_BRANCH 已同步到遠端。${RESET}"


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
