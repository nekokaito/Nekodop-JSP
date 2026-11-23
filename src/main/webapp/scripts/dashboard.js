document.addEventListener('DOMContentLoaded', function () {
	function updateTime () {
	  const now = new Date();

	  // Format time
	  const timeOptions = {
	    hour: "2-digit",
	    minute: "2-digit",
	    second: "2-digit",
	    hour12: true,
	  };
	  const timeString = now.toLocaleTimeString("en-US", timeOptions);

	  // Format date
	  const dateOptions = {
	    weekday: "long",
	    year: "numeric",
	    month: "long",
	    day: "numeric",
	  };
	  const dateString = now.toLocaleDateString("en-US", dateOptions);

	  document.getElementById("currentTime").textContent = timeString;
	  document.getElementById("currentDate").textContent = dateString;
	};

	
	
  function loadUsers() {
    fetch("get-users.jsp")
      .then(function (response) {
        return response.json();
      })
      .then(function (users) {
        let userContainer = document.getElementById("user-list");
        userContainer.innerHTML = "";

        const usersCount = document.getElementById("total-users");
	    usersCount.innerText = users.length;
		
        if (users && users.length > 0) {
          users.forEach(function (user) {
            var row = document.createElement("tr");
           
            row.innerHTML = `
              <td>
                <div class="flex items-center gap-3">
                  <div class="avatar">
                    <div class="mask-squircle" style="height: 48px; width: 48px;">
                      <img
                        src="${user.profile_picture || "images/profile.png"}"
                        alt="Avatar"
                        style="height: 100%; width: 100%; object-fit: cover; border-radius: 12px;"
                      />
                    </div>
                  </div>
                  <div>
                    <div class="font-bold">${user.name}</div>
                  </div>
                </div>
              </td>
              <td>
                ${user.email || "N/A"}
                <br />
                <span class="badge badge-ghost badge-sm">
                  ${user.user_role || "Unknown Role"}
                </span>
              </td>
              <td>${user.phone_number || "N/A"}</td>
              <td>${user.created_at || "N/A"}</td>
              <td>
                ${ user.user_role !== "admin"
                    ? '<button class="delete-btn" data-user-id="' + user.id + '">Delete</button>'
                    : ""
                }
              </td>
            `;

            userContainer.appendChild(row);
          });

          // delete event listeners
          let deleteButtons = document.querySelectorAll(".delete-btn");
          deleteButtons.forEach(function (btn) {
            btn.addEventListener("click", function () {
              let userId = this.getAttribute("data-user-id");

              if (confirm("Are you sure you want to delete this user?")) {
                fetch("delete-user.jsp?id=" + userId)
                  .then(function (res) {
                    return res.json();
                  })
                  .then(function (result) {
                    if (result.success) {
                      alert("User deleted successfully!");
                      loadUsers(); // refresh list
                    } else {
                      alert("Error: " + result.error);
                    }
                  })
                  .catch(function (err) {
                    console.error("Delete failed:", err);
                  });
              }
            });
          });
        }
      })
      .catch(function (error) {
        console.error("Error fetching users:", error);
      });
  }
  
  
  
  var allCats = [];
  var postsLoadError = "";

  // fetch all cats from jsp
  function fetchPosts() {
    return fetch("get-cats.jsp") 
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        if (data && !Array.isArray(data) && data.error) {
          throw new Error(data.error);
        }
        if (data && data.length && data[0].error) {
          throw new Error(data[0].error);
        }
        postsLoadError = "";
        allCats = data || [];
        return allCats;
      })
      .catch(function (error) {
        console.error("Error fetching posts:", error);
        postsLoadError = error.message || "Could not load posts.";
        return [];
      });
  }

  // filter cats by approval status
  function filterCats(status) {
    switch (status) {
      case "approved":
        return allCats.filter(function (cat) {
          return cat.status === "1";
        });
      case "pending":
        return allCats.filter(function (cat) {
          return cat.status === "0";
        });
      case "rejected":
        return allCats.filter(function (cat) {
          return cat.status === "2";
        });
      case "adopted":
        return allCats.filter(function (cat) {
          return String(cat.adopted) === "1" || Boolean(cat.adoptedBy || cat.adopted_by);
        });
      default:
        return allCats;
    }
  }

  function escapeHtml(value) {
    return String(value == null ? "" : value).replace(/[&<>"']/g, function (character) {
      return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[character];
    });
  }

  function renderAdoptedCats() {
    var list = document.getElementById("adopted-cats-list");
    if (!list) return;
    var adoptedCats = filterCats("adopted");
    list.innerHTML = "";

    if (!adoptedCats.length) {
      list.innerHTML = "<tr><td colspan='4'>No adopted cats yet.</td></tr>";
      return;
    }

    adoptedCats.forEach(function (cat) {
      var row = document.createElement("tr");
      var catImage = escapeHtml(cat.image || "images/No_Cats.png");
      var ownerImage = escapeHtml(cat.ownerImage || "images/profile.png");
      var adopterImage = escapeHtml(cat.adopterImage || "images/profile.png");
      var catName = escapeHtml(cat.name || "Unnamed cat");
      var ownerName = escapeHtml(cat.ownerName || "Unknown owner");
      var adopterName = escapeHtml(cat.adopterName || "Unknown adopter");
      var adoptedAt = escapeHtml(cat.adoptedAt || "Unknown");

      row.innerHTML = `
        <td><div class="adoption-person"><img class="adoption-cat-image" src="${catImage}" alt="${catName}" loading="lazy"><a href="cat-details.jsp?id=${encodeURIComponent(cat.id)}">${catName}</a></div></td>
        <td><div class="adoption-person"><img src="${ownerImage}" alt="" loading="lazy"><span>${ownerName}</span></div></td>
        <td><div class="adoption-person"><img src="${adopterImage}" alt="" loading="lazy"><span>${adopterName}</span></div></td>
        <td>${adoptedAt}</td>
      `;
      list.appendChild(row);
    });
  }

  function updatePostCounters() {
    document.getElementById("approved-count").textContent = filterCats("approved").length;
    document.getElementById("pending-count").textContent = filterCats("pending").length;
    document.getElementById("rejected-count").textContent = filterCats("rejected").length;
    document.getElementById("adopted-count").textContent = filterCats("adopted").length;
  }

  // setup filter and refresh functionality
  function setupPostActions() {
    var refreshBtn = document.getElementById("refresh-posts");
    var filterSelect = document.getElementById("filter");

    if (!refreshBtn || !filterSelect) {
      console.warn("Post filter or refresh elements not found.");
      return;
    }

    // filter change
    filterSelect.addEventListener("change", function () {
      var selected = filterSelect.value;
      var filtered = filterCats(selected);
      renderPosts(filtered);
    });

    // refresh click
    refreshBtn.addEventListener("click", function () {
      fetchPosts().then(function () {
        var selected = filterSelect.value;
        var filtered = filterCats(selected);
        renderPosts(filtered);
        renderAdoptedCats();
        updatePostCounters();
      });
    });
  }

  // render posts
  function renderPosts(catList) {
    var container = document.getElementById("post-container");

    // clear
    container.innerHTML = "";

    if (postsLoadError) {
      container.style.height = "auto";
      var errorMessage = document.createElement("p");
      errorMessage.className = "posts-error";
      errorMessage.textContent = "Could not load posts: " + postsLoadError;
      container.appendChild(errorMessage);
      return;
    }

    if (!catList || catList.length === 0) {
      container.style.height = "100vh";
      container.innerHTML =
        "<div class='no-cats'>" +
        "<img src='images/No_Cats.png' alt='No Cats Found' />" +
        "<p>No Cat Posts Found.</p>" +
        "</div>";
      return;
    }

    container.style.height = "auto";

    catList.forEach(function (cat) {
      // optimize cloudinary url
      var optimizedImage = cat.image ? cat.image.replace("/upload/", "/upload/f_webp,q_40/") : "images/No_Cats.png";
      var age = String(cat.age || "Age unknown").replace(/^0 years\s*/, "");
      var isAdopted = String(cat.adopted) === "1" || Boolean(cat.adoptedBy || cat.adopted_by);
      var postStatus = isAdopted ? "Adopted" : cat.status === "1" ? "Approved" : cat.status === "2" ? "Rejected" : "Pending";
      var statusClass = postStatus.toLowerCase();

      var card = document.createElement("div");
      card.className = "card cat-card-link";
      card.innerHTML = `
	        <a class="cat-card-main" href="cat-details.jsp?id=${encodeURIComponent(cat.id)}">
	          <div class="cat-img">
	            <img src="${optimizedImage}" alt="${cat.name || "Cat"}" loading="lazy" />
	          </div>
	          <div class="card-body">
	            <div class="card-text">
	              <div class="dashboard-cat-title">
	                <h2>${cat.name || "Unnamed cat"}</h2>
	                <span class="post-status post-status-${statusClass}">${postStatus}</span>
	              </div>
	              <p class="cat-card-meta"><i class="fa-solid fa-cake-candles" aria-hidden="true"></i><span>${age}</span></p>
	              <p class="cat-card-meta"><i class="fa-solid fa-venus-mars" aria-hidden="true"></i><span>${cat.gender || "Unknown"}</span></p>
	              <p class="cat-card-meta"><i class="fa-solid fa-paw" aria-hidden="true"></i><span>${cat.breed || cat.cat_breed || "Unknown"}</span></p>
	            </div>
	            <div class="owner-img">
	              <img id="owner-${cat.id}" src="${cat.ownerImage || "images/profile.png"}" alt="Owner of ${cat.name || "cat"}" loading="lazy" />
	            </div>
	          </div>
	        </a>
	      `;

      container.appendChild(card);

    
      
    });
  }

  // run when page ready

  updateTime();
  setInterval(updateTime, 1000);
  loadUsers();
  fetchPosts().then(function () {
        setupPostActions();

        var initialFilter = document.getElementById("filter")
          ? document.getElementById("filter").value
          : "all";

        var filtered = filterCats(initialFilter);
        renderPosts(filtered);

        renderAdoptedCats();
        updatePostCounters();
      });

});
