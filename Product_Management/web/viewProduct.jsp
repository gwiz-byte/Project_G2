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
    </style>
</head>
<body>
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
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
