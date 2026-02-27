---
layout: default
title: 标签
permalink: /tags/
---

# 标签

{% assign tags = site.tags | sort %}
{% if tags.size > 0 %}
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

{% for tag in tags %}
<section class="tag-section" id="{{ tag[0] | slugify: 'raw' }}">
  <h2># {{ tag[0] }} <small>({{ tag[1].size }})</small></h2>
  {% assign tag_name = tag[0] %}
  {% assign tag_posts = tag[1] %}
  {% include post-list.html posts=tag_posts list_id=tag_name %}
</section>
{% endfor %}
{% else %}
<p>暂无标签。</p>
{% endif %}
