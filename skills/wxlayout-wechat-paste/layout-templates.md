# 卡片模板参考（配色槽分离）

> 结构源：`data/wechat-layout-templates.json` · 配色源：`../wechat-safe-colors/data/wechat-safe-palette.json`

## 配色模式说明

| 模式 | 含义 | 模板 |
|------|------|------|
| **safe-default** | 槽位已绑 Safe 族，默认即可粘贴 | T00, T07, T08, T99 |
| **safe-swappable** | 结构固定，指定槽可换 Safe 族 | T01, T03, T05, T06 |
| **builtin** | 整卡自有配色，不拆 Safe 槽 | T02 |
| **mixed** | 深壳来自 Safe，点缀色可保留 | T04 |

---

## T00 · 开篇杂志

**结构：** 标签行 → 渐变大标题 → 右对齐导语 → 分隔线 → 正文 → 居中引用带 → 底栏品牌字

**配色槽：**

| 槽位 | 默认 Token | 可换 |
|------|------------|------|
| surface | `neutral.surface` | — |
| border / rule | `neutral.border` | — |
| 正文 | 方案 **N** | — |
| 标题渐变 accent | 灰阶 + sage 点缀 | accent 族 |

---

## T01 · 笔记

**结构：** 横线纸底 → 顶栏（图标+章节号+标题）→ 左留白正文 → 底部便签摘要块

**配色槽：**

| 槽位 | 默认 Token | 可换族 |
|------|------------|--------|
| surface | `parchment.base` | parchment, rose, sage, lavender, morandiBlue, bridge |
| surfaceMuted | `parchment.scale.200` | 同上族内 scale |
| line（横线） | `parchment.scale.300` | 同上 |
| border | `parchment.border` | 同上 |
| text | 方案 **N** | 浅莫兰迪底时 **B** |

---

## T02 · 山水理念 · builtin

**结构：** 青绿渐变底 → 头部分割 → 左竖线多行分条 → 居中金句框

**不拆 Safe 槽。** 使用内置青绿体系：

- 底 `#f2f5f0` · 边 `#b8c4b8` · 标题 `#2c3a32` · 正文 `#44403c` · 点缀 `#8b7355`

若全文都要 Safe 统一，**勿用 T02**；改用 T01 或 T07。

---

## T03 · 对比路径 · 四色块

**结构：** 灰底容器 → 子块 A/B/C（浅底并列）→ 子块 D（深底高亮）→ 收尾语

**配色槽：**

| 槽位 | 默认 Token | 可换族 |
|------|------------|--------|
| container | `neutral.surfaceGray` | neutral |
| blockA | `rose.base` | rose, lavender, morandiBlue… |
| blockB | `parchment.base` | parchment, bridge… |
| blockC | `sage.base` | sage, morandiBlue… |
| blockD | `charcoal.scale.300` | charcoal, morandiBlue.scaleDark |
| 浅块字 | 方案 **N** | — |
| 深块字 | 方案 **W** | 莫兰迪深块 **C** |

**换色示例：** 四块全改莫兰迪：`100/200/300` + 深 `scaleDark.300`，仍保持 A/B/C/D **结构**。

---

## T04 · 架构极客 · mixed

**结构：** 深渐变外壳 → L01/L03 外凸 Layer → L02/L04 内凹 Layer → 代码流 strip

**配色槽：**

