<%@ page import="java.sql.*, utils.DBConnection" %>
<%@ page contentType="application/json" language="java" %>
<%
    String catId = request.getParameter("id");
    boolean success = false;
    
    if (catId != null) {
        try {
            Connection conn = DBConnection.getConnection();
            
            String sql = "DELETE FROM cats WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, catId);
            
            int rows = ps.executeUpdate();
            success = rows > 0;
            
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    out.print("{\"success\": " + success + "}");
%>