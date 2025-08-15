<%@ page import="org.json.JSONObject" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.sql.*, utils.DBConnection" %>
<%
    request.setCharacterEncoding("UTF-8");

    // Read JSON body
    StringBuilder sb = new StringBuilder();
    try (BufferedReader reader = new BufferedReader(new InputStreamReader(request.getInputStream(), "UTF-8"))) {
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
    }

    JSONObject json = new JSONObject(sb.toString());

    String name = json.getString("name");
    String email = json.getString("email");
    String profilePicture = json.getString("profilePicture");

    String userId = (String) session.getAttribute("userId");

    Connection conn = null;
    PreparedStatement ps = null;
    JSONObject res = new JSONObject();
    ResultSet rs = null;
    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement("UPDATE users SET name=?, email=?, profile_picture=? WHERE id=?");
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, profilePicture);
        ps.setString(4, userId);

        int rows = ps.executeUpdate();
        if (rows > 0) {
        	ps = conn.prepareStatement("SELECT name, email, profile_picture FROM users WHERE id=?");
            ps.setString(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("userEmail", rs.getString("email"));
                session.setAttribute("userProfilePicture", rs.getString("profile_picture"));
            }

            res.put("success", true);
        } else {
            res.put("success", false);
            res.put("error", "No user updated.");
        }
    } catch (Exception e) {
        res.put("success", false);
        res.put("error", e.getMessage());
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }

    response.setContentType("application/json");
    response.getWriter().write(res.toString());
%>
