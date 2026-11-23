document.addEventListener("DOMContentLoaded", function () {
  var catInfo = document.getElementById("cat-info");
  var catId = new URLSearchParams(window.location.search).get("id");

  function escapeHtml(value) {
    return String(value == null ? "" : value).replace(
      /[&<>"']/g,
      function (char) {
        return {
          "&": "&amp;",
          "<": "&lt;",
          ">": "&gt;",
          '"': "&quot;",
          "'": "&#39;",
        }[char];
      },
    );
  }

  function showMessage(message) {
    if (window.showToast) showToast(message, "error");
    else window.alert(message);
  }

  function getApprovalLabel(status) {
    return (
      { 0: "Pending", 1: "Accepted", 2: "Rejected" }[String(status)] ||
      "Pending"
    );
  }

  function getVideoThumbnailUrl(videoUrl) {
    try {
      var url = new URL(videoUrl, window.location.href);
      if (!url.hostname.endsWith("cloudinary.com") || !url.pathname.includes("/video/upload/")) return "";
      url.pathname = url.pathname
        .replace("/video/upload/", "/video/upload/so_0,f_jpg/")
        .replace(/\.[^/.]+$/, ".jpg");
      return url.href;
    } catch (error) {
      return "";
    }
  }

  function renderCat(cat) {
    var isAdopted = String(cat.adopted) === "1";
    var ownerImage = cat.ownerImage || "images/profile.png";
    var age = String(cat.age || "Age unknown").replace(/^0 years\s*/, "");
    var phone = String(cat.phone || "").replace(/\D/g, "");

    var whatsappUrl =
      "https://wa.me/88" +
      encodeURIComponent(phone) +
      "?text=" +
      encodeURIComponent(
        "Hello, I would like to ask about " + cat.name + " on NekoDop.",
      );
    var status = String(cat.status == null ? "0" : cat.status);
    var image = escapeHtml(cat.image || "images/No_Cats.png");
    var video = escapeHtml(cat.video || "");
    var videoThumbnail = escapeHtml(getVideoThumbnailUrl(cat.video || "") || cat.image || "images/No_Cats.png");
    var adminActions = isAdmin
      ? "<div class='approval-controls' aria-label='Admin post approval controls'>" +
        "<p>Post status: <strong class='approval-status status-" +
        status +
        "'>" +
        escapeHtml(getApprovalLabel(status)) +
        "</strong></p>" +
        "<button type='button' class='approve-button' data-status='1' " +
        (status === "1" ? "disabled" : "") +
        ">Accept</button>" +
        "<button type='button' class='reject-button' data-status='2' " +
        (status === "2" ? "disabled" : "") +
        ">Reject</button>" +
        "</div>"
      : "";

    var favoriteButton =
      "<button type='button' class='favorite-button detail-favorite' data-cat-id='" +
      escapeHtml(cat.id) +
      "' aria-label='" +
      (cat.isFavorite ? "Remove from favorites" : "Add to favorites") +
      "' aria-pressed='" +
      Boolean(cat.isFavorite) +
      "' title='" +
      (cat.isFavorite ? "Remove from favorites" : "Add to favorites") +
      "'><svg viewBox='0 0 24 24' aria-hidden='true'><path d='M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z'></path></svg></button>";

    catInfo.innerHTML =
      "<article class='cat-content'>" +
      "<div class='cat-image'><div id='preview-container'>" +
      "<img id='main-preview-image' class='main-preview" +
      (video ? "" : " image-only") +
      "' src='" +
      image +
      "' alt='" +
      escapeHtml(cat.name) +
      "'>" +
      (video
        ? "<video id='main-preview-video' class='main-preview hidden' controls><source src='" +
          video +
          "'></video>"
        : "") +
      "</div>" +
      (video
        ? "<div class='media-selector'><button type='button' class='media-thumb active' id='show-image' aria-label='Show cat photo'><img src='" +
          image +
          "' alt=''></button><button type='button' class='media-thumb' id='show-video' aria-label='Show cat video'><img id='video-preview-thumbnail' src='" +
          videoThumbnail +
          "' alt=''><i class='fa-solid fa-circle-play' aria-hidden='true'></i></button></div>"
        : "") +
      "</div>" +
      "<div class='cat-info-content'>" +
      "<h1 class='pet-name'>" +
      escapeHtml(cat.name) +
      "</h1>" +
      "<div class='pet-details'>" +
      "<div class='pet-attribute'><i class='fa-solid fa-cake-candles' aria-hidden='true'></i><span><strong>Age</strong> " + escapeHtml(age) + "</span></div>" +
      "<div class='pet-attribute'><i class='fa-solid fa-venus-mars' aria-hidden='true'></i><span><strong>Gender</strong> " + escapeHtml(cat.gender || "Unknown") + "</span></div>" +
      "<div class='pet-attribute'><i class='fa-solid fa-paw' aria-hidden='true'></i><span><strong>Breed</strong> " + escapeHtml(cat.breed || "Unknown") + "</span></div>" +
      "<div class='pet-attribute'><i class='fa-solid fa-heart' aria-hidden='true'></i><span><strong>Adoption</strong> " + (isAdopted ? "Adopted" : "Available") + "</span></div>" +
      "</div>" +
      (isAdopted
        ? "<div class='adopted-by-info'><span class='label'>Adopted by</span><div class='adopted-by-person'><img src='" +
          escapeHtml(cat.adopterImage || "images/profile.png") +
          "' alt='' loading='lazy'><span>" +
          escapeHtml(cat.adopterName || "Unknown adopter") +
          "</span></div></div>"
        : "") +
      "<div class='pet-description'><p>" +
      escapeHtml(cat.description || "No description provided.") +
      "</p></div>" +
      "<div class='more-info'><p><span class='label'>Additional info:</span> " +
      escapeHtml(cat.additional || "None") +
      "</p></div>" +
      "<div class='action-buttons'>" +
      favoriteButton +
      "<a class='whatsapp-button' href='" +
      whatsappUrl +
      "' target='_blank' rel='noopener noreferrer' data-cat-id='" +
      escapeHtml(cat.id) +
      "'><i class='fa-brands fa-whatsapp' aria-hidden='true'></i> Chat on WhatsApp</a>" +
      "<a class='email-button' href='mailto:" +
      escapeHtml(cat.ownerEmail || "") +
      "' data-cat-id='" +
      escapeHtml(cat.id) +
      "'><i class='fa-regular fa-envelope' aria-hidden='true'></i> Send an Email</a>" +
      adminActions +
      "</div>" +
      "<section class='posted-by'><h3>Posted by</h3><div class='poster-info'>" +
      "<div class='poster-avatar'><img src='" +
      escapeHtml(ownerImage) +
      "' alt='Owner profile'></div>" +
      "<div><p class='poster-name'>" +
      escapeHtml(cat.ownerName || "Cat owner") +
      "</p>" +
      "<p class='poster-text'>" +
      escapeHtml(cat.address || "") +
      "</p>" +
      "<p class='poster-text'>" +
      escapeHtml(
        cat.created_at ? new Date(cat.created_at).toLocaleDateString() : "",
      ) +
      "</p></div>" +
      "</div></section>" +
      "</div></article>";

    if (video) {
      var imageButton = document.getElementById("show-image");
      var videoButton = document.getElementById("show-video");
      var imageElement = document.getElementById("main-preview-image");
      var videoElement = document.getElementById("main-preview-video");
      var videoThumbnailElement = document.getElementById("video-preview-thumbnail");
      videoThumbnailElement.addEventListener("error", function () {
        this.onerror = null;
        this.src = image;
      });
      imageButton.addEventListener("click", function () {
        imageElement.classList.remove("hidden");
        videoElement.classList.add("hidden");
        videoElement.pause();
        imageButton.classList.add("active");
        videoButton.classList.remove("active");
      });
      videoButton.addEventListener("click", function () {
        imageElement.classList.add("hidden");
        videoElement.classList.remove("hidden");
        videoButton.classList.add("active");
        imageButton.classList.remove("active");
      });
    }
  }

  function postStatus(catId, field, value) {
    return fetch("update-status.jsp", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({ catId: catId, [field]: value }),
    }).then(function (response) {
      return response.json();
    });
  }

  catInfo.addEventListener("click", function (event) {
    var favoriteButton = event.target.closest(".detail-favorite");
    var approvalButton = event.target.closest(
      ".approve-button, .reject-button",
    );
    var contactLink = event.target.closest(".whatsapp-button, .email-button");

    if (favoriteButton) {
      event.preventDefault();
      fetch("toggle-favorite.jsp", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({ catId: favoriteButton.dataset.catId }),
      })
        .then(function (response) {
          return response.json();
        })
        .then(function (result) {
          if (!result.success)
            return showMessage(result.message || "Could not update favorite.");
          favoriteButton.setAttribute(
            "aria-pressed",
            String(result.isFavorite),
          );
          favoriteButton.setAttribute(
            "aria-label",
            result.isFavorite ? "Remove from favorites" : "Add to favorites",
          );
          favoriteButton.title = result.isFavorite
            ? "Remove from favorites"
            : "Add to favorites";
        })
        .catch(function () {
          showMessage("Could not update favorite.");
        });
    } else if (approvalButton) {
      event.preventDefault();
      if (!isAdmin || approvalButton.disabled) return;
      postStatus(catId, "approvalStatus", approvalButton.dataset.status)
        .then(function (result) {
          if (!result.success)
            return showMessage(
              result.message || "Could not update post status.",
            );
          window.location.reload();
        })
        .catch(function () {
          showMessage("Could not update post status.");
        });
    } else if (contactLink) {
      fetch("record-cat-view.jsp", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({ catId: contactLink.dataset.catId }),
        keepalive: true,
      }).catch(function (error) {
        console.error("Could not record contact view:", error);
      });
    }
  });

  if (!catId) {
    catInfo.textContent = "Cat not found.";
    return;
  }

  fetch("get-cat.jsp?id=" + encodeURIComponent(catId))
    .then(function (response) {
      return response.json();
    })
    .then(function (cat) {
      if (!cat || cat.error || !cat.id) {
        catInfo.textContent = cat && cat.error ? cat.error : "Cat not found.";
        return;
      }
      if (isAdmin) {
        var morePostsLink = document.createElement("a");
        morePostsLink.href = "dashboard.jsp#posts";
        morePostsLink.className = "return-btn";
        morePostsLink.innerHTML = "<i class='fa-solid fa-file'></i> More Posts";
        document.getElementById("nav-home").appendChild(morePostsLink);
      }
      renderCat(cat);
    })
    .catch(function (error) {
      console.error("Error fetching cat details:", error);
      catInfo.textContent = "Failed to load cat details.";
    });
});
