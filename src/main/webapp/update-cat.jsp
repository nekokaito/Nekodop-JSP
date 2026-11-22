<%@ page import="java.sql.*, utils.DBConnection, org.json.JSONObject" %>
<%
response.setContentType("application/json;charset=UTF-8");
String userId = (String) session.getAttribute("userId");
JSONObject json = new JSONObject();
if (userId == null) {
    json.put("success", false);
    json.put("message", "User not logged in");
    out.print(json.toString());
    return;
}

String catId = request.getParameter("catId");
String catName = request.getParameter("catName");
String catGender = request.getParameter("catGender");
String catBreed = request.getParameter("catBreed");
String adoptionStatus = request.getParameter("adoptionStatus");
String adoptedBy = request.getParameter("adoptedBy");
String catAge;
try {
    int year = Integer.parseInt(request.getParameter("year"));
    int month = Integer.parseInt(request.getParameter("month"));
    if (year < 0 || month < 0 || month > 12) throw new NumberFormatException();
    catAge = (year > 0 ? year + " year" + (year > 1 ? "s" : "") : "") +
             (year > 0 && month > 0 ? " " : "") +
             (month > 0 ? month + " month" + (month > 1 ? "s" : "") : "");
    if (catAge.isEmpty()) catAge = "0 months";
} catch (Exception e) {
    json.put("success", false);
    json.put("message", "Invalid age");
    out.print(json.toString());
    return;
}

if (catId == null || catName == null || catGender == null || catBreed == null ||
    !("0".equals(adoptionStatus) || "1".equals(adoptionStatus)) ||
    ("1".equals(adoptionStatus) && (adoptedBy == null || adoptedBy.trim().isEmpty()))) {
    json.put("success", false);
    json.put("message", "Missing or invalid required parameters");
    out.print(json.toString());
    return;
}

boolean success = false;
String message = "";
try (Connection conn = DBConnection.getConnection()) {
    conn.setAutoCommit(false);
    try {
        try (PreparedStatement ps = conn.prepareStatement(
            "UPDATE cats SET cat_name=?, cat_image=?, cat_video=?, cat_age=?, cat_gender=?, cat_breed=?, " +
            "cat_description=?, owner_address=?, additional_information=? WHERE id=? AND cat_owner_id=?")) {
            ps.setString(1, catName);
            ps.setString(2, request.getParameter("catImageUrl"));
            ps.setString(3, request.getParameter("catVideoUrl"));
            ps.setString(4, catAge);
            ps.setString(5, catGender);
            ps.setString(6, catBreed);
            ps.setString(7, request.getParameter("catDescription"));
            ps.setString(8, request.getParameter("ownerAddress") != null ? request.getParameter("ownerAddress") : "");
            ps.setString(9, request.getParameter("additionalInfo") != null ? request.getParameter("additionalInfo") : "");
            ps.setString(10, catId);
            ps.setString(11, userId);
            if (ps.executeUpdate() == 0) throw new SQLException("Cat not found or you do not own this listing");
        }

        if ("1".equals(adoptionStatus)) {
            try (PreparedStatement verify = conn.prepareStatement(
                "SELECT COUNT(*) FROM cat_views WHERE cat_id=? AND user_id=?")) {
                verify.setString(1, catId);
                verify.setString(2, adoptedBy);
                try (ResultSet rs = verify.executeQuery()) {
                    if (!rs.next() || rs.getInt(1) == 0 || adoptedBy.equals(userId))
                        throw new SQLException("Select a user who viewed this cat");
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE cats SET adopted_by=?, adopted_at=SYSTIMESTAMP WHERE id=? AND cat_owner_id=?")) {
                ps.setString(1, adoptedBy);
                ps.setString(2, catId);
                ps.setString(3, userId);
                ps.executeUpdate();
            }
        } else {
            try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE cats SET adopted_by=NULL, adopted_at=NULL WHERE id=? AND cat_owner_id=?")) {
                ps.setString(1, catId);
                ps.setString(2, userId);
                ps.executeUpdate();
            }
        }
        conn.commit();
        success = true;
    } catch (Exception e) {
        conn.rollback();
        throw e;
    }
} catch (Exception e) {
    message = "Database error: " + e.getMessage();
    e.printStackTrace();
}
json.put("success", success);
json.put("message", message);
out.print(json.toString());
%>
