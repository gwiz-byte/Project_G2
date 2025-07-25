<%@ page import="java.util.List" %>
<%@ page import="model.MenuAttributeValue" %>
<%@ page import="model.MenuAttribute" %>
<%@ page import="dal.MenuAttributeDAO" %>
<%@ page import="dal.MenuAttributeValueDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%
    List<MenuAttributeValue> list = (List<MenuAttributeValue>) request.getAttribute("menuAttributeValues");
    List<MenuAttribute> menuAttributes = (List<MenuAttribute>) request.getAttribute("menuAttributes");
    
    // Xử lý khi truy cập trực tiếp JSP
    if (list == null) {
        list = MenuAttributeValueDAO.getMenuAttributeValues(null, null, 0, 10);
    }
    if (menuAttributes == null) {
        menuAttributes = MenuAttributeDAO.getAllMenuAttributes(null, null);
    }
    
    String ctx = request.getContextPath();
    String sortOrder = (String) request.getAttribute("sortOrder");
    String currentSort = sortOrder != null ? sortOrder : "default";
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    String search = (String) request.getAttribute("search");
    String searchParam = search != null ? "&search=" + java.net.URLEncoder.encode(search, "UTF-8") : "";
    String sortParam = "&sort=" + currentSort;
    String defaultUrl = ctx + "/menuAttributeValueManagement?sort=default" + searchParam;
    String ascUrl = ctx + "/menuAttributeValueManagement?sort=asc" + searchParam;
    String descUrl = ctx + "/menuAttributeValueManagement?sort=desc" + searchParam;
    String statusAscUrl = ctx + "/menuAttributeValueManagement?sort=status_asc" + searchParam;
    String statusDescUrl = ctx + "/menuAttributeValueManagement?sort=status_desc" + searchParam;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu (level 3)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; }
        .table-wrapper {
            background-color: white;
            padding: 1.5rem;
            border-radius: .5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,.1);
        }
        .btn-action { background: none; border: none; padding: 0; margin: 0 8px; color: #6c757d; font-size: 1.1rem; }
        .btn-action:hover { color: #0d6efd; }
        .text-danger:hover { color: #dc3545 !important; }
        .page-info { display: inline-block; padding: 0.375rem 0.75rem; background-color: #0d6efd; color: white; border-radius: 0.25rem; margin: 0 5px; font-weight: 500; }
        .table thead th { font-weight: 600; color: #343a40; }
        .sort-column {
            display: flex;
            align-items: center;
            gap: 3px;
        }
        .sort-icons {
            display: inline-flex;
            flex-direction: column;
            margin-left: 3px;
            height: 16px;
        }
        .sort-icon {
            cursor: pointer;
            color: #6c757d;
            line-height: 8px;
            font-size: 11px;
            margin: -2px 0;
        }
        .sort-icon:hover {
            color: #0d6efd;
        }
        .sort-active {
            color: #0d6efd;
        }
        .sort-icon i {
            display: block;
        }
    </style>
</head>
<body class="bg-light">
<div class="container my-5">
    <div class="table-wrapper">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="mb-0">Menu Attribute Values</h4>
            <span class="text-muted">Total Values: <%= request.getAttribute("totalMenuAttributeValues") != null ? request.getAttribute("totalMenuAttributeValues") : "N/A" %></span>
        </div>

        <div class="row g-3 align-items-center mb-4">
            <div class="col-md-3">
                <select class="form-select" id="sortControl" onchange="window.location.href = this.value;">
                    <option value="<%= defaultUrl %>" <%= "default".equals(currentSort) ? "selected" : "" %>>Sort by ID</option>
                    <option value="<%= ascUrl %>" <%= "asc".equals(currentSort) ? "selected" : "" %>>Name A-Z</option>
                    <option value="<%= descUrl %>" <%= "desc".equals(currentSort) ? "selected" : "" %>>Name Z-A</option>
                </select>
            </div>
            <div class="col-md-6">
                <form action="<%= ctx %>/menuAttributeValueManagement" method="get">
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" placeholder="Search by value, URL, or attribute..." value="<%= search != null ? search : "" %>"/>
                        <% if (sortOrder != null) { %>
                        <input type="hidden" name="sort" value="<%= sortOrder %>"/>
                        <% } %>
                        <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i></button>
                    </div>
                </form>
            </div>
            <div class="col-md-3 text-end">
                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addMenuAttributeValueModal">
                    <i class="fas fa-plus"></i> Add Value
                </button>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Value</th>
                    <th>URL</th>
                    <th>Attribute</th>
                    <th>
                        <div class="sort-column">
                            Status
                            <div class="sort-icons">
                                <span class="sort-icon <%= "status_asc".equals(currentSort) ? "sort-active" : "" %>" onclick="window.location.href='<%= statusAscUrl %>'">
                                    <i class="fas fa-sort-up"></i>
                                </span>
                                <span class="sort-icon <%= "status_desc".equals(currentSort) ? "sort-active" : "" %>" onclick="window.location.href='<%= statusDescUrl %>'">
                                    <i class="fas fa-sort-down"></i>
                                </span>
                            </div>
                        </div>
                    </th>
                    <th class="text-center">Actions</th>
                </tr>
                </thead>
                <tbody>
                <% if (list != null && !list.isEmpty()) {
                    for (MenuAttributeValue value : list) { %>
                <tr>
                    <td><strong><%= value.getValueId() %></strong></td>
                    <td><%= value.getValue() %></td>
                    <td><%= value.getUrl() %></td>
                    <td>
                        <% for(MenuAttribute ma : menuAttributes) { if(ma.getAttributeId() == value.getAttributeId()) { %>
                            <%= ma.getName() %>
                        <% }} %>
                    </td>
                    <td><%= value.getStatus() %></td>
                    <td class="text-center">
                        <button class="btn-action" 
                                onclick="editMenuAttributeValue(this)"
                                data-bs-toggle="modal"
                                data-bs-target="#editMenuAttributeValueModal"
                                title="Edit"
                                data-id="<%= value.getValueId() %>"
                                data-value="<%= value.getValue().replace("\"", "&quot;").replace("'", "&#39;") %>"
                                data-url="<%= value.getUrl() != null ? value.getUrl().replace("\"", "&quot;").replace("'", "&#39;") : "" %>"
                                data-attributeid="<%= value.getAttributeId() %>"
                                data-status="<%= value.getStatus() %>">
                            <i class="fas fa-edit"></i>
                        </button>
                    </td>
                </tr>
                <%  }
                } else { %>
                <tr><td colspan="6" class="text-center py-5">No values found.</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <div id="menuAttributeValuesJsonContainer" data-json="<%= new Gson().toJson(list).replace("\"", "&quot;").replace("'", "&#39;") %>" style="display:none;"></div>
        <% if (totalPages != null && totalPages > 1) { %>
        <nav aria-label="Page navigation" class="mt-4 d-flex justify-content-end align-items-center">
            <% String prevLink = ctx + "/menuAttributeValueManagement?page=" + (currentPage - 1) + searchParam + sortParam; %>
            <a href="<%= currentPage > 1 ? prevLink : "#" %>" class="btn btn-outline-primary <%= currentPage <= 1 ? "disabled" : "" %>">Previous</a>
            <span class="page-info"><%= currentPage %> / <%= totalPages %></span>
            <% String nextLink = ctx + "/menuAttributeValueManagement?page=" + (currentPage + 1) + searchParam + sortParam; %>
            <a href="<%= currentPage < totalPages ? nextLink : "#" %>" class="btn btn-outline-primary <%= currentPage >= totalPages ? "disabled" : "" %>">Next</a>
        </nav>
        <% } %>
    </div>
</div>

<!-- Add Value Modal -->
<div class="modal fade" id="addMenuAttributeValueModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Value</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="<%= ctx %>/menuAttributeValueManagement" method="post" novalidate>
                    <input type="hidden" name="action" value="add" />
                    <div class="mb-3">
                        <label for="value" class="form-label">Value</label>
                        <input type="text" class="form-control" id="value" name="value" required>
                        <div class="invalid-feedback">Giá trị không được để trống và không quá 100 ký tự.</div>
                    </div>
                    <div class="mb-3">
                        <label for="url" class="form-label">URL</label>
                        <input type="text" class="form-control" id="url" name="url">
                        <div class="invalid-feedback">URL không được quá 255 ký tự.</div>
                    </div>
                    <div class="mb-3">
                        <label for="attributeId" class="form-label">Menu Attribute</label>
                        <select class="form-select" id="attributeId" name="attributeId" required>
                            <option value="">-- Chọn thuộc tính menu cha --</option>
                            <% for(MenuAttribute ma : menuAttributes) { %>
                                <option value="<%= ma.getAttributeId() %>"><%= ma.getName() %></option>
                            <% } %>
                        </select>
                        <div class="invalid-feedback">Vui lòng chọn một Menu Attribute.</div>
                    </div>
                    <div class="mb-3">
                        <label for="status" class="form-label">Status</label>
                        <select class="form-select" id="status" name="status">
                            <option value="Activate">Activate</option>
                            <option value="Deactivate">Deactivate</option>
                        </select>
                    </div>
                    <div class="text-end">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Edit Value Modal -->
<div class="modal fade" id="editMenuAttributeValueModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Menu Attribute Value</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="<%= ctx %>/menuAttributeValueManagement" method="post" novalidate>
                    <input type="hidden" name="action" value="update" />
                    <input type="hidden" name="id" id="editId">
                    <div class="mb-3">
                        <label for="editValue" class="form-label">Value</label>
                        <input type="text" class="form-control" id="editValue" name="value" required>
                        <div class="invalid-feedback">Giá trị không được để trống và không quá 100 ký tự.</div>
                    </div>
                    <div class="mb-3">
                        <label for="editUrl" class="form-label">URL</label>
                        <input type="text" class="form-control" id="editUrl" name="url">
                        <div class="invalid-feedback">URL không được quá 255 ký tự.</div>
                    </div>
                    <div class="mb-3">
                        <label for="editAttributeId" class="form-label">Menu Attribute</label>
                        <select class="form-select" id="editAttributeId" name="attributeId" required>
                            <option value="">-- Chọn thuộc tính menu cha --</option>
                            <% for(MenuAttribute ma : menuAttributes) { %>
                                <option value="<%= ma.getAttributeId() %>"><%= ma.getName() %></option>
                            <% } %>
                        </select>
                        <div class="invalid-feedback">Vui lòng chọn một Menu Attribute.</div>
                    </div>
                    <div class="mb-3">
                        <label for="editStatus" class="form-label">Status</label>
                        <select class="form-select" id="editStatus" name="status">
                            <option value="Activate">Activate</option>
                            <option value="Deactivate">Deactivate</option>
                        </select>
                    </div>
                    <div class="text-end">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
<script>
    var menuAttributeValuesData = JSON.parse(document.getElementById('menuAttributeValuesJsonContainer').dataset.json);

    function editMenuAttributeValue(element) {
        const id = parseInt(element.dataset.id);
        const item = menuAttributeValuesData.find(i => i.valueId === id);

        if (item) {
            document.getElementById('editId').value = item.valueId;
            document.getElementById('editValue').value = item.value;
            document.getElementById('editUrl').value = item.url === null ? '' : item.url;
            document.getElementById('editAttributeId').value = item.attributeId;
            document.getElementById('editStatus').value = item.status;

            // Reset validation states when modal opens
            document.querySelector('#editMenuAttributeValueModal form').classList.remove('was-validated');
            document.querySelectorAll('#editMenuAttributeValueModal .form-control, #editMenuAttributeValueModal .form-select').forEach(function(input) {
                input.classList.remove('is-invalid');
            });

            // Show the modal
            var editModal = new bootstrap.Modal(document.getElementById('editMenuAttributeValueModal'));
            editModal.show();
        } else {
            console.error("Menu attribute value not found for ID:", id);
            alert("Không tìm thấy giá trị thuộc tính menu này để chỉnh sửa.");
        }
    }

    // Custom validation for Add Menu Attribute Value form
    (function() {
        'use strict';
        var form = document.querySelector('#addMenuAttributeValueModal form');

        form.addEventListener('submit', function(event) {
            let isValid = true;

            // Kiểm tra trường giá trị không chỉ là khoảng trắng và giới hạn ký tự
            var valueInput = form.querySelector('#value');
            if (valueInput.value.trim() === '') {
                valueInput.setCustomValidity('Giá trị không được để trống.');
                isValid = false;
            } else if (valueInput.value.length > 100) {
                valueInput.setCustomValidity('Giá trị không được quá 100 ký tự.');
                isValid = false;
            } else {
                valueInput.setCustomValidity('');
            }
            
            // Kiểm tra trường URL và giới hạn ký tự
            var urlInput = form.querySelector('#url');
            if (urlInput.value.length > 255) {
                urlInput.setCustomValidity('URL không được quá 255 ký tự.');
                isValid = false;
            } else {
                urlInput.setCustomValidity('');
            }

            // Kiểm tra Menu Attribute đã chọn chưa
            var attributeIdInput = form.querySelector('#attributeId');
            if (attributeIdInput.value === '') {
                attributeIdInput.setCustomValidity('Vui lòng chọn một Menu Attribute.');
                isValid = false;
            } else {
                attributeIdInput.setCustomValidity('');
            }

            if (!isValid || !form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    })();

    // Custom validation for Edit Menu Attribute Value form
    (function() {
        'use strict';
        var form = document.querySelector('#editMenuAttributeValueModal form');

        form.addEventListener('submit', function(event) {
            let isValid = true;

            // Kiểm tra trường giá trị không chỉ là khoảng trắng và giới hạn ký tự
            var editValueInput = form.querySelector('#editValue');
            if (editValueInput.value.trim() === '') {
                editValueInput.setCustomValidity('Giá trị không được để trống.');
                isValid = false;
            } else if (editValueInput.value.length > 100) {
                editValueInput.setCustomValidity('Giá trị không được quá 100 ký tự.');
                isValid = false;
            } else {
                editValueInput.setCustomValidity('');
            }
            
            // Kiểm tra trường URL và giới hạn ký tự
            var editUrlInput = form.querySelector('#editUrl');
            if (editUrlInput.value.length > 255) {
                editUrlInput.setCustomValidity('URL không được quá 255 ký tự.');
                isValid = false;
            } else {
                editUrlInput.setCustomValidity('');
            }

            // Kiểm tra Menu Attribute đã chọn chưa
            var editAttributeIdInput = form.querySelector('#editAttributeId');
            if (editAttributeIdInput.value === '') {
                editAttributeIdInput.setCustomValidity('Vui lòng chọn một Menu Attribute.');
                isValid = false;
            } else {
                editAttributeIdInput.setCustomValidity('');
            }

            if (!isValid || !form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    })();
</script>
</body>
</html> 