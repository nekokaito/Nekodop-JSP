document.addEventListener('DOMContentLoaded', function () {
	
	
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

  loadUsers();
});
