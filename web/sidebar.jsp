<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("userAuth");
%>
<!-- Sidebar -->
<div class="col-md-3 col-lg-2 sidebar">
    <div class="logo-container">
        <h3 class="text-light">
            <i class="fas fa-microchip me-2"></i>
            <span class="fw-bold">CES</span>
        </h3>
    </div>
    
    <!-- Admin Profile -->
    <div class="admin-profile d-flex align-items-center">
        <img src="${pageContext.request.contextPath}/assets/admin-avartar.png.jpg" alt="Admin Avatar" class="admin-avatar" style="width:50px;height:50px;border-radius:50%;object-fit:cover;background:#e0e7ff;">
        <div class="admin-info">
            <h6>${user.fullname}</h6>
            <small>Administrator</small>
        </div>
    </div>

    <nav>
        <a href="${pageContext.request.contextPath}/adminDashboard.jsp" class="<%= request.getRequestURI().endsWith("adminDashboard.jsp") ? "active" : "" %>">
            <i class="fas fa-home me-2"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/categoryList.jsp" target="mainFrame" class="<%= request.getRequestURI().endsWith("categoryList.jsp") ? "active" : "" %>">
            <i class="fas fa-list me-2"></i> Categories
        </a>
        <a href="productservlet" target="mainFrame" class="<%= request.getRequestURI().contains("productservlet") ? "active" : "" %>">
            <i class="fas fa-box me-2"></i> Products
        </a>
        <a href="${pageContext.request.contextPath}/viewcustomers" target="mainFrame" class="<%= request.getRequestURI().contains("viewcustomers") ? "active" : "" %>">
            <i class="fas fa-users me-2"></i> Customers
        </a>
        <a href="${pageContext.request.contextPath}/viewblogs" target="mainFrame" class="<%= request.getRequestURI().contains("viewblogs") ? "active" : "" %>">
            <i class="fas fa-blog me-2"></i> Blogs
        </a>
        <a href="${pageContext.request.contextPath}/viewfeedback" target="mainFrame" class="<%= request.getRequestURI().contains("viewfeedback") ? "active" : "" %>">
            <i class="fas fa-comments me-2"></i> Feedback
        </a>
        <a href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt me-2"></i> Logout
        </a>
    </nav>
</div>