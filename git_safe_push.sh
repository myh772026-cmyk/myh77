#!/bin/bash

# 安全推送腳本

# 1️⃣ 更新遠端分支
echo "Fetching latest changes from origin..."
git fetch origin

# 2️⃣ rebase 本地 main 分支
echo "Rebasing your commits on top of origin/main..."
git rebase origin/main

# 3️⃣ 檢查 rebase 是否成功
if [ $? -ne 0 ]; then
    echo "Rebase 有衝突，請先手動解決衝突後再推送。"
    exit 1
fi

# 4️⃣ 推送到遠端
echo "Pushing to origin/main..."
git push -u origin main

echo "✅ 推送完成！本地 main 已經同步到遠端。"
