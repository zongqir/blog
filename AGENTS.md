# Repository Guidelines（仓库指南）

## 项目结构与模块组织
本仓库是一个基于 Jekyll 的 GitHub Pages 博客。

- `_posts/`：博客文章，文件名格式为 `YYYY-MM-DD-slug.md`。
- `_layouts/`：页面布局模板（如 `default.html`、`post.html`）。
- `_includes/`：可复用的 Liquid 片段（如文章列表渲染）。
- `assets/css/`、`assets/js/`：主题样式与前端脚本。
- `.github/workflows/pages.yml`：构建并部署到 `gh-pages` 的工作流。
- `scripts/new-post.ps1`：PowerShell 发文脚手架。
- 根页面：`index.md`、`archive.md`、`tags.md`、`about.md`、`404.md`。

## 构建、测试与本地开发命令
在仓库根目录执行：

```bash
bundle install
bundle exec jekyll serve
bundle exec jekyll build
```

- `jekyll serve`：本地预览（`http://127.0.0.1:4000`）。
- `jekyll build`：生成生产构建到 `_site/`。

创建新文章（PowerShell）：

```powershell
.\scripts\new-post.ps1 -Title "我的文章" -Description "摘要" -Tags 架构设计,SaaS化解读
```

## 编码风格与命名规范
- Markdown、HTML、CSS、脚本统一使用 UTF-8。
- 保持与现有文件一致的缩进风格（HTML/CSS/Liquid 使用 2 空格）。
- 面向站点展示的文案优先中文，表达简洁直接。
- 文章 frontmatter 固定使用：`title`、`description`、`date`、`updated`、`tags`。

## 博客写作补充约束
- 当任务涉及博客选题、提纲、初稿、改写、润色、复盘、发布时，默认先判断该用哪个 blog skill，不再把详细执行规则长期堆在 `AGENTS.md` 里。
- 博客相关总原则只保留不伤文的底线：真实性、可发布性、承诺与正文一致、不要脑补、不要用单一模板硬套所有文章。
- 如与本文件其他规则冲突，优先级顺序为：
  1. 真实性与安全性
  2. 可发布性
  3. 对应 blog skill 的明确约束
  4. 本文件其余通用写作规则

## 博客协作统一执行口径
博客相关规则默认按 skill 分工执行：

- 结构、大纲、标题推进：`skills/blog-outline-doctor/SKILL.md`
- 内容写透度与关键段落补写：`skills/blog-depth-reviewer/SKILL.md`
- 文风、表达、删改边界：`skills/blog-writing-style/SKILL.md`
- 文章类型与适用质量尺子：`skills/blog-article-fit-checker/SKILL.md`
- 总检与问题分诊：`skills/blog-quality-gate/SKILL.md`
- SEO、frontmatter、标签、专题、首页聚合：`skills/blog-seo-governor/SKILL.md`
- 写作流程、发布门禁、页面核验：`skills/blog-release-gate/SKILL.md`

这里只保留三条总原则：

1. 目标不是生成标准博客，而是把作者真实想法整理成可发布的文章。
2. 先判断问题属于结构、写透度、表达、类型错配、事实风险、SEO 或发布门禁中的哪一类，再调用对应 skill，不要所有问题都堆到一个地方解决。
3. 当用户对文章给出新批评时，先修当前文章，再把可复用约束沉淀到对应 skill，而不是继续把 `AGENTS.md` 写成一份越来越长的博客总手册。
## 决策优先级与冲突处理
当规则冲突或目标冲突时，按以下顺序决策（从高到低）：

1. 真实性与安全性：不得伪造数据、误导读者或引入高风险改动。
2. 可发布性：页面可构建、可渲染、关键路径不报错。
3. 内容可读性：信息结构清晰、结论可验证、读者可执行。
4. 一致性：遵循既有信息架构、文案口径、视觉 token。
5. 美观度：在不破坏前四项前提下优化视觉表现。

执行约束：
- 不以“视觉好看”为理由破坏内容真实性。
- 不以“快速上线”为理由跳过构建与发布门禁。
- 不以“炫技动画”为理由损害性能与可读性。

## 博客写作 SOP（从选题到发布）
- 写作流程、阶段判断、发布前顺序与门禁，统一按 `skills/blog-release-gate/SKILL.md` 执行。
- 博客任务的最小总要求只保留三条：
  1. 开头 200 字内说清问题和重要性。
  2. 正文兑现开头承诺，不要前后脱节。
  3. 不拿单一模板要求所有文章；是否需要方案、落地、结果、框架，按 `skills/blog-article-fit-checker/SKILL.md` 判断。

## Frontmatter 元数据规范（必填 + 可选）
- frontmatter、标签、专题、聚合位与相关文章规则，统一按 `skills/blog-seo-governor/SKILL.md` 执行。

## 自动标签与自动运营字段规则（写作时自动完成）
- 自动标签、专题归类和运营字段补齐，统一按 `skills/blog-seo-governor/SKILL.md` 执行。

## 首页运营规则（元数据驱动）
- 首页聚合、运营字段和 SEO 分发入口的视觉约束，统一按 `skills/blog-seo-governor/SKILL.md` 执行。

## 发布门禁清单（发布前必须通过）
- 发布门禁、页面核验和上线确认，统一按 `skills/blog-release-gate/SKILL.md` 执行。



## 测试与验证指南
本仓库无单元测试框架，采用构建与页面核验：

1. 本地执行 `bundle exec jekyll build`，确保构建通过。
2. 抽查关键页面：`/`、`/archive/`、`/tags/`、`/about/`。
3. 更完整的发布核验、页面检查和上线确认按 `skills/blog-release-gate/SKILL.md` 执行。

## 提交与 Pull Request 规范
- 提交信息遵循 Conventional Commits，例如：
  - `feat(theme): 重构为暗色阅读优先主题`
  - `fix(ci): ...`
  - `content(profile): 更新关于页与标签体系`
- 每次提交聚焦单一主题（主题样式、内容、CI、脚本分开提交）。
- PR 建议包含：
  - 变更内容与动机。
  - 受影响的页面或文件路径。
  - 涉及 UI 时附截图。
  - 本地构建或 CI 通过说明。

## Git 自动提交策略
- 完成代码修改后，默认直接执行提交，不再二次询问。
- 提交格式使用 Conventional Commits。
- 允许执行：`git add`、`git commit`。
- 禁止执行：`git reset --hard`、`git checkout --`、`git revert`（除非用户明确要求）。
- 若工作区存在与当前任务无关的改动，不要回滚，跳过并只提交本次相关文件。
