---
name: wxlayout-template-picker
version: 0.1
disable-model-invocation: true
description: >-
  Helps users visually pick WeChat layout templates (T00-T08, L01-L02) and
  WeChat-Safe color themes/families before rendering. Guides selection via
  the interactive picker page or a text checklist, then produces a
  LayoutRequest-style summary to feed into wxlayout-wechat-paste. Use when
  user asks 选模板、选配色、挑卡片、模板配色、template picker、
  which template、color theme chooser, or wants to preview options before
  排版.
---

# WXLayout · 模板与配色选择器

## 定位

本 Skill **不渲染 HTML**，只帮用户**选定模板和配色**，再把选择结果交给 `wxlayout-wechat-paste` 执行渲染。

适用场景：用户想先看看有哪些模板/色卡、各自长什么样、适合什么文章，再决定用哪一套——而不是直接甩给 Agent 自主编排。

## 依赖

- `wxlayout-wechat-paste` — 拿到选择结果后实际渲染
- `wechat-safe-colors` — 配色 Token 解析（通过 paste Skill 间接依赖）

## 两种使用方式

### 方式一：交互式索引页（推荐）

打开 `examples/template-color-picker.html`（用浏览器直接打开）：

- 左栏：12 张模板卡片（T00–T08 / L01 / L02），可勾选
- 左栏：配色主题、色族、字色方案 N/B/W/C
- 右栏：680px 实时预览，点模板卡即预览
- 底部：一键生成「复制说明」，把勾选结果转成给 Agent 的指令

用户在页面上选好后，把生成的指令粘贴到对话里：

```
排版 @article.md
模板：T00 + T01×2 + T03 + T08
配色：warm；T03 用 rose/parchment/sage/charcoal
```

然后 `@wxlayout-wechat-paste` 执行。

### 方式二：对话式选择（无浏览器时）

用户说「帮我选模板」时，Agent 按下面流程引导。

## 模板速查（给用户看）

| ID | 名称 | 适合 | 配色模式 |
|----|------|------|----------|
| T00 | 开篇杂志 | 文首标题+钩子，几乎所有文章都用 | safe-default |
| T01 | 笔记 | 痛点、经历、引述、第一人称叙事 | 可换族 |
| T02 | 山水理念 | 分层、东方 calm、哲学感（builtin 青绿） | builtin |
| T03 | 对比路径 | A/B/C/D 并列方案、路径对比、pros/cons | 四槽可换 |
| T04 | 架构极客 | Layer、数据流、模块、技术架构（深壳） | mixed |
| T05 | 故事 | 案例、叙事、「然后我发现」 | 可换族 |
| T06 | 元测试深块 | 清单、自检、inventory、本文即测试 | 可换族 |
| T07 | 路线图 | MVP、阶段、计划、时间轴 | safe-default |
| T08 | 结语 | 文尾、金句、CTA | safe-default |
| T99 | 页脚灰栏 | 日期、版权、相关链接 | safe-default |
| L01 | 中性长文卡 | 深度长文、少卡片、Part 1 | safe-default · r12 |
| L02 | 羊皮纸长文卡 | 长文 Part 2、收尾半篇 | parchment · r12 |

## 配色主题速查

| Theme | 气质 | 主族 | 适合文章 |
|-------|------|------|----------|
| warm | 暖中性 | neutral + parchment | 观点、随笔、方法论 |
| warm-mixed | 暖+对比 | neutral + parchment + T03 四色 | 有并列路径的方法文 |
| cool-neutral | 冷净 | neutral + morandiBlue | 产品、技术、架构 |
| morandi-soft | 雾蓝莫兰迪 | morandiBlue 50–100 | 故事、案例、温柔叙事 |
| neutral-warm-accent | 中性+暖点缀 | neutral + sage + parchment | 路线图、计划 |
| dark-accent | 深底强调 | charcoal + 三色轮换 | 元文章、清单、自检 |

## 字色方案速查

| 方案 | 场景 | L1 标题 | L2 正文 | L3 次要 | L4 注释 |
|------|------|---------|---------|---------|---------|
| N | 浅底默认（暖色系） | #383838 | #525252 | #666666 | #888888 |
| B | 浅底·莫兰迪 | #2F3840 | #4A5258 | #5C6570 | #7A8490 |
| W | 深底默认 | #F4ECD7 | #EDE4CF | #D4DCE3 | #B8C4CC |
| C | 深底·莫兰迪 | #F0F2F4 | #D4DCE3 | #A8B8C4 | #8A9AA8 |

## 选择流程（Agent 引导）

1. **问文章类型**：观点 / 方法 / 技术 / 故事 / 路线图 / 清单 / 长文？
2. **问长度档位**：<1500 短 / 1500–3500 中 / >3500 长
3. **按 articleProfiles 给默认组合**（见 `../wxlayout-wechat-paste/orchestration.md` §3）
4. **问是否要换色族**：默认走 defaultBindings，用户想换才换
5. **输出 LayoutRequest 摘要**：

```
你的选择：
- 模板：T00 + T01×2 + T03 + T08
- 配色：warm-mixed；T03 四块用 rose/parchment/sage/charcoal
- 字色：浅底 N，深底 W
- 圆角：r12（12px）

下一步：把这段贴给 @wxlayout-wechat-paste 排版 @你的文章.md
```

## 输出约束

- 本 Skill **不输出 HTML**，只输出选择摘要
- 摘要格式参照 `wxlayout-wechat-paste` 的「用户可覆盖」语法
- 若用户文章已贴在对话里，直接把摘要+文章一起转给 paste Skill，无需用户二次粘贴

## 延伸阅读

- 交互式选择页 → `examples/template-color-picker.html`
- 模板细节 → [../wxlayout-wechat-paste/layout-templates.md](../wxlayout-wechat-paste/layout-templates.md)
- 配色细节 → [../wechat-safe-colors/palette-reference.md](../wechat-safe-colors/palette-reference.md)
- 自主编排规则 → [../wxlayout-wechat-paste/orchestration.md](../wxlayout-wechat-paste/orchestration.md)
