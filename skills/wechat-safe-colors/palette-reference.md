# WeChat-Safe 色板参考手册

> Token 源：`data/wechat-safe-palette.json` v0.5

## 1. 中性画布

| Token | HEX | 用途 |
|-------|-----|------|
| canvas | `#F5F5F5` | 文章外层底 |
| surface | `#FAFAFA` | 中性卡片（开篇/07/08） |
| surfaceGray | `#EEEEEE` | 对比外框、页脚 |
| border | `#D1D1D6` | 中性分隔线 |
| textPrimary | `#383838` | 浅底主字（= N-L1） |
| textSecondary | `#666666` | 浅底次要（= N-L3） |

## 2. 色系阶梯（50 → 500）

边框规则：**取同族 scale 400**，若无 400 则取比 base 深一档。

### 羊皮纸 parchment

| 阶 | HEX |
|----|-----|
| 50 | `#FAF6EC` |
| 100 | `#F4ECD7` |
| 200 | `#EDE4CF` |
| 300 | `#E5D9BC` |
| 400 | `#D9CEB0` (border) |
| 500 | `#D4C4A8` |

### 尘粉 rose

| 阶 | HEX |
|----|-----|
| 50 | `#F0E4E4` |
| 100 | `#E8D5D5` |
| 200 | `#CFB7B7` |
| 300 | `#D9C4C4` |
| 400 | `#B8A0A0` (border) |
| 500 | `#A89090` |

### 鼠尾草 sage

| 阶 | HEX |
|----|-----|
| 50 | `#E8EDD8` |
| 100 | `#D4DEB8` |
| 200 | `#BAC895` |
| 300 | `#C5D0A8` |
| 400 | `#9FA882` (border) |
| 500 | `#8A9470` |

### 薰衣草 lavender

| 阶 | HEX |
|----|-----|
| 50 | `#E4DFEC` |
| 100 | `#D8D2E4` |
| 200 | `#C8C0D4` |
| 300 | `#B8B0C8` |
| 400 | `#B0A8C4` (border) |
| 500 | `#9890AD` |

### 暖灰 warmNeutral

| 阶 | HEX | 字色 |
|----|-----|------|
| 50 | `#F0EEEA` | N |
| 100 | `#E8E4DE` | N |
| 200 | `#D8D4CC` | N |
| 300 | `#5C5348` | **W** |
| 400 | `#44403C` | **W** |

### 炭灰 charcoal

| 阶 | HEX | 字色 |
|----|-----|------|
| 100 | `#525252` | W |
| 200 | `#444444` | W |
| 300 | `#383838` | W |
| 400 | `#2D2D2D` | W |
| 500 | `#161618` | W |

### 莫兰迪蓝 morandiBlue（浅）

| 阶 | HEX | 字色 |
|----|-----|------|
| 50 | `#EEF1F4` | N |
| 100 | `#D4DCE3` | N / B |
| 200 | `#B8C4CC` | N / B |
| 300 | `#A8B8C4` | N / B |
| 400 | `#8A9AA8` (border) | N / B |
| 500 | `#738291` | B |

### 莫兰迪深蓝 morandiBlue scaleDark

| 阶 | HEX | 字色 |
|----|-----|------|
| 100 | `#6B7B8A` | W / C |
| 200 | `#526872` | W / C |
| 300 | `#3D4F5C` | W / C |
| 400 | `#2F3E48` | W / C |
| 500 | `#243038` | C |

## 3. Bridge 过渡色（渐变底 fallback）

| 名称 | HEX | 渐变示例 |
|------|-----|----------|
| parchmentRose | `#DFD5C8` | 羊皮→尘粉 |
| roseSage | `#D4C9AE` | 尘粉→鼠尾草 |
| sageParchment | `#D8DFC8` | 鼠尾草→羊皮 |
| morandiBlueParchment | `#C8D4DC` | 莫兰迪↔羊皮 |

## 4. 四级字色方案

| ID | 场景 | L1 | L2 | L3 | L4 |
|----|------|----|----|----|-----|
| N | 浅底默认 | `#383838` | `#525252` | `#666666` | `#888888` |
| B | 浅底·莫兰迪 | `#2F3840` | `#4A5258` | `#5C6570` | `#7A8490` |
| W | 深底默认 | `#F4ECD7` | `#EDE4CF` | `#D4DCE3` | `#B8C4CC` |
| C | 深底·莫兰迪 | `#F0F2F4` | `#D4DCE3` | `#A8B8C4` | `#8A9AA8` |

**选用建议：**

- 暖色系卡（羊皮/尘粉/鼠尾草/薰衣草）→ **N**
- 莫兰迪浅卡要整体雾蓝感 → **B**
- 炭灰/暖褐深卡 → **W**
- 莫兰迪深卡要冷净感 → **C**；要跨族暖对比 → **W**

## 5. 禁止与降级

**粘贴版禁止作大面积底：**

`#2563eb` `#d97706` `#059669` `#7c3aed` 及 Tailwind 500+ 饱和色

**降级规则：**

| 特性 | 处理 |
|------|------|
| 渐变分隔线 | → solid，取 border Token |
| 渐变字 | 保留 + `color` fallback |
| 渐变底 | 保留 + `background-color` fallback |
| `rgba()` | → 不透明 HEX |
| box-shadow | 仅深卡 Layer 可选 |
| border-radius | 全篇统一 12px（见 wxlayout-wechat-paste tokens） |

## 6. 高亮色 H1 / H2

| Token | 名称 | base | deep | onDark | tint | 配对主题 |
|-------|------|------|------|--------|------|----------|
| `highlights.warm` | H1 暖琥珀 | `#B8A078` | `#6E6248` | `#E5D9BC` | `#F0E8D8` | warm · warm-mixed · neutral-warm-accent · dark-accent |
| `highlights.cool` | H2 板岩青 | `#8AADA4` | `#4A635C` | `#A8C4BC` | `#E4EDEA` | cool-neutral · morandi-soft |

### 搭配速查

| 底色族 | 推荐高亮 | tag 字色 | 左竖线 |
|--------|----------|----------|--------|
| neutral / parchment | H1 | `#6E6248` | `#B8A078` |
| morandiBlue 浅 | H2 | `#4A635C` | `#8AADA4` |
| charcoal 深 | H1 或 H2 | `#E5D9BC` / `#A8C4BC` | base 色 |

### 与 sage 的关系

- **sage.base** `#BAC895`：仍用于 T03 色块、T07 tag 默认
- **H1 暖琥珀**：字/线高亮，偏黄暖
- **H2 板岩青**：morandi / 架构 accent，替代 legacy `#64d2ff`
