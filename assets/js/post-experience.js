(function () {
  var content = document.querySelector("[data-post-content]");
  if (!content) return;

  var progressBar = document.querySelector("[data-reading-progress]");
  var toc = document.querySelector("[data-post-toc]");
  var tocNav = document.querySelector("[data-post-toc-nav]");
  var headings = Array.from(content.querySelectorAll("h2, h3"));

  function slugify(text) {
    return (
      text
        .toLowerCase()
        .trim()
        .replace(/[^\w\u4e00-\u9fa5\s-]/g, "")
        .replace(/\s+/g, "-")
        .replace(/-+/g, "-") || "section"
    );
  }

  if (toc && tocNav && headings.length > 0) {
    var idSet = Object.create(null);
    headings.forEach(function (heading, index) {
      if (!heading.id) {
        var baseId = slugify(heading.textContent || "");
        var candidate = baseId;
        var suffix = 1;
        while (idSet[candidate] || document.getElementById(candidate)) {
          candidate = baseId + "-" + suffix;
          suffix += 1;
        }
        heading.id = candidate + "-" + (index + 1);
      }
      idSet[heading.id] = true;

      var link = document.createElement("a");
      link.className = "toc-link toc-" + heading.tagName.toLowerCase();
      link.href = "#" + heading.id;
      link.textContent = heading.textContent;
      tocNav.appendChild(link);
    });

    toc.hidden = false;
  }

  var ticking = false;

  function updateProgress() {
    if (!progressBar) return;
    var contentRect = content.getBoundingClientRect();
    var viewportHeight = window.innerHeight || document.documentElement.clientHeight;
    var total = content.scrollHeight - viewportHeight * 0.35;
    var passed = -contentRect.top + viewportHeight * 0.22;
    var ratio = total > 0 ? Math.max(0, Math.min(1, passed / total)) : 0;
    progressBar.style.transform = "scaleX(" + ratio + ")";
  }

  function updateTocActive() {
    if (!tocNav || !headings.length) return;
    var marker = 130;
    var activeId = headings[0].id;

    headings.forEach(function (heading) {
      var rect = heading.getBoundingClientRect();
      if (rect.top <= marker) {
        activeId = heading.id;
      }
    });

    var links = tocNav.querySelectorAll(".toc-link");
    links.forEach(function (link) {
      var isActive = link.getAttribute("href") === "#" + activeId;
      link.classList.toggle("active", isActive);
    });
  }

  function handleScroll() {
    if (ticking) return;
    ticking = true;
    window.requestAnimationFrame(function () {
      updateProgress();
      updateTocActive();
      ticking = false;
    });
  }

  updateProgress();
  updateTocActive();
  window.addEventListener("scroll", handleScroll, { passive: true });
  window.addEventListener("resize", handleScroll);
})();
