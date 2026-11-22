<%@ page import="java.sql.*, utils.DBConnection, org.json.JSONArray, org.json.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
String userId = (String) session.getAttribute("userId");
String catId = request.getParameter("catId");
JSONObject json = new JSONObject();
JSONArray users = new JSONArray();
if (userId == null || catId == null || catId.trim().isEmpty()) {
    response.setStatus(userId == null ? 401 : 400);
    json.put("success", false);
    json.put("message", userId == null ? "User not logged in" : "Missing cat ID");
    out.print(json.toString());
    return;
}
try (Connection conn = DBConnection.getConnection();
     PreparedStatement ps = conn.prepareStatement(
         "SELECT DISTINCT u.id, u.name, u.profile_picture FROM cat_views cv " +
         "JOIN users u ON u.id=cv.user_id JOIN cats c ON c.id=cv.cat_id " +
         "WHERE cv.cat_id=? AND c.cat_owner_id=? AND cv.user_id<>c.cat_owner_id ORDER BY u.name")) {
    ps.setString(1, catId);
    ps.setString(2, userId);
    try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            JSONObject item = new JSONObject();
            item.put("id", rs.getString("id"));
            item.put("name", rs.getString("name"));
            item.put("profilePicture", rs.getString("profile_picture"));
            users.put(item);
        }
    }
    json.put("success", true);
    json.put("users", users);
} catch (Exception e) {
    response.setStatus(500);
    json.put("success", false);
    json.put("message", "Database error: " + e.getMessage());
}
out.print(json.toString());
%>
