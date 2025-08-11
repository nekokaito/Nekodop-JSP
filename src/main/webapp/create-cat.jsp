<%@ page import="java.sql.*" %>
<%@ page import="java.util.UUID" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page contentType="application/json" language="java" %>
<%
    Map<String, String> formData = new HashMap<>();
    String imageUrl = "";
    boolean success = false;
    String message = "";
    
    // Parse multipart request
    if (ServletFileUpload.isMultipartContent(request)) {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        
        List<FileItem> items = upload.parseRequest(request);
        
        for (FileItem item : items) {
            if (item.isFormField()) {
                formData.put(item.getFieldName(), item.getString());
            } else if (item.getFieldName().equals("cat-image")) {
                // Upload to Cloudinary
                // (Implementation would be similar to your JavaScript version)
                // imageUrl = ...;
            }
        }
    }
    
    // Insert into database
    if (!formData.isEmpty() && !imageUrl.isEmpty()) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "a12345");
            
            String sql = "INSERT INTO cats (id, cat_owner_id, cat_name, cat_image, cat_age, cat_gender, cat_description, owner_phone, owner_address, additional_information) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            
            // Set parameters
            ps.setString(1, UUID.randomUUID().toString());
            ps.setString(2, formData.get("userId"));
            ps.setString(3, formData.get("cat-name"));
            ps.setString(4, imageUrl);
            
            // Format age
        int year = formData.get("year") != null && !formData.get("year").isEmpty()
        ? Integer.parseInt(formData.get("year"))
        : 0;

        int month = formData.get("month") != null && !formData.get("month").isEmpty()
        ? Integer.parseInt(formData.get("month"))
        : 0;

            String catAge = "";
            if (year > 0) catAge += year + " year" + (year > 1 ? "s" : "");
            if (month > 0) {
                if (year > 0) catAge += " ";
                catAge += month + " month" + (month > 1 ? "s" : "");
            }
            ps.setString(5, catAge);
            
            ps.setString(6, formData.get("gender"));
            ps.setString(7, formData.get("description"));
            ps.setString(8, formData.get("phone"));
            ps.setString(9, formData.get("address"));
            ps.setString(10, formData.get("additional"));
            
            int rows = ps.executeUpdate();
            success = rows > 0;
            
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = e.getMessage();
        }
    }
    
    out.print("{\"success\": " + success + ", \"message\": \"" + message + "\"}");
%>