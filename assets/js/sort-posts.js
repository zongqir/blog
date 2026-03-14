(function () {
  var lists = document.querySelectorAll(".post-list[data-sort-mode='updated-first']");
  if (!lists.length) return;

  lists.forEach(function (list) {
    var items = Array.from(list.querySelectorAll(".post-item"));
    items.sort(function (a, b) {
      var aTs = Number(a.dataset.sortTs || "0");
      var bTs = Number(b.dataset.sortTs || "0");
      return bTs - aTs;
    });
    items.forEach(function (item) {
      list.appendChild(item);
    });
  });
})();

