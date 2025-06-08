<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%
    // Check if user is logged in and is an admin
    User user = (User) session.getAttribute("userAuth");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Check if user is admin
    if (!"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/homepageservlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #343a40;
            padding-top: 20px;
        }
        .sidebar .logo-container {
            padding: 15px 20px;
        }
        .sidebar .logo-container h3 {
            margin: 0;
        }
        .admin-profile {
            padding: 15px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 15px;
        }
        .admin-profile img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 10px;
        }
        .admin-profile .admin-info {
            color: #fff;
        }
        .admin-profile .admin-info h6 {
            margin: 0;
            font-weight: 600;
        }
        .admin-profile .admin-info small {
            color: rgba(255,255,255,0.7);
        }
        .sidebar a {
            color: #fff;
            text-decoration: none;
            padding: 10px 20px;
            display: block;
        }
        .sidebar a:hover {
            background-color: #495057;
        }
        .sidebar a.active {
            background-color: #495057;
        }
        .main-content {
            padding: 20px;
        }
        .card {
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .stat-card {
            border-radius: 15px;
            border: none;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="sidebar.jsp" />
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content" style="padding:0;">
                <iframe id="mainFrame" name="mainFrame" src="${pageContext.request.contextPath}/adminHome.jsp" style="width:100%;height:100vh;border:none;"></iframe>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 