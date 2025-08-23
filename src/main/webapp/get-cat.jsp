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
                        json.put("ownerName", rs.getString("owner_name"));
                        json.put("ownerImage", rs.getString("owner_image"));
                        json.put("ownerEmail", rs.getString("owner_email"));
                        json.put("additional", rs.getString("additional_information"));
                        json.put("status", rs.getString("is_approved"));
                        json.put("adopted", rs.getString("adopted"));
                        json.put("created_at", rs.getString("created_at"));
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
