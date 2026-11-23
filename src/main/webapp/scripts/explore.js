document.addEventListener('DOMContentLoaded', function () {

  var cats = [];

  var searchInput = document.getElementById("search-input");
  var ageFilter = document.getElementById("age-filter");
  var breedFilter = document.getElementById("breed-filter");
  var maleCheckbox = document.getElementById("male-filter");
  var femaleCheckbox = document.getElementById("female-filter");

  if (searchInput) searchInput.addEventListener("input", applyFilters);
  if (ageFilter) ageFilter.addEventListener("change", applyFilters);
  if (breedFilter) breedFilter.addEventListener("change", fetchCats);
  if (maleCheckbox) maleCheckbox.addEventListener("change", applyFilters);
  if (femaleCheckbox) femaleCheckbox.addEventListener("change", applyFilters);
 
  function fetchCats() {
    var selectedBreed = breedFilter ? breedFilter.value : "All";
    fetch("get-explore-cats.jsp?breed=" + encodeURIComponent(selectedBreed))
      .then(function(res) { return res.json(); })
      .then(function(data) {
		
        cats = data || [];
        applyFilters();
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
    var selectedAge = ageFilter ? ageFilter.value : "all";
    var maleChecked = maleCheckbox ? maleCheckbox.checked : false;
    var femaleChecked = femaleCheckbox ? femaleCheckbox.checked : false;

    var filteredCats = cats.filter(function(cat) {
      var nameMatch = cat.name.toLowerCase().includes(searchQuery);
      var genderMatch = (!maleChecked && !femaleChecked) ||
                        (maleChecked && cat.gender.toLowerCase() === "male") ||
                        (femaleChecked && cat.gender.toLowerCase() === "female");
      var ageMatch = selectedAge === "all" || getAgeCategory(cat.age) === selectedAge;
      return nameMatch && genderMatch && ageMatch;
    });

    renderCats(filteredCats);
  }

  function getAgeCategory(age) {
    var ageText = String(age || "").toLowerCase();
    var yearsMatch = ageText.match(/(\d+)\s*years?/);
    var monthsMatch = ageText.match(/(\d+)\s*months?/);
    var years = yearsMatch ? parseInt(yearsMatch[1], 10) : 0;
    var months = monthsMatch ? parseInt(monthsMatch[1], 10) : 0;
    var ageInYears = years + months / 12;

    if (ageInYears < 1) return "kitten";
    if (ageInYears < 4) return "young";
    if (ageInYears < 8) return "adult";
    return "senior";
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

        var card = "<div class='card cat-card-link'>" +
                     "<a class='cat-card-main' href='cat-details.jsp?id=" + cat.id + "'>" +
                     "<div class='cat-img'><img src='" + optimizedImage + "' alt='" + cat.name + "' /></div>" +
                     "<div class='card-body'>" +
                       "<div class='card-text'>" +
                         "<h2>" + cat.name + "</h2>" +
                         "<p class='cat-card-meta'><i class='fa-solid fa-cake-candles' aria-hidden='true'></i><span>" + (cat.age || "Age unknown") + "</span></p>" +
                       "<p class='cat-card-meta'><i class='fa-solid fa-venus-mars' aria-hidden='true'></i><span>" + (cat.gender || "Unknown") + "</span></p>" +
                       "<p class='cat-card-meta'><i class='fa-solid fa-paw' aria-hidden='true'></i><span>" + (cat.breed || "Unknown") + "</span></p>" +
                       "</div>" +
                       "<div class='owner-img'>" +
                         "<img src='" + ownerImage + "' alt='Owner of " + cat.name + "' />" +
                       "</div>" +
                     "</div>" +
                   "</a>" +
                   "<button type='button' class='favorite-button' data-cat-id='" + cat.id + "' aria-label='" + (cat.isFavorite ? "Remove from favorites" : "Add to favorites") + "' aria-pressed='" + !!cat.isFavorite + "'><svg viewBox='0 0 24 24' aria-hidden='true'><path d='M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z'></path></svg></button>" +
                   "</div>";
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

  document.getElementById("cat-container").addEventListener("click", function(event) {
    var button = event.target.closest(".favorite-button");
    if (!button) return;
    event.preventDefault();
    event.stopPropagation();
    var catId = button.getAttribute("data-cat-id");
    fetch("toggle-favorite.jsp", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({ catId: catId })
    }).then(function(response) { return response.json(); })
      .then(function(result) {
        if (!result.success) {
          if (window.showToast) showToast(result.message || "Could not update favorite.", "error");
          return;
        }
        var cat = cats.find(function(item) { return String(item.id) === String(catId); });
        if (cat) cat.isFavorite = result.isFavorite;
        button.setAttribute("aria-pressed", String(result.isFavorite));
        button.setAttribute("aria-label", result.isFavorite ? "Remove from favorites" : "Add to favorites");
      }).catch(function(error) { console.error("Favorite update failed:", error); });
  });


  // initial fetch
  fetchCats();

});
