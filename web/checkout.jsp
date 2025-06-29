<%-- 
    Document   : checkout
    Created on : Jun 25, 2025, 6:37:27 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Checkout - Thanh toán</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: #333;
            }

            .container {
                max-width: 1200px;
                /*margin: 0 auto;*/
                /*padding: 20px;*/
            }

            .checkout-header {
                text-align: center;
                margin-bottom: 20px;
            }

            .checkout-header h1 {
                color: #111;
                font-size: 2.2rem;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                margin-top: 24px;
                margin-bottom: 8px;
            }

            .checkout-header p {
                color: rgba(34,34,34,0.8);
                font-size: 1rem;
                margin-bottom: 0;
            }

            .checkout-content {
                display: grid;
                grid-template-columns: 1fr 400px;
                gap: 30px;
                align-items: flex-start;
            }

            .checkout-form {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                backdrop-filter: blur(10px);
                padding: 18px 16px 18px 16px;
            }

            .order-summary {
                background: white;
                border-radius: 14px;
                box-shadow: 0 10px 24px rgba(0,0,0,0.08);
                overflow: hidden;
                backdrop-filter: blur(10px);
                padding: 14px 12px 16px 12px;
                height: fit-content;
            }

            .order-summary h2 {
                font-size: 1.15rem;
                margin-bottom: 10px;
            }

            .form-group {
                margin-bottom: 14px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 600;
                color: #2d3436;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 9px;
                border: 2px solid #e1e5e9;
                border-radius: 15px;
                font-size: 13px;
                transition: all 0.3s ease;
                background: linear-gradient(145deg, #ffffff, #f8f9fa);
            }

            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
            }

            .cart-items {
                margin-bottom: 20px;
            }

            .cart-item {
                display: flex;
                align-items: center;
                padding: 12px 8px;
                border: 2px solid #f8f9fa;
                border-radius: 10px;
                margin-bottom: 10px;
                transition: all 0.3s ease;
                background: linear-gradient(145deg, #ffffff, #f8f9fa);
            }

            .cart-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 30px rgba(0,0,0,0.1);
                border-color: #667eea;
            }

            .item-image {
                width: 50px;
                height: 50px;
                border-radius: 8px;
                margin-right: 10px;
                object-fit: cover;
                box-shadow: 0 2px 6px rgba(0,0,0,0.12);
            }

            .item-info {
                flex: 1;
            }

            .item-info h4 {
                font-size: 0.75rem;
                font-weight: bold;
                color: #2d3436;
                margin-bottom: 4px;
            }

            .item-info .quantity {
                color: #636e72;
                font-size: 0.7rem;
                margin-bottom: 4px;
            }

            .item-info .description {
                color: #636e72;
                margin-bottom: 6px;
                line-height: 1.3;
                font-size: 0.7rem;
            }

            .item-price {
                font-size: 0.85rem;
                font-weight: bold;
                color: #e17055;
            }

            .order-total {
                border-top: 2px solid #667eea;
                padding-top: 10px;
                margin-top: 10px;
            }

            .total-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
                font-size: 0.98rem;
            }

            .total-row.final {
                font-size: 1.15rem;
                font-weight: bold;
                color: #2d3436;
                border-top: 2px solid #ddd;
                padding-top: 10px;
                margin-top: 10px;
            }

            .checkout-btn {
                width: 100%;
                padding: 10px 0;
                background: linear-gradient(45deg, #00b894, #00a085);
                color: white;
                border: none;
                border-radius: 18px;
                font-size: 1rem;
                font-weight: bold;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-top: 12px;
            }

            .checkout-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            }

            .checkout-btn:disabled {
                opacity: 0.5;
                cursor: not-allowed;
                transform: none;
            }

            .loading {
                display: none;
                text-align: center;
                padding: 20px;
                color: #636e72;
            }

            .loading.show {
                display: block;
            }

            .error-message {
                background: #f8d7da;
                color: #721c24;
                padding: 15px;
                border-radius: 15px;
                margin-bottom: 20px;
                display: none;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .success-message {
                background: #d4edda;
                color: #155724;
                padding: 15px;
                border-radius: 15px;
                margin-bottom: 20px;
                display: none;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .empty-cart {
                text-align: center;
                padding: 60px 30px;
                color: #636e72;
            }

            .empty-cart i {
                font-size: 4rem;
                margin-bottom: 20px;
                color: #ddd;
            }

            @media (max-width: 900px) {
                .checkout-content {
                    grid-template-columns: 1fr;
                }
                .checkout-form {
                    max-height: none;
                }
            }
        </style>
    </head>
    <body>
        <!-- Include Header -->
        <jsp:include page="header.jsp"/>
        <div class="container">
            <div class="checkout-header">
                <h1>Thanh toán đơn hàng</h1>
                <p>Vui lòng kiểm tra thông tin và hoàn tất đơn hàng</p>
            </div>

            <div class="checkout-content">
                <div class="checkout-form">
                    <h2>Thông tin giao hàng</h2>

                    <div class="error-message" id="errorMessage"></div>
                    <div class="success-message" id="successMessage"></div>

                    <form id="checkoutForm">
                        <div class="form-group">
                            <label for="fullName">Họ và tên *</label>
                            <input type="text" id="fullName" name="fullName" required>
                        </div>

                        <div class="form-group">
                            <label for="phone">Số điện thoại *</label>
                            <input type="tel" id="phone" name="phone" required onchange="validatePhone()">
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" onchange="validateEmail()">
                        </div>

                        <div class="form-group">
                            <label for="address">Địa chỉ giao hàng *</label>
                            <textarea id="address" name="address" rows="3" required 
                                      placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố"></textarea>
                        </div>

                        <div class="form-group">
                            <label for="paymentMethod">Phương thức thanh toán *</label>
                            <select id="paymentMethod" name="paymentMethod" required>
                                <option value="">Chọn phương thức thanh toán</option>
                                <option value="1">Thanh toán khi nhận hàng (COD)</option>
                                <option value="2">Chuyển khoản ngân hàng</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="notes">Ghi chú đơn hàng</label>
                            <textarea id="notes" name="notes" rows="2" 
                                      placeholder="Ghi chú thêm về đơn hàng (tùy chọn)"></textarea>
                        </div>
                    </form>
                </div>

                <div class="order-summary">
                    <h2>Đơn hàng của bạn</h2>

                    <div id="loading-container" class="loading">
                        <p>Đang tải giỏ hàng...</p>
                    </div>

                    <div id="empty-cart" class="empty-cart" style="display: none;">
                        <i class="fas fa-shopping-cart"></i>
                        <p>Giỏ hàng trống</p>
                    </div>

                    <div id="cart-items-container" class="cart-items">
                        <!-- Cart items will be rendered here -->
                    </div>

                    <div id="cart-summary" class="order-total">
                        <div class="total-row">
                            <span>Tạm tính:</span>
                            <span id="subtotal">0₫</span>
                        </div>
                        <div class="total-row">
                            <span>Phí vận chuyển:</span>
                            <span>Miễn phí</span>
                        </div>
                        <div class="total-row final">
                            <span>Tổng cộng:</span>
                            <span id="total">0₫</span>
                        </div>
                    </div>

                    <button type="button" onclick="processCheckout()" form="checkoutForm" class="checkout-btn" id="checkoutButton">
                        Thanh toán
                    </button>
                </div>
            </div>
        </div>
        <!-- Footer -->
        <jsp:include page="footer.jsp"/>

        <script>
            // Configuration
            const API_BASE_URL = '/CES/CartApiServlet';
            const USER_INFO_API_URL = '/CES/UserInfoApiServlet';
            const userId = 1; // This should be dynamically set from session

            // Global variables
            let cartItems = [];
            let isLoading = false;

            // Initialize page
            document.addEventListener('DOMContentLoaded', function () {
                loadCartItems();
                loadUserInfo(); // Tự động điền thông tin user
            });

            // API Functions
            async function apiCall(url, method = 'GET', data = null) {
                const options = {
                    method: method,
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    credentials: 'same-origin'
                };

                if (data) {
                    options.body = JSON.stringify(data);
                }

                try {
                    const response = await fetch(url, options);
                    const result = await response.json();

                    if (!response.ok) {
                        throw new Error(result.message || 'API call failed');
                    }

                    return result;
                } catch (error) {
                    console.error('API Error:', error);
                    throw error;
                }
            }

            // Load cart items from server
            async function loadCartItems() {
                try {
                    setLoading(true);
                    const response = await apiCall(API_BASE_URL);
                    cartItems = response.data || [];
                    renderCartItems();
                } catch (error) {
                    showMessage('Lỗi khi tải giỏ hàng: ' + error.message, 'error');
                } finally {
                    setLoading(false);
                }
            }

            // Render cart items
            function renderCartItems() {
                const container = document.getElementById('cart-items-container');
                const emptyCart = document.getElementById('empty-cart');
                const summary = document.getElementById('cart-summary');
                const loadingContainer = document.getElementById('loading-container');

                if (cartItems.length === 0) {
                    container.style.display = 'none';
                    summary.style.display = 'none';
                    emptyCart.style.display = 'block';
                    loadingContainer.style.display = 'none';
                    return;
                }

                container.style.display = 'block';
                summary.style.display = 'block';
                emptyCart.style.display = 'none';
                loadingContainer.style.display = 'none';

                let html = '';
                let total = 0;

                cartItems.forEach(item => {
                    const itemTotal = item.quantity * item.product.price;
                    total += itemTotal;

                    html += '<div class="cart-item" data-item-id="' + item.id + '">' +
                            '<img src="' + (item.product.imageUrl || '/CES/images/default-product.jpg') + '" ' +
                            'alt="' + item.product.name + '" ' +
                            'class="item-image">' +
                            '<div class="item-info">' +
                            '<h4>' + item.product.name + '</h4>' +
                            '<div class="quantity">Số lượng: ' + item.quantity + '</div>' +
                            '<div class="description">' + (item.product.description || 'Sản phẩm chất lượng cao') + '</div>' +
                            '<div class="item-price">' + formatPrice(itemTotal) + '₫</div>' +
                            '</div>' +
                            '</div>';
                });

                container.innerHTML = html;
                updateSummary(total);
            }

            // Update summary
            function updateSummary(total) {
                document.getElementById('subtotal').textContent = formatPrice(total) + '₫';
                document.getElementById('total').textContent = formatPrice(total) + '₫';
            }

            // Utility functions
            function formatPrice(price) {
                return new Intl.NumberFormat('vi-VN').format(price);
            }

            function isValidVietnamesePhoneNumber(phoneNumber) {
                const regex = /^(\+84|0)(3|5|7|8|9)\d{8}$/;
                return regex.test(phoneNumber);
            }
            function isValidEmail(email) {
                const regex = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;
                return regex.test(email);
            }
            function validatePhone() {
                const phone = document.getElementById("phone");
                if (!isValidVietnamesePhoneNumber(phone.value)) {
                    return false;
                }
                return true;
            }
            function validateEmail() {
                const email = document.getElementById("email");
                if (!isValidEmail(email.value)) {
                    return false;
                }
                return true;
            }
            // Process checkout
            async function processCheckout() {
                if (cartItems.length === 0) {
                    showError('Giỏ hàng của bạn đang trống');
                    return;
                }
                if (!validatePhone()) {
                    showError('Số điện thoại không hợp lệ!');
                    return;
                }
                if (!validateEmail()) {
                    showError('Email không hợp lệ!');
                    return;
                }
                // Validate form
                const form = document.getElementById('checkoutForm');
                if (!form.checkValidity()) {
                    form.reportValidity();
                    return;
                }

                try {
                    const checkoutBtn = document.getElementById('checkoutButton');
                    checkoutBtn.disabled = true;
                    checkoutBtn.textContent = 'Đang xử lý...';

                    // Prepare order data
                    const formData = new FormData(form);
                    let totalAmount = 0;
                    const orderData = {
                        totalAmount: 0,
                        paymentMethodId: parseInt(formData.get('paymentMethod')),
                        shippingAddress: formData.get('address'),
                        status: 'pending',
                        orderDetails: cartItems.map(item => {
                            let price = 0;
                            if (item.product && item.product.price) {
                                if (typeof item.product.price === 'object' && item.product.price.value !== undefined) {
                                    price = parseFloat(item.product.price.value) || 0;
                                } else {
                                    price = parseFloat(item.product.price) || 0;
                                }
                            }
                            totalAmount = item.quantity * price;
                            return {
                                productId: item.productId,
                                quantity: item.quantity || 0,
                                price: price
                            };
                        })
                    };
                    orderData.totalAmount = totalAmount;

                    // Send order to API
                    const response = await fetch('/CES/OrderApiServlet', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        credentials: 'same-origin',
                        body: JSON.stringify(orderData)
                    });

                    if (!response.ok) {
                        throw new Error('HTTP error! status: ' + response.status);
                    }

                    const result = await response.json();

                    if (result.success) {
                        showSuccess('Đặt hàng thành công! Vui lòng thanh toán.');
                        // Clear form
                        form.reset();
                        // Reload cart (should be empty now)
                        setTimeout(() => {
                            loadCartItems();
                            window.location = "payment-servlet?orderId=" + result.orderId;
                        }, 4000);
                    } else {
                        showError('Đặt hàng thất bại: ' + (result.message || 'Lỗi không xác định'));
                    }
                } catch (error) {
                    console.error('Checkout error:', error);
                    showError('Có lỗi xảy ra khi đặt hàng: ' + error.message);
                } finally {
                    const checkoutBtn = document.getElementById('checkoutButton');
                    checkoutBtn.disabled = false;
                    checkoutBtn.textContent = 'Đặt hàng';
                }
            }

            // Show error message
            function showError(message) {
                const errorDiv = document.getElementById('errorMessage');
                errorDiv.textContent = message;
                errorDiv.style.display = 'block';

                // Hide success message
                document.getElementById('successMessage').style.display = 'none';

                // Scroll to top to show error
                window.scrollTo(0, 0);

                // Auto hide after 5 seconds
                setTimeout(() => {
                    errorDiv.style.display = 'none';
                }, 5000);
            }

            // Show success message
            function showSuccess(message) {
                const successDiv = document.getElementById('successMessage');
                successDiv.textContent = message;
                successDiv.style.display = 'block';
                // Hide error message
                document.getElementById('errorMessage').style.display = 'none';
                // Scroll to top to show success
                window.scrollTo(0, 0);
                // Auto hide after 5 seconds
                setTimeout(() => {
                    successDiv.style.display = 'none';
                }, 5000);
            }

            function setLoading(loading) {
                isLoading = loading;
                const loadingContainer = document.getElementById('loading-container');
                const itemsContainer = document.getElementById('cart-items-container');
                const summary = document.getElementById('cart-summary');

                if (loading) {
                    loadingContainer.style.display = 'block';
                    itemsContainer.style.display = 'none';
                    summary.style.display = 'none';
                } else {
                    loadingContainer.style.display = 'none';
                }
            }

            function showMessage(message, type = 'info', timeout = 5000) {
                const container = document.getElementById(type === 'error' ? 'errorMessage' : 'successMessage');
                container.textContent = message;
                container.style.display = 'block';

                if (timeout > 0) {
                    setTimeout(() => {
                        container.style.display = 'none';
                    }, timeout);
                }
            }

            // Load user information and auto-fill form
            async function loadUserInfo() {
                try {
                    const response = await apiCall(USER_INFO_API_URL);
                    if (response.success && response.data) {
                        const userInfo = response.data;
                        document.getElementById('fullName').value = userInfo.fullName || '';
                        document.getElementById('phone').value = userInfo.phone || '';
                        document.getElementById('email').value = userInfo.email || '';
                        document.getElementById('address').value = userInfo.address || '';
                    }
                } catch (error) {
                    // Không hiển thị lỗi vì user có thể chưa đăng nhập
                }
            }
        </script>
    </body>
</html>
