document.addEventListener('DOMContentLoaded', function () {

  var cats = [];

  var searchInput = document.getElementById("search-input");
  var maleCheckbox = document.getElementById("male-filter");
  var femaleCheckbox = document.getElementById("female-filter");

  if (searchInput) searchInput.addEventListener("input", applyFilters);
  if (maleCheckbox) maleCheckbox.addEventListener("change", applyFilters);
  if (femaleCheckbox) femaleCheckbox.addEventListener("change", applyFilters);
 
  function fetchCats() {
    fetch("get-explore-cats.jsp")
      .then(function(res) { return res.json(); })
      .then(function(data) {
		
        cats = data || [];
        renderCats(cats);
      })
      .catch(function(error) {
        var container = document.getElementById("cat-container");
        if (container) {
          container.innerHTML = "<p>Failed to load cats. Please try again later.</p>";
        }
        console.error("Error fetching cats:", error);
      });
  }

  function applyFilters() {
    var searchQuery = searchInput ? searchInput.value.toLowerCase() : "";
    var maleChecked = maleCheckbox ? maleCheckbox.checked : false;
    var femaleChecked = femaleCheckbox ? femaleCheckbox.checked : false;

    var filteredCats = cats.filter(function(cat) {
      var nameMatch = cat.name.toLowerCase().includes(searchQuery);
      var genderMatch = (!maleChecked && !femaleChecked) ||
                        (maleChecked && cat.gender.toLowerCase() === "male") ||
                        (femaleChecked && cat.gender.toLowerCase() === "female");
      return nameMatch && genderMatch;
    });

    renderCats(filteredCats);
  }

  function renderCats(catList) {
    var container = document.getElementById("cat-container");
    if (!container) return;

    if (catList.length > 0) {
      container.style.height = "auto";

      var catCards = [];
      for (var i = 0; i < catList.length; i++) {
        var cat = catList[i];

        var ownerImage = cat.ownerImage ? cat.ownerImage : "images/profile.png";
        var optimizedImage = cat.image.replace("/upload/", "/upload/f_webp,q_40/");

        var card = "<a href='cat-details.jsp?id=" + cat.id + "'>" +
                   "<div class='card'>" +
                     "<div class='cat-img'><img src='" + optimizedImage + "' alt='" + cat.name + "' /></div>" +
                     "<div class='card-body'>" +
                       "<div class='card-text'>" +
                         "<h2>" + cat.name + "</h2>" +
                         "<p>" + cat.age + "</p>" +
                         "<p>" + cat.gender + "</p>" +
                       "</div>" +
                       "<div class='owner-img'>" +
                         "<img src='" + ownerImage + "' alt='Owner of " + cat.name + "' />" +
                       "</div>" +
                     "</div>" +
                   "</div>" +
                   "</a>";
        catCards.push(card);
      }

      container.innerHTML = catCards.join("");

    } else {
      container.style.height = "100vh";
      container.innerHTML = "<div class='no-cats'>" +
                            "<img src='images/No_Cats.png' alt='No Cats Found' />" +
                            "<p>No Cat Posts Found.</p>" +
                            "</div>";
    }
  }


  // initial fetch
  fetchCats();

});
