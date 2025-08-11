// Initialize after page loads
document.addEventListener('DOMContentLoaded', function() {
    // Show toast notification
    showToast("Make sure phone number has WhatsApp", "info");
    console.log('its working')
    // Section switching
    document.getElementById('post-tab').addEventListener('click', function() {
        showSection('post-section', 'post-tab');
    });
    
    document.getElementById('my-cats-tab').addEventListener('click', function() {
        showSection('my-cats-section', 'my-cats-tab');
    });
    
    function showSection(sectionId, tabId) {
        document.getElementById("post-section").style.display = "none";
        document.getElementById("my-cats-section").style.display = "none";
        document.getElementById(sectionId).style.display = "block";
        
        var profileLinks = document.querySelectorAll('.profile-links li');
        for (var i = 0; i < profileLinks.length; i++) {
            profileLinks[i].classList.remove('active');
        }
        
        document.getElementById(tabId).classList.add('active');
    }
    
    // Modal functionality
    var editProfileBtn = document.querySelector('.edit-profile-btn');
    var editProfileModal = document.getElementById('edit-profile-modal');
    var closeProfileModal = document.querySelector('.close-btn-profile');
    var closePostModal = document.querySelector('.close-btn');
    var editPostModal = document.getElementById('edit-post-modal');
    
    if (editProfileBtn) {
        editProfileBtn.addEventListener('click', function() {
           editProfileModal.classList.remove("hidden");
        });
    }
    
    if (closeProfileModal) {
        closeProfileModal.addEventListener('click', function() {
            editProfileModal.classList.add("hidden");
        });
    }
    
    if (closePostModal) {
        closePostModal.addEventListener('click', function() {
            editPostModal.classList.remove('show');
        });
    }
    
    // Tab switching in edit profile modal
	  const tabPersonal = document.getElementById("tab-personal");
	  const tabPassword = document.getElementById("tab-password");
	  const personalForm = document.getElementById("edit-profile-form");
	  const changePasswordForm = document.getElementById("change-password-form");
    
	  tabPersonal.addEventListener("click", function() {
	    tabPersonal.classList.add("active");
	    tabPassword.classList.remove("active");

	    personalForm.classList.remove("hidden");
	    changePasswordForm.classList.add("hidden");
	  });

	  tabPassword.addEventListener("click", function() {
	    tabPassword.classList.add("active");
	    tabPersonal.classList.remove("active");

	    changePasswordForm.classList.remove("hidden");
	    personalForm.classList.add("hidden");
	  });

    
    // Profile image preview
    var profilePicInput = document.getElementById('edit-profile-picture');
    var profilePicPreview = document.getElementById('profile-picture-preview');
    
    if (profilePicInput) {
        profilePicInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                
                reader.onload = function(e) {
                    profilePicPreview.src = e.target.result;
                };
                
                reader.readAsDataURL(this.files[0]);
            }
        });
    }
    
    // Logout functionality
    var logoutBtn = document.getElementById('logout-btn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function() {
            window.location.href = 'logout.jsp';
        });
    }
    
    // Delete cat functionality
    var deleteBtns = document.querySelectorAll('.delete-cat');
    for (var i = 0; i < deleteBtns.length; i++) {
        deleteBtns[i].addEventListener('click', function() {
            var catCard = this.closest('.cat-card');
            var catId = catCard.getAttribute('data-id');
            var catName = catCard.querySelector('h3').textContent;
            
            if (confirm('Are you sure you want to delete "' + catName + '"?')) {
                // Send delete request to server
                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'delete-cat.jsp', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            try {
                                var data = JSON.parse(xhr.responseText);
                                if (data.success) {
                                    showToast("Cat deleted successfully", "success");
                                    catCard.parentNode.removeChild(catCard);
                                } else {
                                    showToast("Failed to delete cat", "error");
                                }
                            } catch (e) {
                                showToast("Error parsing server response", "error");
                            }
                        } else {
                            showToast("Error deleting cat", "error");
                        }
                    }
                };
                xhr.send('id=' + encodeURIComponent(catId));
            }
        });
    }
    
    // Edit cat functionality
    var editBtns = document.querySelectorAll('.edit-cat');
    for (var j = 0; j < editBtns.length; j++) {
        editBtns[j].addEventListener('click', function() {
            var catCard = this.closest('.cat-card');
            var catId = catCard.getAttribute('data-id');
            
            var xhr = new XMLHttpRequest();
            xhr.open('GET', 'get-cat.jsp?id=' + encodeURIComponent(catId), true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            var cat = JSON.parse(xhr.responseText);
                            document.getElementById('edit-cat-name').value = cat.name;
                            // TODO: populate other fields here
                            
                            editPostModal.classList.add('show');
                        } catch (e) {
                            showToast("Error loading cat data", "error");
                        }
                    } else {
                        showToast("Error loading cat data", "error");
                    }
                }
            };
            xhr.send();
        });
    }
    
    // Form submission handling
    var postForm = document.getElementById('post-form');
    if (postForm) {
        postForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            var valid = true;
            
            // Clear errors
            var errors = document.querySelectorAll('.error');
            for (var k = 0; k < errors.length; k++) {
                errors[k].textContent = '';
            }
            
            // Cat name validation
            var catName = document.getElementById('cat-name').value;
            if (!catName) {
                document.getElementById('error-cat-name').textContent = "Cat name is required";
                valid = false;
            }
            
            // Phone validation
            var phone = document.getElementById('phone').value;
            if (!/^01\d{9}$/.test(phone)) {
                document.getElementById('error-phone').textContent = 
                    "Invalid phone number format. Must be 11 digits starting with 01.";
                valid = false;
            }
            
            // Year validation
            var year = parseInt(document.getElementById('year').value, 10) || 0;
            if (year < 0 || year > 25) {
                document.getElementById('error-year').textContent = "Year must be between 0-25";
                valid = false;
            }
            
            // Month validation
            var month = parseInt(document.getElementById('month').value, 10) || 0;
            if (month < 0 || month > 12) {
                document.getElementById('error-month').textContent = "Month must be between 0-12";
                valid = false;
            }
            
            // Image validation
            var catImageInput = document.getElementById('cat-image');
            var catImage = catImageInput.files.length > 0 ? catImageInput.files[0] : null;
            if (!catImage) {
                document.getElementById('error-image').textContent = "Please select an image";
                valid = false;
            }
            
            if (!valid) {
                return;
            }
            
            var formData = new FormData();
            formData.append('cat-name', catName);
            formData.append('year', year);
            formData.append('month', month);
            formData.append('gender', document.getElementById('gender').value);
            formData.append('phone', phone);
            formData.append('address', document.getElementById('address').value);
            formData.append('additional', document.getElementById('additional').value);
            formData.append('description', document.getElementById('description').value);
            formData.append('cat-image', catImage);
            formData.append('userId', '<%= userId %>');
            
            var xhrSubmit = new XMLHttpRequest();
            xhrSubmit.open('POST', 'create-cat.jsp', true);
            xhrSubmit.onreadystatechange = function() {
                if (xhrSubmit.readyState === 4) {
                    if (xhrSubmit.status === 200) {
                        try {
                            var data = JSON.parse(xhrSubmit.responseText);
                            if (data.success) {
                                showToast("Cat posted successfully!", "success");
                                postForm.reset();
                            } else {
                                showToast("Failed to post cat: " + data.message, "error");
                            }
                        } catch (e) {
                            showToast("Error parsing server response", "error");
                        }
                    } else {
                        showToast("Error posting cat", "error");
                    }
                }
            };
            xhrSubmit.send(formData);
        });
    }
});
