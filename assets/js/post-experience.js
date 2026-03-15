(function () {
  var content = document.querySelector("[data-post-content]");
  if (!content) return;

  var progressBar = document.querySelector("[data-reading-progress]");
  var toc = document.querySelector("[data-post-toc]");
  var tocNav = document.querySelector("[data-post-toc-nav]");
  var tocToggle = document.querySelector("[data-post-toc-toggle]");
  var postGrid = document.querySelector("[data-post-grid]");
  var headings = Array.from(content.querySelectorAll("h2, h3"));
  var tocBreakpoint = window.matchMedia("(max-width: 1079px)");
  var minHeadingsForToc = 2;

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

  function setTocOpen(isOpen) {
    if (!toc || !tocToggle) return;
    toc.classList.toggle("is-open", isOpen);
    tocToggle.setAttribute("aria-expanded", String(isOpen));
  }

  if (toc && tocNav && headings.length >= minHeadingsForToc) {
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
    if (postGrid) {
      postGrid.classList.add("has-toc");
    }
    setTocOpen(false);
  } else if (toc) {
    toc.hidden = true;
    if (postGrid) {
      postGrid.classList.remove("has-toc");
    }
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
    if (!tocNav || headings.length < minHeadingsForToc) return;
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

  if (tocToggle) {
    tocToggle.addEventListener("click", function () {
      var isOpen = toc.classList.contains("is-open");
      setTocOpen(!isOpen);
    });
  }

  if (tocNav) {
    tocNav.addEventListener("click", function (event) {
      var link = event.target.closest(".toc-link");
      if (!link || !tocBreakpoint.matches) return;
      setTocOpen(false);
    });
  }

  function syncTocMode() {
    if (!toc || !tocToggle) return;
    if (!tocBreakpoint.matches) {
      toc.classList.remove("is-open");
      tocToggle.setAttribute("aria-expanded", "false");
      return;
    }

    tocToggle.setAttribute("aria-expanded", String(toc.classList.contains("is-open")));
  }

  updateProgress();
  updateTocActive();
  syncTocMode();
  window.addEventListener("scroll", handleScroll, { passive: true });
  window.addEventListener("resize", function () {
    syncTocMode();
    handleScroll();
  });
})();
