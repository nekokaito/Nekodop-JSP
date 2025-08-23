<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page import="org.json.JSONArray, org.json.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    JSONArray catsArray = new JSONArray();

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT * FROM cats ";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                JSONObject json = new JSONObject();
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
                json.put("additional", rs.getString("additional_information"));
                json.put("status", rs.getString("is_approved"));
                json.put("adopted", rs.getString("adopted"));
                catsArray.put(json);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        JSONObject errorObj = new JSONObject();
        errorObj.put("error", "Database error");
        catsArray.put(errorObj);
    }

    out.print(catsArray.toString());
%>
