<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Customer Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .customer-card {
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .customer-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .customer-meta {
            font-size: 0.9em;
            color: #666;
        }
        .filter-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .pagination {
            margin-top: 30px;
        }
        .action-buttons {
            margin-top: 10px;
            display: flex;
            gap: 10px;
        }
        .role-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8em;
            font-weight: 500;
        }
        .role-admin {
            background-color: #dc3545;
            color: white;
        }
        .role-customer {
            background-color: #28a745;
            color: white;
        }
        .role-staff {
            background-color: #007bff;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center mb-4">Customer Management</h1>
        
        <!-- Add New Customer Button -->
        <div class="text-end mb-4">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                <i class="bi bi-person-plus"></i> Add New Customer
            </button>
        </div>

        <!-- Stats Section -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body text-center">
                        <h5>Total Customers: ${totalCustomers}</h5>
                        <p class="mb-0">Page ${currentPage} of ${totalPages}</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-section">
            <form action="viewcustomers" method="GET" class="row g-3">
                <input type="hidden" name="page" value="${currentPage}">
                <div class="col-md-3">
                    <label class="form-label">Sort By:</label>
                    <select name="sortBy" class="form-select" onchange="this.form.submit()">
                        <option value="id" ${param.sortBy == 'id' ? 'selected' : ''}>ID</option>
                        <option value="name" ${param.sortBy == 'name' ? 'selected' : ''}>Name</option>
                        <option value="email" ${param.sortBy == 'email' ? 'selected' : ''}>Email</option>
                        <option value="role" ${param.sortBy == 'role' ? 'selected' : ''}>Role</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Filter by Role:</label>
                    <select name="role" class="form-select" onchange="this.form.submit()">
                        <option value="">All Roles</option>
                        <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Admin</option>
                        <option value="staff" ${param.role == 'staff' ? 'selected' : ''}>Staff</option>
                        <option value="customer" ${param.role == 'customer' ? 'selected' : ''}>Customer</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Search:</label>
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" 
                               placeholder="Search by name, email, or phone..." 
                               value="${param.search}">
                        <button class="btn btn-outline-secondary" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Customers Display -->
        <div class="row">
            <c:forEach items="${customerList}" var="customer">
                <div class="col-md-6">
                    <div class="card customer-card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h5 class="card-title mb-0">${customer.name}</h5>
                                <span class="role-badge role-${customer.role.toLowerCase()}">${customer.role}</span>
                            </div>
                            <div class="customer-meta mb-3">
                                <p class="mb-1">
                                    <i class="bi bi-envelope"></i> ${customer.email}
                                </p>
                                <p class="mb-1">
                                    <i class="bi bi-telephone"></i> ${customer.phone_number}
                                </p>
                                <p class="mb-1">
                                    <i class="bi bi-geo-alt"></i> ${customer.address}
                                </p>
                            </div>
                            <div class="action-buttons">
                                <button type="button" class="btn btn-sm btn-primary" 
                                        onclick="editCustomer(${customer.id}, '${customer.name}', '${customer.email}', 
                                                           '${customer.phone_number}', '${customer.address}', '${customer.role}')"
                                        data-bs-toggle="modal" data-bs-target="#editCustomerModal">
                                    <i class="bi bi-pencil"></i> Edit
                                </button>
                                <button type="button" class="btn btn-sm btn-warning" 
                                        onclick="resetPassword(${customer.id})"
                                        data-bs-toggle="modal" data-bs-target="#resetPasswordModal">
                                    <i class="bi bi-key"></i> Reset Password
                                </button>
                                <button type="button" class="btn btn-sm btn-danger" 
                                        onclick="deleteCustomer(${customer.id}, '${customer.name}')"
                                        data-bs-toggle="modal" data-bs-target="#deleteCustomerModal">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty customerList}">
                <div class="col-12 text-center">
                    <div class="alert alert-info" role="alert">
                        <i class="bi bi-info-circle"></i> No customers found.
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Customer pagination" class="d-flex justify-content-center">
                <ul class="pagination">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="viewcustomers?page=${currentPage - 1}&sortBy=${param.sortBy}&role=${param.role}&search=${param.search}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="viewcustomers?page=${i}&sortBy=${param.sortBy}&role=${param.role}&search=${param.search}">
                                ${i}
                            </a>
                        </li>
                    </c:forEach>
                    
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="viewcustomers?page=${currentPage + 1}&sortBy=${param.sortBy}&role=${param.role}&search=${param.search}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>

    <!-- Add Customer Modal -->
    <div class="modal fade" id="addCustomerModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Customer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="Customer_control" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label class="form-label">Name:</label>
                            <input type="text" class="form-control" name="name" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Email:</label>
                            <input type="email" class="form-control" name="email" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Password:</label>
                            <input type="password" class="form-control" name="password" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Phone Number:</label>
                            <input type="tel" class="form-control" name="phone_number" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Address:</label>
                            <textarea class="form-control" name="address" rows="2" required></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Role:</label>
                            <select class="form-select" name="role" required>
                                <option value="customer">Customer</option>
                                <option value="staff">Staff</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Add Customer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Customer Modal -->
    <div class="modal fade" id="editCustomerModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Customer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="Customer_control" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="customer_id" id="edit_customer_id">
                        
                        <div class="mb-3">
                            <label class="form-label">Name:</label>
                            <input type="text" class="form-control" name="name" id="edit_name" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Email:</label>
                            <input type="email" class="form-control" name="email" id="edit_email" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Phone Number:</label>
                            <input type="tel" class="form-control" name="phone_number" id="edit_phone" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Address:</label>
                            <textarea class="form-control" name="address" id="edit_address" rows="2" required></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Role:</label>
                            <select class="form-select" name="role" id="edit_role" required>
                                <option value="customer">Customer</option>
                                <option value="staff">Staff</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Update Customer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Reset Password Modal -->
    <div class="modal fade" id="resetPasswordModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reset Password</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="Customer_control" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="updatePassword">
                        <input type="hidden" name="customer_id" id="reset_customer_id">
                        
                        <div class="mb-3">
                            <label class="form-label">New Password:</label>
                            <input type="password" class="form-control" name="new_password" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Confirm Password:</label>
                            <input type="password" class="form-control" name="confirm_password" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Reset Password</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Customer Modal -->
    <div class="modal fade" id="deleteCustomerModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Delete Customer</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="Customer_control" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="customer_id" id="delete_customer_id">
                        <p>Are you sure you want to delete customer <span id="delete_customer_name" class="fw-bold"></span>? This action cannot be undone.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editCustomer(id, name, email, phone, address, role) {
            document.getElementById('edit_customer_id').value = id;
            document.getElementById('edit_name').value = name;
            document.getElementById('edit_email').value = email;
            document.getElementById('edit_phone').value = phone;
            document.getElementById('edit_address').value = address;
            document.getElementById('edit_role').value = role.toLowerCase();
        }
        
        function resetPassword(id) {
            document.getElementById('reset_customer_id').value = id;
        }
        
        function deleteCustomer(id, name) {
            document.getElementById('delete_customer_id').value = id;
            document.getElementById('delete_customer_name').textContent = name;
        }
    </script>
</body>
</html> 