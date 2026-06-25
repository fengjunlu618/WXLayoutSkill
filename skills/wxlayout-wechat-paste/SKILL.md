---
name: wxlayout-wechat-paste
version: 0.1
disable-model-invocation: true
description: >-
  Renders paste-ready WeChat公众号 HTML from Markdown. Autonomously picks
  card templates (T00-T08, L01-L02) and WeChat-Safe color bindings from
  article style, length, and semantics when user does not specify. Use for
  MD排版、公众号 HTML、WeChat Official Account article formatting,
  MD to WeChat HTML, 模板配色, 公众号排版, 内容不该排版, or
  公众号 HTML generation.
---

# WXLayout · 公众号粘贴排版

## 依赖

本 Skill 依赖 **wechat-safe-colors** Skill 提供色板解析。两个 Skill 必须同时安装（见仓库 README）。

## 两层模型（必读）

```
Markdown 内容
    → ① 选模板（结构）     data/wechat-layout-templates.json
    → ② 绑配色（Token）    ../wechat-safe-colors/data/wechat-safe-palette.json
    → ③ 渲染 inline HTML   输出 #copy-target + 复制按钮
```

| 层 | 管什么 | 不管什么 |
|----|--------|----------|
| **模板** | 卡片结构、组件布局、阴影/横线/分栏 | 具体 HEX（除 builtin 模板） |
| **配色** | 各槽位用哪一族 Safe 色、四级字色 N/W/B/C | 段落该用哪种模板 |

## 自主编排（默认行为 · 必执行）

**用户未指定模板/配色时，Agent 必须自行判断，不得反问「要用哪张卡」除非文章语义极度模糊。**

机器可读规则：`data/wechat-layout-orchestration.json`
人类可读细则：[orchestration.md](orchestration.md)

### 编排流程（渲染前）

1. **扫描 MD**：估算字数、H2/H3 数量、是否有 table、引用、并列小标题、清单、时间阶段。
2. **判定类型**（可多标签）：个人观点 / 方法框架 / 产品技术 / 故事案例 / 路线图 / 元宣言 / 长文统一。
3. **定模板种类数**（不是节数）：
   - 短文 &lt;1500 字 → **2–3 种**（通常 T00 + 一种正文卡 + T08）
   - 中文 1500–3500 → **3–4 种**
   - 长文 &gt;3500 → **4–5 种**，同模板可复用于多节
4. **映射语义 → 模板**（见 semanticTriggers）；普通段落留在 T00 内或 neutral 流式正文，**不要每节一张卡**。
5. **定配色主题**（warm / cool-neutral / morandi-soft 等），全篇色族 **≤4**；仅对需要多彩的槽 swap，其余 defaultBindings。
6. **输出前自检**：深底卡是否过多、是否海报化、T02 是否仅一张。

### 渲染前简要说明（给用户）

用 3–5 行说明决策即可，例如：

```
编排方案：中等长度观点+产品混合文
模板：T00 开篇 · T01×2（痛点/问题）· T03（四路径）· T04（架构）· T08 结语
配色：暖中性主调（neutral+parchment）；T03 用 rose/parchment/sage/charcoal；T04 深 charcoal + sage 点缀
```

用户若只说「排版这篇 MD」，即视为同意该方案。

## 权威文件

| 文件 | 用途 |
|------|------|
| [orchestration.md](orchestration.md) | 自主编排细则 |
| [layout-templates.md](layout-templates.md) | 模板目录、槽位 |
| `data/wechat-layout-orchestration.json` | 决策 JSON |
| `data/wechat-layout-templates.json` | defaultBindings |
| `data/wechat-layout-tokens.json` | 圆角 **r12（12px）** / 间距 / 内嵌规范 |
| `../wechat-safe-colors/SKILL.md` | 配色层 |

### 执行顺序

1. 执行 **自主编排**（上节）。
2. 读 `defaultBindings`；按 colorTheme 决定是否 swapSlots。
3. 解析 Token → HEX + 方案 N/W/B/C（交给 wechat-safe-colors）。
4. 输出 `#copy-target` + 复制按钮。

**圆角：** 全篇统一 `radius.card/inner/image/code = 12px`（别名 **r12**），仅 pill 980px 例外；禁止 4/6/8/10/18px 混用。

## 模板速查

| ID | 名称 | 语义触发 | 配色模式 |
|----|------|----------|----------|
| T00 | 开篇杂志 | 始终用于文首 | safe-default |
| T01 | 笔记 | 痛点、经历、引述 | 可换族 |
| T02 | 山水理念 | 分层/表格/东方 calm | **builtin** |
| T03 | 对比路径 | 并列 A/B/C/D、路径 | 四槽可换 |
| T04 | 架构极客 | Layer、数据流、模块 | mixed |
| T05 | 故事 | 案例、叙事 | 可换族 |
| T06 | 元测试 | 清单、自检、inventory | 可换族 |
| T07 | 路线图 | MVP、阶段、计划 | safe-default |
| T08 | 结语 | 文尾、金句 | safe-default |
| T99 | 页脚 | 日期、声明 | safe-default |
| L01 | 中性长文 | 深度长文 / 单卡或 Part1 | safe-default · r12 |
| L02 | 羊皮纸长文 | Part2 收尾 / 双长卡 | parchment · r12 |

## 用户可覆盖（可选）

用户指定时 **覆盖** 自主判断，未提及的仍由 Agent 补全。

```
排版 @article.md
模板：只要 T01 + T08（其余你看着办）  ← 部分覆盖
配色：全篇 morandi                    ← 全量覆盖
```

完全指定时按用户清单执行，不再改模板种类。

## 配色解析规则

1. Token：`{family}.base` | `{family}.scale.*` | `neutral.surface` | `textScheme.*`
2. 浅底 → **N**（莫兰迪浅 → **B**）；深底 → **W**（莫兰迪深 → **C**）
3. T02 → `builtinPalette`；边框 = 同族 `.border`

详见 [../wechat-safe-colors/SKILL.md](../wechat-safe-colors/SKILL.md)。

## 禁止

- 海报化（每 H2 一种新模板/新色族）
- 粘贴版大面积高饱和色
- 用户未问时反复确认模板清单
- 把「选颜色」当「选模板」
- 混用 4/6/8/10/18px 圆角（统一 12px）
- `#FFFFFF` 纯白底/白边、rgba 阴影、双图并排 inline-block

## 延伸阅读

- [orchestration.md](orchestration.md) · [layout-templates.md](layout-templates.md)
- 配色层 → [../wechat-safe-colors/SKILL.md](../wechat-safe-colors/SKILL.md)
