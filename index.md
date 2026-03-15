---
layout: default
title: 首页
---

<section class="home-hero home-panel">
  <div class="home-hero-copy">
    <p class="section-kicker">工程判断刊</p>
    <h1 class="home-hero-title">复杂系统不是堆技术栈，而是持续做正确取舍。</h1>
    <p class="home-hero-intro">这里长期讨论 SaaS 化、架构演进、稳定性治理与性能优化。重点不是追逐热词，而是把真正影响结果的工程判断拆开说明白。</p>
    <div class="home-hero-actions">
      <a class="action-link" href="{{ '/archive/' | relative_url }}">进入归档</a>
      <a class="action-link action-link-muted" href="{{ '/tags/' | relative_url }}">按议题继续读</a>
    </div>
  </div>
  <aside class="home-hero-aside">
    <p class="section-kicker">当前关注议题</p>
    <ul class="issue-list">
      <li>
        <strong>SaaS 化</strong>
        <span>关注业务抽象、产品边界与能力复用，而不是只谈迁移姿势。</span>
      </li>
      <li>
        <strong>架构演进</strong>
        <span>讨论什么时候该拆、什么时候该稳，以及演进成本如何被业务承受。</span>
      </li>
      <li>
        <strong>稳定性治理</strong>
        <span>把告警、容量、链路和事故复盘放回同一套系统视角里看。</span>
      </li>
      <li>
        <strong>性能优化</strong>
        <span>不追求抽象的极致，而是寻找最值得投入的性能瓶颈与收益比。</span>
      </li>
    </ul>
  </aside>
</section>

{% assign published_posts = site.posts | where_exp: "p", "p.draft != true" %}

{% assign featured_candidates = published_posts | where: "featured", true | sort: "featured_rank" %}
{% assign featured_post = nil %}
{% if featured_candidates.size > 0 %}
  {% assign featured_post = featured_candidates | first %}
{% else %}
  {% assign featured_ts = 0 %}
  {% for post in published_posts %}
    {% assign post_ts = post.updated | default: post.date | date: '%s' | plus: 0 %}
    {% if post_ts > featured_ts %}
      {% assign featured_post = post %}
      {% assign featured_ts = post_ts %}
    {% endif %}
  {% endfor %}
{% endif %}

{% assign hot_candidates = published_posts | where: "hot", true | sort: "hot_rank" %}
{% assign hot_posts = "" | split: "" %}
{% for post in hot_candidates %}
  {% if featured_post == nil or post.url != featured_post.url %}
    {% assign hot_posts = hot_posts | push: post %}
  {% endif %}
{% endfor %}
{% if hot_posts.size == 0 %}
  {% assign hot_auto_pool = published_posts | where_exp: "p", "p.tags contains '架构设计' or p.tags contains '工程治理' or p.tags contains 'SRE' or p.tags contains '性能优化'" %}
  {% if hot_auto_pool.size == 0 %}
    {% assign hot_auto_pool = published_posts %}
  {% endif %}
  {% for post in hot_auto_pool limit:3 %}
    {% if featured_post == nil or post.url != featured_post.url %}
      {% assign hot_posts = hot_posts | push: post %}
    {% endif %}
  {% endfor %}
{% endif %}
{% assign hot_posts_count = hot_posts.size %}

{% assign series_names = published_posts | map: "series" | compact | uniq %}
{% assign active_series_count = series_names.size %}
{% assign status_post = featured_post | default: site.posts.first %}
{% assign home_posts = "" | split: "" %}
{% for post in published_posts %}
  {% if featured_post == nil or post.url != featured_post.url %}
    {% assign home_posts = home_posts | push: post %}
  {% endif %}
{% endfor %}
{% assign recent_posts = "" | split: "" %}
{% for post in home_posts limit: 6 %}
  {% assign recent_posts = recent_posts | push: post %}
{% endfor %}

<section class="home-featured home-panel">
  <div class="home-featured-main">
    <p class="section-kicker">本期重点</p>
    {% if featured_post %}
    <article class="featured-story">
      <p class="featured-kicker">优先阅读</p>
      <h2 class="featured-title">
        <a href="{{ featured_post.url | relative_url }}">{{ featured_post.title }}</a>
      </h2>
      <p class="featured-meta">
        发布于 {{ featured_post.date | date: "%Y-%m-%d" }}
        {% if featured_post.updated %}
          <span class="meta-sep">/</span>
          更新于 {{ featured_post.updated | date: "%Y-%m-%d" }}
        {% endif %}
      </p>
      {% if featured_post.description %}
        <p class="featured-desc">{{ featured_post.description }}</p>
      {% endif %}
      {% if featured_post.tags and featured_post.tags.size > 0 %}
        <p class="featured-tags">
          {% for tag in featured_post.tags %}
            <a class="tag-chip" href="{{ '/tags/' | relative_url }}#{{ tag | slugify: 'raw' }}">{{ tag }}</a>
          {% endfor %}
        </p>
      {% endif %}
    </article>
    {% endif %}
  </div>

  {% if hot_posts_count > 0 %}
  <aside class="home-featured-side">
    <p class="section-kicker">起步阅读</p>
    {% include post-list.html posts=hot_posts list_id="home-hot" list_class="home-hot-list" show_updated=false %}
  </aside>
  {% endif %}
</section>

<section class="home-editorial-grid">
  <section class="home-series home-panel">
    <div class="section-heading">
      <div>
        <p class="section-kicker">专题连载</p>
        <h2 class="home-section-title">沿着同一类问题连续读</h2>
      </div>
      <p class="home-section-desc">优先按 <code>series</code> 聚合，保留成体系的阅读路径。</p>
    </div>
    <div class="series-grid">
      {% for series_name in series_names %}
        {% assign series_posts = published_posts | where: "series", series_name %}
        {% if series_posts and series_posts.size > 0 %}
          {% assign latest_series_post = series_posts | first %}
          <article class="series-card">
            <p class="series-kicker">{{ series_name }} 系列</p>
            <h3 class="series-title"><a href="{{ latest_series_post.url | relative_url }}">{{ latest_series_post.title }}</a></h3>
            <p class="series-meta">{{ series_posts.size }} 篇 · 最近更新 {{ latest_series_post.updated | default: latest_series_post.date | date: "%Y-%m-%d" }}</p>
          </article>
        {% endif %}
      {% endfor %}
    </div>
  </section>

  <section class="home-feed home-panel">
    <div class="section-heading">
      <div>
        <p class="section-kicker">近期文章</p>
        <h2 class="home-feed-title">从最新写作切入</h2>
      </div>
      <p class="home-section-desc">先看最近更新的判断，再决定是否进入专题深读。</p>
    </div>
    {% include post-list.html posts=recent_posts list_id="home" list_class="home-feed-list" show_updated=false %}
    <p class="home-more">
      <a class="action-link" href="{{ '/archive/' | relative_url }}">查看全部文章</a>
    </p>
  </section>
</section>

<section class="status-strip home-panel" aria-label="站点状态">
  <div class="status-item">
    <span class="status-label">最近更新</span>
    <span class="status-value">{{ status_post.updated | default: status_post.date | date: "%Y-%m-%d" }}</span>
  </div>
  <div class="status-item">
    <span class="status-label">内容规模</span>
    <span class="status-value">累计 {{ published_posts.size }} 篇文章</span>
  </div>
  <div class="status-item">
    <span class="status-label">专题连载</span>
    <span class="status-value">已上线 {{ active_series_count }} 个系列</span>
  </div>
</section>
