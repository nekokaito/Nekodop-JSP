<%@ page import="java.sql.*, utils.DBConnection, org.json.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%
    response.setContentType("application/json;charset=UTF-8");
    JSONObject json = new JSONObject();
    String userId = (String) session.getAttribute("userId");
    String catId = request.getParameter("catId");

    if (userId == null) {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        json.put("success", false);
        json.put("message", "Please sign in to contact the owner.");
    } else if (catId == null || catId.trim().isEmpty()) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        json.put("success", false);
        json.put("message", "Missing cat ID.");
    } else {
        String sql = "MERGE INTO cat_views v " +
                     "USING (SELECT ? AS cat_id, ? AS user_id FROM dual) s " +
                     "ON (v.cat_id = s.cat_id AND v.user_id = s.user_id) " +
                     "WHEN MATCHED THEN UPDATE SET v.seen_at = SYSTIMESTAMP " +
                     "WHEN NOT MATCHED THEN INSERT (cat_id, user_id) VALUES (s.cat_id, s.user_id)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, catId);
            ps.setString(2, userId);
            ps.executeUpdate();
            json.put("success", true);
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            json.put("success", false);
            json.put("message", "Could not record this view.");
        }
    }
    out.print(json.toString());
%>
