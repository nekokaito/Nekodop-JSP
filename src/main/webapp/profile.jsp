<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.UUID" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Check if user is logged in
String userId = (String) session.getAttribute("userId");
if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
}

// Get user data from session
String userName = (String) session.getAttribute("userName");
String userEmail = (String) session.getAttribute("userEmail");
String userProfilePicture = (String) session.getAttribute("userProfilePicture");
String userRole = (String) session.getAttribute("userRole");
boolean isAdmin = "admin".equals(userRole);
String createdAtStr = (String) session.getAttribute("createdAt");

// Parse createdAt from string to Timestamp
Timestamp createdAt = null;
if (createdAtStr != null && !createdAtStr.isEmpty()) {
    try {
        createdAt = Timestamp.valueOf(createdAtStr); 
    } catch (IllegalArgumentException e) {
        
    }
}

// Calculate time since user joined
String joinTime = "";
if (createdAt != null) {
    long joinTimestamp = createdAt.getTime();
    long now = System.currentTimeMillis();
    long diff = now - joinTimestamp;
    
    long seconds = diff / 1000;
    long minutes = seconds / 60;
    long hours = minutes / 60;
    long days = hours / 24;
    
    if (days > 0) {
        joinTime = "joined " + days + " day" + (days != 1 ? "s" : "") + " ago";
    } else if (hours > 0) {
        joinTime = "joined " + hours + " hour" + (hours != 1 ? "s" : "") + " ago";
    } else if (minutes > 0) {
        joinTime = "joined " + minutes + " minute" + (minutes != 1 ? "s" : "") + " ago";
    } else {
        joinTime = "joined just now";
    }
}

