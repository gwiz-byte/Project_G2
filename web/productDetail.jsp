<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Product Detail</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <a href="${pageContext.request.contextPath}/homepageservlet" class="btn btn-secondary mt-2">
                &larr; Back
            </a>

            <div class="row">
                <!-- Product Image -->
                <div class="col-md-5">
                    <img src="${product.image_url}" alt="${product.name}" class="img-fluid rounded">
                </div>

                <!-- Product Info -->
                <div class="col-md-7">
                    <h2 class="mb-3">${product.name}</h2>
                    <h4 class="text-muted">${product.brand}</h4>
                    <h3 class="text-danger mb-3">$${product.price}</h3>

                    <p><strong>Category ID:</strong> ${product.category_id}</p>
                    <p><strong>Stock:</strong> 
                        <c:choose>
                            <c:when test="${product.stock > 0}">${product.stock} available</c:when>
                            <c:otherwise><span class="text-danger">Out of Stock</span></c:otherwise>
                        </c:choose>
                    </p>

                    <hr>

                    <h5>Description</h5>
                    <p>${product.description}</p>

                    <h5>Specifications</h5>
                    <p>${product.spec_description}</p>

                    <c:if test="${product.stock > 0}">
                        <a href="${pageContext.request.contextPath}/cart?service=addToCart&productID=${product.id}" class="btn btn-primary mt-3">
                            Add to Cart
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
        <hr>
        <h4 class="mt-5">Related Products</h4>
        <div class="row">
            <c:forEach var="p" items="${relatedProducts}">
                <div class="col-md-3 mb-4">
                    <div class="card h-100">
                        <img src="${p.image_url}" class="card-img-top" alt="${p.name}">
                        <div class="card-body">
                            <h5 class="card-title">${p.name}</h5>
                            <p class="card-text">${p.brand}</p>
                            <p class="card-text text-danger">$${p.price}</p>
                            <a href="${pageContext.request.contextPath}/productDetail?productID=${p.id}" class="btn btn-outline-primary btn-sm">View</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </body>
</html>
