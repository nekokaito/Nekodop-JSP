# Nekodop (JSP) — Submodule README

**Nekodop (JSP)**  
A simple JSP/Servlet Java web app for cat adoption posts — converted from an HTML/CSS/JS frontend.  
Designed to be used as a lightweight sub-repo/submodule without heavy frameworks (no Spring).  
Suitable for deployment on Tomcat or any servlet container.

---

## Contents
- `src/` — Java servlets, helpers (JDBC utils), and models  
- `webapp/` — JSP pages, static assets (CSS, JS, images)  
- `WEB-INF/` — `web.xml`, configuration files, library jars  
- `sql/` — example SQL schema & seed data  
- `README.md` — this file

---

## Features
- User registration and login (basic, session-based)  
- Create, read, update, and delete (CRUD) cat adoption posts  
- Upload and store image URLs (recommended: Cloudinary or local uploads)  
- Simple role handling (user / admin) via database flags and servlet checks  
- Clean separation: minimal logic in JSP, main logic in servlets and utilities

---

## Tech Stack
- Java (JDK 11+)  
- JSP / Servlets (no frameworks)  
- JDBC (configurable for SQLite or MySQL/Postgres)  
- Apache Tomcat (or any servlet container)

> This repo intentionally avoids `uuid`, `bcrypt`, and `JWT` per project constraints.  
> For production use, stronger authentication and encryption are recommended.

---

## Quick Setup (Local)

### 1. Add this repo as a submodule
```bash
git submodule add <git-url> nekodop-jsp
git submodule update --init --recursive
```

### 2. Open or import the project
Import as a **Dynamic Web Project** (Eclipse) or a standard Java web app (IntelliJ).

### 3. Configure the database
Default: **SQLite (file-based)** — quick setup.  
Or use **MySQL/Postgres** by updating the JDBC URL, username, and password.

Edit `WEB-INF/classes/config.properties`:
```properties
db.driver=org.sqlite.JDBC
db.url=jdbc:sqlite:/path/to/nekodop.db
db.user=
db.pass=
```

### 4. Initialize the database
**SQLite example:**
```bash
sqlite3 nekodop.db < sql/schema.sql
sqlite3 nekodop.db < sql/seed.sql
```

**MySQL example:**
```sql
CREATE DATABASE nekodop;
USE nekodop;
-- run the contents of sql/schema.sql and sql/seed.sql
```

### 5. Configure Tomcat
Point your IDE to a local Tomcat installation.

### 6. Build and deploy
- Export as WAR (`Project -> Export -> WAR`) and place into `TOMCAT_HOME/webapps/`, or  
- Run directly from IDE using configured Tomcat settings.

### 7. Visit in browser
```
http://localhost:8080/nekodop-jsp/
```

---

## Important Files to Edit
- `WEB-INF/web.xml` — servlet mappings and session settings  
- `WEB-INF/classes/config.properties` — database and app configuration  
- `src/com/nekodop/servlets/*` — main servlet logic  
- `webapp/views/*.jsp` — UI templates (minimal Java code, prefer JSTL)

---

## Notes and Recommendations
- Keep JSP files presentation-focused; move logic to servlets and utility classes.  
- Use Cloudinary or similar service for image storage (store URLs in the database).  
- Replace simple password storage with secure hashing and add HTTPS for production.  
- For future authentication features (JWT, OAuth, etc.), consider a separate module.

---

## Troubleshooting
- **ClassNotFoundException** for JDBC driver: add the driver JAR to `WEB-INF/lib` or Tomcat’s `lib` folder.  
- **404 after deploy:** check `web.xml` mappings and WAR context name.  
- **Database errors:** verify JDBC URL, path, and permissions (for SQLite).

---

## License
MIT License — feel free to use and modify for learning, portfolio, or academic projects.
