<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page import="org.json.JSONObject, org.json.JSONArray" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    JSONArray usersArray = new JSONArray();

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT * FROM users";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                JSONObject user = new JSONObject();
                user.put("id", rs.getString("id"));
                user.put("name", rs.getString("name"));
                user.put("email", rs.getString("email"));
                user.put("profile_picture", rs.getString("profile_picture"));
                user.put("user_role", rs.getString("user_role"));
                user.put("created_at", rs.getString("created_at"));
                usersArray.put(user);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        JSONObject error = new JSONObject();
        error.put("error", "Database error");
        usersArray.put(error);
    }

    out.print(usersArray.toString());
%>
