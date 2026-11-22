<%@ page import="java.sql.*, java.util.UUID" %>
<%@ page import="utils.DBConnection" %>
<%@ page import="org.json.JSONObject" %>
<%
// Set content type to JSON
response.setContentType("application/json;charset=UTF-8");

// Initialize variables
boolean success = false;
String message = "";
JSONObject responseJson = new JSONObject();
String userId = (String) session.getAttribute("userId");

// Check user session
if (userId == null) {
    responseJson.put("success", false);
    responseJson.put("message", "User not logged in");
    out.print(responseJson.toString());
    return;
}

// Get parameters safely
String catName = request.getParameter("catName");
String catGender = request.getParameter("catGender");
String catBreed = request.getParameter("catBreed");
String catDescription = request.getParameter("catDescription");
String ownerAddress = request.getParameter("ownerAddress");
String additionalInfo = request.getParameter("additionalInfo");
String catImageUrl = request.getParameter("catImageUrl");
String videoUrl = request.getParameter("catVideoUrl");

// Validate parameters
if (catName == null || catGender == null || catBreed == null || catImageUrl == null) {
    responseJson.put("success", false);
    responseJson.put("message", "Missing required parameters");
    out.print(responseJson.toString());
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
    String sql = "INSERT INTO cats (id, cat_owner_id, cat_name, cat_image, cat_video, cat_age, cat_gender, cat_breed, cat_description, owner_address, additional_information) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement ps = conn.prepareStatement(sql);
    
    // Set parameters
    ps.setString(1, UUID.randomUUID().toString());
    ps.setString(2, userId);
    ps.setString(3, catName);
    ps.setString(4, catImageUrl);
    ps.setString(5, videoUrl != null && !videoUrl.isEmpty() ? videoUrl: null);
    ps.setString(6, catAge.trim());
    ps.setString(7, catGender);
    ps.setString(8, catBreed);
    ps.setString(9, catDescription);
    ps.setString(10, ownerAddress != null ? ownerAddress : "");
    ps.setString(11, additionalInfo != null ? additionalInfo : "");

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

responseJson.put("success", success);
responseJson.put("message", message != null ? message : "");
out.print(responseJson.toString());
%>
