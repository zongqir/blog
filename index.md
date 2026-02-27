---
layout: default
title: 首页
---

# 最新文章

{% assign featured_post = nil %}
{% assign featured_ts = 0 %}
{% for post in site.posts %}
  {% assign post_ts = post.updated | default: post.date | date: '%s' | plus: 0 %}
  {% if post_ts > featured_ts %}
    {% assign featured_post = post %}
    {% assign featured_ts = post_ts %}
  {% endif %}
{% endfor %}

{% if featured_post %}
<section class="featured-post">
  <p class="featured-kicker">精选文章</p>
  <h2 class="featured-title">
    <a href="{{ featured_post.url | relative_url }}">{{ featured_post.title }}</a>
  </h2>
  <p class="featured-meta">
    发布于 {{ featured_post.date | date: "%Y-%m-%d" }}
    {% if featured_post.updated %}
      <span class="meta-sep">|</span>
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
</section>
{% endif %}

{% assign hot_urls = "/2026/02/26/i18n-context-governance/,/2026/02/26/complex-business-governance/,/2025/01/18/linux-troubleshooting-decision-map/" | split: "," %}
{% assign hot_posts = "" | split: "" %}
{% for post in site.posts %}
  {% if hot_urls contains post.url %}
    {% assign hot_posts = hot_posts | push: post %}
  {% endif %}
{% endfor %}
{% assign hot_posts_count = hot_posts.size %}

{% assign series_tags = "架构设计,工程治理,SRE" | split: "," %}
{% assign active_series_count = 0 %}
{% for series_tag in series_tags %}
  {% assign series_posts = site.tags[series_tag] %}
  {% if series_posts and series_posts.size > 0 %}
    {% assign active_series_count = active_series_count | plus: 1 %}
  {% endif %}
{% endfor %}
{% assign status_post = featured_post | default: site.posts.first %}

<section class="status-strip">
  <div class="status-item">
    <span class="status-label">站点活跃</span>
    <span class="status-value">最近更新 {{ status_post.updated | default: status_post.date | date: "%Y-%m-%d" }}</span>
  </div>
  <div class="status-item">
    <span class="status-label">内容规模</span>
    <span class="status-value">累计 {{ site.posts.size }} 篇文章</span>
  </div>
  <div class="status-item">
    <span class="status-label">专题连载</span>
    <span class="status-value">已上线 {{ active_series_count }} 个系列</span>
  </div>
</section>

{% if hot_posts_count > 0 %}
<section class="home-hot">
  <h2 class="home-section-title">热门文章 <small>({{ hot_posts_count }})</small></h2>
  <p class="home-section-desc">编辑精选的高价值文章入口，适合首次访问快速了解站点内容。</p>
  {% include post-list.html posts=hot_posts list_id="home-hot" list_class="home-hot-list" show_updated=false %}
</section>
{% endif %}

<section class="home-series">
  <h2 class="home-section-title">专题连载 <small>({{ active_series_count }})</small></h2>
  <p class="home-section-desc">围绕固定主题持续更新，形成可追踪的知识脉络。</p>
  <div class="series-grid">
    {% for series_tag in series_tags %}
      {% assign series_posts = site.tags[series_tag] %}
      {% if series_posts and series_posts.size > 0 %}
        {% assign latest_series_post = series_posts | first %}
        <article class="series-card">
          <p class="series-kicker">{{ series_tag }} 系列</p>
          <h3 class="series-title"><a href="{{ latest_series_post.url | relative_url }}">{{ latest_series_post.title }}</a></h3>
          <p class="series-meta">{{ series_posts.size }} 篇 · 最近更新 {{ latest_series_post.updated | default: latest_series_post.date | date: "%Y-%m-%d" }}</p>
        </article>
      {% endif %}
    {% endfor %}
  </div>
</section>

{% assign home_posts = "" | split: "" %}
{% for post in site.posts %}
  {% if featured_post == nil or post.url != featured_post.url %}
    {% assign home_posts = home_posts | push: post %}
  {% endif %}
{% endfor %}

<section class="home-feed">
  <h2 class="home-feed-title">全部文章 <small>({{ home_posts.size }})</small></h2>
  {% include post-list.html posts=home_posts list_id="home" list_class="home-feed-list" show_updated=false %}
</section>
