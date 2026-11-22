document.addEventListener('DOMContentLoaded', function () {

    // CONFIG
	
    const CLOUDINARY_CLOUD_NAME = 'dyvqe1hgj';
    const CLOUDINARY_UPLOAD_PRESET = 'nekodop';

    const BYTES_PER_MB = 1024 * 1024;
    const MAX_IMAGE_MB = 5;
    const MAX_VIDEO_MB = 25;

    // Element ids for the "Post cat" form
    const POST_FORM_CONFIG = {
        errorPrefix: 'error-',
        ids: {
            name: 'cat-name',
            phone: 'phone',
            year: 'year',
            month: 'month',
            gender: 'gender',
            address: 'address',
            additional: 'additional',
            description: 'description',
            image: 'cat-image',
            video: 'cat-video'
        }
    };

    // Element ids for the "Edit cat" form
    const EDIT_FORM_CONFIG = {
        errorPrefix: 'edit-error-',
        ids: {
            name: 'edit-cat-name',
            phone: 'edit-phone',
            year: 'edit-year',
            month: 'edit-month',
            gender: 'edit-gender',
            address: 'edit-address',
            additional: 'edit-additional',
            description: 'edit-description',
            image: 'edit-cat-image-new',
            video: 'edit-cat-video-new'
        }
    };

    // 2. SMALL HELPERS
     
    function getEl(id) {
        return document.getElementById(id);
    }

    function getValue(id) {
        const el = getEl(id);
        return el ? el.value.trim() : '';
    }

    function setValue(id, value) {
        const el = getEl(id);
        if (el) el.value = (value === null || value === undefined) ? '' : value;
    }

    function setText(id, text) {
        const el = getEl(id);
        if (el) el.textContent = text;
    }

    function openModal(modal) {
        if (!modal) return;
        modal.classList.remove('hidden');
        modal.classList.add('modal');
    }

    function closeModal(modal) {
        if (!modal) return;
        modal.classList.add('hidden');
        modal.classList.remove('modal');
    }

    function reloadPage(delayMs) {
        setTimeout(function () {
            location.reload();
        }, delayMs);
    }

    function clearErrors() {
        const errors = document.querySelectorAll('.error');
        errors.forEach(function (el) {
            el.textContent = '';
        });
    }

    // Shows the message inside its error element; falls back to a toast if the element doesn't exist
    function showFieldError(errorId, message) {
        const el = getEl(errorId);
        if (el) {
            el.textContent = message;
        } else {
            showToast(message, 'error');
        }
    }

    // FILE SIZE VALIDATION 
  
    function getFileSizeError(file, type) {
        if (!file) return '';

        const isVideo = (type === 'video');
        const limitMb = isVideo ? MAX_VIDEO_MB : MAX_IMAGE_MB;
        const label = isVideo ? 'Video' : 'Image';

        if (file.size > limitMb * BYTES_PER_MB) {
            const sizeMb = (file.size / BYTES_PER_MB).toFixed(1);
            return label + ' must be ' + limitMb + 'MB or smaller (selected: ' + sizeMb + 'MB)';
        }
        return '';
    }

    // CLOUDINARY UPLOAD

    async function uploadToCloudinary(file, resourceType) {
        const label = (resourceType === 'video') ? 'Video' : 'Image';

        const formData = new FormData();
        formData.append('file', file);
        formData.append('upload_preset', CLOUDINARY_UPLOAD_PRESET);
        formData.append('cloud_name', CLOUDINARY_CLOUD_NAME);

        const url = 'https://api.cloudinary.com/v1_1/' + CLOUDINARY_CLOUD_NAME + '/' + resourceType + '/upload';

        try {
            const res = await fetch(url, { method: 'POST', body: formData });
            if (!res.ok) throw new Error('Upload failed: ' + res.status);
            const data = await res.json();
            return data.secure_url;
        } catch (error) {
            console.error('Upload error:', error);
            throw new Error(label + ' upload failed');
        }
    }

    //INITIAL TOAST
   
    showToast('Make sure phone number has WhatsApp', 'info');

    // SECTION SWITCHING (Post / My Cats)

    const SECTION_IDS = ['post-section', 'my-cats-section'];

    function showSection(sectionId, tabId) {
        SECTION_IDS.forEach(function (id) {
            const el = getEl(id);
            if (el) el.style.display = 'none';
        });

        const activeSection = getEl(sectionId);
        if (activeSection) activeSection.style.display = 'block';

        const profileLinks = document.querySelectorAll('.profile-links li');
        profileLinks.forEach(function (link) {
            link.classList.remove('active');
        });

        const activeTab = getEl(tabId);
        if (activeTab) activeTab.classList.add('active');
    }

    const postTab = getEl('post-tab');
    const myCatsTab = getEl('my-cats-tab');

    if (postTab && myCatsTab) {
        postTab.addEventListener('click', function () {
            showSection('post-section', 'post-tab');
        });
        myCatsTab.addEventListener('click', function () {
            showSection('my-cats-section', 'my-cats-tab');
        });
    }

    //EDIT PROFILE MODAL (open/close + tabs)

    const editProfileModal = getEl('edit-profile-modal');
    const openBtnProfile = document.querySelector('.edit-profile-btn');
    const closeBtnProfile = document.querySelector('.close-btn-profile');
    const tabPersonal = getEl('tab-personal');
    const tabPassword = getEl('tab-password');
    const personalForm = getEl('edit-profile-form');
    const changePasswordForm = getEl('change-password-form');

    if (openBtnProfile) {
        openBtnProfile.addEventListener('click', function () {
            openModal(editProfileModal);
        });
    }

    if (closeBtnProfile) {
        closeBtnProfile.addEventListener('click', function () {
            closeModal(editProfileModal);
        });
    }

    function switchProfileTab(showTab, hideTab, showForm, hideForm) {
        showTab.classList.add('active');
        hideTab.classList.remove('active');
        showForm.classList.remove('hidden');
        hideForm.classList.add('hidden');
    }

    if (tabPersonal && tabPassword && personalForm && changePasswordForm) {
        tabPersonal.addEventListener('click', function () {
            switchProfileTab(tabPersonal, tabPassword, personalForm, changePasswordForm);
        });
        tabPassword.addEventListener('click', function () {
            switchProfileTab(tabPassword, tabPersonal, changePasswordForm, personalForm);
        });
    }

    //PROFILE PICTURE PREVIEW (with size validation)
	
    const profilePicInput = getEl('edit-profile-picture');
    const profilePicPreview = getEl('profile-picture-preview');

    if (profilePicInput && profilePicPreview) {
        profilePicInput.addEventListener('change', function () {
            if (!this.files || !this.files[0]) return;

            const sizeError = getFileSizeError(this.files[0], 'image');
            if (sizeError) {
                showToast(sizeError, 'error');
                this.value = ''; // clear the invalid selection
                return;
            }

            const reader = new FileReader();
            reader.onload = function (e) {
                profilePicPreview.src = e.target.result;
            };
            reader.readAsDataURL(this.files[0]);
        });
    }

    // UPDATE PROFILE (name, email, picture)

    if (personalForm) {
        personalForm.addEventListener('submit', async function (e) {
            e.preventDefault();

            const name = getValue('edit-name');
            const email = getValue('edit-email');
            const file = profilePicInput ? profilePicInput.files[0] : null;

            let profilePictureUrl = profilePicPreview ? profilePicPreview.src : '';

            const sizeError = getFileSizeError(file, 'image');
            if (sizeError) {
                showToast(sizeError, 'error');
                return;
            }

            try {
                if (file) {
                    profilePictureUrl = await uploadToCloudinary(file, 'image');
                }

                const res = await fetch('update-user.jsp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        name: name,
                        email: email,
                        profilePicture: profilePictureUrl
                    })
                });

                const data = await res.json();

                if (data.success) {
                    showToast('Profile updated successfully.', 'success');
                    reloadPage(3000);
                } else {
                    showToast(data.error || 'Failed to update profile.', 'error');
                }
            } catch (err) {
                console.error(err);
                showToast(err.message || 'Something went wrong while updating user.', 'error');
            }
        });
    }

    // CHANGE PASSWORD
    function validatePassword(password) {
        if (!password) return { isValid: false, error: 'Password is required' };

        const errors = [];

        if (password.length < 8) errors.push('at least 8 characters');
        if (!/[A-Z]/.test(password)) errors.push('one uppercase letter');
        if (!/[a-z]/.test(password)) errors.push('one lowercase letter');
        if (!/\d/.test(password)) errors.push('one digit');
        if (!/[!@#$%^&*(),.?":{}|<>]/.test(password)) errors.push('one special character');

        if (errors.length === 0) return { isValid: true };

        return {
            isValid: false,
            error: 'Password must contain: ' + errors.join(', ')
        };
    }

    if (changePasswordForm) {
        changePasswordForm.addEventListener('submit', async function (e) {
            e.preventDefault();

            // Clear previous error messages
            setText('current-password-error', '');
            setText('new-password-error', '');
            setText('confirm-password-error', '');

            const currentPassword = getValue('current-password');
            const newPassword = getValue('new-password');
            const confirmPassword = getValue('confirm-password');

            // Client-side validation
            if (!currentPassword) {
                setText('current-password-error', 'Current password is required');
                return;
            }

            const validation = validatePassword(newPassword);
            if (!validation.isValid) {
                setText('new-password-error', validation.error);
                return;
            }

            if (newPassword !== confirmPassword) {
                setText('confirm-password-error', 'New passwords do not match!');
                return;
            }

            try {
                const res = await fetch('update-password.jsp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({
                        currentPassword: currentPassword,
                        newPassword: newPassword
                    })
                });

                const resultText = await res.text();
                let data;

                try {
                    data = JSON.parse(resultText);
                } catch (parseError) {
                    console.error('JSON parse error:', parseError);
                    showToast('Invalid server response', 'error');
                    return;
                }

                if (res.status === 401) {
                    setText('current-password-error', data.error || 'Current password is incorrect!');
                    return;
                }

                if (res.status === 400) {
                    setText('new-password-error', data.error || 'Invalid new password format');
                    return;
                }

                if (res.ok) {
                    showToast('Password updated successfully!', 'success');
                    changePasswordForm.reset();
                    closeModal(editProfileModal);
                    reloadPage(3000);
                } else {
                    showToast(data.error || 'Password update failed', 'error');
                }
            } catch (err) {
                console.error('Password update error:', err);
                showToast('Network error: ' + err.message, 'error');
            }
        });
    }

    // LOGOUT

    const logoutBtn = getEl('logout-btn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function () {
            window.location.href = 'logout.jsp';
        });
    }

    //12. DELETE CAT

    async function deleteCat(catCard) {
        const catId = catCard.dataset.id;
        const nameEl = catCard.querySelector('h3');
        const nameText = nameEl ? nameEl.textContent : 'this cat';

        if (!confirm('Are you sure you want to delete "' + nameText + '"?')) return;

        try {
            const res = await fetch('delete-cat.jsp', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'id=' + encodeURIComponent(catId)
            });
            const data = await res.json();

            if (data.success) {
                showToast('Cat deleted successfully', 'success');
                catCard.remove();
            } else {
                showToast(data.message || 'Failed to delete cat', 'error');
            }
        } catch (err) {
            console.error(err);
            showToast('Network error', 'error');
        }
    }

    const deleteBtns = document.querySelectorAll('.delete-cat');
    deleteBtns.forEach(function (btn) {
        btn.addEventListener('click', function () {
            const catCard = this.closest('.cat-card');
            if (catCard) deleteCat(catCard);
        });
    });
  

    // Reads + validates a cat form. 
    function readCatForm(config, isImageRequired) {
        clearErrors();

        const ids = config.ids;
        const prefix = config.errorPrefix;
        let isValid = true;

        function fail(errorKey, message) {
            showFieldError(prefix + errorKey, message);
            isValid = false;
        }

        // Name
        const name = getValue(ids.name);
        if (!name) fail('cat-name', 'Cat name is required');

        // Phone
        const phone = getValue(ids.phone);
        if (!/^01\d{9}$/.test(phone)) {
            fail('phone', 'Invalid format. 11 digits starting with 01');
        }

        // Age
        const year = parseInt(getValue(ids.year), 10);
        if (isNaN(year) || year < 0 || year > 25) fail('year', 'Must be between 0-25');

        const month = parseInt(getValue(ids.month), 10);
        if (isNaN(month) || month < 0 || month > 12) fail('month', 'Must be between 0-12');

        // Image
        const imageInput = getEl(ids.image);
        const imageFile = imageInput ? imageInput.files[0] : null;
        if (!imageFile && isImageRequired) {
            fail('image', 'Please select an image');
        } else {
            const imageError = getFileSizeError(imageFile, 'image');
            if (imageError) fail('image', imageError);
        }

        // Video (always optional)
        const videoInput = getEl(ids.video);
        const videoFile = videoInput ? videoInput.files[0] : null;
        const videoError = getFileSizeError(videoFile, 'video');
        if (videoError) fail('video', videoError);

        return {
            isValid: isValid,
            imageFile: imageFile,
            videoFile: videoFile,
            data: {
                name: name,
                year: year,
                month: month,
                phone: phone,
                gender: getValue(ids.gender),
                address: getValue(ids.address),
                additional: getValue(ids.additional),
                description: getValue(ids.description)
            }
        };
    }

    // Uploads new image/video 
    async function uploadCatMedia(form, currentImageUrl, currentVideoUrl) {
        let imageUrl = currentImageUrl;
        let videoUrl = currentVideoUrl;

        if (form.imageFile) {
            showToast('Uploading image...', 'info');
            imageUrl = await uploadToCloudinary(form.imageFile, 'image');
        }

        if (form.videoFile) {
            showToast('Uploading video...', 'info');
            videoUrl = await uploadToCloudinary(form.videoFile, 'video');
        }

        return { imageUrl: imageUrl, videoUrl: videoUrl };
    }

    // Builds the request body shared by create-cat.jsp and update-cat.jsp
    function buildCatParams(data, media) {
        const params = new URLSearchParams();
        params.append('catName', data.name);
        params.append('year', data.year);
        params.append('month', data.month);
        params.append('catGender', data.gender);
        params.append('ownerPhone', data.phone);
        params.append('ownerAddress', data.address);
        params.append('additionalInfo', data.additional);
        params.append('catDescription', data.description);
        params.append('catImageUrl', media.imageUrl);
        params.append('catVideoUrl', media.videoUrl);
        return params;
    }

    // POSTs url-encoded params and returns parsed JSON
    async function postParams(url, params) {
        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        });
        return await response.json();
    }

    //EDIT CAT/ Update 

    const editCatModal = getEl('edit-post-modal');
    const closeBtnEditCat = getEl('close-btn');
    const editCatForm = getEl('edit-post-form');

    async function loadCatData(catId) {
        try {
            const res = await fetch('get-cat.jsp?id=' + encodeURIComponent(catId));
            const cat = await res.json();

            setValue('edit-cat-id', catId);
            setValue('edit-cat-name', cat.name);

            // Split age string (e.g. "2 years 3 months") into year / month
            const ageText = String(cat.age || '');
            const yearMatch = ageText.match(/(\d+)\s*year/);
            const monthMatch = ageText.match(/(\d+)\s*month/);
            setValue('edit-year', yearMatch ? yearMatch[1] : 0);
            setValue('edit-month', monthMatch ? monthMatch[1] : 0);

            setValue('edit-gender', cat.gender);
			setValue('edit-status', String(cat.adopted) === '1' ? '1' : '0');
            setValue('edit-phone', cat.phone);
            setValue('edit-address', cat.address);
            setValue('edit-additional', cat.additional);
            setValue('edit-description', cat.description);
            setValue('edit-cat-image-current', cat.image);
            setValue('edit-cat-video-current', cat.video || '');

            
            setValue(EDIT_FORM_CONFIG.ids.image, '');
            setValue(EDIT_FORM_CONFIG.ids.video, '');
            clearErrors();

            openModal(editCatModal);
        } catch (err) {
            console.error(err);
            showToast('Error loading cat data', 'error');
        }
    }

    const editCatBtns = document.querySelectorAll('.edit-cat');
    editCatBtns.forEach(function (btn) {
        btn.addEventListener('click', function () {
            const card = this.closest('.cat-card');
            if (card && card.dataset.id) {
                loadCatData(card.dataset.id);
            }
        });
    });

    if (closeBtnEditCat) {
        closeBtnEditCat.addEventListener('click', function () {
            closeModal(editCatModal);
        });
    }

    if (editCatForm) {
        editCatForm.addEventListener('submit', async function (e) {
            e.preventDefault();

            const form = readCatForm(EDIT_FORM_CONFIG, false); // image optional when editing
            if (!form.isValid) return;

            try {
                const media = await uploadCatMedia(
                    form,
                    getValue('edit-cat-image-current'),
                    getValue('edit-cat-video-current')
                );

                const params = buildCatParams(form.data, media);
                params.append('catId', getValue('edit-cat-id'));
                params.append('adoptStatus', getValue('edit-status'));

                const data = await postParams('update-cat.jsp', params);

                if (data.success) {
                    showToast('Updated successfully!', 'success');
                    reloadPage(2000);
                } else {
                    throw new Error(data.message || 'Update failed');
                }
            } catch (error) {
                console.error('Submission error:', error);
                showToast(error.message || 'An error occurred', 'error');
            }
        });
    }

    //POST CAT
  
    const postForm = getEl('post-form');

    if (postForm) {
        postForm.addEventListener('submit', async function (e) {
            e.preventDefault();

            const form = readCatForm(POST_FORM_CONFIG, true); // image required when posting
            if (!form.isValid) return;

            try {
                const media = await uploadCatMedia(form, '', '');
                const params = buildCatParams(form.data, media);

                const data = await postParams('create-cat.jsp', params);
                console.log(data);

                if (data.success) {
                    showToast('Posted successfully!', 'success');
                    postForm.reset();
                    reloadPage(3000);
                } else {
                    throw new Error(data.message || 'Post failed');
                }
            } catch (error) {
                console.error('Submission error:', error);
                showToast(error.message || 'An error occurred', 'error');
            }
        });
    }
});