<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Redirect to PersonalController
    String qs = request.getQueryString();
    String target = request.getContextPath() + "/personal" + (qs != null ? "?" + qs : "");
    response.sendRedirect(target);
%>