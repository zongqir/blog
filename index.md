---
layout: default
title: 首页
---

# 最新文章

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
  <p class="home-section-desc">优先按 frontmatter 的 <code>series</code> 字段聚合，自动形成系列入口。</p>
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

{% assign home_posts = "" | split: "" %}
{% for post in published_posts %}
  {% if featured_post == nil or post.url != featured_post.url %}
    {% assign home_posts = home_posts | push: post %}
  {% endif %}
{% endfor %}

<section class="home-feed">
  <h2 class="home-feed-title">全部文章 <small>({{ home_posts.size }})</small></h2>
  {% include post-list.html posts=home_posts list_id="home" list_class="home-feed-list" show_updated=false %}
</section>
