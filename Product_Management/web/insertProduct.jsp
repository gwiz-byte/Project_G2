<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Product</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/CSS/update.css"> 
    <style>
        .product-img { max-width: 150px; margin-bottom: 10px; }
        .delete-form { margin-top: 20px; }
        .delete-button { background-color: red; color: white; border: none; padding: 10px; cursor: pointer; }
        label { display: block; margin-top: 10px; }
        input, select, textarea { width: 100%; padding: 8px; margin-top: 5px; }
        button { margin-top: 15px; padding: 10px 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Add New Product</h2>

        <!-- ADD PRODUCT FORM -->
        <form action="adminoptions?service=insertProduct" method="post" class="edit-form">

            <label>Name:</label>
            <input type="text" name="name" required />

            <label>Brand:</label>
            <input type="text" name="brand" required />

            <label>Category ID:</label>
            <input type="number" name="category_id" required />

            <label>Price:</label>
            <input type="text" name="price" step="0.01" required />

            <label>Stock:</label>
            <input type="number" name="stock" required />

            <label>Description:</label>
            <textarea name="description" rows="4"></textarea>

            <label>Spec Description:</label>
            <textarea name="spec_description" rows="4"></textarea>

            <label>Image URL:</label><br/>
            <input type="text" name="image_url" required />

            <label>Status:</label>
            <select name="status" required>
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
            </select>

            <button type="submit">Add Product</button>
            <a href="adminoptions?service=viewProduct" style="text-decoration:none;">
                <button type="button" style="margin-left:10px;">Cancel</button>
            </a>
        </form>
    </div>
</body>
</html>
