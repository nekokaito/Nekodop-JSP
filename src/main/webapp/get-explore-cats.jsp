<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page import="org.json.JSONArray, org.json.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    JSONArray catsArray = new JSONArray();
    String userId = (String) session.getAttribute("userId");
    String breed = request.getParameter("breed");
    if (breed == null || breed.trim().isEmpty()) breed = "All";
    if (!"All".equals(breed) && !"Deshi".equals(breed) && !"Persian".equals(breed) &&
        !"Mixed".equals(breed) && !"Others".equals(breed)) breed = "All";

    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT c.id, c.cat_owner_id, c.cat_name, c.cat_image, c.cat_video, c.cat_age, " +
                     "c.cat_gender, c.cat_breed, c.cat_description, u.phone_number AS owner_phone, " +
                     "c.owner_address, c.additional_information, " +
                     "u.name AS owner_name, u.profile_picture AS owner_image, u.email AS owner_email, " +
                     "a.name AS adopter_name, a.phone_number AS adopter_phone, a.profile_picture AS adopter_image, " +
                     "c.is_approved, c.adopted, c.adopted_by, c.adopted_at, " +
                     "CASE WHEN EXISTS (SELECT 1 FROM user_favorite_cats f WHERE f.cat_id = c.id AND f.user_id = ?) THEN 1 ELSE 0 END AS is_favorite " +
                     "FROM cats c JOIN users u ON c.cat_owner_id = u.id " +
                     "LEFT JOIN users a ON a.id = c.adopted_by " +
                     "WHERE c.is_approved = 1 AND c.adopted_by IS NULL";
        if (!"All".equals(breed)) sql += " AND c.cat_breed = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            if (!"All".equals(breed)) ps.setString(2, breed);
            try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                JSONObject json = new JSONObject();
                json.put("id", rs.getString("id"));
                json.put("ownerId", rs.getString("cat_owner_id"));
                json.put("cat_owner_id", rs.getString("cat_owner_id"));
                json.put("name", rs.getString("cat_name"));
                json.put("image", rs.getString("cat_image"));
                json.put("age", rs.getString("cat_age"));
                json.put("gender", rs.getString("cat_gender"));
                json.put("breed", rs.getString("cat_breed"));
                json.put("cat_breed", rs.getString("cat_breed"));
                json.put("description", rs.getString("cat_description"));
                json.put("phone", rs.getString("owner_phone"));
                json.put("address", rs.getString("owner_address"));
                json.put("ownerName", rs.getString("owner_name"));
                json.put("ownerImage", rs.getString("owner_image"));
                json.put("ownerEmail", rs.getString("owner_email"));
                json.put("adopterName", rs.getString("adopter_name"));
                json.put("adopterPhone", rs.getString("adopter_phone"));
                json.put("adopterImage", rs.getString("adopter_image"));
                json.put("additional", rs.getString("additional_information"));
                json.put("status", rs.getString("is_approved"));
                json.put("adopted", rs.getString("adopted"));
                json.put("adoptedBy", rs.getString("adopted_by"));
                json.put("adoptedAt", rs.getString("adopted_at"));
                json.put("adopted_by", rs.getString("adopted_by"));
                json.put("adopted_at", rs.getString("adopted_at"));
                json.put("isFavorite", rs.getInt("is_favorite") == 1);
                catsArray.put(json);
            }
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
