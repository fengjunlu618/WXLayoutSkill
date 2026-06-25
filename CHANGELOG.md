# 更新日志

本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### 新增
- 首次开源发布 `wechat-safe-colors` Skill（v0.5 安全色板）
- 首次开源发布 `wxlayout-wechat-paste` Skill（自主编排 + 模板渲染）
- 首次开源发布 `wxlayout-template-picker` Skill（模板配色选择器，输出 LayoutRequest 摘要）
- 交互式模板配色索引页 `examples/template-color-picker.html`（浏览器打开，左栏勾选右栏预览）
- 4 个 theme JSON 数据文件内联进 Skill `data/` 目录，实现自包含
- 一键安装脚本 `install.sh` / `install.ps1`，支持 `--target cursor|codex|claude|all`
- 短文 demo 样例 `examples/demo.md`
- 方法论文档 `docs/methodology.md` 与 `docs/why-safe-colors.md`
- **多 Agent 兼容**：新增根目录 `AGENTS.md`（遵循 agents.md 开放标准），覆盖无 Skill 机制的 Agent（GitHub Copilot、Windsurf）
- **Codex 适配**：三个 Skill 均新增 `agents/openai.yaml`，声明 `allow_implicit_invocation: true`

### 变更
- 所有 Skill 内引用路径改为相对自身目录（`./data/*.json`）
- `wxlayout-wechat-paste` 顶部新增「依赖」段落，显式声明对 `wechat-safe-colors` 的依赖
- 两个 Skill 均加入 `disable-model-invocation: true`，避免误激活
- description 增加英文触发词，覆盖海外 WeChat 写作者搜索
- `install.sh` / `install.ps1` 从单目标升级为多 Agent 安装（保留默认 `all` 行为）

### 兼容性矩阵

| Agent | 支持 | 机制 |
|-------|------|------|
| Cursor | ✅ | SKILL.md + frontmatter |
| Codex CLI | ✅ | SKILL.md + agents/openai.yaml |
| Claude Code | ✅ | SKILL.md + frontmatter |
| GitHub Copilot | ✅ | AGENTS.md 自动读取 |
| Windsurf | ✅ | AGENTS.md 自动读取 |

### 移除
- 移除原项目内「明日测试」「待下一轮验证」等作者内部待办口吻
- 移除对 `themes/`、`output/` 等项目绝对路径的引用
