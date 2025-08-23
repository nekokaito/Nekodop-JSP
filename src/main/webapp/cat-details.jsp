<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// Check if user is logged in
String userId = (String) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");
String userProfilePicture = (String) session.getAttribute("userProfilePicture");
String userRole = (String) session.getAttribute("userRole");
boolean isAdmin = "admin".equals(userRole);


if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
}

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Nekodop - Cozy community built for cat lovers</title>
    <meta name="description" content="Nekodop is a community-driven cat adoption platform where you can discover, adopt, and support cats in need." />
    <meta name="keywords" content="Nekodop, cat adoption, adopt cats, pet rescue, cat shelter" />
    <meta name="author" content="Nekodop Team" />
    <link rel="icon" href="images/NekoDopLogoAlt.png" type="image/x-icon" />
    <link rel="stylesheet" href="styles/global.css" />
    <link rel="stylesheet" href="styles/toast.css" />
    <link rel="stylesheet" href="styles/navbar.css" />
    <link rel="stylesheet" href="styles/profile.css" />
    <link rel="stylesheet" href="styles/hero.css" />
    <link rel="stylesheet" href="styles/footer.css" />
    <link rel="stylesheet" href="styles/form.css" />
    <link rel="stylesheet" href="styles/card.css" />
    <link rel="stylesheet" href="styles/preloader.css" />
    <link rel="stylesheet" href="styles/feature.css" />
    <link rel="stylesheet" href="styles/support.css" />
    <link rel="stylesheet" href="styles/details.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=DynaPuff:wght@400..700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
   
</head>

<body>
    <!-- Preloader -->
    <div id="preloader" class="preloader">
        <img src="images/preloader.gif" alt="Loading..." />
    </div>
    
     <!-- Navbar -->
        <nav class="navbar">
            <div class="logo-div">
                <a href="index.jsp" class="logo">Nekodop</a>
            </div>

            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="index.jsp#explore">Explore</a></li>
                <li><a href="index.jsp#support">Support</a></li>
                <li><a href="index.jsp#gallery">Gallery</a></li>
                <li><a href="index.jsp#contact">Contact</a></li>
                <% if (userId == null) { %>
                    <li class="login-phn">
                        <a href="login.jsp"><button class="login-btn">Login</button></a>
                    </li>
                <% } %>
            </ul>

            <div class="user-nav">
                <% if (userId == null) { %>
                    <a href="login.jsp">
                        <button class="login-btn login-desktop">Login</button>
                    </a>
                <% } else { %>
                    <div class="user-menu">
                        <div class="user-icon">
                            <img src="<%= userProfilePicture != null ? userProfilePicture : "images/profile.png" %>" 
                                 alt="User" class="profile-img" />
                        </div>
                        <ul class="dropdown-menu">
                            <li><a href="profile.jsp"><i class="fa-regular fa-circle-user"></i> My Profile</a></li>
                            <% if (isAdmin) { %>
                                <li><a href="dashboard.jsp"><i class="fa-solid fa-calendar"></i> Dashboard</a></li>
                            <% } %>
                            <li><button id="logout-btn"><i class="fa-solid fa-right-from-bracket"></i> Logout</button></li>
                        </ul>
                    </div>
                <% } %>
            </div>
            <button class="hamburger">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </nav>
    
    <div class="cat-details">
        <div id="nav-home" class="nav-home">
          <a href="index.jsp#explore" class="return-btn">
            <i class="fas fa-arrow-left"></i>
            Back
          </a>
          
        </div>
        
        <div id="cat-info">
          <div class="loader-container">
            <span class="loader loader-white"></span>
            <div>
        </div>
      </div>
    </div>
    </div>
    <!-- Footer Section -->
      <footer id="footer-content" class="footer">
        <div class="footer-logo">
          <img
            class="footer-logo-img"
            src="images/NekoDopLogo.png"
            alt="Nekodop Logo"
          />
        </div>
        <div class="company-name">Nekodop</div>
        <div class="tagline">Cozy community built for cat lovers</div>
        <div class="copyright">Copyright © 2025 - All right reserved </div>
        <div class="social-icons">
          <a href="https://x.com" class="social-icon" target="blank"
          ><i class="fab fa-twitter"></i
        ></a>
        <a href="https://youtube.com" class="social-icon" target="blank"
          ><i class="fab fa-youtube"></i
        ></a>
        <a href="https://facebook.com" target="blank" class="social-icon"
          ><i class="fab fa-facebook-f"></i
        ></a>
        </div>
      </footer>
    <script src="https://kit.fontawesome.com/ef66a13064.js" crossorigin="anonymous"></script>
    <script src="scripts/reponsive.js"></script>
    <script src="scripts/toast.js"></script>
    <script src="scripts/main.js"></script>
    <script src="scripts/user-nav.js"></script>
    <script>
      const isAdmin = <%= isAdmin %>;
   </script>
    <script src="scripts/cat-details.js"></script>
</body>
</html>