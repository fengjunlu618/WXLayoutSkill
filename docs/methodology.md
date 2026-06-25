# 方法论

> 本文档解释这套 Skill 背后的设计思想，帮助贡献者理解「为什么这么设计」而非「怎么用」。

## 1. 核心命题：内容 ≠ 排版

公众号排版的根本问题，是**把内容和排版绑死在了同一条链路上**。

写 Markdown 时想「这段右对齐做小字脚注」——MD 语法表达不了。为了排版去扩展 MD 语法？内容文件就脏了，换主题、换平台都麻烦。AI 一次性直出 HTML？改一个字号要重新生成，CSS 在微信里兼容性是玄学。

我们借鉴建筑行业的做法：**方案设计**和**施工图**是两套图纸。方案解决「好不好用、好不好看」；施工图解决「梁要多厚、管怎么走」。分层，才能各自迭代。

公众号也该如此：

| 层级 | 管什么 | 用什么 |
|------|--------|--------|
| **内容层** | 写什么、结构怎样 | Markdown |
| **排版层** | 怎么排、哪里用卡片 | LayoutDoc（AI + Skill） |
| **渲染层** | 长什么样 | Design Token 主题 |
| **导出层** | 能不能粘贴进微信 | 内联 HTML + 兼容清洗 |

**Markdown 只管内容。排版是另一套决策。** 哪一段做金句居中？哪里用对比卡片？章节之间用什么分隔？这些不该塞进 MD 语法，而该由独立的「排版文档」描述。

## 2. LayoutDoc：排版的中间表示

排版决策用一个 JSON 结构描述，叫 **LayoutDoc**。它是「内容」和「视觉」之间的中间层：

```
Content (MD) → ContentAST
   → [Layout Skill]   → LayoutDoc（结构/组件选型）
   → [Theme Skill]    → LayoutDoc + ThemeTokens
   → [Enhance Skill]  → 局部节点替换（可选）
   → Renderer         → 微信兼容 HTML
```

**关键约束：**

- AI 只写 LayoutDoc，不碰最终 HTML
- Renderer 是**确定性**的：相同 LayoutDoc + ThemeTokens → 相同 HTML
- 调参数**不触发** AI，只重渲染，保证快速可预测

在本 Skill 包里，LayoutDoc 的角色由 `wxlayout-wechat-paste` 的编排决策承担——Agent 读完 MD 后，按 `orchestration.json` 决定模板组合与配色绑定，再渲染成 HTML。

## 3. 自主编排：Agent 读完文章自己决定

用户只说「排版这篇 MD」时，Agent **必须自行判断**，不反问「要用哪张卡」。

### 决策流程

1. **扫描 MD**：字数、H2/H3 数量、table、引用、并列结构、阶段词
2. **判定文章类型**：个人观点 / 方法框架 / 产品技术 / 故事案例 / 路线图 / 元宣言 / 长文统一
3. **定模板种类数**（按长度）：
   - 短文 &lt;1500 字 → 2–3 种
   - 中文 1500–3500 → 3–4 种
   - 长文 &gt;3500 → 4–5 种
4. **映射语义 → 模板**：blockquote → T01，并列 A/B/C/D → T03，Layer/数据流 → T04，MVP/阶段 → T07
5. **定配色主题**，全篇色族 ≤4
6. **自检**：深底卡是否过多、是否海报化、T02 是否仅一张

### 核心原则

**卡片是「章节级强调」，不是段落装饰。** 一节里只有 1 个核心论点才独立成卡。普通段落留在 T00 内或 neutral 流式正文，不要每节一张卡。

### 反模式（禁止）

- 每个 H2 换一种模板 → 海报化
- 短于 1500 字用 5+ 模板种类
- 连续 3 张深底卡
- T02 与 T04 同篇且相邻（气质冲突）
- 全篇每节不同色族（花）
- 混用 4/6/8/10/18px 圆角（统一 12px）

## 4. 微信安全色：为什么不直接用 Tailwind

公众号编辑器有几个「坑」：

