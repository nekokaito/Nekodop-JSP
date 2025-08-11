<%@ page import="java.sql.*" %>
<%@ page contentType="application/json" language="java" %>
<%
    String catId = request.getParameter("id");
    boolean success = false;
    
    if (catId != null) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "a12345");
            
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