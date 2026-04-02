#!/bin/bash

# 高級自動推送腳本
# 會自動暫存更改、rebase 遠端更新、推送

# 1️⃣ 暫存所有更改（包括 untracked files）
echo "Staging all changes..."
git add -A

# 2️⃣ 檢查是否有 commit
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
    echo "⚠️ Rebase 有衝突，請手動解決後再推送。"
    exit 1
fi

# 6️⃣ 推送到遠端
echo "Pushing to origin/main..."
git push -u origin main

echo "✅ 自動推送完成！"

