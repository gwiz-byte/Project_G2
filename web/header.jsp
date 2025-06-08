<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Top Bar -->
<div class="top-bar">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <i class="fas fa-phone-alt me-2"></i> 24/7 Customer Service: 1-800-123-4567
            </div>
            <div class="col-md-6 text-end">
                <span class="me-3"><i class="fas fa-truck me-1"></i> Free shipping on orders over $100</span>
                <span><i class="fas fa-map-marker-alt me-1"></i> Track Order</span>
            </div>
        </div>
    </div>
</div>

<!-- Main Navigation -->
<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/homepageservlet">
            <i class="fas fa-microchip me-2"></i>
            <span class="fw-bold">CES</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" id="productsDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        All Products
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="productsDropdown">
                        <li><a class="dropdown-item" href="#">CPUs</a></li>
                        <li><a class="dropdown-item" href="#">Motherboards</a></li>
                        <li><a class="dropdown-item" href="#">Graphics Cards</a></li>
                        <li><a class="dropdown-item" href="#">Memory (RAM)</a></li>
                        <li><a class="dropdown-item" href="#">Storage</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">New Arrivals</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Today's Deals</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Custom Builds</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/viewblogs">Blog</a>
                </li>
            </ul>
            <form class="d-flex me-3">
                <div class="input-group">
                    <input type="search" class="form-control" placeholder="Search products...">
                    <button class="btn btn-outline-primary" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </form>
            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${not empty sessionScope.userAuth}">
                        <!-- User Dropdown -->
                        <div class="dropdown me-3">
                            <c:choose>
                                <c:when test="${fn:toLowerCase(sessionScope.user_role) eq 'admin'}">
                                    <a class="btn btn-outline-primary dropdown-toggle" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fas fa-user me-1"></i>
                                        ${fn:trim(fn:replace(sessionScope.user_name, '(Admin)', ''))} (Admin)
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown">
                                        <li>
                                            <a class="dropdown-item text-primary" href="${pageContext.request.contextPath}/adminDashboard.jsp">
                                                <i class="fas fa-gauge-high me-2"></i>Admin Dashboard
                                            </a>
                                        </li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/adminDashboard.jsp">
                                                <i class="fas fa-user-circle me-2"></i>Profile
                                            </a>
                                        </li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orderHistory"><i class="fas fa-history me-2"></i>Order History</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                                    </ul>
                                </c:when>
                                <c:otherwise>
                                    <a class="btn btn-outline-primary dropdown-toggle" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fas fa-user me-1"></i>
                                        ${sessionScope.user_name}
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown">
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                                <i class="fas fa-user-circle me-2"></i>Profile
                                            </a>
                                        </li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orderHistory"><i class="fas fa-history me-2"></i>Order History</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                                    </ul>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary me-2">
                            <i class="fas fa-user me-1"></i> Login
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary me-2">
                            <i class="fas fa-user-plus me-1"></i> Register
                        </a>
                    </c:otherwise>
                </c:choose>
                <a href="view-cart" class="btn btn-outline-primary position-relative">
                    <i class="fas fa-shopping-cart"></i>
                    <span id="cartCount" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                        0
                    </span>
                </a>
            </div>
        </div>
    </div>
</nav> 