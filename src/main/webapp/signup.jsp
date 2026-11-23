<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.InputStream" %>

<%
    // === redirect if already logged in ===
    if (session.getAttribute("userId") != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    boolean registrationSuccess = false;
    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String userId = java.util.UUID.randomUUID().toString();
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phone_number");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("re-password");
        String termsAccepted = request.getParameter("termsAccepted");
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

        if (name == null || email == null || phoneNumber == null || password == null || rePassword == null ||
            name.trim().isEmpty() || email.trim().isEmpty() || phoneNumber.trim().isEmpty() || password.isEmpty() || rePassword.isEmpty()) {
            message = "All fields are required!";
        } else if (!"on".equals(termsAccepted)) {
            message = "You must accept the Terms & Privacy Policy to create an account.";
        } else if (!phoneNumber.matches("01[0-9]{9}")) {
            message = "Phone number must be exactly 11 digits and start with 01.";
        } else if (!password.equals(rePassword)) {
            message = "Passwords do not match!";
        } else if (passwordError != null) {
            message = passwordError;
        } else if (profilePhotoUrl == null || profilePhotoUrl.trim().isEmpty()) {
            message = "Profile photo is required!";
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
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();

                    // Insert user data
                    ps = conn.prepareStatement(
                        "INSERT INTO users (id, name, email, phone_number, password, profile_picture, user_role, created_at) " +
                        "VALUES (?, ?, ?, ?, ?, ?, 'user', CURRENT_TIMESTAMP)"
                    );
                    ps.setString(1, userId);
                    ps.setString(2, name);
                    ps.setString(3, email);
                    ps.setString(4, phoneNumber.trim());
                    ps.setString(5, password);
                    ps.setString(6, profilePhotoUrl);

                    int inserted = ps.executeUpdate();

                    if (inserted > 0) {
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

                        session.setAttribute("userId", userId);
                        session.setAttribute("userName", name);
                        session.setAttribute("userEmail", email);
                        session.setAttribute("userPhone", phoneNumber.trim());
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
    <link href="https://fonts.googleapis.com/css2?family=DynaPuff:wght@400..700&display=swap" rel="stylesheet"/>
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
          <div class="form-group">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" required/>
          </div>
          <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" required/>
          </div>
          <div class="form-group">
            <label for="phone-number">Phone Number</label>
            <input type="tel" id="phone-number" name="phone_number" autocomplete="tel" inputmode="numeric" pattern="01[0-9]{9}" maxlength="11" minlength="11" placeholder="Your WhatsApp Number. Ex: 016XXXXXXXX" title="Enter 11 digits starting with 01" required />
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
          <div class="terms-consent">
            <input type="checkbox" id="terms-accepted" name="termsAccepted" required />
            <label for="terms-accepted">I agree to the <button type="button" class="terms-link" id="open-terms" aria-haspopup="dialog" aria-controls="terms-modal">Terms &amp; Privacy Policy</button>.</label>
          </div>
          <button type="submit" id="submit-btn" disabled>Submit</button>
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
                  <img class="paper-plane paper-plane-img" src="images/paperfly.png" alt="Paper Plane"/>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
    <div class="terms-modal" id="terms-modal" aria-hidden="true">
      <div class="terms-modal-backdrop" data-close-terms></div>
      <section class="terms-modal-panel" role="dialog" aria-modal="true" aria-labelledby="terms-title" tabindex="-1">
        <button type="button" class="terms-modal-close" aria-label="Close Terms &amp; Privacy Policy" data-close-terms>&times;</button>
        <div class="terms-modal-content">
          <h2 id="terms-title">Nekodop Terms &amp; Privacy Policy</h2>
          <p class="terms-last-updated">Last updated: Nov 23, 2026</p>

          <h3>1. Acceptance of Terms</h3>
          <p>By creating an account on Nekodop, you confirm that you have read, understood and agreed to these Terms &amp; Privacy Policy. If you do not agree, please do not sign up or use the website.</p>
          <p>Nekodop is a platform where people can post cats and kittens that need a home, and where others can find them and arrange an adoption.</p>

          <h3>2. Eligibility and Account Registration</h3>
          <ul>
            <li>You must be at least 18 years old, or use Nekodop under the supervision of a parent or guardian.</li>
            <li>You must give accurate information when you sign up, and keep it up to date.</li>
            <li>You are responsible for keeping your password safe and for all activity under your account.</li>
            <li>One person may have only one account. Fake or duplicate accounts may be removed.</li>
          </ul>

          <h3>3. Our Role: Platform Only</h3>
          <p>Nekodop only provides a place for users to meet. We are not an adoption agency, a shelter, a veterinarian or a party to any adoption.</p>
          <ul>
            <li>We do not own, house, inspect or transport any cat listed on the website.</li>
            <li>We do not check the health, vaccination status, behavior or background of any cat or user.</li>
            <li>Listings are written by users. We do not guarantee that they are accurate or complete.</li>
            <li>Every adoption is an agreement between the person giving the cat and the person adopting it.</li>
          </ul>

          <h3>4. WhatsApp Number Sharing and Privacy</h3>
          <p>To let adopters and posters reach each other, Nekodop shows the WhatsApp number you provide. By signing up, you agree to the following:</p>
          <ul>
            <li>Your WhatsApp number can be seen by other registered users of Nekodop.</li>
            <li>Only share a number you are comfortable making visible to registered users. Do not use a number you want to keep private.</li>
            <li>Anyone who sees your number may contact you. We cannot control who messages you or what they say.</li>
            <li>Nekodop is not responsible for spam, unwanted messages, harassment, scams or any misuse of your number by another user.</li>
            <li>Your conversations on WhatsApp are private between you and the other person. We do not see, store or monitor them.</li>
            <li>If you want your number removed, you can edit your profile or contact us. We will remove it from the website, but we cannot delete copies other users already saved.</li>
            <li>We collect only the information needed to run the website (such as name, email and WhatsApp number). We do not sell your personal data to third parties.</li>
          </ul>

          <h3>5. Selling Cats Is Forbidden</h3>
          <p>Nekodop is for free adoption and rehoming only. Selling cats is not allowed.</p>
          <ul>
            <li>You may not sell, trade, breed for profit or ask for payment in exchange for a cat listed on Nekodop.</li>
            <li>You may not use the website to advertise or find buyers.</li>
            <li>Listings or users that break this rule may be removed or banned without warning.</li>
            <li>If you sell a cat or take payment anyway, you do so entirely at your own risk. Nekodop is not responsible for any payment, refund, deposit, fraud or dispute connected to it.</li>
            <li>We will not help recover money, mediate payment disputes or take part in any financial matter between users.</li>
            <li>Please report anyone who asks for money to us so we can review the account.</li>
          </ul>

          <h3>6. User Responsibilities and Prohibited Conduct</h3>
          <p>You agree to:</p>
          <ul>
            <li>Post only cats that you own or have the right to rehome, with honest information and recent, real photos.</li>
            <li>Describe the cat's age, health, vaccination status and temperament truthfully.</li>
            <li>Treat other users politely and respectfully.</li>
          </ul>
          <p>You agree not to:</p>
          <ul>
            <li>Post false, misleading or stolen content.</li>
            <li>Harass, threaten, scam or pressure other users.</li>
            <li>Use another person's number or details without permission.</li>
            <li>Use the website for anything illegal, or for any purpose other than cat adoption.</li>
            <li>Collect other users' numbers to send bulk messages or advertising.</li>
          </ul>

          <h3>7. Animal Welfare</h3>
          <p>Cats are living animals, not products. By using Nekodop you agree to:</p>
          <ul>
            <li>Give an adopted cat food, clean water, shelter and veterinary care.</li>
            <li>Never abandon, abuse, neglect or harm a cat.</li>
            <li>Never give an adopted cat to someone who may harm it, sell it or use it for breeding for profit.</li>
            <li>Meet in a safe place and ask questions before handing over or accepting a cat.</li>
          </ul>
          <p>We may remove listings or accounts reported for cruelty or neglect.</p>

          <h3>8. Disclaimer and No Involvement in Private Matters</h3>
          <p>You use Nekodop at your own risk.</p>
          <ul>
            <li>Nekodop does not take part in any private arrangement, conversation, meeting or agreement between users.</li>
            <li>We are not responsible for what happens after users make contact, including meetings, transfers of a cat, disagreements, or return of a cat.</li>
            <li>We are not responsible for any loss, injury, illness, damage, theft, scam or dispute that comes from using the website or from contact with another user.</li>
            <li>We are not responsible for cats that are sick, injured, aggressive or not as described in a listing.</li>
            <li>We do not act as a judge or mediator in disputes. Users must settle matters between themselves.</li>
            <li>To the fullest extent allowed by law, Nekodop and its owners are not liable for any direct or indirect damages arising from your use of the website.</li>
            <li>The website is provided "as is". We do not promise it will always be available or free of errors.</li>
          </ul>

          <h3>9. Account Suspension, Changes and Contact</h3>
          <ul>
            <li>We may suspend or delete any account or listing that breaks these terms, with or without notice.</li>
            <li>You may delete your account at any time by contacting us.</li>
            <li>We may update these terms from time to time. The "Last updated" date above will change, and continued use of Nekodop means you accept the new version.</li>
            <li>These terms are governed by the laws of [your country]. Please replace this with your own.</li>
          </ul>
        </div>
      </section>
    </div>
    <script src="scripts/toast.js"></script>
    <script>
      let uploadSuccess = false;
      let isUploading = false;
      const fileInput = document.getElementById("profile-photo");
      const hiddenInput = document.getElementById("profile-photo-url");
      const submitBtn = document.getElementById("submit-btn");
      const phoneInput = document.getElementById("phone-number");
      const termsCheckbox = document.getElementById("terms-accepted");
      const termsModal = document.getElementById("terms-modal");
      const openTermsButton = document.getElementById("open-terms");

      function updateSubmitState() {
          submitBtn.disabled = !termsCheckbox.checked || isUploading;
      }

      termsCheckbox.addEventListener("change", updateSubmitState);
      updateSubmitState();

      function setTermsModalOpen(isOpen) {
          termsModal.setAttribute("aria-hidden", String(!isOpen));
          document.body.classList.toggle("terms-modal-open", isOpen);
          if (isOpen) {
              termsModal.querySelector(".terms-modal-close").focus();
          } else {
              openTermsButton.focus();
          }
      }

      openTermsButton.addEventListener("click", function() {
          setTermsModalOpen(true);
      });
      termsModal.querySelectorAll("[data-close-terms]").forEach(function(element) {
          element.addEventListener("click", function() {
              setTermsModalOpen(false);
          });
      });
      document.addEventListener("keydown", function(event) {
          if (event.key === "Escape" && termsModal.getAttribute("aria-hidden") === "false") {
              setTermsModalOpen(false);
          }
      });

      phoneInput.addEventListener("input", function() {
          this.value = this.value.replace(/\\D/g, "").slice(0, 11);
      });

      fileInput.addEventListener("change", async function() {
          const file = this.files[0];
          if (!file) return;

          isUploading = true;
          updateSubmitState();

          try {
              const formData = new FormData();
              formData.append("file", file);
              formData.append("upload_preset", "nekodop");

              const res = await fetch("https://api.cloudinary.com/v1_1/dyvqe1hgj/image/upload", {
                  method: "POST",
                  body: formData,
              });

              const uploadedImg = await res.json();

              if (uploadedImg.secure_url) {
                  hiddenInput.value = uploadedImg.secure_url;
                  uploadSuccess = true;
                  isUploading = false;
                  updateSubmitState();
              } else {
                  uploadSuccess = false;
                  alert("Upload failed, please try again.");
                  isUploading = false;
                  updateSubmitState();
              }
          } catch (err) {
              console.error("Upload error", err);
              uploadSuccess = false;
              alert("Failed to upload image");
              isUploading = false;
              updateSubmitState();
          }
      });

      document.getElementById("signup-form").addEventListener("submit", function(e) {
          const password = document.getElementById("password").value.trim();
          const rePassword = document.getElementById("re-password").value.trim();
          const photoUrl = hiddenInput.value.trim();
          const phoneNumber = phoneInput.value;

          if (!termsCheckbox.checked) {
              e.preventDefault();
              showToast("Please accept the Terms & Privacy Policy to continue.", "error");
              return;
          }

          if (!/^01[0-9]{9}$/.test(phoneNumber)) {
              e.preventDefault();
              showToast("Phone number must be exactly 11 digits and start with 01.", "error");
              return;
          }

          if (!uploadSuccess || !photoUrl) {
              e.preventDefault();
              showToast("Please wait until profile photo upload completes.", "error");
              return;
          }

          if (password.length < 8) {
              e.preventDefault();
              showToast("Password must be at least 8 characters long.", "error");
              return;
          } else if (!/[A-Z]/.test(password)) {
              e.preventDefault();
              showToast("Password must contain at least one uppercase letter.", "error");
              return;
          } else if (!/[a-z]/.test(password)) {
              e.preventDefault();
              showToast("Password must contain at least one lowercase letter.", "error");
              return;
          } else if (!/\d/.test(password)) {
              e.preventDefault();
              showToast("Password must contain at least one digit.", "error");
              return;
          } else if (!/[!@#$%^&*(),.?\":{}|<>]/.test(password)) {
              e.preventDefault();
              showToast("Password must contain at least one special character.", "error");
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
