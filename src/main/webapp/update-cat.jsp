<%@ page import="java.sql.*, java.util.UUID" %>
<%@ page import="utils.DBConnection" %>
<%
response.setContentType("application/json");


boolean success = false;
String message = "";
String userId = (String) session.getAttribute("userId");

// check login
if (userId == null) {
    out.print("{\"success\": false, \"message\": \"User not logged in\"}");
    return;
}

// params
String catId = request.getParameter("catId");
String catName = request.getParameter("catName");
String catGender = request.getParameter("catGender");
String catDescription = request.getParameter("catDescription");
String ownerAddress = request.getParameter("ownerAddress");
String phone = request.getParameter("ownerPhone");
String additionalInfo = request.getParameter("additionalInfo");
String catImageUrl = request.getParameter("catImageUrl");
String adoptStatus = request.getParameter("adoptStatus");

// validation
if (catId == null || catName == null || catGender == null) {
    out.print("{\"success\": false, \"message\": \"Missing required parameters\"}");
    return;
}

// convert year/month
int year = 0, month = 0;
try {
    year = Integer.parseInt(request.getParameter("year"));
    month = Integer.parseInt(request.getParameter("month"));
} catch (NumberFormatException e) {
    message = "Invalid age format: " + e.getMessage();
}

// build age string
String catAge = "";
if (year > 0) catAge += year + " year" + (year > 1 ? "s" : "");
if (month > 0) {
    if (!catAge.isEmpty()) catAge += " ";
    catAge += month + " month" + (month > 1 ? "s" : "");
}
if (catAge.isEmpty()) catAge = "0 months";

try {
    Connection conn = DBConnection.getConnection();

    String sql = "UPDATE cats SET cat_name = ?, cat_image = ?, cat_age = ?, cat_gender = ?, " +
                 "cat_description = ?, owner_phone = ?, owner_address = ?, additional_information = ?, adopt_status = ? " +
                 "WHERE id = ? AND cat_owner_id = ?";

    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setString(1, catName);
    ps.setString(2, catImageUrl);
    ps.setString(3, catAge.trim());
    ps.setString(4, catGender);
    ps.setString(5, catDescription);
    ps.setString(6, phone != null ? phone : "");
    ps.setString(7, ownerAddress != null ? ownerAddress : "");
    ps.setString(8, additionalInfo != null ? additionalInfo : "");
    ps.setString(9, adoptStatus != null ? adoptStatus : "0");
    ps.setString(10, catId);
    ps.setString(11, userId);

    int rows = ps.executeUpdate();
    success = rows > 0;

    ps.close();
    conn.close();
} catch (Exception e) {
    message = "Database error: " + e.getMessage();
    e.printStackTrace();
}

// return response
out.print("{\"success\": " + success + ", \"message\": \"" + 
        (message != null ? message.replace("\"", "\\\"") : "") + "\"}");
%>
