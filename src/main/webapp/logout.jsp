<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Invalidate the session
    session.invalidate();
    
    // Redirect to home page
    response.sendRedirect("index.jsp");
%>