<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h2 class="mb-4">Dashboard Overview</h2>
<!-- Statistics Cards -->
<div class="row mb-4">
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stat-card bg-primary text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase mb-0">Total Products</h6>
                        <h2 class="mb-0">${totalProducts}</h2>
                    </div>
                    <i class="fas fa-box fa-2x"></i>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stat-card bg-success text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase mb-0">Total Customers</h6>
                        <h2 class="mb-0">${totalCustomers}</h2>
                    </div>
                    <i class="fas fa-users fa-2x"></i>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stat-card bg-info text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase mb-0">Total Orders</h6>
                        <h2 class="mb-0">${totalOrders}</h2>
                    </div>
                    <i class="fas fa-shopping-cart fa-2x"></i>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card stat-card bg-warning text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase mb-0">Total Revenue</h6>
                        <h2 class="mb-0">$${totalRevenue}</h2>
                    </div>
                    <i class="fas fa-dollar-sign fa-2x"></i>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Quick Actions -->
<div class="row mb-4">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">Quick Actions</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/adminLayout.jsp?content=addProduct.jsp&title=Add New Product" class="btn btn-primary w-100">
                            <i class="fas fa-plus me-2"></i> Add New Product
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/adminLayout.jsp?content=categoryContent.jsp&title=Manage Categories" class="btn btn-success w-100">
                            <i class="fas fa-folder-plus me-2"></i> Manage Categories
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/adminLayout.jsp?content=customerContent.jsp&title=Customer Management" class="btn btn-info w-100">
                            <i class="fas fa-user-plus me-2"></i> View Customers
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/adminLayout.jsp?content=blogContent.jsp&title=Blog Management" class="btn btn-warning w-100">
                            <i class="fas fa-edit me-2"></i> Manage Blogs
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Recent Activities -->
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">Recent Activities</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Activity</th>
                                <th>User</th>
                                <th>Time</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recentActivities}" var="activity">
                                <tr>
                                    <td>${activity.description}</td>
                                    <td>${activity.user}</td>
                                    <td>${activity.time}</td>
                                    <td>
                                        <span class="badge bg-${activity.status == 'Completed' ? 'success' : 'warning'}">
                                            ${activity.status}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div> 