// Handle user menu dropdown
        document.addEventListener('DOMContentLoaded', function() {
            const userMenu = document.querySelector('.user-menu');
            if (userMenu) {
                const userIcon = userMenu.querySelector('.user-icon');
                const dropdownMenu = userMenu.querySelector('.dropdown-menu');
                
                userIcon.addEventListener('click', function(e) {
                    e.stopPropagation();
                    dropdownMenu.classList.toggle('show');
                });
                
                document.addEventListener('click', function() {
                    dropdownMenu.classList.remove('show');
                });
                
                // Logout functionality
                const logoutBtn = document.getElementById('logout-btn');
                if (logoutBtn) {
                    logoutBtn.addEventListener('click', function() {
                        // Redirect to logout page
                        window.location.href = 'logout.jsp';
                    });
                }
            }
            
            // Preloader timeout
            setTimeout(function() {
                document.getElementById('preloader').style.display = 'none';
                document.getElementById('main-content').style.display = 'block';
            }, 2000);
        });/**
 * 
 */