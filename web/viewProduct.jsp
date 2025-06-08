<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector, model.Products" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String sortBy = request.getParameter("sortBy");
    String order = request.getParameter("order");
    String baseUrl = request.getContextPath() + "/productservlet?service=viewProduct";
%>

<%! 
    public String getNextOrder(String col, String sortBy, String order) {
        if (sortBy == null || !sortBy.equals(col)) return "asc";
        if ("asc".equalsIgnoreCase(order)) return "desc";
        if ("desc".equalsIgnoreCase(order)) return "none";
        return "asc";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Product List</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }

            .top-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
            }

            .search-section,
            .filter-section,
            .insert-btn {
                margin: 5px;
            }

            .insert-btn {
                padding: 8px 15px;
                background-color: #4CAF50;
                color: white;
                text-decoration: none;
                border-radius: 5px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            th, td {
                border: 1px solid #ccc;
                padding: 10px;
                text-align: center;
                vertical-align: middle;
            }

            thead {
                background-color: #f2f2f2;
            }

            tbody tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            tbody tr:hover {
                background-color: #e9f5ff;
            }

            .sort-link {
                text-decoration: none;
                color: #007bff;
                font-weight: bold;
            }

            form {
                display: inline-block;
            }

            input[type="text"] {
                padding: 5px;
                width: 250px;
            }

            button {
                padding: 6px 10px;
                margin-left: 5px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            button:hover {
                background-color: #0056b3;
            }

        </style>
    </head>
    <body>
        <div class="top-bar">
            <!-- Left: Insert Button -->
            <a href="${pageContext.request.contextPath}/productservlet?service=insertProduct" class="insert-btn">Insert Product</a>
            <!-- Middle: Filters -->
            <div class="filter-section">
                <form action="productservlet" method="get" style="display: inline;">
                    <input type="hidden" name="service" value="filterByBrand"/>
                    <select name="brand" required>
                        <option value="">-- Select Brand --</option>
                        <c:forEach var="b" items="${brand}">
                            <option value="${b}">${b}</option>
                        </c:forEach>
                    </select>
                    <button type="submit">Filter Brand</button>
                </form>
                <form action="productservlet" method="get" style="display: inline;">
                    <input type="hidden" name="service" value="filterByCategory"/>
                    <select name="category_id" required>
                        <option value="">-- Select Category --</option>
                        <c:forEach var="c" items="${category}">
                            <option value="${c.id}">${c.name}</option>
                        </c:forEach>
                    </select>
                    <button type="submit">Filter Category</button>
                </form>
            </div>

            <!-- Right: Search -->
            <div class="search-section">
                <form action="${pageContext.request.contextPath}/productservlet" method="get">
                    <input type="hidden" name="service" value="searchProduct" />
                    <input type="text" name="keyword" placeholder="Search by name, brand, description..." value="${keyword != null ? keyword : ''}" />
                    <button type="submit">Search & Sort</button>
                </form>
            </div>
        </div>
        <table border="1" cellpadding="5" cellspacing="0">
            <thead>
                <tr>
                    <th>
                        <a class="sort-link" href="<%= 
                            "none".equals(getNextOrder("id", sortBy, order)) 
                            ? baseUrl 
                            : baseUrl + "&sortBy=id&order=" + getNextOrder("id", sortBy, order)
                           %>">Product ID</a>
                    </th>
                    <th>Name</th>
                    <th>Brand</th>
                    <th>
                        <a class="sort-link" href="<%= 
                            "none".equals(getNextOrder("category_id", sortBy, order)) 
                            ? baseUrl 
                            : baseUrl + "&sortBy=category_id&order=" + getNextOrder("category_id", sortBy, order)
                           %>">Category</a>
                    </th>
                    <th>
                        <a class="sort-link" href="<%= 
                            "none".equals(getNextOrder("price", sortBy, order)) 
                            ? baseUrl 
                            : baseUrl + "&sortBy=price&order=" + getNextOrder("price", sortBy, order)
                           %>">Price</a>
                    </th>
                    <th>
                        <a class="sort-link" href="<%= 
                        "none".equals(getNextOrder("stock", sortBy, order)) 
                        ? baseUrl 
                        : baseUrl + "&sortBy=stock&order=" + getNextOrder("stock", sortBy, order)
                           %>">Stock</a>
                    </th>
                    <th>Image</th>
                    <th>Description</th>
                    <th>Spec_description</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${product}" var="product">
                    <tr>
                        <td>${product.id}</td>
                        <td>${product.name}</td>
                        <td>${product.brand}</td>
                        <td>${product.categoryName}</td>
                        <td>${product.price}</td>
                        <td>${product.stock}</td>
                        <td><img src="${product.image_url}" alt="${product.name}" width="100" /></td>
                        <td>${product.description}</td>
                        <td>${product.spec_description}</td>
                        <td>${product.status}</td>

                        <td>
                            <a href="productservlet?service=updateProduct&id=${product.id}" style="padding: 5px 10px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 3px;">
                                Edit
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </body>
</html>
