<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
// Check if user is logged in
String userId = (String) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");
String userProfilePicture = (String) session.getAttribute("userProfilePicture");
String userRole = (String) session.getAttribute("userRole");
boolean isAdmin = "admin".equals(userRole);

%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta
      http-equiv="Content-Security-Policy"
      content="upgrade-insecure-requests"
    />
    <title>Dashboard - Nekodop</title>
    <link rel="icon" href="images/NekoDopLogoAlt.png" type="image/x-icon" />
    <link rel="stylesheet" href="styles/global.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/dashboard.css">
    <link rel="stylesheet" href="styles/table.css" />
    <link rel="stylesheet" href="styles/toast.css" />
    <link rel="stylesheet" href="styles/navbar.css" />
    <link rel="stylesheet" href="styles/footer.css" />
    <link rel="stylesheet" href="styles/form.css" />
    <link rel="stylesheet" href="styles/card.css" />
    <link rel="stylesheet" href="styles/preloader.css" />
    <link rel="stylesheet" href="styles/profile.css" />
    <link rel="stylesheet" href="styles/feature.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=DynaPuff:wght@400..700&display=swap"
      rel="stylesheet"
    />
  </head>

  <body>
    <!-- Preloader -->
    <div id="preloader" class="preloader">
      <img src="images/preloader.gif" alt="" />
    </div>

    <main id="main-content">
      <nav class="navbar">
        <div class="logo-div">
          <a href="index.jsp" class="logo">Nekodop</a>
        </div>

        <ul class="nav-links">
          <li><a href="#dashboard">Dashboard</a></li>
          <li>
            <a href="#users">Users</a>
          </li>
          <li><a href="#posts">Posts</a></li>

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
      <div id="toast-container"></div>
      <div id="app" class="container">
        <!-- Dashboard Section -->
        <div id="dashboard" class="dashboard">
         <div style="background-image: url('images/bg-d.jpg');" class="dashboard-header">
            <div class="hero">
              <h1 class="hero-title">Welcome to Dashboard</h1>
              <div class="time-section">
                <div class="current-time" id="currentTime">12:00:00</div>
                <div class="current-date" id="currentDate">
                  Monday, January 1, 2024
                </div>
              </div>
            </div>
            <div class="dashboard-menu">
              <a href="index.jsp">
                <div class="counter-item">
                  <h3>Home</h3>
                  <p id=""><i class="fa-solid fa-house"></i></p>
                </div>
              </a>
              <a href="#users">
                <div class="counter-item">
                  <h3>Users</h3>
                  <p id=""><i class="fa-solid fa-users"></i></p>
                </div>
              </a>
              <a href="#posts">
                <div class="counter-item">
                  <h3>Posts</h3>
                  <p id=""><i class="fa-solid fa-file"></i></p>
                </div>
              </a>
              <a href="pages/profile.html">
                <div class="counter-item">
                  <h3>Profile</h3>
                  <p id=""><i class="fa-solid fa-user"></i></p>
                </div>
              </a>
            </div>
            <div class="user-profile">
              <img
                id="dashboard-profile-picture"
                src="<%= userProfilePicture != null ? userProfilePicture : "images/profile.png" %>"
                alt="User Profile"
                class="profile-picture"
              />
              <div class="user-info">
                <h3 id="dashboard-username"><% out.print(userName); %></h3>
                <p>Administrator</p>
              </div>
            </div>
          </div>

          <div class="dashboard-counters">
            <div class="counter-item">
              <h3>Total Users</h3>
              <p id="total-users">1,247</p>
            </div>
            <div class="counter-item">
              <h3>Approved Posts</h3>
              <p id="approved-count">856</p>
            </div>
            <div class="counter-item">
              <h3>Pending Posts</h3>
              <p id="pending-count">23</p>
            </div>
            <div class="counter-item">
              <h3>Rejected Posts</h3>
              <p id="rejected-count">12</p>
            </div>
          </div>
        </div>
        <!-- Users Section -->
        <div id="users" class="users">
          <div class="user-header">
            <h2 class="user-title">Users List</h2>
            <div class="user-description">
              All registered users are listed here.
            </div>
          </div>
          <div id="user-container">
            <table class="table">
              <!-- head -->
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Created At</th>
                  <th></th>
                </tr>
              </thead>
              <tbody id="user-list">
                <!-- user list  -->
                <tr>
                  <td colspan="4" class="text-center">Loading users...</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Posts Section -->
        <div id="posts" class="posts">
          <div class="posts-header">
            <h2 class="posts-title">Recent Posts</h2>
            <div class="posts-description">
              Here you can find the latest posts from our community.
            </div>
          </div>
          <div class="posts-tools">
            <div class="posts-actions">
              <button id="refresh-posts" class="refresh-btn">
                <i class="fa-solid fa-arrows-rotate"></i>
              </button>
            </div>
            <div class="posts-filter">
              <select id="filter" class="filter-select">
                <option value="pending">Pending</option>
                <option value="approved">Approved</option>
                <option value="rejected">Rejected</option>
                <option value="all">All</option>
              </select>
            </div>
          </div>
          <div class="card-container" id="post-container">
            <p>Loading posts...</p>
          </div>
        </div>
      </div>
    </main>
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
      <div class="copyright">Copyright © 2025 - All right reserved</div>
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
  </body>
  <script
    src="https://kit.fontawesome.com/ef66a13064.js"
    crossorigin="anonymous"
  ></script>
  <script src="scripts/reponsive.js"></script>
  <script  src="scripts/main.js"></script>
  <script src="scripts/toast.js"></script>
  <script src="scripts/dashboard.js"></script>
  <script src="scripts/user-nav.js"></script>
  
</html>
