<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    String userId = (String) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get user data from session
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String userProfilePicture = (String) session.getAttribute("userProfilePicture");
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Profile</title>
    
</head>
<body>
    <!-- Profile page content -->
    <h1>Welcome, <%= userName %></h1>
    <!-- Rest of profile page -->
</body>
</html>