| 槽位 | 默认 | 可换 |
|------|------|------|
| shell | `charcoal.scale.500` (#161618) | charcoal, morandiBlue.scaleDark.300 |
| layerRaised | `#2a2a2c` | 同深族 |
| layerInset | `#18181a` | 同深族 |
| 正文 | 方案 **W** | **C** on morandi |
| accent 点缀 | `highlights.cool.base`（板岩青） | sage；legacy `#64d2ff` 已废弃 |

---

## T05 · 故事

**结构：** 大圆角壳 → 头 → 正文 → 内嵌 callout → 居中收束

**默认 Safe 绑定：** morandiBlue 50/100/200 + 方案 **B**。

可换 `surface/callout` 族：morandiBlue, parchment, lavender。

---

## T06 · 元测试深块

**结构：** 深壳 → 居中大字 → 斑马 list → 底 quote

**配色槽：**

| 槽位 | 默认 | 可换 |
|------|------|------|
| shell | `charcoal.scale.300` | charcoal, morandiDark |
| text | 方案 **W** | **C** |
| listEmphasis 轮换 | rose / parchment / sage | 任意 Safe 族 base |

---

## T07 · 路线图

**结构：** 中性壳 → 左线时间轴 → 阶段 tag → 底 parchment 展望块

**配色槽：**

| 槽位 | 默认 | 可换 |
|------|------|------|
| surface | `neutral.surface` | — |
| tagPrimary | `sage.base` | sage, morandiBlue, rose |
| bottomBlock | `parchment.base` | parchment, morandiBlue, sage |

---

## T08 · 结语

**结构：** 中性壳 → 正文 → 右对齐 lede → 居中 parchment 金句块

**配色槽：** `quoteBlock` 默认 parchment，可换 rose / morandiBlue / sage。

---

## T99 · 页脚灰栏

`neutral.surfaceGray` + 方案 N。与 T08 区分，避免视觉连成一片。

---

## 典型文章组合

| 文章类型 | 模板组合 |
|----------|----------|
| 观点长文 | T00 + T01×N + T08 |
| 方法论 | T00 + T02 + T03 + T08 |
| 产品/技术 | T00 + T04 + T07 + T08 |
| 实验/自述 | T00 + T01 + T06 + T08 |
| 长文深度阅读 | L01 + L02 |

多数情况 **2–3 种模板循环** 即可；配色用各模板 `defaultBindings`，除非用户显式换槽。

---

## 内嵌组件 · 代码块 & 图片槽

### 代码块 · validated

| 变体 | 要点 |
|------|------|
| 浅底短代码 | parchment 底 + monospace + `white-space: pre-wrap` |
| 深底纵向滚动 | `max-height` + `overflow-y: auto` + `-webkit-overflow-scrolling: touch` |
| 横向滚动 | 外层 `overflow-x: auto`，内层 `white-space: pre` |
| 架构条 | charcoal 底 + 左 accent 细线（用 H2 板岩青，不用 `#64d2ff`） |

### 图片槽 · image-slot

**禁止：** `#FFFFFF` 纯白底/白边、`box-shadow`、rgba 半透明、`inline-block` 双图并排。

**必须：**

1. **外层 frame** + **内层 slot**（`min-height: 160–200px` + Safe 底色）
2. 边框用 Safe 族加深（parchment `#D9CEB0`、neutral `#D1D1D6`、morandi `#B8C4CC`）
3. 字色用 N 或 B 四级（`#383838` / `#666666` / `#888888` 或 morandi 蓝灰）
4. **复制时** 移除 `<img>`，槽内替换为 `<p>点击插入图片</p>`，保留 slot 的 `min-height` 与底色，避免粘贴后换行塌陷

**推荐包装（5 种）：**

| ID | 风格 | 底色族 |
|----|------|--------|
| E1 | 基础槽 + caption 灰条 | warmNeutral / neutral |
| E2 | 羊皮纸双层浮框 | parchment |
| E3 | 画框 + 内描边 | parchment |
| E4 | 全宽 + morandi caption | morandiBlue |
| E5 | 拍立得（parchment 替白边） | parchment.50 / .200 |

---

## L01 · 中性长文卡

**结构：** 单张外卡 → 开篇 → `section-divider` × N → 内嵌 parchment / gray / code / image-slot

| Token | 值 |
|-------|-----|
| `radius.card` | 12px · `#FAFAFA` · border `#E5E5EA` |
| `radius.inner` | 12px · 所有内嵌块 |
| 章分隔 | margin/padding-top 28px · border-top 1px `#D1D1D6` |

---

## L02 · 羊皮纸长文卡

**结构：** 羊皮纸外卡 → 章分隔 → 内块 / 金句 / 页脚

| Token | 值 |
|-------|-----|
| surface | `#F4ECD7` · radius 12px · border `#D9CEB0` |
| divider | `#E5D9BC` |

---

## 全站圆角 · layout-tokens

> `data/wechat-layout-tokens.json`

| Token | 值 | 用于 |
|-------|-----|------|
| `radius.card` | **12px** | 外卡 L/T 系列 |
| `radius.inner` | **12px** | 内嵌块、代码、图片槽 |
| `radius.image` | **12px** | 槽内 img |
| `radius.code` | **12px** | 代码框 |
| `radius.pill` | 980px | 仅标签 |
| alias | **r12** | Agent 说明 / 页脚标注 |

**规则：** 全篇统一 12px；禁止 4/6/8/10/18px 混用 · `#FFFFFF` · rgba 阴影 · 双图并排
