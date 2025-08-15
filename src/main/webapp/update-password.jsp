<%@ page import="java.sql.*, org.json.JSONObject" %>
<%@ page import="utils.DBConnection" %>
<%
response.setContentType("application/json");
JSONObject json = new JSONObject();

try {
    String userId = (String) session.getAttribute("userId");
    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");


    if (userId == null || currentPassword == null || newPassword == null) {
        response.setStatus(400);
        json.put("error", "Missing required parameters");
        out.print(json);
        return;
    }

    Connection con = DBConnection.getConnection();

    // Verify current password
    String sql = "SELECT password FROM users WHERE id = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, userId);
    ResultSet rs = pstmt.executeQuery();

    if (!rs.next()) {
        response.setStatus(401);
        json.put("error", "User not found");
        out.print(json);
        return;
    }

    String storedPassword = rs.getString("password");
    if (!currentPassword.equals(storedPassword)) {
        response.setStatus(401);
        json.put("error", "Current password is incorrect");
        out.print(json);
        return;
    }

    // Server-side password validation
    if (newPassword.length() < 8) {
        response.setStatus(400);
        json.put("error", "Password must be at least 8 characters");
        out.print(json);
        return;
    }

    // Update password
    sql = "UPDATE users SET password = ? WHERE id = ?";
    pstmt = con.prepareStatement(sql);
    pstmt.setString(1, newPassword);
    pstmt.setString(2, userId);

    int rows = pstmt.executeUpdate();
    if (rows > 0) {
        json.put("message", "Password updated successfully");
    } else {
        response.setStatus(500);
        json.put("error", "Failed to update password");
    }

    out.print(json);
    con.close();

} catch (Exception e) {
    response.setStatus(500);
    json.put("error", "Server error: " + e.getMessage());
    out.print(json.toString());
}
%>
