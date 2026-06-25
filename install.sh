#!/usr/bin/env bash
# WeChat Layout Skills · 多 Agent 一键安装
# 用法: ./install.sh [--target cursor|codex|claude|all]
# 默认: --target all
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-}"

# 解析参数
if [[ "$TARGET" == "--target" ]]; then
  TARGET="${2:-all}"
elif [[ "$TARGET" == "" ]]; then
  TARGET="all"
elif [[ "$TARGET" == --target=* ]]; then
  TARGET="${TARGET#--target=}"
else
  TARGET="all"
fi

# 校验
case "$TARGET" in
  cursor|codex|claude|all) ;;
  *)
    echo "用法: $0 [--target cursor|codex|claude|all]"
    echo "  cursor  仅安装到 Cursor (~/.cursor/skills/)"
    echo "  codex   仅安装到 Codex CLI (~/.agents/skills/)"
    echo "  claude  仅安装到 Claude Code (~/.claude/skills/)"
    echo "  all     全部安装（默认）"
    exit 1
    ;;
esac

SKILLS=(wechat-safe-colors wxlayout-wechat-paste wxlayout-template-picker)

# 目标目录（bash 3.2 兼容，不用关联数组）
target_dir_for() {
  case "$1" in
    cursor) echo "${HOME}/.cursor/skills" ;;
    codex)  echo "${HOME}/.agents/skills" ;;
    claude) echo "${HOME}/.claude/skills" ;;
  esac
}

# 选择要安装的 Agent
if [[ "$TARGET" == "all" ]]; then
  AGENTS=(cursor codex claude)
else
  AGENTS=("$TARGET")
fi

echo "WeChat Layout Skills 安装脚本"
echo "源目录: $SCRIPT_DIR/skills"
echo "目标 Agent: ${AGENTS[*]}"
echo ""

for agent in "${AGENTS[@]}"; do
  target_dir="$(target_dir_for "$agent")"
  echo "── $agent → $target_dir ──"
  mkdir -p "$target_dir"

  for skill in "${SKILLS[@]}"; do
    src="$SCRIPT_DIR/skills/$skill"
    dst="$target_dir/$skill"

    if [ ! -d "$src" ]; then
      echo "  ✗ 找不到 $src"
      exit 1
    fi

    if [ -d "$dst" ]; then
      echo "  → $skill 已存在，覆盖更新"
      rm -rf "$dst"
    else
      echo "  → 安装 $skill"
    fi

    cp -R "$src" "$dst"
    echo "  ✓ $skill"
  done
  echo ""
done

echo "安装完成。"
echo ""
echo "三个 Skill："
echo "  @wechat-safe-colors       配色层"
echo "  @wxlayout-wechat-paste    排版引擎（依赖配色层）"
echo "  @wxlayout-template-picker 模板配色选择器（依赖前两者）"
echo ""
echo "各 Agent 触发方式："
echo "  Cursor       @wxlayout-wechat-paste 排版 @article.md"
echo "  Codex CLI    \$wxlayout-wechat-paste 排版 article.md   (或 /skills 选择)"
echo "  Claude Code  /wxlayout-wechat-paste                    (或描述任务自动触发)"
echo ""
echo "交互式选择：浏览器打开 examples/template-color-picker.html"
echo ""
echo "无 Skill 机制的 Agent（GitHub Copilot、Windsurf）："
echo "  根目录 AGENTS.md 会被自动读取，提供核心排版权威规则。"
