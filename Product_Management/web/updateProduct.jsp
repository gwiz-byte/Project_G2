<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Product</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/CSS/update.css"> 
        <style>
            .product-img {
                max-width: 150px;
                margin-bottom: 10px;
            }
            .delete-form {
                margin-top: 20px;
            }
            .delete-button {
                background-color: red;
                color: white;
                border: none;
                padding: 10px;
                cursor: pointer;
            }
            label {
                display: block;
                margin-top: 10px;
            }
            input, select, textarea {
                width: 100%;
                padding: 8px;
                margin-top: 5px;
            }
            button {
                margin-top: 15px;
                padding: 10px 20px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Edit Product</h2>

            <!-- EDIT PRODUCT FORM -->
            <form action="adminoptions?service=updateProduct" method="post" class="edit-form">
                <input type="hidden" name="productID" value="${product.id}" />

                <label>Name:</label>
                <input type="text" name="name" value="${product.name}" required />

                <label>Brand:</label>
                <input type="text" name="brand" value="${product.brand}" required />

                <label>Category ID:</label>
                <input type="number" name="category_id" value="${product.category_id}" required />

                <label>Price:</label>
                <input type="text" name="price" value="${product.price}" required />

                <label>Stock:</label>
                <input type="number" name="stock" value="${product.stock}" required />

                <label>Description:</label>
                <textarea name="description" rows="4">${product.description}</textarea>

                <label>Spec Description:</label>
                <textarea name="spec_description" rows="4">${product.spec_description}</textarea>

                <label>Image URL:</label><br/>
                <img src="${product.image_url}" alt="${product.name}" class="product-img" />
                <input type="text" name="image_url" value="${product.image_url}" required />

                <label>Status:</label>
                <select name="status" required>
                    <option value="Active" ${product.status == 'Active' ? 'selected' : ''}>Active</option>
                    <option value="Inactive" ${product.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                </select>

                <button type="submit">Save Changes</button>
                <a href="productservlet?service=viewProduct" style="text-decoration:none;">
                    <button type="button" style="margin-left:10px;">Cancel</button>
                </a>
            </form>
        </div>
    </body>
</html>
