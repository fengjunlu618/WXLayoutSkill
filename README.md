# WeChat Layout Skills

> 用 Cursor / Codex / Claude Code Skill 给微信公众号做精细化排版的「方法论 + 配色系统 + 模板引擎 + 可视化选择器」开源包。
> Markdown 进去，粘贴级安全色 HTML 出来，复制即发。

## 这是什么

三个 **Agent Skill** + 一个交互式选择页，封装了一套经过微信公众号编辑器**浅色 + 深色双模式实测**的排版方法论：

| Skill | 职责 |
|-------|------|
| `wxlayout-wechat-paste` | **排版引擎**：读 Markdown → 自主选模板（T00–T08 / L01–L02）→ 绑配色 → 渲染粘贴级 inline HTML |
| `wechat-safe-colors` | **配色层**：9 族低饱和安全色 + 四级字色 N/W/B/C + 高亮 H1/H2，微信深色模式不发脏 |
| `wxlayout-template-picker` | **选择器**：帮用户可视化选模板/配色，输出选择摘要交给排版引擎执行 |

另附 `examples/template-color-picker.html` —— 浏览器打开的交互式模板配色索引页，左栏勾选模板/色卡，右栏 680px 实时预览，一键生成给 Agent 的指令。

## 为什么需要它

公众号排版有三个老问题：

1. **Markdown 实时预览型**工具——MD 语法表达不了「这段右对齐、这句做金句、这里用对比卡片」
2. **固定模板型**工具——精细控制几乎为零，模板长什么样文章就长什么样
3. **AI 直出 HTML**——改一个字号要重新生成，CSS 在微信里兼容性是玄学

这套 Skill 走第四条路：**内容 ≠ 排版**。

- Markdown 只管内容（文字、结构）
- 排版由独立的「LayoutDoc」+ Skill 自主决策（卡片选型、对齐、强调）
- 视觉由 WeChat-Safe 配色 Token 驱动，**浅/深双模式都安全**
- 输出全内联样式 HTML，复制粘贴到公众号编辑器即可

## 兼容的 AI 编码 Agent

这套 Skill 基于开放标准，支持主流 AI 编码 Agent：

| Agent | Skill 机制 | 触发方式 | 安装目录 |
|-------|-----------|----------|----------|
| **Cursor** | ✅ `SKILL.md` | `@skill-name` + 隐式 | `~/.cursor/skills/` |
| **Codex CLI** | ✅ `SKILL.md` + `agents/openai.yaml` | `$skill-name` 或 `/skills` + 隐式 | `~/.agents/skills/` |
| **Claude Code** | ✅ `SKILL.md` | `/skill-name` + 隐式 | `~/.claude/skills/` |
| **GitHub Copilot** | ❌ 无 Skill，走 instructions | 自动读 `AGENTS.md` | — |
| **Windsurf** | ❌ 无 Skill，走 rules | 自动读 `AGENTS.md` | — |

