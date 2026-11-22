<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page import="org.json.JSONArray, org.json.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    String catId = request.getParameter("id");
    String userId = (String) session.getAttribute("userId");
    JSONObject json = new JSONObject();

    if (catId != null) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT c.id, c.cat_owner_id, c.cat_name, c.cat_image, c.cat_video, c.cat_age, " +
                         "c.cat_gender, c.cat_breed, c.cat_description, u.phone_number AS owner_phone, " +
                         "c.owner_address, c.additional_information, " +
                         "u.name AS owner_name, u.profile_picture AS owner_image, u.email AS owner_email, " +
                         "a.name AS adopter_name, a.phone_number AS adopter_phone, a.profile_picture AS adopter_image, " +
                         "c.is_approved, c.adopted, c.adopted_by, c.adopted_at, c.created_at " +
                         "FROM cats c JOIN users u ON c.cat_owner_id = u.id " +
                         "LEFT JOIN users a ON a.id = c.adopted_by WHERE c.id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, catId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
	                    json.put("ownerId", rs.getString("cat_owner_id"));
	                    json.put("cat_owner_id", rs.getString("cat_owner_id"));
                    	json.put("id", rs.getString("id"));
                        json.put("name", rs.getString("cat_name"));
                        json.put("image", rs.getString("cat_image"));
                        json.put("video", rs.getString("cat_video"));
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
                        try (PreparedStatement favorite = conn.prepareStatement(
                                "SELECT COUNT(*) FROM user_favorite_cats WHERE user_id = ? AND cat_id = ?")) {
                            favorite.setString(1, userId);
                            favorite.setString(2, catId);
                            try (ResultSet favoriteRs = favorite.executeQuery()) {
                                json.put("isFavorite", favoriteRs.next() && favoriteRs.getInt(1) > 0);
                            }
                        }

                        JSONArray viewers = new JSONArray();
                        try (PreparedStatement views = conn.prepareStatement(
                                "SELECT u.name, cv.seen_at FROM cat_views cv JOIN users u ON u.id = cv.user_id " +
                                "WHERE cv.cat_id = ? ORDER BY cv.seen_at DESC")) {
                            if (userId != null && userId.equals(rs.getString("cat_owner_id"))) {
                                views.setString(1, catId);
                                try (ResultSet viewRs = views.executeQuery()) {
                                    while (viewRs.next()) {
                                        JSONObject viewer = new JSONObject();
                                        viewer.put("name", viewRs.getString("name"));
                                        viewer.put("seenAt", viewRs.getString("seen_at"));
                                        viewers.put(viewer);
                                    }
                                }
                            }
                        }
                        json.put("views", viewers);
                        json.put("created_at", rs.getString("created_at"));
                    } else {
                        json.put("error", "Cat not found");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.put("error", "Database error: " + (e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName()));
        }
    } else {
        json.put("error", "No ID provided");
    }

    out.print(json.toString());
%>
