<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.InputStream" %>
<%
    // Handle form submission
    boolean registrationSuccess = false;
    String message = null;
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String userId = java.util.UUID.randomUUID().toString();
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("re-password");
        String profilePhotoUrl = request.getParameter("profilePhotoUrl");  

        // ==== backend password validation ====
        String passwordError = null;
        if (password == null || password.trim().length() < 8) {
            passwordError = "Password must be at least 8 characters long.";
        } else if (!password.matches(".*[A-Z].*")) {
            passwordError = "Password must contain at least one uppercase letter.";
        } else if (!password.matches(".*[a-z].*")) {
            passwordError = "Password must contain at least one lowercase letter.";
        } else if (!password.matches(".*\\d.*")) {
            passwordError = "Password must contain at least one digit.";
        } else if (!password.matches(".*[!@#$%^&*(),.?\":{}|<>].*")) {
            passwordError = "Password must contain at least one special character.";
        }

        if (name == null || email == null || password == null || rePassword == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || password.isEmpty() || rePassword.isEmpty()) {
            message = "All fields are required!";
        } else if (!password.equals(rePassword)) {
            message = "Passwords do not match!";
        } else if (passwordError != null) {
            message = passwordError;
        } else {
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                conn = DBConnection.getConnection();

                // Check if email already exists
                ps = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE email = ?");
                ps.setString(1, email);
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    message = "Email is already registered!";
                } else {
                    // Close previous resources
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();

                    // Insert user data
                    ps = conn.prepareStatement(
                        "INSERT INTO users (id, name, email, password, profile_picture, user_role, created_at) " +
                        "VALUES (?, ?, ?, ?, ?, 'user', CURRENT_TIMESTAMP)"
                    );
                    ps.setString(1, userId);
                    ps.setString(2, name);
                    ps.setString(3, email);
                    ps.setString(4, password); 
                    if (profilePhotoUrl == null || profilePhotoUrl.trim().isEmpty()) {
                        ps.setNull(5, java.sql.Types.VARCHAR);
                    } else {
                        ps.setString(5, profilePhotoUrl);
                    }

                    int inserted = ps.executeUpdate();

                    if (inserted > 0) {
                        // query back inserted data
                        if (ps != null) ps.close();
                        ps = conn.prepareStatement("SELECT user_role, created_at FROM users WHERE id = ?");
                        ps.setString(1, userId);
                        rs = ps.executeQuery();

                        String userRole = "user";
                        String createdAt = "";
                        if (rs.next()) {
                            userRole = rs.getString("user_role");
                            createdAt = rs.getString("created_at");
                        }

                        // Save user info in session
                        session.setAttribute("userId", userId);
                        session.setAttribute("userName", name);
                        session.setAttribute("userEmail", email);
                        session.setAttribute("userProfilePicture", profilePhotoUrl);
                        session.setAttribute("userRole", userRole);
                        session.setAttribute("createdAt", createdAt);

                        registrationSuccess = true;
                        message = "Registration successful!";
                    } else {
                        message = "Registration failed, please try again.";
                    }
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch(Exception ignored) {}
                if (ps != null) try { ps.close(); } catch(Exception ignored) {}
                if (conn != null) try { conn.close(); } catch(Exception ignored) {}
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create Account - Nekodop</title>
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
    <link
      href="https://fonts.googleapis.com/css2?family=DynaPuff:wght@400..700&display=swap"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="signup-body">
    <div id="toast-container"></div>
    <div class="back">
      <a href="index.jsp">
        <div class="back-home">
          <i class="fa-solid fa-house-chimney"></i>
        </div>
      </a>
    </div>
    <div class="contact-container">
      <section class="form-section">
        <div class="logo">
          <span class="logo-text">Sign Up</span>
        </div>

        <form id="signup-form" method="post" action="signup.jsp">
          <div class="form-row"></div>
          <div class="form-group">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" required/>
          </div>
          <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" required/>
          </div>
          <div class="form-group">
            <label for="profile-photo">Upload Profile Photo</label>
            <input type="file" id="profile-photo" accept="image/*" />
             <input type="hidden" name="profilePhotoUrl" id="profile-photo-url" />
          </div>
          <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" autocomplete="new-password" required />
          </div>
          <div class="form-group">
            <label for="re-password">Re-Password</label>
            <input type="password" id="re-password" name="re-password" autocomplete="new-password" required />
          </div>
           <button type="submit">Submit</button>
          <span class="form-footer">
            <p>
              Already Have an Account?
              <a href="login.jsp">Login</a>
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
                  <img
                    class="paper-plane paper-plane-img"
                    src="images/paperfly.png"
                    alt="Paper Plane"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
    <script src="scripts/toast.js"></script>
    <script>
      // === Cloudinary upload ===
      document.getElementById("profile-photo").addEventListener("change", async function() {
          const file = this.files[0];
          if (!file) return;

          try {
              const formData = new FormData();
              formData.append("file", file);
              formData.append("upload_preset", "nekodop");
              formData.append("cloud_name", "dyvqe1hgj");

              const res = await fetch(
                "https://api.cloudinary.com/v1_1/dyvqe1hgj/image/upload",
                {
                    method: "POST",
                    body: formData,
                }
              );

              const uploadedImg = await res.json();
              document.getElementById("profile-photo-url").value = uploadedImg.secure_url;
          } catch (err) {
              console.error("Upload error", err);
              alert("Failed to upload image");
          }
      });

      // === Password validation (frontend) ===
      const validatePassword = (password) => {
        password = password.trim(); 
        let error = null;

        if (password.length < 8) {
          error = "Password must be at least 8 characters long.";
        } else if (!/[A-Z]/.test(password)) {
          error = "Password must contain at least one uppercase letter.";
        } else if (!/[a-z]/.test(password)) {
          error = "Password must contain at least one lowercase letter.";
        } else if (!/\d/.test(password)) {
          error = "Password must contain at least one digit.";
        } else if (!/[!@#$%^&*(),.?\":{}|<>]/.test(password)) {
          error = "Password must contain at least one special character.";
        }

        return {
          isValid: error === null,
          error,
        };
      };

      document.getElementById("signup-form").addEventListener("submit", function (e) {
        const password = document.getElementById("password").value;
        const rePassword = document.getElementById("re-password").value;

        const { isValid, error } = validatePassword(password);

        if (!isValid) {
          e.preventDefault();
          
          showToast(error, "error");
          return;
        }

        if (password !== rePassword) {
          e.preventDefault();
          showToast("Passwords do not match!", "error");
          return;
        }
      });

      <% if (message != null) { %>
        window.onload = function() {
          showToast("<%= message %>", "<%= registrationSuccess ? "success" : "error" %>");
          <% if (registrationSuccess) { %>
            setTimeout(function() {
              window.location.href = "index.jsp";
            }, 2000);
          <% } %>
        }
      <% } %>
    </script>
</body>
</html>
