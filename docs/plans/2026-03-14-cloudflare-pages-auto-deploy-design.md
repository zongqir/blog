# Cloudflare Pages Auto Deploy Design

## Goal

Replace the existing GitHub Pages and Vercel deployment paths with a single deployment flow:

- author writes content in the repo
- pushes to `main`
- GitHub Actions builds the Jekyll site
- GitHub Actions deploys `_site` to the Cloudflare Pages project `zongqir-blog`
- production traffic stays on `https://blog.zongqir.com`

## Current State

- The repo contains a GitHub Pages workflow that builds Jekyll and force-pushes to `gh-pages`.
- The repo also contains `vercel.json`.
- The active production domain has already been bound to the Cloudflare Pages project `zongqir-blog`.
- Local Cloudflare CLI access is available, but CI still requires repository secrets.

## Chosen Approach

Use GitHub Actions as the single automation entrypoint and Cloudflare Pages Direct Upload as the deployment target.

Why this approach:

- it matches the desired user workflow: push code and wait for production to update
- it keeps the build logic in the repo instead of hiding it in dashboard settings
- it removes duplicate deployment systems and avoids GitHub Pages / Vercel drift

## Workflow Design

1. Trigger on pushes to `main` and manual `workflow_dispatch`.
2. Install Ruby and restore Bundler cache.
3. Build the Jekyll site into `_site`.
4. Deploy `_site` with `cloudflare/wrangler-action@v3`.
5. Use repository secrets:
   - `CLOUDFLARE_ACCOUNT_ID`
   - `CLOUDFLARE_API_TOKEN`

## Repo Changes

- replace the GitHub Pages workflow with a Cloudflare Pages deployment workflow
- delete `vercel.json`
- update `README.md` to describe the Cloudflare-first publish flow
- remove the GitHub Pages `CNAME` file
- set `_config.yml` `url` to the production domain

## Risk Handling

- If `CLOUDFLARE_API_TOKEN` is not configured yet, the workflow should skip the deploy step instead of failing the whole run.
- The account ID can be set immediately because it is already known.
- The API token still requires a one-time manual creation in Cloudflare because it is not recoverable from the existing local OAuth login.

## Success Criteria

- `main` pushes trigger a GitHub Action run.
- When both Cloudflare secrets exist, the action builds and deploys to `zongqir-blog`.
- No GitHub Pages or Vercel deployment config remains in the repo.
