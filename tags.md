---
layout: default
title: 标签
permalink: /tags/
---

<section class="page-hero page-panel">
  <p class="section-kicker">标签索引</p>
  <h1>沿着同一类问题继续读。</h1>
  <p class="page-intro">从标签快速回到相近主题，把分散的文章重新拼成一条清晰的阅读路径。</p>
</section>

{% assign tags = site.tags | sort %}
{% if tags.size > 0 %}
<section class="page-panel tags-panel">
  <p class="tags-summary">共 {{ tags.size }} 个标签，点击可跳转到对应分组。</p>
  <p class="tag-cloud">
  {% for tag in tags %}
  {% assign tag_name = tag[0] %}
  {% assign tag_posts = tag[1] %}
  <a class="tag-chip" href="#{{ tag_name | slugify: 'raw' }}">
    {{ tag_name }}
    <span class="tag-count">{{ tag_posts.size }}</span>
  </a>
  {% endfor %}
  </p>
</section>

{% for tag in tags %}
<section class="tag-section page-panel" id="{{ tag[0] | slugify: 'raw' }}">
  <h2># {{ tag[0] }} <small>({{ tag[1].size }})</small></h2>
  {% assign tag_name = tag[0] %}
  {% assign tag_posts = tag[1] %}
  {% include post-list.html posts=tag_posts list_id=tag_name %}
</section>
{% endfor %}
{% else %}
<p>暂无标签。</p>
{% endif %}
