<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    JSONObject json = new JSONObject();
    String userId = request.getParameter("id");

   
    String currentRole = (String) session.getAttribute("userRole");

    if (currentRole != null && currentRole.equals("admin")) {
        if (userId != null && !userId.trim().isEmpty()) {
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "DELETE FROM users WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, userId);
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        json.put("success", true);
                    } else {
                        json.put("success", false);
                        json.put("error", "User not found");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                json.put("success", false);
                json.put("error", "Database error");
            }
        } else {
            json.put("success", false);
            json.put("error", "Invalid ID");
        }
    } else {
        json.put("success", false);
        json.put("error", "Unauthorized (Admin only)");
    }

    out.print(json.toString());
%>
