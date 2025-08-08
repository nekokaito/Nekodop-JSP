<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- SEO Meta Tags -->
    <title>Nekodop - Cozy community built for cat lovers</title>

    <meta
      name="description"
      content="Nekodop is a community-driven cat adoption platform where you can discover, adopt, and support cats in need. Join us to make a difference, one paw at a time. Cozy community built for cat lovers"
    />
    <meta
      name="keywords"
      content="Nekodop, cat adoption, adopt cats, pet rescue, cat shelter, animal care, donate for cats"
    />
    <meta name="author" content="Nekodop Team" />

    <!-- Favicon -->
    <link rel="icon" href="images/NekoDopLogoAlt.png" type="image/x-icon" />

    <!-- Styles -->
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
    <link rel="stylesheet" href="styles/gallery.css" />
    <link rel="stylesheet" href="styles/video.css" />
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=DynaPuff:wght@400..700&display=swap"
      rel="stylesheet"
    />

    <!-- Security -->
    <meta
      http-equiv="Content-Security-Policy"
      content="upgrade-insecure-requests"
    />
  </head>

  <body>
    <!-- Preloader -->
    <div id="preloader" class="preloader">
      <img src="images/preloader.gif" alt="" />
    </div>
    <!-- Main Content -->
    <main id="main-content">
      <!-- Navbar -->
      <nav class="navbar">
        <div class="logo-div">
          <a href="#" class="logo">Nekodop</a>
        </div>

        <ul class="nav-links">
          <li><a href="#home">Home</a></li>
          <li>
            <a href="#explore">Explore</a>
          </li>
          <li><a href="#support">Support</a></li>
          <li><a href="#gallery">Gallery</a></li>
          <li>
            <a href="#contact">Contact</a>
          </li>
          <li class="login-phn">
            <a href="/pages/login.html"
              ><button class="login-btn">Login</button></a
            >
          </li>
        </ul>

        <div class="user-nav">
          <a href="/pages/login.html">
            <button class="login-btn login-desktop">Login</button>
          </a>
        </div>
        <button class="hamburger">
          <span></span>
          <span></span>
          <span></span>
        </button>
      </nav>
      <!-- Toast Container -->
      <div id="toast-container"></div>
      <!-- Main App Container -->
      <div id="app" class="container">
        <!-- Home Section -->
        <div id="home">
          <main class="hero">
            <div class="hero-content">
              <h1 class="hero-text">Looking for a <span>good</span> time?</h1>
              <p>
                Adoption gives pets in shelters or rescue centers a second
                chance at life. By adopting, you're not only giving love to
                oneliver pet but also freeing up space for another animal in
                need.
              </p>

              <div class="cta-buttons">
                <a href="#explore">
                  <div class="adopt-now">
                    adopt now
                    <svg
                      width="20"
                      height="20"
                      viewBox="0 0 24 24"
                      fill="white"
                    >
                      <path
                        d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm0-12c-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4z"
                      />
                    </svg>
                  </div>
                </a>
                <a href="#" id="custom-watch-video" class="watch-video">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="#000">
                    <path d="M8 5v14l11-7z" />
                  </svg>
                  Watch Video
                </a>
                <div id="custom-video-modal" class="custom-video-modal">
                  <div class="custom-modal-content">
                    <video id="custom-video-player" controls>
                      <source src="/feature/feature.mp4" type="video/mp4" />
                      Your browser does not support the video tag.
                    </video>
                  </div>
                </div>
              </div>
            </div>

            <div class="hero-images">
              <div class="blob blob-1"></div>
              <div class="blob blob-2"></div>
              <img
                src="images/white-cat.png"
                alt="Cat illustration"
                class="cat1-image"
              />
              <img
                src="images/black-cat.png"
                alt="Cat illustration"
                class="cat2-image"
              />
            </div>
          </main>
          <div>
            <h1 class="section-title">
              Why You Should <span>Choose Us ?</span>
            </h1>
            <p style="text-align: center; color: #666; margin-bottom: 3rem">
              We keep things fast and clutter-free so you can spend less time
              browsing and more time finding your next furry friend.
            </p>

            <div class="features">
              <div class="feature-card">
                <div class="feature-icon">
                  <i class="fa-solid fa-shield-cat"></i>
                </div>
                <h3 class="feature-title">Simple & Secure</h3>
                <p class="feature-text">
                  We make it easy for users to create accounts, post about cats,
                  and connect with potential adopters—all without complicated
                  steps or unnecessary logins.
                </p>
              </div>

              <div class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-cat"></i></div>
                <h3 class="feature-title">Cat Welfare</h3>
                <p class="feature-text">
                  Nekodop is built with love for cats. Every feature is designed
                  to help more felines find safe, loving homes.
                </p>
              </div>

              <div class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-code"></i></div>
                <h3 class="feature-title">Devs Who Care</h3>
                <p class="feature-text">
                  This isn't a generic platform. Nekodop is handcrafted by
                  passionate developers who care about animal welfare and user
                  privacy.
                </p>
              </div>
            </div>
          </div>

          <section class="how-it-section">
            <img src="images/takecare.png" alt="" />
            <div class="text-content">
              <h2>Take Care Of Your Pet And Keep It Away From Any Diseases.</h2>
              <p>
                A healthy pet is a happy pet. <br />
                Simple things like clean water, balanced meals, <br />
                and regular playtime can help your pet stay active and
                disease-free. <br />
                It's all about giving them the love and care they deserve.
              </p>
            </div>
          </section>

          <section class="how-it-section reverse">
            <img src="images/vt.png" alt="" />
            <div class="text-content">
              <h2>The Best Care We Provide For Your Pet</h2>
              <p>
                It's very important to provide your pets with food, water,
                shelter, and a safe place to play. If you are going on a
                vacation, you should make sure your pet is properly cared for
                while you're away.
              </p>
              <a href="#" class="check-button">Check</a>
            </div>
          </section>
        </div>

        <!-- Explore Section -->
        <div id="explore" class="explore">
          <h1 class="section-title">
            Explorer Our <span class="highlight">Cats</span>
          </h1>
          <div class="filter-section">
            <input type="text" id="search-input" placeholder="Search by name" />

            <div id="gender-filters">
              <label><input type="checkbox" id="male-filter" /> Male</label>
              <label><input type="checkbox" id="female-filter" /> Female</label>
            </div>
          </div>

          <div class="card-container" id="cat-container">
            <div class="loader-container">
              <span class="loader loader-purple"></span>
              <div></div>
            </div>
          </div>
        </div>
        <!-- Support Section -->
        <div id="support" class="support">
          <div>
            <img
              class="support-banner"
              src="images/support_banner.jpg"
              alt="Support Image"
            />
          </div>
          <div class="support-content">
            <h2>We're Here to Help</h2>
            <p>
              If you have any questions or need assistance, feel free to reach
              out to our support team. We're dedicated to ensuring the best
              experience for you and your pets. It is a community-driven
              platform dedicated to helping stray and rescued cats find loving
              homes. By donating, you’re not just supporting a website — you’re
              changing lives.
            </p>
          </div>
          <section class="how-it-section">
            <div class="support-img">
              <img class="" src="images/heart_donation.png" alt="" />
            </div>
            <div class="text-content">
              <h2>Donate to Support Our Cause</h2>
              <p>
                Your contributions help us maintain the platform and support our
                mission of finding homes for cats in need. Every donation, big
                or small, makes a difference.
              </p>
            </div>
          </section>
          <section class="how-it-section">
            <div class="support-img">
              <img class="" src="images/question.png" alt="" />
            </div>
            <div class="text-content">
              <h2>Why Your Support Matters</h2>
              <ul class="support-list">
                <li>Provide food, shelter, and medical care for stray cats.</li>
                <li>Maintain and improve the Nekodop platform.</li>
                <li>Organize adoption events and awareness campaigns.</li>
                <li>Support verified rescuers and foster homes.</li>
              </ul>
            </div>
          </section>
          <section class="how-it-section">
            <div class="support-img">
              <img class="" src="images/bkash_logo.png" alt="" />
            </div>
            <div class="text-content">
              <h2>How to Donate</h2>
              <p>
                We currently accept donations via
                <span class="highlight">bKash.</span>
              </p>
              <ul class="support-list">
                <li>
                  bKash Number:
                  <span
                    style="
                      font-family: consolas;
                      border: 1px solid #ccc;
                      margin-left: 2px;
                      padding: 2px 4px;
                      font-weight: bold;
                    "
                    >01630844517</span
                  >
                </li>
                <li>Account Type: Personal</li>
                <li>
                  Reference: Nekodop Donation<small>
                    (Please mention this during payment)
                  </small>
                </li>
              </ul>
            </div>
          </section>
          <div class="text-content">
            <h2 style="text-align: center">Thank You for Supporting Nekodop</h2>
            <p>
              From the bottom of our hearts, thank you for believing in our
              mission. Every donation you make, no matter how small, directly
              helps us care for stray cats, support rescuers, and improve the
              adoption experience for both cats and their future families. Your
              kindness allows us to keep Nekodop running, build new features,
              and most importantly — give these animals a second chance at life.
              In a world where so many voices go unheard, your support helps us
              amplify the meows that matter. Together, we are not just building
              a platform — we are building hope, one paw at a time.
            </p>
          </div>
        </div>

        <!-- Gallery Section -->
        <div id="gallery" class="gallery">
          <h1>Nekodop Gallery</h1>
          <div class="gallery-description">
            <p>
              From fluffy giants to sleek and elegant companions, the world is
              filled with unique cat breeds, each with their own charm, look,
              and personality. Discover the beauty of nature’s design through
              these fascinating felines from every corner of the globe.
            </p>
          </div>
          <div class="gallery-container"></div>
        </div>

        <!-- Contact Section -->
        <div id="contact">
          <div class="contact-container">
            <section class="form-section">
              <div class="logo">
                <span class="logo-text">Contact</span>
              </div>

              <form
                action="https://formsubmit.co/siddiqsazzad001@gmail.com"
                method="POST"
              >
                <div class="form-row">
                  <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input
                      type="text"
                      id="firstName"
                      name="First Name"
                      required
                    />
                  </div>
                  <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input
                      type="text"
                      id="lastName"
                      name="Last Name"
                      required
                    />
                  </div>
                </div>
                <div class="form-group">
                  <label for="email">Email Address</label>
                  <input type="email" id="email" name="Email" required />
                </div>
                <div class="form-group">
                  <label for="message">Message</label>
                  <textarea id="message" name="Message" required></textarea>
                </div>
                <button type="submit">Submit</button>
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
  <!-- 
  <script src="/scripts/reponsive.js"></script>
 
  <script type="module" src="/scripts/auth/user-nav.js"></script>
  -->
  <script src="scripts/toast.js"></script>
   <script src="scripts/main.js"></script>
  <script src="scripts/utils/video.js"></script>
   
</html>
    