1. **不支持外链 CSS**，所有样式必须 inline
2. **深色模式 remap** 会把高饱和色发脏——`color-scheme: light` 绕不过去
3. **`rgba()` 半透明**在深色模式下合成结果不可控
4. **标签白名单**有限，`div` 在部分环境会被 strip

实测发现：Tailwind 500+ 的高饱和蓝/琥珀/薄荷作卡片大面积底，在深色模式下会变成脏污色。

### 安全色七原则（P1–P7）

| # | 原则 | 说明 |
|---|------|------|
| P1 | 低饱和、中明度 | 避免 Tailwind 500+ 高饱和色作卡片大面积底 |
| P2 | 浅底深字 | 浅色彩底统一 `#383838` 正文，不用彩色字当正文 |
| P3 | 深底浅字 | 深底用 `#F4ECD7` / `#EDE4CF`，标签可用 `#BAC895` / `#CFB7B7` |
| P4 | 边框 = 底色加深 | 如 `#F4ECD7` → 边框 `#D9CEB0`，不用对比色描边 |
| P5 | 渐变可留、fallback 必留 | 标题渐变在浅色 OK；暗色失效时靠 `color` 降级 |
| P6 | 不绕过 remap | 白底画布 + `color-scheme: light` 对公众号无效；靠色板适配 |
| P7 | 层次靠底色区分 | 页脚 `#EEEEEE`、结语 `#FAFAFA`、金句 `#F4ECD7`，避免同色连成一页 |

详见 [why-safe-colors.md](why-safe-colors.md)。

## 5. 模板与配色两层分离

这是本 Skill 包最重要的架构决策：

```
模板 (T00-T08)  →  定义配色槽 surface / blockA / accent …
                        ↓ 绑定
Safe Palette    →  解析为 HEX + 方案 N/W/B/C
```

| 层 | 管什么 | 不管什么 |
|----|--------|----------|
| **模板** | 卡片结构、组件布局、阴影/横线/分栏 | 具体 HEX（除 builtin 模板） |
| **配色** | 各槽位用哪一族 Safe 色、四级字色 | 段落该用哪种模板 |

**好处：**

- 换配色不用动结构（`swappableSlots`）
- 换模板不用重选颜色（`defaultBindings`）
- 新主题 = 新的色族组合，不用写新模板

## 6. 渲染确定性

Renderer 是最后一道闸，职责：

1. **Visit**：遍历 LayoutDoc 节点
2. **Resolve**：Theme Engine 解析每个节点的 style
3. **Inline**：style 对象 → `style="..."` 字符串
4. **Sanitize**：标签白名单（section, p, span, strong, em, br, a）
5. **Degrade**：不兼容 CSS 替换（gradient→solid + fallback、rgba→HEX、radius clamp 12px）

**相同输入永远产出相同输出**——这是「参数调节不触发 AI」的前提，也是可迭代的基础。

## 7. 与现有方案的差异

| 方案 | 问题 | 本 Skill 包的做法 |
|------|------|-------------------|
| MD 实时预览 | MD 语法表达不了精细排版 | MD 只管内容，排版交给 LayoutDoc |
| 固定模板 | 精细控制为零 | 自主编排 + 可换槽 + 参数调节 |
| AI 直出 HTML | 不可迭代、CSS 兼容玄学 | AI 只写 LayoutDoc，Renderer 确定性渲染 + 安全色降级 |
| 海报式堆砌 | 阅读性差 | 卡片是章节级强调，反海报化 |

## 8. 扩展点

| 想扩展什么 | 怎么做 |
|-----------|--------|
| 新模板 | 在 `data/wechat-layout-templates.json` 加 TXX，附浅/深粘贴实测 |
| 新色族 | 在 `wechat-safe-colors/data/wechat-safe-palette.json` 加 family + scale |
| 新文章类型 | 在 `data/wechat-layout-orchestration.json` 的 `articleProfiles` 加 profile |
| 新高亮色 | 在 palette `highlights` 加 H3，配 `highlightPairing.autoByTheme` |
| 新渲染目标 | 实现 Renderer 接口（知乎、Notion 等） |
