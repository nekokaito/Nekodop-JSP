document.addEventListener('DOMContentLoaded', function () {

  var cats = [];

  var searchInput = document.getElementById("search-input");
  var ageFilter = document.getElementById("age-filter");
  var maleCheckbox = document.getElementById("male-filter");
  var femaleCheckbox = document.getElementById("female-filter");

  if (searchInput) searchInput.addEventListener("input", applyFilters);
  if (ageFilter) ageFilter.addEventListener("change", applyFilters);
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
