<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="application/json" language="java" %>
<%
    String catId = request.getParameter("id");
    Map<String, String> cat = new HashMap<>();
    
    if (catId != null) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "a12345");
            
            String sql = "SELECT * FROM cats WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, catId);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                cat.put("id", rs.getString("id"));
                cat.put("name", rs.getString("cat_name"));
                cat.put("image", rs.getString("cat_image"));
                cat.put("age", rs.getString("cat_age"));
                cat.put("gender", rs.getString("cat_gender"));
                cat.put("description", rs.getString("cat_description"));
                cat.put("phone", rs.getString("owner_phone"));
                cat.put("address", rs.getString("owner_address"));
                cat.put("additional", rs.getString("additional_information"));
                cat.put("status", rs.getString("is_approved"));
                cat.put("adopted", rs.getString("adopted"));
            }
            
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Convert map to JSON
    out.print("{");
    boolean first = true;
    for (Map.Entry<String, String> entry : cat.entrySet()) {
        if (!first) out.print(",");
        out.print("\"" + entry.getKey() + "\": \"" + entry.getValue() + "\"");
        first = false;
    }
    out.print("}");
%>