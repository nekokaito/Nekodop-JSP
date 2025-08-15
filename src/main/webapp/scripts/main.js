// -----------------------------
// DOM Ready
// -----------------------------
document.addEventListener("DOMContentLoaded", function () {
  // Show Active Section (SPA)
  function showActiveSection() {
    var sections = document.querySelectorAll("#app > div");
  
    var hash = window.location.hash;
	
	    // Set default hash
    if (!hash) {
      var path = window.location.pathname;

      if (path.endsWith("/pages/dashboard.jsp")) {
        hash = "#dashboard";
      } else {
        hash = "#home";
      }
    }

    for (var i = 0; i < sections.length; i++) {
      var section = sections[i];
      section.style.display = ("#" + section.id) === hash ? "block" : "none";
    }
  }

  showActiveSection();
  window.addEventListener("hashchange", showActiveSection);

  // On Load Preloader Handling
  window.onload = function () {
    var preloader = document.getElementById("preloader");
    var app = document.getElementById("main-content");
    var footer = document.getElementById("footer-content");

    preloader.style.display = "flex";
    app.style.display = "none";
    footer.style.display = "none";

    setTimeout(function () {
      preloader.style.display = "none";
      app.style.display = "block";
      footer.style.display = "block";
    }, 2000);
  };
});
