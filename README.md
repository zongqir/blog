# Blog Starter (Cloudflare Pages + Jekyll)

This repository is fully prepared for a personal blog on Cloudflare Pages.
After setup, your only ongoing task is adding Markdown files in `_posts/`.

## What is already done

- GitHub Actions deploy workflow for Cloudflare Pages is included.
- Home and Archive lists sort by `updated` first, then `date` fallback.
- Post page shows both `date` and `updated`.
- Tags page is generated from frontmatter `tags`.
- RSS (`/feed.xml`), sitemap, and SEO tags are enabled.

## First publish

1. Create a Cloudflare Pages project and bind your production domain.
2. Add these GitHub repository secrets:
   `CLOUDFLARE_ACCOUNT_ID`
   `CLOUDFLARE_API_TOKEN`
3. Push to `main`. The workflow will build the site and deploy it to Cloudflare Pages.

## Ongoing writing workflow

Create files in `_posts/` with this filename pattern:

`YYYY-MM-DD-your-title.md`

Frontmatter template:

```yaml
---
title: 'Post title'
description: 'Short summary'
date: 2025-01-18 10:30:00 +0800
updated: 2025-01-18 10:30:00 +0800
tags:
  - notes
  - life
---
```

If you edit chronology, adjust `date` and/or `updated` directly.

## One-command post creation (PowerShell)

```powershell
.\scripts\new-post.ps1 -Title "My New Post" -Description "Quick summary" -Tags notes,dev
```

Optional explicit dates:

```powershell
.\scripts\new-post.ps1 -Title "Backfill" -Date "2023-08-12 10:00:00 +0800" -Updated "2024-12-01 09:00:00 +0800"
```

## Local preview (optional)

Prerequisite: Ruby + Bundler

```bash
bundle install
bundle exec jekyll serve
```

Open `http://127.0.0.1:4000`.

## Key files

- Site config: `_config.yml`
- Deploy workflow: `.github/workflows/pages.yml`
- Cloudflare config: `wrangler.jsonc`
- Main layout: `_layouts/default.html`
- Post layout: `_layouts/post.html`
- List renderer: `_includes/post-list.html`
- New post helper: `scripts/new-post.ps1`
