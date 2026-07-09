#!/bin/bash
# Auto-commit and push Woodchuck Box Designer changes to GitHub
# Triggered by launchd whenever woodchuck-box-designer.html is saved.

REPO="/Users/isaacrentmeester/Library/Mobile Documents/com~apple~CloudDocs/html"
LOG="$HOME/.woodchuck-autopush.log"

cd "$REPO" || exit 1

# Only act if there are actual changes to the tracked files
if git diff --quiet HEAD -- woodchuck-box-designer.html wood-quoting-tool.html CLAUDE.md IronLog.html ASB_Vendor_Navigation_Guide.html 2>/dev/null; then
  exit 0
fi

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
MSG="Auto-save $TIMESTAMP"

git add woodchuck-box-designer.html wood-quoting-tool.html CLAUDE.md IronLog.html ASB_Vendor_Navigation_Guide.html
git commit -m "$MSG" >> "$LOG" 2>&1
git push origin main >> "$LOG" 2>&1

echo "[$TIMESTAMP] Pushed to GitHub" >> "$LOG"
