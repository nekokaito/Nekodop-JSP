<%@ page import="java.sql.*, java.util.UUID" %>
<%@ page import="utils.DBConnection" %>
<%
// Set content type to JSON
response.setContentType("application/json");

// Initialize variables
boolean success = false;
String message = "";
String userId = (String) session.getAttribute("userId");
String userName = (String)  session.getAttribute("userName");
String userEmail = (String) session.getAttribute("userEmail");
String userProfilePicture = (String) session.getAttribute("userProfilePicture");

// Check user session
if (userId == null) {
    out.print("{\"success\": false, \"message\": \"User not logged in\"}");
    return;
}

// Get parameters safely
String catName = request.getParameter("catName");
String catGender = request.getParameter("catGender");
String catDescription = request.getParameter("catDescription");
String ownerAddress = request.getParameter("ownerAddress");
String phone = request.getParameter("ownerPhone");
String additionalInfo = request.getParameter("additionalInfo");
String catImageUrl = request.getParameter("catImageUrl");

// Validate parameters
if (catName == null || catGender == null || catImageUrl == null) {
    out.print("{\"success\": false, \"message\": \"Missing required parameters\"}");
    return;
}

// Convert year/month safely
int year = 0, month = 0;
try {
    year = Integer.parseInt(request.getParameter("year"));
    month = Integer.parseInt(request.getParameter("month"));
} catch (NumberFormatException e) {
    message = "Invalid age format: " + e.getMessage();
}

try {
    // Database connection
    Connection conn = DBConnection.getConnection();

    // Build age string
  // Fix age concatenation logic:
String catAge = "";
if (year > 0) catAge += year + " year" + (year > 1 ? "s" : "");
if (month > 0) {
    if (!catAge.isEmpty()) catAge += " ";
    catAge += month + " month" + (month > 1 ? "s" : "");
}
if (catAge.isEmpty()) catAge = "0 months";

    // Prepare SQL
    String sql = "INSERT INTO cats (id, cat_owner_id, cat_name, cat_image, cat_age, cat_gender, cat_description, owner_phone, owner_address, additional_information, owner_name, owner_email, owner_image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement ps = conn.prepareStatement(sql);
    
    // Set parameters
    ps.setString(1, UUID.randomUUID().toString());
    ps.setString(2, userId);
    ps.setString(3, catName);
    ps.setString(4, catImageUrl);
    ps.setString(5, catAge.trim());
    ps.setString(6, catGender);
    ps.setString(7, catDescription);
    ps.setString(8, phone != null ? phone : "");
    ps.setString(9, ownerAddress != null ? ownerAddress : "");
    ps.setString(10, additionalInfo != null ? additionalInfo : "");
    ps.setString(11, userName);
    ps.setString(12, userEmail);
    ps.setString(13, userProfilePicture);

    // Execute and check result
    int rows = ps.executeUpdate();
    success = rows > 0;
    
    // Cleanup
    ps.close();
    conn.close();
} catch (Exception e) {
    message = "Database error: " + e.getMessage();
    e.printStackTrace();
}

// Return JSON response
out.print("{\"success\": " + success + ", \"message\": \"" + 
        (message != null ? message.replace("\"", "\\\"") : "") + "\"}");
%>