<%@ page import="java.sql.*, utils.DBConnection, org.json.JSONObject" %>
<%
response.setContentType("application/json;charset=UTF-8");

boolean success = false;
String message = "";
String userId = (String) session.getAttribute("userId");

JSONObject json = new JSONObject();

// check login
if (userId == null) {
    json.put("success", false);
    json.put("message", "User not logged in");
    out.print(json.toString());
    return;
}

// params
String catId = request.getParameter("catId");
String catName = request.getParameter("catName");
String catGender = request.getParameter("catGender");
String catBreed = request.getParameter("catBreed");
String catDescription = request.getParameter("catDescription");
String ownerAddress = request.getParameter("ownerAddress");
String additionalInfo = request.getParameter("additionalInfo");
String catImageUrl = request.getParameter("catImageUrl");
String catVideoUrl = request.getParameter("catVideoUrl");

// validation
if (catId == null || catName == null || catGender == null || catBreed == null) {
    json.put("success", false);
    json.put("message", "Missing required parameters");
    out.print(json.toString());
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

try (Connection conn = DBConnection.getConnection();
	     PreparedStatement ps = conn.prepareStatement(
	         "UPDATE cats SET cat_name = ?, cat_image = ?, cat_video = ?, cat_age = ?, cat_gender = ?, " +
	         "cat_breed = ?, cat_description = ?, owner_address = ?, additional_information = ? " +
	         "WHERE id = ? AND cat_owner_id = ?"
	     )) {

	    ps.setString(1, catName);
	    ps.setString(2, catImageUrl);
	    ps.setString(3, catVideoUrl); 
	    ps.setString(4, catAge.trim());
	    ps.setString(5, catGender);
	    ps.setString(6, catBreed);
	    ps.setString(7, catDescription);
	    ps.setString(8, ownerAddress != null ? ownerAddress : "");
	    ps.setString(9, additionalInfo != null ? additionalInfo : "");
	    ps.setString(10, catId);
	    ps.setString(11, userId);

	    int rows = ps.executeUpdate();
	    success = rows > 0;
	} catch (Exception e) {
	    message = "Database error: " + e.getMessage();
	    e.printStackTrace();
	}

// return JSON safely
json.put("success", success);
json.put("message", message != null ? message : "");
out.print(json.toString());
%>
