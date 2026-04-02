#!/bin/bash

# 互動式 + 自動備份的安全推送腳本

# 1️⃣ 暫存所有更改
echo "Staging all changes..."
git add -A

# 2️⃣ 自動 commit（如果有更改）
if git diff --cached --quiet; then
    echo "No changes to commit."
else
    echo "Committing changes..."
    git commit -m "Auto commit: $(date '+%Y-%m-%d %H:%M:%S')"
fi

# 3️⃣ 抓取遠端更新
echo "Fetching latest changes from origin..."
git fetch origin

# 4️⃣ 建立本地備份分支（避免衝突丟失修改）
BACKUP_BRANCH="backup_$(date '+%Y%m%d_%H%M%S')"
echo "Creating backup branch: $BACKUP_BRANCH"
git branch "$BACKUP_BRANCH"

# 5️⃣ rebase 本地 main 分支
echo "Rebasing on top of origin/main..."
git rebase origin/main

# 6️⃣ 檢查 rebase 是否成功
if [ $? -ne 0 ]; then
    echo "⚠️ Rebase 發生衝突！本地修改已備份到分支 $BACKUP_BRANCH"
    while true; do
        read -p "選擇操作: [m] 手動解決衝突, [a] 放棄推送, [s] 暫停: " choice
        case "$choice" in
            m|M)
                echo "請手動解決衝突後再執行 ./git_interactive_backup_push.sh"
                exit 0
                ;;
            a|A)
                echo "放棄此次推送..."
                git rebase --abort
                exit 0
                ;;
            s|S)
                echo "暫停腳本，請稍後手動處理"
                exit 0
                ;;
            *)
                echo "無效選項，請輸入 m、a 或 s"
                ;;
        esac
    done
fi

# 7️⃣ 推送到遠端
echo "Pushing to origin/main..."
git push -u origin main

echo "✅ 推送完成！你的本地 main 已同步到遠端。"
