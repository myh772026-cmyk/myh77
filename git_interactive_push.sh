#!/bin/bash

# 互動式自動推送腳本
# 會暫存、commit、rebase，遇到衝突提供選項

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

# 4️⃣ rebase 本地 main 分支
echo "Rebasing on top of origin/main..."
git rebase origin/main

# 5️⃣ 檢查 rebase 是否成功
if [ $? -ne 0 ]; then
    echo "⚠️ Rebase 發生衝突！"
    while true; do
        read -p "選擇操作: [m] 手動解決衝突, [a] 放棄推送, [s] 繼續暫停: " choice
        case "$choice" in
            m|M)
                echo "請手動解決衝突後再執行 ./git_interactive_push.sh"
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

# 6️⃣ 推送到遠端
echo "Pushing to origin/main..."
git push -u origin main

echo "✅ 推送完成！"
