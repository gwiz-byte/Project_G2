<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    model.User user = (model.User) session.getAttribute("userAuth");
    // Các biến giả lập số liệu, sau này thay bằng dữ liệu động
    int totalUsers = 1200;
    int totalProducts = 350;
    double totalRevenue = 12500000.5;
    int ordersProcessed = 320;
    int ordersPending = 18;
    int visitsToday = 450;
    int visitsWeek = 3200;
    int newUsersToday = 8;
    int newUsersWeek = 45;
    String lastActiveUser = "Nguyen Van A";
    int lockedAccounts = 2;
    int hiddenProducts = 12;
    int outOfStock = 7;
    String topService = "Express Delivery";
    int delayedOrders = 3;
    int systemErrors = 1;
    int newFeedback = 5;
%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
    body { background: #f8fafc; }
    .dashboard-section { margin-bottom: 2.5rem; }
    .dashboard-title { font-size: 1.5rem; font-weight: 700; color: #2563eb; margin-bottom: 1.2rem; }
    .stat-card { border-radius: 1.2rem; box-shadow: 0 2px 8px rgba(37,99,235,0.07); border: none; }
    .stat-icon { font-size: 2.2rem; margin-right: 0.7rem; }
    .stat-value { font-size: 2rem; font-weight: 700; }
    .stat-label { color: #64748b; font-size: 1rem; }
    .alert-custom { border-radius: 1rem; font-size: 1.08rem; }
    .chart-container { background: #fff; border-radius: 1.2rem; box-shadow: 0 2px 8px rgba(37,99,235,0.07); padding: 1.5rem; }
    .user-list { list-style: none; padding: 0; margin: 0; }
    .user-list li { padding: 0.5rem 0; border-bottom: 1px solid #f1f5f9; }
    .user-list li:last-child { border-bottom: none; }
</style>
<div class="container py-4 pt-5">
    <!-- 1. System Overview -->
    <div class="dashboard-section">
        <div class="dashboard-title"><i class="fas fa-chart-pie me-2"></i> System Overview</div>
        <div class="row g-4">
            <div class="col-md-3">
                <div class="card stat-card p-3 d-flex flex-row align-items-center">
                    <i class="fas fa-users stat-icon text-primary"></i>
                    <div>
                        <div class="stat-value"><%= totalUsers %></div>
                        <div class="stat-label">Users</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-3 d-flex flex-row align-items-center">
                    <i class="fas fa-boxes stat-icon text-success"></i>
                    <div>
                        <div class="stat-value"><%= totalProducts %></div>
                        <div class="stat-label">Products</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-3 d-flex flex-row align-items-center">
                    <i class="fas fa-coins stat-icon text-warning"></i>
                    <div>
                        <div class="stat-value"><%= String.format("%,.0f", totalRevenue) %>₫</div>
                        <div class="stat-label">Total Revenue</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-3 d-flex flex-row align-items-center">
                    <i class="fas fa-shopping-cart stat-icon text-danger"></i>
                    <div>
                        <div class="stat-value"><%= ordersProcessed %> / <span class="text-muted" style="font-size:1.2rem"><%= ordersPending %></span></div>
                        <div class="stat-label">Orders Processed / Pending</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row g-4 mt-2">
            <div class="col-md-3">
                <div class="card stat-card p-3 d-flex flex-row align-items-center">
                    <i class="fas fa-eye stat-icon text-info"></i>
                    <div>
                        <div class="stat-value"><%= visitsToday %></div>
                        <div class="stat-label">Visits Today</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-3 d-flex flex-row align-items-center">
                    <i class="fas fa-calendar-week stat-icon text-secondary"></i>
                    <div>
                        <div class="stat-value"><%= visitsWeek %></div>
                        <div class="stat-label">Visits This Week</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 2. Time-based Statistics -->
    <div class="dashboard-section">
        <div class="dashboard-title"><i class="fas fa-chart-line me-2"></i> Time-based Statistics</div>
        <div class="row g-4">
            <div class="col-md-6">
                <div class="chart-container mb-2">
                    <canvas id="revenueChart" height="120"></canvas>
                </div>
            </div>
            <div class="col-md-6">
                <div class="chart-container mb-2">
                    <canvas id="ordersChart" height="120"></canvas>
                </div>
            </div>
        </div>
    </div>
    <!-- 3. User Information -->
    <div class="dashboard-section">
        <div class="dashboard-title"><i class="fas fa-user-friends me-2"></i> User Information</div>
        <div class="row g-4">
            <div class="col-md-3">
                <div class="card stat-card p-3">
                    <div class="stat-label mb-1">New Users Today</div>
                    <div class="stat-value text-success"><%= newUsersToday %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-3">
                    <div class="stat-label mb-1">New Users This Week</div>
                    <div class="stat-value text-info"><%= newUsersWeek %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-3">
                    <div class="stat-label mb-1">Last Active User</div>
                    <div class="stat-value text-primary"><%= lastActiveUser %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-3">
                    <div class="stat-label mb-1">Locked Accounts</div>
                    <div class="stat-value text-danger"><%= lockedAccounts %></div>
                </div>
            </div>
        </div>
        <div class="row g-4 mt-2">
            <div class="col-md-6">
                <div class="card stat-card p-3">
                    <div class="stat-label mb-2">Top Active Users</div>
                    <ul class="user-list">
                        <li>Nguyen Van B <span class="badge bg-success">Top 1</span></li>
                        <li>Le Thi C <span class="badge bg-info">Top 2</span></li>
                        <li>Tran D <span class="badge bg-warning text-dark">Top 3</span></li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card stat-card p-3">
                    <div class="stat-label mb-2">Accounts with Issues</div>
                    <ul class="user-list">
                        <li>Pham E <span class="badge bg-danger">Locked</span></li>
                        <li>Nguyen F <span class="badge bg-warning text-dark">Warning</span></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <!-- 4. Content / Service Management -->
    <div class="dashboard-section">
        <div class="dashboard-title"><i class="fas fa-box-open me-2"></i> Content / Service Management</div>
        <div class="row g-4">
            <div class="col-md-3">
                <div class="card stat-card p-3">
                    <div class="stat-label mb-1">Visible Products</div>
                    <div class="stat-value text-success"><%= totalProducts - hiddenProducts %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-3">
                    <div class="stat-label mb-1">Hidden Products</div>
                    <div class="stat-value text-secondary"><%= hiddenProducts %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-3">
                    <div class="stat-label mb-1">Out of Stock</div>
                    <div class="stat-value text-danger"><%= outOfStock %></div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-3">
                    <div class="stat-label mb-1">Top Service</div>
                    <div class="stat-value text-warning"><%= topService %></div>
                </div>
            </div>
        </div>
    </div>
    <!-- 5. Alerts / Important Events -->
    <div class="dashboard-section">
        <div class="dashboard-title"><i class="fas fa-exclamation-triangle me-2 text-danger"></i> Alerts / Important Events</div>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="alert alert-warning alert-custom d-flex align-items-center"><i class="fas fa-clock me-2"></i> <b><%= delayedOrders %></b> orders are delayed!</div>
            </div>
            <div class="col-md-4">
                <div class="alert alert-danger alert-custom d-flex align-items-center"><i class="fas fa-bug me-2"></i> <b><%= systemErrors %></b> system errors need attention!</div>
            </div>
            <div class="col-md-4">
                <div class="alert alert-info alert-custom d-flex align-items-center"><i class="fas fa-comment-dots me-2"></i> <b><%= newFeedback %></b> new user feedbacks.</div>
            </div>
        </div>
    </div>
</div>
<script>
// Chart.js demo data
const revenueChart = new Chart(document.getElementById('revenueChart').getContext('2d'), {
    type: 'line',
    data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
            label: 'Revenue (million ₫)',
            data: [12, 19, 8, 15, 22, 30, 25],
            borderColor: '#2563eb',
            backgroundColor: 'rgba(37,99,235,0.08)',
            tension: 0.4,
            fill: true
        }]
    },
    options: { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
});
const ordersChart = new Chart(document.getElementById('ordersChart').getContext('2d'), {
    type: 'bar',
    data: {
        labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        datasets: [{
            label: 'Orders',
            data: [20, 25, 18, 30, 28, 35, 40],
            backgroundColor: '#f59e42',
            borderRadius: 8
        }]
    },
    options: { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
});
</script> 