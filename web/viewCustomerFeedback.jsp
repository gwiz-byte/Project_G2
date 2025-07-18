<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="container mt-4">
    <div class="row">
        <div class="col-12">
            <h3>Customer Reviews</h3>
            <hr>
            
            <!-- Display average rating -->
            <div class="mb-4">
                <div class="d-flex align-items-center">
                    <div class="star-rating me-2">
                        <c:set var="avg" value="${averageRating + 0}" />
                        <c:forEach begin="1" end="5" var="i">
                            <span style="color: #ffd700; font-size: 24px;">
                                ${i <= avg ? '★' : '☆'}
                            </span>
                        </c:forEach>
                    </div>
                    <span class="text-muted">
                        ${String.format("%.1f", averageRating)} out of 5
                        (${totalFeedback} ${totalFeedback == 1 ? 'review' : 'reviews'})
                    </span>
                </div>
            </div>

            <!-- Feedback list -->
            <div class="row">
                <c:choose>
                    <c:when test="${empty feedbackList}">
                        <div class="col-12">
                            <p class="text-muted">No reviews yet. Be the first to review this product!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${feedbackList}" var="feedback">
                            <div class="col-12 mb-4">
                                <div class="card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div class="star-rating">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <span style="color: #ffd700; font-size: 18px;">
                                                        ${i <= feedback.rating ? '★' : '☆'}
                                                    </span>
                                                </c:forEach>
                                            </div>
                                            <small class="text-muted">${feedback.created_at}</small>
                                        </div>
                                        <p class="card-text">${feedback.content}</p>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <small class="text-muted">
                                                By ${not empty feedback.customerName ? feedback.customerName : 'Anonymous User'}
                                            </small>
                                            <c:if test="${not empty sessionScope.customer && sessionScope.customer.customer_id == feedback.customer_id}">
                                                <div class="btn-group">
                                                    <button type="button" class="btn btn-sm btn-outline-primary" 
                                                            onclick="editFeedback('${feedback.feedback_id}', '${fn:escapeXml(feedback.content)}', '${feedback.rating}')">
                                                        Edit
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-danger" 
                                                            onclick="deleteFeedback('${feedback.feedback_id}')">
                                                        Delete
                                                    </button>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Feedback pagination" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="productservlet?service=productDetail&id=${product.id}&page=${currentPage - 1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="productservlet?service=productDetail&id=${product.id}&page=${i}">
                                    ${i}
                                </a>
                            </li>
                        </c:forEach>
                        
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="productservlet?service=productDetail&id=${product.id}&page=${currentPage + 1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</div>

<!-- Add JavaScript for edit/delete functionality -->
<script>
    function editFeedback(feedbackId, content, rating) {
        // Implement edit functionality
        // You can show a modal or redirect to an edit page
    }
    
    function deleteFeedback(feedbackId) {
        if (confirm('Are you sure you want to delete this review?')) {
            window.location.href = 'productservlet?service=deleteFeedback&id=' + feedbackId;
        }
    }
</script> 