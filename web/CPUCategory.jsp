<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="dal.ProductDAO" %>
<%@ page import="model.Products" %>
<%@ page import="java.util.Vector" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="css/cpuCategory.css" rel="stylesheet">
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </head>
    <body>
        <%
            ProductDAO productDAO = new ProductDAO();

            // Số sản phẩm trên mỗi trang (thay đổi thành 4)
            int productsPerPage = 4;

            // Lấy trang hiện tại từ parameter, mặc định là trang 1
            int currentPage = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                currentPage = Integer.parseInt(pageStr);
            }

            // Lấy tổng số sản phẩm CPU
            int totalProducts = productDAO.getTotalCPUProducts();

            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalProducts / productsPerPage);

            // Lấy danh sách sản phẩm cho trang hiện tại
            Vector<Products> cpuProducts = productDAO.getCPUProductsWithPaging(currentPage, productsPerPage);

            // Set attributes để sử dụng trong JSP
            request.setAttribute("cpuProducts", cpuProducts);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
        %>

        <div class="container">
            <div class="cpu-section">
                <div class="cpu-header">
                    <h2 class="cpu-title">CPU Products</h2>
                </div>

                <div class="products-grid">
                    <c:forEach var="product" items="${cpuProducts}">
                        <div class="product-card">
                            <img src="${product.image_url}" class="product-image" alt="${product.name}">
                            <h5 class="product-title">${product.name}</h5>
                            <p class="product-description">${product.description}</p>
                            <span class="product-price">$${product.price}</span>

                            <!-- Add to Cart Button -->
                            <button class="btn btn-primary add-to-cart-btn" 
                                    onclick="addToCart('${product.id}', '${product.name}', '${product.price}')"
                                    id="addBtn_${product.id}">
                                <i class="fas fa-shopping-cart me-2"></i>Add to Cart
                            </button>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <ul class="pagination">
                        <!-- Previous button -->
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage - 1}" tabindex="-1">Previous</a>
                        </li>

                        <!-- Page numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                            <li class="page-item ${pageNumber == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${pageNumber}">${pageNumber}</a>
                            </li>
                        </c:forEach>

                        <!-- Next button -->
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}">Next</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Custom JavaScript -->
        <script>

            async function addToCart(productId, productName, productPrice) {
                const addButton = document.getElementById('addBtn_' + productId);

                // Disable button and show loading
                addButton.disabled = true;
                addButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Adding...';

                try {
                    const response = await fetch('http://localhost:9999/Project_G2/CartApiServlet', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            userId: currentUserId,
                            productId: productId,
                            quantity: 1
                        })
                    });

                    const result = await response.json();

                    if (result.success) {
                        // Show success message
                        Swal.fire({
                            icon: 'success',
                            title: 'Success!',
                            text: productName + ' has been added to your cart!',
                            timer: 2000,
                            showConfirmButton: false
                        });

                        // Add visual feedback
                        addButton.classList.add('btn-success');
                        addButton.innerHTML = '<i class="fas fa-check me-2"></i>Added!';

                        setTimeout(() => {
                            addButton.classList.remove('btn-success');
                            addButton.innerHTML = '<i class="fas fa-shopping-cart me-2"></i>Add to Cart';
                        }, 2000);
                    } else {
                        throw new Error(result.message || 'Failed to add to cart');
                    }
                } catch (error) {
                    console.error('Error adding to cart:', error);
                    Swal.fire({
                        icon: 'error',
                        title: 'Error!',
                        text: error.message || 'Failed to add product to cart. Please try again.'
                    });
                } finally {
                    // Re-enable button
                    addButton.disabled = false;
                    if (!addButton.classList.contains('btn-success')) {
                        addButton.innerHTML = '<i class="fas fa-shopping-cart me-2"></i>Add to Cart';
                    }
                }
            }
        </script>
    </body>
</html> 