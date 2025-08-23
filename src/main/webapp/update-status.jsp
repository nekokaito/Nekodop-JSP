<%@ page import="java.sql.*, utils.DBConnection, org.json.JSONObject" %>
<%
response.setContentType("application/json;charset=UTF-8");

boolean success = false;
String message = "";
String userId = (String) session.getAttribute("userId");
String userRole = (String) session.getAttribute("userRole");
boolean isAdmin = "admin".equals(userRole);
JSONObject json = new JSONObject();

// check login
if (userId == null) {
    json.put("success", false);
    json.put("message", "User not logged in");
    out.print(json.toString());
    return;
}
// check admin
if (!isAdmin) {
    json.put("success", false);
    json.put("message", "Only admin can update status");
    out.print(json.toString());
    return;
}
// params
String catId = request.getParameter("catId");
String adoptStatus = request.getParameter("adoptStatus");



if (catId == null) {
    json.put("success", false);
    json.put("message", "Missing required parameters");
    out.print(json.toString());
    return;
}

if (adoptStatus == null) adoptStatus = "0";

try {
    Connection conn = DBConnection.getConnection();
    String sql = "UPDATE cats SET is_approved = ? WHERE id = ?";
    PreparedStatement ps = conn.prepareStatement(sql);

    ps.setString(1, adoptStatus);
    ps.setString(2, catId);

    int rows = ps.executeUpdate();
    success = rows > 0;

    if (!success) {
        message = "Update failed or not authorized";
    }

    ps.close();
    conn.close();
} catch (Exception e) {
    message = "Database error: " + e.getMessage();
    e.printStackTrace();
}

json.put("success", success);
json.put("message", message);
out.print(json.toString());
%>
