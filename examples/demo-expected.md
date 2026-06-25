# Demo 预期输出说明

> 本文件不是手写的 HTML，而是说明：把 `demo.md` 喂给 `@wxlayout-wechat-paste` 后，应该得到什么样的输出。

## 预期编排方案

```
编排方案：
- 类型：个人观点 · 约 1100 字 · 4 节
- 模板：T00 → T01×2 → T08（共 3 种）
- 配色：warm — neutral 正文 + parchment 笔记
- 未使用：T04（无技术段）、T03（无并列路径）、T07（无路线图）
```

## 模板落点

| 文章段落 | 模板 | 说明 |
|----------|------|------|
| 标题 + 钩子首段 | **T00 开篇杂志** | 渐变标题 + 右对齐导语「内容和排版，我把它拆开了」 |
| 「天下苦公众号排版久矣」段 | **T01 笔记** | parchment 横线纸底，痛点叙事 |
| 「问题出在哪」段 | **T01 笔记**（复用） | 同模板，不另起新种类 |
| 「内容和排版，本来就不该是一回事」段 | **T00 内正文** + table | 不独立成卡，table 在 T00 内呈现 |
| 金句「内容 ≠ 排版」 | T01 sticky-summary 或 T08 quoteBlock | 居中强调 |
| 「写在最后」 | **T08 结语** | neutral 壳 + parchment 金句块 |

## 配色绑定

| 槽位 | Token | HEX |
|------|-------|-----|
| T00 surface | `neutral.surface` | `#FAFAFA` |
| T00 text | 方案 N | `#383838` / `#525252` / `#666666` |
| T01 surface | `parchment.base` | `#F4ECD7` |
| T01 line | `parchment.scale.300` | `#E5D9BC` |
| T01 border | `parchment.border` | `#D9CEB0` |
| T08 quoteBlock | `parchment.base` | `#F4ECD7` |
| 全篇圆角 | r12 | 12px |

## 验证清单

- [ ] 浅色模式粘贴到公众号编辑器，4 段抽检样式正确
- [ ] 切深色模式，parchment 底不发脏，字色可读
- [ ] table 在深色模式下边框层次保持
- [ ] 圆角全篇 12px，无混用
- [ ] 无 `#FFFFFF` 纯白底、无 rgba 阴影

## 怎么跑

在 Cursor 里：

```
@wxlayout-wechat-paste 排版 @examples/demo.md
```

把生成的 HTML 保存为 `examples/demo-expected.html`，浏览器打开对照本文档的预期。
