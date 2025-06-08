<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Home Page</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="css/homePage.css" rel="stylesheet">
        <!-- SweetAlert2 for notifications -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            .product-card {
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border: none;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .product-card:hover {
                box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            }

            .btn:disabled {
                opacity: 0.6;
            }

            .input-group .btn {
                border-color: #dee2e6;
            }

            .input-group .form-control {
                border-left: 0;
                border-right: 0;
            }

            .price {
                font-size: 1.25rem;
                font-weight: bold;
                color: #0d6efd;
            }

            /* Add new styles for product card elements */
            .product-card .card-title {
                color: #000000;
                font-weight: 600;
                margin-bottom: 1rem;
            }

            .product-card .btn {
                width: 100%;
                margin-bottom: 0.5rem;
            }

            .product-card .quantity-section {
                width: 100%;
                margin-bottom: 1rem;
            }

            .product-card .quantity-section .input-group {
                width: 100%;
            }

            .product-card .quantity-section label {
                width: 100%;
                margin-bottom: 0.5rem;
                font-weight: 500;
            }

            .product-card .card-body {
                padding: 1.25rem;
            }

            .product-card .card-text {
                color: #6c757d;
                margin-bottom: 1rem;
            }

            .feature-card {
                text-align: center;
                padding: 2rem;
                border-radius: 10px;
                background: white;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
            }

            .feature-card:hover {
                transform: translateY(-5px);
            }

            .feature-icon {
                font-size: 3rem;
                color: #0d6efd;
                margin-bottom: 1rem;
            }

            .hero-section {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 100px 0;
                margin-bottom: 50px;
            }

            .deal-section {
                background-color: #f8f9fa;
                padding: 50px 0;
            }

            .top-bar {
                background-color: #343a40;
                color: white;
                padding: 10px 0;
                font-size: 0.9rem;
            }

            footer {
                background-color: #343a40;
                color: white;
                padding: 50px 0 20px 0;
                margin-top: 50px;
            }

            .social-icons a {
                color: white;
                font-size: 1.5rem;
                margin-right: 15px;
                transition: color 0.3s ease;
            }

            .social-icons a:hover {
                color: #0d6efd;
            }

            .dropdown-menu.show {
                display: block !important;
            }

            .quantity-selector {
                display: flex;
                border: 1px solid #ccc;
                border-radius: 4px;
                overflow: hidden;
                width: 120px;
                height: 36px;
                background: #fff;
            }
            .qty-btn {
                width: 36px;
                border: none;
                background: none;
                font-size: 1.25rem;
                color: #333;
                cursor: pointer;
                outline: none;
                transition: background 0.2s;
            }
            .qty-btn:hover {
                background: #f0f0f0;
            }
            .qty-input {
                width: 48px;
                border: none;
                outline: none;
                font-size: 1.25rem;
                background: none;
            }
        </style>
    </head>
    <body>
        <!-- Include Header -->
        <jsp:include page="header.jsp"/>

        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h1 class="display-4 fw-bold mb-4">Build Your Dream PC</h1>
                        <p class="lead mb-4">Premium computer components at competitive prices. Free expert consultation on custom builds.</p>
                        <a href="#" class="btn btn-primary btn-lg me-2">Shop Now</a>
                        <a href="#" class="btn btn-outline-light btn-lg">Custom Build</a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Features -->
        <section class="py-5">
            <div class="container">
                <div class="row g-4">
                    <div class="col-md-3">
                        <div class="feature-card">
                            <i class="fas fa-shipping-fast feature-icon"></i>
                            <h5>Free Shipping</h5>
                            <p class="mb-0">On orders over $100</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="feature-card">
                            <i class="fas fa-headset feature-icon"></i>
                            <h5>24/7 Support</h5>
                            <p class="mb-0">Expert assistance</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="feature-card">
                            <i class="fas fa-shield-alt feature-icon"></i>
                            <h5>Secure Payments</h5>
                            <p class="mb-0">100% secure checkout</p>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="feature-card">
                            <i class="fas fa-undo feature-icon"></i>
                            <h5>Easy Returns</h5>
                            <p class="mb-0">30-day return policy</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Today's Deals -->
        <section class="deal-section">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0">Today's Best Deals</h2>
                    <a href="#" class="btn btn-link">View All</a>
                </div>

                <!-- Display error message if any -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger" role="alert">
                        ${errorMessage}
                    </div>
                </c:if>

                <!-- Debug information -->
                <c:if test="${empty product}">
                    <div class="alert alert-warning" role="alert">
                        No products available at the moment.
                    </div>
                </c:if>

                <div class="row">
                    <c:forEach var="product" items="${product}">
                        <div class="col-md-3 mb-4">
                            <div class="card product-card h-100">
                                <a href="${pageContext.request.contextPath}/productservlet?service=productDetail&id=${product.id}" style="text-decoration: none;">
                                    <img src="${product.image_url}" class="card-img-top" alt="${product.name}" style="height: 200px; object-fit: cover;">
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title">${product.name}</h5>
                                        <p class="card-text flex-grow-1">${product.description}</p>
                                        <div class="d-flex align-items-center mb-3">
                                            <span class="price fw-bold text-primary fs-5">$${product.price}</span>
                                        </div>
                                    </div>
                                </a>       

                                <!-- Quantity Selector -->
                                <div class="d-flex align-items-center mb-3">
                                    <div class="quantity-selector" style="width: 120px; margin: 0 auto;">
                                        <button type="button" class="qty-btn" onclick="changeQuantity(${product.id}, -1)">-</button>
                                        <input type="number" id="quantity_${product.id}" value="1" min="1" max="99" class="qty-input" style="text-align:center;">
                                        <button type="button" class="qty-btn" onclick="changeQuantity(${product.id}, 1)">+</button>
                                    </div>
                                </div>

                                <!-- Add to Cart Button -->
                                <button class="btn btn-primary w-100" 
                                        onclick="addToCart(${product.id}, '${product.name}', ${product.price})"
                                        id="addBtn_${product.id}">
                                    <i class="fas fa-cart-plus me-2"></i>Add to Cart
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>

        <!-- Categories -->
        <section class="py-5">
            <div class="container">
                <h2 class="mb-4">Shop by Category</h2>
                <div class="row">
                    <div class="col-md-4">
                        <div class="card category-card">
                            <img src="https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea" class="card-img-top" alt="Processors">
                            <div class="card-body">
                                <h5 class="card-title">Processors</h5>
                                <p class="card-text">Latest CPUs from Intel & AMD</p>
                                <a href="#cpuProducts" class="btn btn-outline-primary">Shop Now</a>
                            </div>
                        </div>
                    </div>
                    <!-- Add more category cards -->
                </div>
            </div>
        </section>

        <!-- CPU Products Section -->
        <section id="cpuProducts" class="py-5 bg-light">
            <jsp:include page="CPUCategory.jsp" />
        </section>

        <!-- Newsletter -->
        <section class="py-5 bg-light">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-6 text-center">
                        <h3>Subscribe to Our Newsletter</h3>
                        <p>Get the latest updates on new products and upcoming sales</p>
                        <form class="newsletter-form">
                            <div class="input-group">
                                <input type="email" class="form-control" placeholder="Your email address">
                                <button class="btn btn-primary" type="submit">Subscribe</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer>
            <div class="container">
                <div class="row">
                    <div class="col-md-3">
                        <h5>About CES</h5>
                        <p>Your trusted source for premium computer components and custom PC builds.</p>
                        <div class="social-icons">
                            <a href="#"><i class="fab fa-facebook"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                            <a href="#"><i class="fab fa-youtube"></i></a>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <h5>Quick Links</h5>
                        <ul class="list-unstyled">
                            <li><a href="#" class="text-white">About Us</a></li>
                            <li><a href="#" class="text-white">Contact Us</a></li>
                            <li><a href="#" class="text-white">Terms & Conditions</a></li>
                            <li><a href="#" class="text-white">Privacy Policy</a></li>
                        </ul>
                    </div>
                    <div class="col-md-3">
                        <h5>Customer Service</h5>
                        <ul class="list-unstyled">
                            <li><a href="#" class="text-white">My Account</a></li>
                            <li><a href="#" class="text-white">Track Order</a></li>
                            <li><a href="#" class="text-white">Returns</a></li>
                            <li><a href="#" class="text-white">Help Center</a></li>
                        </ul>
                    </div>
                    <div class="col-md-3">
                        <h5>Contact Info</h5>
                        <ul class="list-unstyled">
                            <li><i class="fas fa-map-marker-alt me-2"></i>123 Tech Street, Silicon Valley, CA</li>
                            <li><i class="fas fa-phone me-2"></i>1-800-123-4567</li>
                            <li><i class="fas fa-envelope me-2"></i>support@ces.com</li>
                        </ul>
                    </div>
                </div>
                <hr class="mt-4">
                <div class="text-center">
                    <p class="mb-0">&copy; 2025 Computer Element System (CES). All rights reserved.</p>
                </div>
            </div>
        </footer>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Initialize Bootstrap Components -->
        <script>
            // Function to initialize dropdowns
            function initializeDropdowns() {
                try {
                    // Check if Bootstrap is loaded
                    if (typeof bootstrap === 'undefined') {
                        console.error('Bootstrap is not loaded properly');
                        return;
                    }

                    // Initialize all dropdowns
                    const dropdownElementList = document.querySelectorAll('[data-bs-toggle="dropdown"]');
                    if (dropdownElementList.length === 0) {
                        console.warn('No dropdown elements found');
                        return;
                    }

                    dropdownElementList.forEach(dropdownToggle => {
                        try {
                            // Remove any existing dropdown instance
                            const existingDropdown = bootstrap.Dropdown.getInstance(dropdownToggle);
                            if (existingDropdown) {
                                existingDropdown.dispose();
                            }

                            // Create new dropdown instance
                            const dropdown = new bootstrap.Dropdown(dropdownToggle);
                            
                            // Add click handler
                            dropdownToggle.addEventListener('click', function(e) {
                                e.preventDefault();
                                e.stopPropagation();
                                dropdown.toggle();
                            });

                            // Debug info
                            console.log('Dropdown initialized:', dropdownToggle.id);
                        } catch (err) {
                            console.error('Error initializing dropdown:', err);
                        }
                    });

                    // Add hover functionality
                    const dropdownMenus = document.querySelectorAll('.dropdown');
                    dropdownMenus.forEach(dropdown => {
                        const toggle = dropdown.querySelector('[data-bs-toggle="dropdown"]');
                        
                        dropdown.addEventListener('mouseenter', function() {
                            const instance = bootstrap.Dropdown.getInstance(toggle);
                            if (instance) {
                                instance.show();
                            } else {
                                new bootstrap.Dropdown(toggle).show();
                            }
                        });
                        
                        dropdown.addEventListener('mouseleave', function() {
                            const instance = bootstrap.Dropdown.getInstance(toggle);
                            if (instance) {
                                instance.hide();
                            }
                        });
                    });

                    // Log total number of dropdowns
                    console.log('Total dropdowns found:', dropdownElementList.length);
                    
                } catch (err) {
                    console.error('Error in dropdown initialization:', err);
                }
            }

            // Initialize on DOMContentLoaded
            document.addEventListener('DOMContentLoaded', initializeDropdowns);

            // Re-initialize on dynamic content changes
            const observer = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {
                    if (mutation.addedNodes.length || mutation.removedNodes.length) {
                        initializeDropdowns();
                    }
                });
            });

            // Start observing the document with the configured parameters
            observer.observe(document.body, { childList: true, subtree: true });
        </script>

        <!-- Custom JavaScript for Cart Functionality -->
        <script>
                                            // Global variables
                                            let cartCount = 0;
                                            const currentUserId = ${sessionScope.userAuth2.id}; // Thay đổi theo user đang đăng nhập

                                            // Function to change quantity
                                            function changeQuantity(productId, change) {
                                                const quantityInput = document.getElementById('quantity_' + productId);
                                                let currentQuantity = parseInt(quantityInput.value);
                                                let newQuantity = currentQuantity + change;

                                                if (newQuantity < 1)
                                                    newQuantity = 1;
                                                if (newQuantity > 99)
                                                    newQuantity = 99;

                                                quantityInput.value = newQuantity;
                                            }

                                            // Function to add product to cart
                                            async function addToCart(productId, productName, productPrice) {
                                                const quantityInput = document.getElementById('quantity_' + productId);
                                                const quantity = parseInt(quantityInput.value);
                                                const addButton = document.getElementById('addBtn_' + productId);

                                                // Disable button and show loading
                                                addButton.disabled = true;
                                                addButton.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Adding...';

                                                try {
                                                    console.log(JSON.stringify({
                                                        userId: currentUserId,
                                                        productId: productId,
                                                        quantity: quantity
                                                    }));
                                                    const response = await fetch('http://localhost:9999/CES/CartApiServlet', {
                                                        method: 'POST',
                                                        headers: {
                                                            'Content-Type': 'application/json'
                                                        },
                                                        body: JSON.stringify({
                                                            userId: currentUserId,
                                                            productId: productId,
                                                            quantity: quantity
                                                        })
                                                    });

                                                    const result = await response.json();

                                                    if (result.success) {
                                                        // Show success message
                                                        Swal.fire({
                                                            icon: 'success',
                                                            title: 'Success!',
                                                            text: productName + `has been added to your cart!`,
                                                            timer: 2000,
                                                            showConfirmButton: false
                                                        });

                                                        // Update cart count
                                                        updateCartCount();

                                                        // Reset quantity to 1
                                                        quantityInput.value = 1;

                                                        // Add visual feedback
                                                        addButton.classList.add('btn-success');
                                                        addButton.innerHTML = '<i class="fas fa-check me-2"></i>Added!';

                                                        setTimeout(() => {
                                                            addButton.classList.remove('btn-success');
                                                            addButton.innerHTML = '<i class="fas fa-cart-plus me-2"></i>Add to Cart';
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
                                                        addButton.innerHTML = '<i class="fas fa-cart-plus me-2"></i>Add to Cart';
                                                    }
                                                }
                                            }

                                            // Function to update cart count
                                            async function updateCartCount() {
                                                try {
                                                    const response = await fetch('CartApiServlet?userId=' + currentUserId);
                                                    const result = await response.json();

                                                    if (result.success && result.data) {
                                                        const totalItems = result.data.reduce((sum, item) => sum + item.quantity, 0);
                                                        document.getElementById('cartCount').textContent = totalItems;
                                                        cartCount = totalItems;
                                                    }
                                                } catch (error) {
                                                    console.error('Error updating cart count:', error);
                                                }
                                            }

                                            // Initialize cart count on page load
                                            document.addEventListener('DOMContentLoaded', function () {
                                                updateCartCount();

                                                // Add hover effects to product cards
                                                const productCards = document.querySelectorAll('.product-card');
                                                productCards.forEach(card => {
                                                    card.addEventListener('mouseenter', function () {
                                                        this.style.transform = 'translateY(-5px)';
                                                        this.style.transition = 'transform 0.3s ease';
                                                    });

                                                    card.addEventListener('mouseleave', function () {
                                                        this.style.transform = 'translateY(0)';
                                                    });
                                                });
                                            });

                                                // Function to view product feedback
                                                function viewFeedback(productId) {
                                                    // Empty function for now
                                                    console.log('View feedback for product:', productId);
                                                }

                                                // Add keyboard support for quantity inputs
                                                document.addEventListener('DOMContentLoaded', function () {
                                                    const quantityInputs = document.querySelectorAll('[id^="quantity_"]');
                                                    quantityInputs.forEach(input => {
                                                        input.addEventListener('keypress', function (e) {
                                                            if (e.key === 'Enter') {
                                                                const productId = this.id.split('_')[1];
                                                                const productCard = this.closest('.product-card');
                                                                const productName = productCard.querySelector('.card-title').textContent;
                                                                const productPrice = parseFloat(productCard.querySelector('.price').textContent.replace(',', '')); // Sửa lỗi dấu ngoặc
                                                                addToCart(parseInt(productId), productName, productPrice);
                                                            }
                                                        });
                                                    input.addEventListener('change', function () {
                                                        let value = parseInt(this.value);
                                                        if (isNaN(value) || value < 1) {
                                                            value = 1;
                                                        }
                                                        if (value > 99) {
                                                            value = 99;
                                                        }
                                                        this.value = value;
                                                    });
                                                });
                                            });
        </script>


    </style>
</body>
</html>