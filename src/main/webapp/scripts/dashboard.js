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

  // fetch all cats from jsp
  function fetchPosts() {
    return fetch("get-cats.jsp") 
      .then(function (res) {
        return res.json();
      })
      .then(function (data) {
        // your jsp directly returns an array []
        allCats = data || [];
        return allCats;
      })
      .catch(function (error) {
        console.error("Error fetching posts:", error);
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
      default:
        return allCats;
    }
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
      });
    });
  }

  // render posts
  function renderPosts(catList) {
    var container = document.getElementById("post-container");

    // clear
    container.innerHTML = "";

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
      var optimizedImage = cat.image.replace(
        "/upload/",
        "/upload/f_webp,q_40/"
      );

      var card = document.createElement("a");
      card.href = "cat-details.jsp?id=" + cat.id;
      card.className = "card";
      card.innerHTML = 	  `
	        <div class="cat-img">
	          <img src="${optimizedImage}" alt="${cat.name}" loading="lazy" />
	        </div>
	        <div class="card-body">
	          <div class="card-text">
	            <h2>${cat.name}</h2>
	            <p>${cat.age.replace(/^0 years\s*/, "")}</p>
	            <p>${cat.gender}</p>
	          </div>
	          <div class="owner-img">
	            <img id="owner-${cat.id}" src="${cat.ownerImage}" alt="Owner of ${
	        cat.cat_name
	      }" loading="lazy" />
	          </div>
	        </div>
	      `;;

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

        // counters
        var approvedCount = filterCats("approved").length;
        var pendingCount = filterCats("pending").length;
        var rejectedCount = filterCats("rejected").length;

        document.getElementById("approved-count").textContent = approvedCount;
        document.getElementById("pending-count").textContent = pendingCount;
        document.getElementById("rejected-count").textContent = rejectedCount;
      });

});
