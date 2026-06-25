---
name: wechat-safe-colors
version: 0.5
disable-model-invocation: true
description: >-
  WeChat-Safe color palette layer for 公众号排版. Provides low-saturation
  families, 50–500 scales, four-level text schemes N/B/W/C, highlight colors
  H1/H2, and mp-darkmode rules. Use with wxlayout-wechat-paste for template
  + color rendering, or when user asks 安全色、配色、字色阶梯、
  WeChat palette, dark-mode safe colors, or 公众号颜色 without picking templates.
---

# WeChat-Safe 配色层

本 Skill 只管 **颜色 Token**，不管卡片结构。排版请用 **wxlayout-wechat-paste**（模板 + 本配色层）。

## 两层关系

```
模板 (T00-T08)  →  定义配色槽 surface / blockA / accent …
                        ↓ 绑定
Safe Palette    →  解析为 HEX + 方案 N/W/B/C
```

## 权威数据源

| 资源 | 路径（相对本 Skill 目录） |
|------|------|
| Token JSON | `data/wechat-safe-palette.json` |
| 完整色表 | [palette-reference.md](palette-reference.md) |
| 模板槽位 | [../wxlayout-wechat-paste/layout-templates.md](../wxlayout-wechat-paste/layout-templates.md) |

## 核心原则（实测归纳 P1–P7）

1. **低饱和、中明度** 实色作大面积底，避免高饱和色（Tailwind 500+）作卡片底
2. 浅底 → 字色方案 **N**（莫兰迪浅底 → **B**）
3. 深底 → 字色方案 **W**（莫兰迪深底 → **C**）
4. 边框 = 同族加深（`.border` 或 scale.400）
5. 渐变保留 + `background-color` / `color` fallback 必留
6. 不绕过 mp-darkmode（白底 + `color-scheme: light` 对公众号无效）

## 四级字色

| 方案 | 场景 | L1 标题 | L2 正文 | L3 次要 | L4 注释 |
|------|------|---------|---------|---------|---------|
| N | 浅底默认 | #383838 | #525252 | #666666 | #888888 |
| B | 浅底·莫兰迪 | #2F3840 | #4A5258 | #5C6570 | #7A8490 |
| W | 深底默认 | #F4ECD7 | #EDE4CF | #D4DCE3 | #B8C4CC |
| C | 深底·莫兰迪 | #F0F2F4 | #D4DCE3 | #A8B8C4 | #8A9AA8 |

## 色族（换槽时用）

parchment · rose · sage · lavender · warmNeutral · charcoal · morandiBlue · bridge · neutral

## 高亮色 H1 / H2

| ID | 名称 | 浅底字/线 | 深底字/线 | 默认配对主题 |
|----|------|-----------|-----------|--------------|
| **H1 暖琥珀** | `highlights.warm` | `#6E6248` deep · `#B8A078` base | `#E5D9BC` | warm · warm-mixed · neutral-warm-accent |
| **H2 板岩青** | `highlights.cool` | `#4A635C` deep · `#8AADA4` base | `#A8C4BC` | cool-neutral · morandi-soft |

**用法：** 阶段 tag、左 `border-left`、`<strong>` 点缀；**禁止**作大面积底。
**自动：** `highlightPairing.autoByTheme` 按配色主题选 H1 或 H2。

详见 [palette-reference.md](palette-reference.md) §7。

## 解析 Token 路径

`{family}.base` · `{family}.scale.{50|100|200|300|400|500}` · `{family}.border` · `neutral.surface` · `textScheme.onLightNeutral`

## 例外

- **T02 山水**：builtin 青绿，不经过本清单主色
- **T04 点缀**：优先 `highlights.cool.base`；legacy `#64d2ff` 已废弃，新文用板岩青

## 工作流（仅配色）

1. 已知模板槽位名（如 T03 blockA）
2. 用户指定族 → 查 `data/wechat-safe-palette.json` scale
3. 按槽位明度选 N/W/B/C
4. 写 inline style

## 延伸阅读

- 模板与槽位 → [../wxlayout-wechat-paste/SKILL.md](../wxlayout-wechat-paste/SKILL.md)
- 完整色表与测试编号 → [palette-reference.md](palette-reference.md)
