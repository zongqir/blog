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

## 技术博客质量标准（写作沉淀）
目标：文章应帮助读者做出更好的技术决策，而不仅是“展示作者懂技术”。

### 七条质量标准
1. 问题定义清楚：交代业务场景、规模、约束、成功标准。
2. 结论可证伪：给出判断依据与选择条件，说明为何选 A 不选 B。
3. 过程可复现：提供关键输入、架构边界、核心实现与落地路径。
4. 权衡讲透：明确收益、成本、风险、维护负担与失败模式。
5. 边界明确：写清适用场景与不适用场景，避免“万能方案”叙事。
6. 结果可验证：尽量给出前后对比指标，至少给观察指标和验证方法。
7. 结构服务决策：优先采用“背景 -> 决策点 -> 方案 -> 权衡 -> 落地 -> 结果 -> 复盘”。

### 四个低质量信号
1. 术语密集但缺乏上下文与约束。
2. 只有成功案例，没有踩坑、回滚和失败复盘。
3. 只有代码片段，没有系统边界与链路影响说明。
4. 只有“最佳实践”结论，没有“为什么是这套实践”的推导过程。

### 发文前自检清单
1. 是否在开头 200 字内明确“问题是什么、为什么重要”。
2. 是否明确写出 trade-off，而不是只写优点。
3. 是否包含至少一个反例或不适用边界。
4. 是否给出可复用的检查清单、落地步骤或迁移顺序。
5. 是否提供验证方式（指标、日志、SLO、回滚点或验收口径）。
6. 是否避免空话和口号式表达，段落能对应具体工程动作。

## 测试与验证指南
本仓库无单元测试框架，采用构建与页面核验：

1. 本地执行 `bundle exec jekyll build`，确保构建通过。
2. 抽查关键页面：`/`、`/archive/`、`/tags/`、`/about/`。
3. 推送后确认 GitHub Actions 的 `Deploy blog to GitHub Pages` 任务成功。

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
