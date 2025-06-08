<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    model.User user = (model.User) session.getAttribute("userAuth");
%>
<style>
    body.admin-home-bg {
        background: linear-gradient(135deg, #e0e7ff 0%, #f8fafc 100%);
        min-height: 100vh;
    }
    .admin-home-card {
        background: #fff;
        border-radius: 20px;
        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.12);
        padding: 40px 32px 32px 32px;
        max-width: 700px;
        margin: 40px auto 0 auto;
        text-align: center;
        position: relative;
    }
    .admin-home-avatar {
        width: 110px;
        height: 110px;
        border-radius: 50%;
        box-shadow: 0 4px 16px rgba(111,66,193,0.15);
        margin-bottom: 18px;
        border: 4px solid #e0e7ff;
        background: #fff;
    }
    .admin-home-title {
        font-family: 'Segoe UI', 'Roboto', Arial, sans-serif;
        font-size: 2.2rem;
        font-weight: 700;
        color: #6f42c1;
        margin-bottom: 10px;
    }
    .admin-home-desc {
        color: #555;
        font-size: 1.1rem;
        margin-bottom: 30px;
    }
    .admin-home-shortcuts {
        display: flex;
        flex-wrap: wrap;
        gap: 18px;
        justify-content: center;
    }
    .admin-home-shortcut-btn {
        min-width: 170px;
        padding: 18px 0;
        border-radius: 14px;
        font-size: 1.08rem;
        font-weight: 500;
        box-shadow: 0 2px 8px rgba(111,66,193,0.07);
        border: none;
        transition: transform 0.13s, box-shadow 0.13s, background 0.13s;
        background: #f3f0ff;
        color: #6f42c1;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
    }
    .admin-home-shortcut-btn:hover {
        background: #6f42c1;
        color: #fff;
        transform: translateY(-3px) scale(1.04);
        box-shadow: 0 6px 18px rgba(111,66,193,0.13);
        text-decoration: none;
    }
    .admin-home-shortcut-btn i {
        font-size: 1.5rem;
    }
    @media (max-width: 600px) {
        .admin-home-card { padding: 18px 6px; }
        .admin-home-title { font-size: 1.3rem; }
        .admin-home-shortcut-btn { min-width: 120px; font-size: 0.98rem; }
    }
</style>
<script>
    document.body.classList.add('admin-home-bg');
</script>
<div class="admin-home-card">
    <img src="${pageContext.request.contextPath}/assets/admin-avartar.png.jpg" alt="Admin Avatar" class="admin-home-avatar">
    <div class="admin-home-title">Welcome, <span>${user.fullname}</span>!</div>
    <div class="admin-home-desc">
        You are at the main administration page of the <b>CES</b> system.<br>
        Use the shortcuts below to manage products, customers, orders, blogs, and feedback.
    </div>
    <div class="admin-home-shortcuts">
        <a href="${pageContext.request.contextPath}/categoryList.jsp" target="mainFrame" class="admin-home-shortcut-btn">
            <i class="fas fa-list"></i> Categories
        </a>
        <a href="productservlet" target="mainFrame" class="admin-home-shortcut-btn">
            <i class="fas fa-box"></i> Products
        </a>
        <a href="${pageContext.request.contextPath}/viewcustomers" target="mainFrame" class="admin-home-shortcut-btn">
            <i class="fas fa-users"></i> Customers
        </a>
        <a href="${pageContext.request.contextPath}/viewblogs" target="mainFrame" class="admin-home-shortcut-btn">
            <i class="fas fa-blog"></i> Blogs
        </a>
        <a href="${pageContext.request.contextPath}/viewfeedback" target="mainFrame" class="admin-home-shortcut-btn">
            <i class="fas fa-comments"></i> Feedback
        </a>
    </div>
</div> 