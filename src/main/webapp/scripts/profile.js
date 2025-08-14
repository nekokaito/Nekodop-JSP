document.addEventListener('DOMContentLoaded', function() {
    // Toast notification
    showToast("Make sure phone number has WhatsApp", "info");
    console.log('DOM loaded');

    // Section switching
    const postTab = document.getElementById('post-tab');
    const myCatsTab = document.getElementById('my-cats-tab');
    
    if (postTab && myCatsTab) {
        postTab.addEventListener('click', function() {
            showSection('post-section', 'post-tab');
        });
        myCatsTab.addEventListener('click', function() {
            showSection('my-cats-section', 'my-cats-tab');
        });
    }

    function showSection(sectionId, tabId) {
        const sections = ['post-section', 'my-cats-section'];
        sections.forEach(function(id) {
            const el = document.getElementById(id);
            if (el) el.style.display = 'none';
        });

        const activeSection = document.getElementById(sectionId);
        if (activeSection) activeSection.style.display = 'block';

        const profileLinks = document.querySelectorAll('.profile-links li');
        profileLinks.forEach(function(link) {
            link.classList.remove('active');
        });
        
        const activeTab = document.getElementById(tabId);
        if (activeTab) activeTab.classList.add('active');
    }

    // Modal functionality
    const editProfileBtn = document.querySelector('.edit-profile-btn');
    const editProfileModal = document.getElementById('edit-profile-modal');
    const closeProfileModal = document.querySelector('.close-btn-profile');
    const closePostModal = document.querySelector('.close-btn');
    const editPostModal = document.getElementById('edit-post-modal');

    if (editProfileBtn && editProfileModal) {
        editProfileBtn.addEventListener('click', function() {
            editProfileModal.classList.remove("hidden");
        });
    }

    if (closeProfileModal && editProfileModal) {
        closeProfileModal.addEventListener('click', function() {
            editProfileModal.classList.add("hidden");
        });
    }

    if (closePostModal && editPostModal) {
        closePostModal.addEventListener('click', function() {
            editPostModal.classList.remove('show');
        });
    }

    // Tab switching in edit profile modal
    const tabPersonal = document.getElementById("tab-personal");
    const tabPassword = document.getElementById("tab-password");
    const personalForm = document.getElementById("edit-profile-form");
    const changePasswordForm = document.getElementById("change-password-form");

    if (tabPersonal && tabPassword && personalForm && changePasswordForm) {
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
    }

    // Profile image preview
    const profilePicInput = document.getElementById('edit-profile-picture');
    const profilePicPreview = document.getElementById('profile-picture-preview');
    
    if (profilePicInput && profilePicPreview) {
        profilePicInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    profilePicPreview.src = e.target.result;
                };
                reader.readAsDataURL(this.files[0]);
            }
        });
    }

    // Logout functionality
    const logoutBtn = document.getElementById('logout-btn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function() {
            window.location.href = 'logout.jsp';
        });
    }

    // Delete cat functionality
    const deleteBtns = document.querySelectorAll('.delete-cat');
    deleteBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            const catCard = this.closest('.cat-card');
            if (!catCard) return;

            const catId = catCard.dataset.id;
            const catName = catCard.querySelector('h3');
            const nameText = catName ? catName.textContent : 'this cat';

            if (confirm('Are you sure you want to delete "' + nameText + '"?')) {
                fetch('delete-cat.jsp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'id=' + encodeURIComponent(catId)
                })
                .then(function(res) {
                    return res.json();
                })
                .then(function(data) {
                    if (data.success) {
                        showToast("Cat deleted successfully", "success");
                        catCard.remove();
                    } else {
                        showToast(data.message || "Failed to delete cat", "error");
                    }
                })
                .catch(function() {
                    showToast("Network error", "error");
                });
            }
        });
    });

    // Edit cat functionality
    const editBtns = document.querySelectorAll('.edit-cat');
    editBtns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            const catCard = this.closest('.cat-card');
            if (!catCard || !editPostModal) return;
            
            const catId = catCard.dataset.id;
            const catName = catCard.querySelector('h3');
            const nameText = catName ? catName.textContent : '';
            
            document.getElementById('edit-cat-name').value = nameText;
            editPostModal.classList.add('show');
        });
    });

    // Cloudinary image upload
    function uploadImageToCloudinary(file) {
        return new Promise(function(resolve, reject) {
            const formData = new FormData();
            formData.append("file", file);
            formData.append("upload_preset", "nekodop");
            formData.append("cloud_name", "dyvqe1hgj");

            fetch("https://api.cloudinary.com/v1_1/dyvqe1hgj/image/upload", {
                method: "POST",
                body: formData
            })
            .then(function(res) {
                if (!res.ok) throw new Error("Upload failed: " + res.status);
                return res.json();
            })
            .then(function(data) {
                resolve(data.secure_url);
            })
            .catch(function(error) {
                console.error("Upload error:", error);
                reject(new Error("Image upload failed"));
            });
        });
    }

    // Form submission handling
    const postForm = document.getElementById('post-form');
    if (postForm) {
        postForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            let isValid = true;

            // Clear previous errors
            const errors = document.querySelectorAll('.error');
            errors.forEach(function(el) {
                el.textContent = '';
            });

            // Validation helpers
            function showError(fieldId, message) {
                const errorEl = document.getElementById('error-' + fieldId);
                if (errorEl) errorEl.textContent = message;
                isValid = false;
            }

            // Validate fields
            const catNameEl = document.getElementById('cat-name');
            const catName = catNameEl.value.trim();
            if (!catName) showError('cat-name', "Cat name is required");

            const phoneEl = document.getElementById('phone');
            const phone = phoneEl.value.trim();
            if (!/^01\d{9}$/.test(phone)) {
                showError('phone', "Invalid format. 11 digits starting with 01");
            }

            const yearEl = document.getElementById('year');
            const year = parseInt(yearEl.value, 10);
            if (isNaN(year) || year < 0 || year > 25) {
                showError('year', "Must be between 0-25");
            }

            const monthEl = document.getElementById('month');
            const month = parseInt(monthEl.value, 10);
            if (isNaN(month) || month < 0 || month > 12) {
                showError('month', "Must be between 0-12");
            }

            const catImageInput = document.getElementById('cat-image');
            const catImage = catImageInput.files[0];
            if (!catImage) showError('image', "Please select an image");

            if (!isValid) return;

            try {
                // Upload image to Cloudinary
                const imageUrl = await uploadImageToCloudinary(catImage);
                
                // Prepare form data with correct parameter names
				const params = new URLSearchParams();
				params.append('catName', catName);
				params.append('year', year);
				params.append('month', month);
				params.append('catGender', document.getElementById('gender').value);
				params.append('ownerPhone', phone);
				params.append('ownerAddress', document.getElementById('address').value.trim());
				params.append('additionalInfo', document.getElementById('additional').value.trim());
				params.append('catDescription', document.getElementById('description').value.trim());
				params.append('catImageUrl', imageUrl); // From Cloudinary

				const response = await fetch('create-cat.jsp', {
				  method: 'POST',
				  headers: { 
				    'Content-Type': 'application/x-www-form-urlencoded' // Correct header
				  },
				  body: params
				});

                // Handle response
                const data = await response.json();
				console.log(data)
                if (data.success) {
                    showToast("Posted successfully!", "success");
                    postForm.reset();
                } else {
                    throw new Error(data.message || "Post failed");
                }
            } catch (error) {
                console.error("Submission error:", error);
                showToast(error.message || "An error occurred", "error");
            }
        });
    }
});