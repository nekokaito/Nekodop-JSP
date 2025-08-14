<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Check if user is already logged in
String userId = (String) session.getAttribute("userId");
if (userId != null) {
    response.sendRedirect("index.jsp");
    return;
}

// Handle login form submission
String message = null;
boolean isSuccess = false;
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    
    if (email == null || password == null || email.trim().isEmpty() || password.isEmpty()) {
        message = "Both email and password are required!";
    } else {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            
        	conn = DBConnection.getConnection();
            
            ps = conn.prepareStatement("SELECT * FROM users WHERE email = ?");
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                String dbPassword = rs.getString("password");
                if (password.equals(dbPassword)) {
                    // Login successful - set session attributes
                    session.setAttribute("userId", rs.getString("id"));
                    session.setAttribute("userName", rs.getString("name"));
                    session.setAttribute("userEmail", rs.getString("email"));
                    session.setAttribute("userProfilePicture", rs.getString("profile_picture"));
                    session.setAttribute("userRole", rs.getString("user_role"));
                    session.setAttribute("createdAt", rs.getString("created_at"));
                    // Set success message and flag
                    message = "Login successful! Redirecting...";
                    isSuccess = true;
                    
                    // Immediate redirect for successful login
                    response.sendRedirect("index.jsp");
                    return;
                } else {
                    message = "Incorrect password!";
                }
            } else {
                message = "No account found with that email!";
            }
        } catch (Exception e) {
            message = "Database error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (ps != null) try { ps.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests" />
    <title>Login - Nekodop</title>
    <link rel="icon" href="images/NekoDopLogoAlt.png" type="image/x-icon" />
    <link rel="stylesheet" href="styles/global.css" />
    <link rel="stylesheet" href="styles/navbar.css" />
    <link rel="stylesheet" href="styles/hero.css" />
    <link rel="stylesheet" href="styles/footer.css" />
    <link rel="stylesheet" href="styles/form.css" />
    <link rel="stylesheet" href="styles/card.css" />
    <link rel="stylesheet" href="styles/toast.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=DynaPuff:wght@400..700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<body class="login-body">
    <div id="toast-container"></div>
    <div class="back">
      <a href="/">
        <div class="back-home">
          <i class="fa-solid fa-house-chimney"></i>
        </div>
      </a>
    </div>

    <div class="contact-container">
      <section class="form-section">
        <div class="logo">
          <span class="logo-text">Login</span>
        </div>

        <% if (message != null && !isSuccess) { %>
            <div class="message" style="color: red; margin-bottom: 15px; text-align: center;">
                <%= message %>
            </div>
        <% } %>

        <form id="login-form" method="POST">
          <div class="form-row"></div>
          <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" required />
          </div>
          <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required />
            <div id="login-error" style="color: rgb(230, 112, 112); margin-top: 5px; font-size: small;"></div>
          </div>
          <button type="submit">Submit</button>
          <span class="form-footer">
            <p>
              Don't You have an account?
              <a href="signup.jsp">Register</a>
            </p>
          </span>
        </form>
      </section>

      <section class="content-section">
        <div class="content">
          <div class="illustration">
            <div class="paper-plane-wrapper">
              <div class="plane">
                <div class="trail">
                  <img class="paper-plane paper-plane-img" src="images/paperfly.png" alt="Paper Plane" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
    
    <script src="scripts/toast.js"></script>
    <script>
      // Show toast message if there's an error
      <% if (message != null && !isSuccess) { %>
        window.onload = function() {
          showToast("<%= message %>", "error");
        }
      <% } %>
    </script>
    <script src="https://kit.fontawesome.com/ef66a13064.js" crossorigin="anonymous"></script>
</body>
</html>