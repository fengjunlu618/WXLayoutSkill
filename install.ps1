# WeChat Layout Skills · 多 Agent 一键安装
# 用法: ./install.ps1 [-Target cursor|codex|claude|all]
# 默认: -Target all
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Target = if ($args -contains "-Target") { $args[Array::IndexOf($args, "-Target") + 1] } else { "all" }

# 校验
$validTargets = @("cursor", "codex", "claude", "all")
if ($Target -notin $validTargets) {
    Write-Host "用法: ./install.ps1 [-Target cursor|codex|claude|all]"
    Write-Host "  cursor  仅安装到 Cursor (%USERPROFILE%\.cursor\skills\)"
    Write-Host "  codex   仅安装到 Codex CLI (%USERPROFILE%\.agents\skills\)"
    Write-Host "  claude  仅安装到 Claude Code (%USERPROFILE%\.claude\skills\)"
    Write-Host "  all     全部安装（默认）"
    exit 1
}

$Skills = @("wechat-safe-colors", "wxlayout-wechat-paste", "wxlayout-template-picker")

# 目标目录映射
$Dirs = @{
    cursor = Join-Path $env:USERPROFILE ".cursor\skills"
    codex  = Join-Path $env:USERPROFILE ".agents\skills"
    claude = Join-Path $env:USERPROFILE ".claude\skills"
}

# 选择要安装的 Agent
if ($Target -eq "all") {
    $Agents = @("cursor", "codex", "claude")
} else {
    $Agents = @($Target)
}

Write-Host "WeChat Layout Skills 安装脚本"
Write-Host "源目录: $ScriptDir\skills"
Write-Host "目标 Agent: $($Agents -join ', ')"
Write-Host ""

foreach ($agent in $Agents) {
    $targetDir = $Dirs[$agent]
    Write-Host "── $agent → $targetDir ──"
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    foreach ($skill in $Skills) {
        $src = Join-Path $ScriptDir "skills\$skill"
        $dst = Join-Path $targetDir $skill

        if (-not (Test-Path $src)) {
            Write-Host "  ✗ 找不到 $src"
            exit 1
        }

        if (Test-Path $dst) {
            Write-Host "  → $skill 已存在，覆盖更新"
            Remove-Item -Recurse -Force $dst
        } else {
            Write-Host "  → 安装 $skill"
        }

        Copy-Item -Recurse -Force $src $dst
        Write-Host "  ✓ $skill"
    }
    Write-Host ""
}

Write-Host "安装完成。"
Write-Host ""
Write-Host "三个 Skill："
Write-Host "  @wechat-safe-colors       配色层"
Write-Host "  @wxlayout-wechat-paste    排版引擎（依赖配色层）"
Write-Host "  @wxlayout-template-picker 模板配色选择器（依赖前两者）"
Write-Host ""
Write-Host "各 Agent 触发方式："
Write-Host "  Cursor       @wxlayout-wechat-paste 排版 @article.md"
Write-Host "  Codex CLI    `$wxlayout-wechat-paste 排版 article.md   (或 /skills 选择)"
Write-Host "  Claude Code  /wxlayout-wechat-paste                    (或描述任务自动触发)"
Write-Host ""
Write-Host "交互式选择：浏览器打开 template-color-picker.html（仓库根目录）"
Write-Host ""
Write-Host "无 Skill 机制的 Agent（GitHub Copilot、Windsurf）："
Write-Host "  根目录 AGENTS.md 会被自动读取，提供核心排版权威规则。"
