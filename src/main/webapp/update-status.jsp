<%@ page import="java.sql.*, utils.DBConnection, org.json.JSONObject" %>
<%
response.setContentType("application/json;charset=UTF-8");

boolean success = false;
String message = "";
String userId = (String) session.getAttribute("userId");
String userRole = (String) session.getAttribute("userRole");
boolean isAdmin = "admin".equals(userRole);
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
String adoptStatus = request.getParameter("adoptStatus");
String approvalStatus = request.getParameter("approvalStatus");



if (catId == null) {
    json.put("success", false);
    json.put("message", "Missing required parameters");
    out.print(json.toString());
    return;
}

try (Connection conn = DBConnection.getConnection()) {
    int rows;
    if (approvalStatus != null) {
        if (!isAdmin) {
            json.put("success", false);
            json.put("message", "Only admin can update approval status");
            out.print(json.toString());
            return;
        }
        if (!"0".equals(approvalStatus) && !"1".equals(approvalStatus) && !"2".equals(approvalStatus)) {
            json.put("success", false);
            json.put("message", "Approval status must be 0 (pending), 1 (accepted), or 2 (rejected).");
            out.print(json.toString());
            return;
        }
        try (PreparedStatement ps = conn.prepareStatement("UPDATE cats SET is_approved = ? WHERE id = ?")) {
            ps.setString(1, approvalStatus);
            ps.setString(2, catId);
            rows = ps.executeUpdate();
        }
    } else if ("1".equals(adoptStatus)) {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE cats SET adopted_by = ?, adopted_at = SYSTIMESTAMP WHERE id = ? AND adopted_by IS NULL")) {
            ps.setString(1, userId);
            ps.setString(2, catId);
            rows = ps.executeUpdate();
        }
    } else if ("0".equals(adoptStatus)) {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE cats SET adopted_by = NULL, adopted_at = NULL WHERE id = ?")) {
            ps.setString(1, catId);
            rows = ps.executeUpdate();
        }
    } else {
        json.put("success", false);
        json.put("message", "Invalid adoption status");
        out.print(json.toString());
        return;
    }

    success = rows > 0;
    if (!success) message = "Cat was not updated; it may already be adopted.";
} catch (SQLException e) {
    if (e.getErrorCode() == 2290 || (e.getMessage() != null && e.getMessage().contains("ORA-02290"))) {
        message = approvalStatus != null
            ? "The database must allow rejected status 2. Run sql/allow-rejected-cat-status.sql."
            : "You cannot adopt your own cat.";
    } else {
        message = "Database error: " + e.getMessage();
        e.printStackTrace();
    }
} catch (Exception e) {
    message = "Database error: " + e.getMessage();
    e.printStackTrace();
}

json.put("success", success);
json.put("message", message);
out.print(json.toString());
%>