// Fetch user's cats from database
List<Map<String, String>> userCats = new ArrayList<>();
try {
    Connection conn = DBConnection.getConnection();
    String sql = "SELECT * FROM cats WHERE cat_owner_id = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setString(1, userId);
    
    ResultSet rs = ps.executeQuery();
    
    while (rs.next()) {
        Map<String, String> cat = new HashMap<>();
        cat.put("id", rs.getString("id"));
        cat.put("name", rs.getString("cat_name"));
        cat.put("image", rs.getString("cat_image"));
        cat.put("age", rs.getString("cat_age"));
        cat.put("gender", rs.getString("cat_gender"));
        cat.put("description", rs.getString("cat_description"));
        cat.put("phone", rs.getString("owner_phone"));
        cat.put("address", rs.getString("owner_address"));
        cat.put("additional", rs.getString("additional_information"));
        cat.put("status", rs.getString("is_approved")); // 0-pending, 1-approved, 2-rejected
        cat.put("adopted", rs.getString("adopted"));
        
        userCats.add(cat);
    }
    
    rs.close();
    ps.close();
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
    <title>Profile - Nekodop</title>
    <link rel="icon" href="images/NekoDopLogoAlt.png" type="image/x-icon" />
    <link rel="stylesheet" href="styles/global.css" />
    <link rel="stylesheet" href="styles/navbar.css" />
    <link rel="stylesheet" href="styles/hero.css" />
    <link rel="stylesheet" href="styles/toast.css" />
    <link rel="stylesheet" href="styles/footer.css" />
    <link rel="stylesheet" href="styles/form.css" />
    <link rel="stylesheet" href="styles/card.css" />
    <link rel="stylesheet" href="styles/profile.css" />
    <link rel="stylesheet" href="styles/preloader.css">
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=DynaPuff:wght@400..700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
   
       
    </style>
</head>
<body>
    <!-- Preloader -->
    <div id="preloader" class="preloader">
        <img src="images/preloader.gif" alt="Loading..." />
    </div>
    
    <!-- Toast Container -->
    <div id="toast-container"></div>
    
    <div id="main-content" class="main-content">
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
        
        <main class="container">
            <div>
                <!-- Profile Section -->
                <div class="profile-container">
                    <div class="profile-image">
                        <img src="<%= userProfilePicture != null ? userProfilePicture : "images/profile.png" %>" 
                             alt="<%= userName != null ? userName : "User" %>" />
                    </div>

                    <div class="profile-info">
                        <div class="profile-name">
                            <h1><%= userName != null ? userName : "Username" %></h1>
                            <span class="edit-profile-btn"><i class="fa-solid fa-pen-to-square"></i></span>
                        </div>
                        <p><i class="fa-solid fa-at"></i> <%= userEmail != null ? userEmail : "email@example.com" %></p>
                        <% if (!joinTime.isEmpty()) { %>
                            <p><i class="fa-regular fa-calendar"></i> <%= joinTime %></p>
                        <% } %>
                    </div>
                </div>
                
                <!-- Edit Profile Modal -->
                <div id="edit-profile-modal" class="hidden">
                    <div class="modal-content">
                        <span class="close-btn-profile">&times;</span>
                        <h2>Edit Profile</h2>
                        <div class="sidebar-layout">
                            <!-- Sidebar -->
                            <div class="sidebar">
                                <button id="tab-personal" class="active">Personal Details</button>
                                <button id="tab-password">Change Password</button>
                            </div>

                            <!-- Content -->
                            <div class="content-area">
                                <!-- Personal Details Form -->
                                <form id="edit-profile-form" class="tab-content active">
                                    <div class="form-group">
                                        <label for="edit-name">Name</label>
                                        <input type="text" id="edit-name" value="<%= userName != null ? userName : "" %>"/>
                                        <span class="error" id="edit-name-error"></span>
                                    </div>
                                    <div class="form-group">
                                        <label for="edit-email">Email</label>
                                        <input type="email" id="edit-email" value="<%= userEmail != null ? userEmail : "" %>">
                                        <span class="error" id="edit-email-error"></span>
                                    </div>
                                    <div class="form-group">
                                        <label for="edit-profile-picture">Profile Picture</label>
                                        <input type="file" id="edit-profile-picture" accept="image/*" />
                                        <div id="profile-picture-preview-container">
                                            <img src="<%= userProfilePicture != null ? userProfilePicture : "images/profile.png" %>" 
                                                 id="profile-picture-preview" alt="Profile Picture Preview" />
                                        </div>
                                    </div>
                                    <button type="submit">Save Changes</button>
                                </form>

                                <!-- Change Password Form -->
                                <form id="change-password-form" class="tab-content hidden">
                                    <div class="form-group">
                                        <label for="current-password">Current Password</label>
                                        <input type="password" id="current-password" required />
                                        <span class="error" id="current-password-error"></span>
                                    </div>
                                    <div class="form-group">
                                        <label for="new-password">New Password</label>
                                        <input type="password" id="new-password" required />
                                        <span class="error" id="new-password-error"></span>
                                    </div>
                                    <div class="form-group">
                                        <label for="confirm-password">Confirm New Password</label>
                                        <input type="password" id="confirm-password" required />
                                        <span class="error" id="confirm-password-error"></span>
                                    </div>
                                    <button type="submit">Change Password</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Profile Links -->
                <ul class="profile-links">
                    <li id="post-tab" class="active">Post</li>
                    <li id="my-cats-tab">My Cats</li>
                </ul>

                <!-- Post Section -->
                <div id="post-section">
                    <form id="post-form">
                        <div class="form-group">
                            <label for="cat-name">Cat Name</label>
                            <input type="text" id="cat-name" required />
                            <span class="error" id="error-cat-name"></span>
                        </div>
                        <div class="post-row">
                            <div class="form-group">
                                <label for="year">Year</label>
                                <input min="0" max="25" type="number" id="year"/>
                                <span class="error" id="error-year"></span>
                            </div>
                            <div class="form-group">
                                <label for="month">Month</label>
                                <input min="0" max="12" type="number" id="month" required />
                                <span class="error" id="error-month"></span>
                            </div>
                            <div class="form-group">
                                <label for="gender">Gender</label>
                                <select id="gender" required>
                                    <option value="" disabled selected>Select gender</option>
                                    <option value="male">Male</option>
                                    <option value="female">Female</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="text" id="phone" required placeholder="01XXXXXXXXX - Only WhatsApp"/>
                                <span class="error" id="error-phone"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="cat-image">Cat Image</label>
                            <input type="file" id="cat-image" accept="image/*" />
                            <span class="error" id="error-image"></span>
                        </div>
                        <div class="form-group">
                            <label for="address">Address</label>
                            <input type="text" id="address" required />
                        </div>
                        <div class="form-group">
                            <label for="additional">Additional Information</label>
                            <input type="text" id="additional" required />
                        </div>
                        <div class="form-group">
                            <label for="description">Cat Description</label>
                            <textarea id="description" required></textarea>
                        </div>
                        <button type="submit">Post</button>
                    </form>
                </div>

                <!-- My Cats Section -->
                <div id="my-cats-section" style="display: none;">
                    <div id="cats-container">
                        <% if (userCats.isEmpty()) { %>
                            <div class="no-cats">
                                <img src="images/No_Cats.png" alt="No Cats Found" />
                                <p>No Cat Posts Found.</p>
                            </div>
                        <% } else { %>
                            <% for (Map<String, String> cat : userCats) { %>
                                <div class="cat-card card update-cat" data-id="<%= cat.get("id") %>">
                                    <img src="<%= cat.get("image") %>" alt="<%= cat.get("name") %>" />
                                    <div class="cat-card-body">
                                        <div class="cat-info">
                                            <div class="cat-name">
                                                <h3><%= cat.get("name") %></h3>
                                                <% 
                                                    String status = cat.get("status");
                                                    String badgeClass = "";
                                                    String statusText = "";
                                                    
                                                    if ("1".equals(status)) {
                                                        badgeClass = "badge-approved";
                                                        statusText = "Approved";
                                                    } else if ("2".equals(status)) {
                                                        badgeClass = "badge-rejected";
                                                        statusText = "Rejected";
                                                    } else {
                                                        badgeClass = "badge-pending";
                                                        statusText = "Pending";
                                                    }
                                                %>
                                                <span class="badge <%= badgeClass %>"><%= statusText %></span>
                                            </div>
                                            <p><%= cat.get("age") %></p>
                                            <p><%= cat.get("gender") %></p>
                                        </div>
                                        <div class="card-actions">
                                            <div class="tooltip-container">
                                                <button class="btn edit-cat" data-id="<%= cat.get("id") %>"><i class="fa-solid fa-pen-to-square"></i></button>
                                                <span class="tooltip-text">Edit Details</span>
                                            </div>
                                            <div class="tooltip-container">
                                                <button class="btn delete-cat"><i class="fa-solid fa-trash"></i></button>
                                                <span class="tooltip-text">Delete</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        <% } %>
                    </div>

                    <!-- Edit Post Modal -->
                    <div id="edit-post-modal" class="hidden">
                        <div class="modal-content">
                            <span id="close-btn" class="close-btn">&times;</span>
                            <h2>Edit Cat Post</h2>
                            <form id="edit-post-form">
                                <div class="form-group">
                                    <label for="edit-cat-name">Cat Name</label>
                                    <input type="hidden" id="edit-cat-id" name="catId"> 
                                    <input type="text" id="edit-cat-name" required />
                                    <span class="error" id="edit-error-cat-name"></span>
                                </div>
                                <div class="post-row">
                                    <div class="form-group">
                                        <label for="edit-year">Year</label>
                                        <input min="0" max="25" type="number" id="edit-year"/>
                                        <span class="error" id="edit-error-year"></span>
                                    </div>
                                    <div class="form-group">
                                        <label for="edit-month">Month</label>
                                        <input min="0" max="12" type="number" id="edit-month" required />
                                        <span class="error" id="edit-error-month"></span>
                                    </div>
                                    <div class="form-group">
                                        <label for="edit-gender">Gender</label>
                                        <select id="edit-gender" required>
                                            <option value="" disabled>Select gender</option>
                                            <option value="male">Male</option>
                                            <option value="female">Female</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="edit-status">Adopt Status</label>
                                        <select id="edit-status" required>
                                            <option value="" disabled>Select status</option>
                                            <option value="0">Not Yet</option>
                                            <option value="1">Yes Adopted</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="edit-phone">Phone Number</label>
                                        <input type="text" id="edit-phone" required />
                                        <span class="error" id="edit-error-phone"></span>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <input type="hidden" id="edit-cat-image-current" />
                                    <label for="edit-cat-image-new">Update Cat Image</label>
                                    <input type="file" id="edit-cat-image-new" accept="image/*" />  
                                    <span class="error" id="edit-error-image"></span>
                                </div>
                                <div class="form-group">
                                    <label for="edit-address">Address</label>
                                    <input type="text" id="edit-address" required />
                                </div>
                                <div class="form-group">
                                    <label for="edit-additional">Additional Information</label>
                                    <input type="text" id="edit-additional" required />
                                </div>
                                <div class="form-group">
                                    <label for="edit-description">Cat Description</label>
                                    <textarea id="edit-description" required></textarea>
                                </div>
                                <button type="submit">Update</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Footer -->
    <footer id="footer-content" class="footer">
        <div class="footer-logo">
            <img class="footer-logo-img" src="images/NekoDopLogo.png" alt="Nekodop Logo" />
        </div>
        <div class="company-name">Nekodop</div>
        <div class="tagline">Cozy community built for cat lovers</div>
        <div class="copyright">Copyright © 2025 - All right reserved</div>
        <div class="social-icons">
            <a href="https://x.com" class="social-icon" target="blank"><i class="fab fa-twitter"></i></a>
            <a href="https://youtube.com" class="social-icon" target="blank"><i class="fab fa-youtube"></i></a>
            <a href="https://facebook.com" target="blank" class="social-icon"><i class="fab fa-facebook-f"></i></a>
        </div>
    </footer>
    <script src="scripts/main.js"></script>
    <script src="scripts/toast.js"></script>
    <script src="https://kit.fontawesome.com/ef66a13064.js" crossorigin="anonymous"></script>
    <script src="scripts/profile.js"></script>
    <script src="scripts/user-nav.js"></script>
</body>
</html>