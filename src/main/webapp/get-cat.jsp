<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    String catId = request.getParameter("id");
    JSONObject json = new JSONObject();

    if (catId != null) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM cats WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, catId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        json.put("id", rs.getString("id"));
                        json.put("name", rs.getString("cat_name"));
                        json.put("image", rs.getString("cat_image"));
                        json.put("age", rs.getString("cat_age"));
                        json.put("gender", rs.getString("cat_gender"));
                        json.put("description", rs.getString("cat_description"));
                        json.put("phone", rs.getString("owner_phone"));
                        json.put("address", rs.getString("owner_address"));
                        json.put("additional", rs.getString("additional_information"));
                        json.put("status", rs.getString("is_approved"));
                        json.put("adopted", rs.getString("adopted"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.put("error", "Database error");
        }
    } else {
        json.put("error", "No ID provided");
    }

    out.print(json.toString());
%>
