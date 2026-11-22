<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.setContentType("application/json;charset=UTF-8");
    JSONObject json = new JSONObject();
    String userId = (String) session.getAttribute("userId");
    String catId = request.getParameter("catId");

    if (userId == null) {
        json.put("success", false);
        json.put("message", "Please sign in to save favorites.");
    } else if (catId == null || catId.trim().isEmpty()) {
        json.put("success", false);
        json.put("message", "Missing cat ID.");
    } else {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int deleted;
                try (PreparedStatement delete = conn.prepareStatement(
                        "DELETE FROM user_favorite_cats WHERE user_id = ? AND cat_id = ?")) {
                    delete.setString(1, userId);
                    delete.setString(2, catId);
                    deleted = delete.executeUpdate();
                }

                boolean isFavorite = deleted == 0;
                if (isFavorite) {
                    try (PreparedStatement insert = conn.prepareStatement(
                            "INSERT INTO user_favorite_cats (user_id, cat_id) VALUES (?, ?)")) {
                        insert.setString(1, userId);
                        insert.setString(2, catId);
                        insert.executeUpdate();
                    }
                }
                conn.commit();
                json.put("success", true);
                json.put("isFavorite", isFavorite);
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
            json.put("success", false);
            json.put("message", "Could not update favorite.");
        }
    }
    out.print(json.toString());
%>
