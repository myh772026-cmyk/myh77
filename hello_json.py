#!/usr/bin/env python3
import json

# 範例任務資料
tasks = [
    {"id": 1, "name": "讀書", "status": "未完成"},
    {"id": 2, "name": "寫程式", "status": "進行中"},
    {"id": 3, "name": "運動", "status": "已完成"}
]

# 將 JSON 輸出到檔案
with open("tasks.json", "w", encoding="utf-8") as f:
    json.dump(tasks, f, ensure_ascii=False, indent=2)

# 在 Terminal 顯示文字
for task in tasks:
    print(f"任務 {task['id']}: {task['name']} - {task['status']}")