- Cursor / Codex / Claude Code 三家共用同一份 `SKILL.md`，目录不同而已
- 仓库根目录 `AGENTS.md` 遵循 [agents.md 开放标准](https://agents.md/)，被上述所有 Agent 自动读取
- Copilot / Windsurf 没有 Skill 机制，靠 `AGENTS.md` 获得核心排版权威规则

## 安装

### 方式一：一键脚本（推荐）

```bash
# macOS / Linux · 默认装到全部三个 Agent
git clone https://github.com/TanShilongMario/WXLayoutSkill.git wechat-layout-skills
cd wechat-layout-skills
./install.sh                       # 等价于 --target all

# 或只装到某一个
./install.sh --target cursor
./install.sh --target codex
./install.sh --target claude
```

```powershell
# Windows PowerShell
git clone https://github.com/TanShilongMario/WXLayoutSkill.git wechat-layout-skills
cd wechat-layout-skills
./install.ps1                      # 等价于 -Target all
./install.ps1 -Target cursor
```

脚本会把 `skills/*` 拷贝到对应 Agent 的全局 Skill 目录。三个 Skill 必须同时安装，`wxlayout-wechat-paste` 依赖 `wechat-safe-colors`，`wxlayout-template-picker` 依赖前两者。

### 方式二：手动拷贝

把 `skills/wechat-safe-colors` 和 `skills/wxlayout-wechat-paste` 两个目录复制到目标 Agent 的 Skill 目录：

| Agent | 个人级 | 项目级 |
|-------|--------|--------|
| Cursor | `~/.cursor/skills/` | `<project>/.cursor/skills/` |
| Codex CLI | `~/.agents/skills/` | `<project>/.agents/skills/` |
| Claude Code | `~/.claude/skills/` | `<project>/.claude/skills/` |

### 方式三：无 Skill 机制的 Agent（Copilot / Windsurf）

无需安装脚本。把仓库 clone 到你的项目目录，根目录 `AGENTS.md` 会被自动读取：

- **GitHub Copilot**：仓库根目录已有 `AGENTS.md`；若想强化，可在 `.github/copilot-instructions.md` 里加一行 `@AGENTS.md` 引用
- **Windsurf**：在 `.windsurf/rules/wechat-layout.md` 写 `@AGENTS.md`，或直接把 `AGENTS.md` 内容复制过去

## 使用

### Cursor

```
@wxlayout-wechat-paste 帮我排版这篇 @article.md
```

### Codex CLI

```
$wxlayout-wechat-paste 排版 article.md
```

或输入 `/skills` 从列表选。Codex 也会根据 description 隐式自动触发。

### Claude Code

```
/wxlayout-wechat-paste
```

然后粘贴文章内容。Claude 也会根据任务描述隐式自动触发。

### GitHub Copilot / Windsurf

直接在对话里描述需求，Agent 会读 `AGENTS.md` 里的排版权威规则：

```
帮我排版这篇文章，输出公众号 HTML：[粘贴 MD]
```

### 通用流程

无论哪个 Agent，触发后都会：

1. 扫描文章（字数、结构、气质）
2. 自主决定模板组合与配色主题（用 3–5 行「编排方案」告知你）
3. 渲染成带 `#copy-target` 和复制按钮的 HTML
4. 你在浏览器打开 → 点「复制排版内容」→ 粘贴到公众号编辑器

也可以指定模板/配色覆盖自主判断：

```
排版 @article.md
模板：只要 T01 + T08
配色：全篇 morandi
```

先看 demo 感受效果：

```bash
# 把 examples/demo.md 喂给 Skill，对照 examples/demo-expected.md 看预期编排
```

## 模板速查

| ID | 名称 | 用于 |
|----|------|------|
| T00 | 开篇杂志 | 文首标题+钩子 |
| T01 | 笔记 | 痛点/经历/引述 |
| T02 | 山水理念 | 分层/东方 calm（builtin 青绿） |
| T03 | 对比路径 | A/B/C/D 并列方案 |
| T04 | 架构极客 | Layer/数据流/模块（深壳） |
| T05 | 故事 | 案例/叙事 |
| T06 | 元测试深块 | 清单/自检 |
| T07 | 路线图 | MVP/阶段/计划 |
| T08 | 结语 | 金句/CTA |
| T99 | 页脚灰栏 | 日期/版权 |
| L01/L02 | 长| 深度长文双卡模式 |

## 配色速查

**9 族安全色：** parchment 羊皮纸 · rose 尘粉 · sage 鼠尾草 · lavender 薰衣草 · warmNeutral 暖灰 · charcoal 炭灰 · morandiBlue 莫兰迪蓝 · bridge 过渡色 · neutral 中性灰。每族含 50→500 明度阶梯。

**四级字色：**

| 方案 | 场景 | 用法 |
|------|------|------|
| N | 浅底默认 | 暖色系浅卡 |
| B | 浅底·莫兰迪 | 雾蓝感浅卡 |
| W | 深底默认 | 炭灰/暖褐深卡 |
| C | 深底·莫兰迪 | 冷净感深卡 |

**高亮色：** H1 暖琥珀（暖主题）、H2 板岩青（冷主题，替代高饱和蓝）。

## 目录结构

```
wechat-layout-skills/
├── README.md                      本文件
├── AGENTS.md                      跨 Agent 通用指引（agents.md 开放标准）
├── LICENSE                        MIT
├── CHANGELOG.md
├── install.sh / install.ps1       多 Agent 一键安装（--target cursor|codex|claude|all）
├── skills/
│   ├── wechat-safe-colors/        配色层 Skill（自包含）
│   │   ├── SKILL.md
│   │   ├── palette-reference.md
│   │   ├── agents/openai.yaml     Codex 专用元数据
│   │   └── data/
│   │       └── wechat-safe-palette.json
│   ├── wxlayout-wechat-paste/     排版引擎 Skill（自包含）
│   │   ├── SKILL.md
│   │   ├── orchestration.md
│   │   ├── layout-templates.md
│   │   ├── agents/openai.yaml     Codex 专用元数据
│   │   └── data/
│   │       ├── wechat-layout-templates.json
│   │       ├── wechat-layout-orchestration.json
│   │       └── wechat-layout-tokens.json
│   └── wxlayout-template-picker/  模板配色选择器 Skill
│       ├── SKILL.md
│       └── agents/openai.yaml     Codex 专用元数据
├── examples/
│   ├── template-color-picker.html 交互式模板配色索引页（浏览器打开）
│   ├── demo.md                    短文样例（<1500 字）
│   └── demo-expected.md           预期编排方案 + 验证清单
└── docs/
    ├── methodology.md             方法论：内容≠排版、自主编排、四层架构
    └── why-safe-colors.md         为什么不用高饱和色（实测故事 + P1–P7 原则）
```

## 方法论

详见 [docs/methodology.md](docs/methodology.md)，核心三条：

1. **内容 ≠ 排版** —— MD 管内容，LayoutDoc 管排版，Theme 管视觉，三层分离各自迭代
2. **自主编排** —— Agent 读文章自己决定模板/配色，不反问；卡片是「章节级强调」不是段落装饰
3. **微信安全色** —— 低饱和、中明度、浅深双模式实测；不绕过 mp-darkmode

## 贡献

欢迎提 Issue / PR：

- 新模板（新增 TXX 需附浅/深双模式粘贴实测截图）
- 新色族（需附浅色/深色双模式粘贴实测截图，与现有 `validated` 色族同等验证）
- 新文章类型 profile（附样例 MD + 渲染结果）
- 标杆文章（多卡组合的上限参考）

## License

MIT — 见 [LICENSE](LICENSE)
