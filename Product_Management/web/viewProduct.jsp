<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector, model.Products" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Product List</title>
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                padding: 8px;
                border: 1px solid #ccc;
                text-align: center;
            }
            th {
                background-color: #f5f5f5;
            }
            img {
                max-width: 60px;
            }
            .search-bar {
                margin-top: 20px;
                margin-bottom: 20px;
            }
            .search-bar input[type="text"] {
                padding: 8px;
                width: 300px;
            }
            .search-bar button {
                padding: 8px 12px;
            }
            .top-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>

        <div class="top-bar">
            <a href="${pageContext.request.contextPath}/productservlet?service=insertProduct">Insert Product</a>

            <form action="${pageContext.request.contextPath}/productservlet?service=searchProduct" method="get" class="search-bar">
                <input type="hidden" name="service" value="searchProduct"/>

                <input type="text" name="keyword" placeholder="Search by name, brand, etc."/>

                Brand:
                <select name="brand">
                    <option value="">All</option>
                    <option value="Logitech">Logitech</option>
                    <option value="Razer">Razer</option>
                    <option value="Corsair">Corsair</option>
                    <!-- Add more brands or load dynamically -->
                </select>

                Price:
                <input type="number" name="minPrice" step="0.01" placeholder="Min" style="width: 80px;">
                -
                <input type="number" name="maxPrice" step="0.01" placeholder="Max" style="width: 80px;">

                <button type="submit">Search</button>
            </form>
        </div>

        <h1>Product List</h1>

        <table>
            <thead>
                <tr>
                    <th>Product ID</th>
                    <th>Name</th>
                    <th>Brand</th>
                    <th>Category ID</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Status</th>
                    <th>Image</th>
                    <th>Description</th>
                    <th>Spec Description</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="product" items="${product}">
                    <tr>
                        <td>${product.id}</td>
                        <td>${product.name}</td>
                        <td>${product.brand}</td>
                        <td>${product.category_id}</td>
                        <td>$${product.price}</td>
                        <td>${product.stock}</td>
                        <td>${product.status}</td>
                        <td><img src="${product.image_url}" alt="${product.name}"></td>
                        <td>${product.description}</td>
                        <td>${product.spec_description}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/productservlet?service=updateProduct&productID=${product.id}">Edit</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </body>
</html>
