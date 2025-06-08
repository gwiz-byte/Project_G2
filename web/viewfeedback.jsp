<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>View Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .rating {
            color: #ffd700;
            font-size: 20px;
        }
        .feedback-card {
            margin-bottom: 20px;
            transition: transform 0.2s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border: none;
        }
        .feedback-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .feedback-meta {
            font-size: 0.9em;
            color: #666;
        }
        .star-rating {
            display: inline-block;
        }
        .star-rating span {
            color: #ffd700;
            font-size: 1.2em;
        }
        .filter-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .pagination {
            margin-top: 30px;
        }
        .feedback-content {
            font-size: 1em;
            line-height: 1.5;
            color: #333;
        }
        .feedback-meta-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        .product-info {
            font-size: 0.9em;
            color: #666;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #eee;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center mb-4">Product Feedback</h1>

        <!-- Stats Section -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body text-center">
                        <h5>Total Feedback: ${totalFeedback}</h5>
                        <p class="mb-0">Page ${currentPage} of ${totalPages}</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Filter Section -->
        <div class="filter-section">
            <form action="viewfeedback" method="GET" class="row g-3">
                <input type="hidden" name="page" value="${currentPage}">
                <div class="col-md-4">
                    <label class="form-label">Sort By:</label>
                    <select name="sortBy" class="form-select" onchange="this.form.submit()">
                        <option value="newest" ${param.sortBy == 'newest' ? 'selected' : ''}>Newest First</option>
                        <option value="oldest" ${param.sortBy == 'oldest' ? 'selected' : ''}>Oldest First</option>
                        <option value="rating" ${param.sortBy == 'rating' ? 'selected' : ''}>Highest Rating</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Filter by Rating:</label>
                    <select name="rating" class="form-select" onchange="this.form.submit()">
                        <option value="">All Ratings</option>
                        <option value="5" ${param.rating == '5' ? 'selected' : ''}>5 Stars</option>
                        <option value="4" ${param.rating == '4' ? 'selected' : ''}>4 Stars</option>
                        <option value="3" ${param.rating == '3' ? 'selected' : ''}>3 Stars</option>
                        <option value="2" ${param.rating == '2' ? 'selected' : ''}>2 Stars</option>
                        <option value="1" ${param.rating == '1' ? 'selected' : ''}>1 Star</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Search:</label>
                    <div class="input-group">
                        <input type="text" name="search" class="form-control" placeholder="Search in feedback..." 
                               value="${param.search}">
                        <button class="btn btn-outline-secondary" type="submit">Search</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Feedback Display -->
        <div class="row">
            <c:forEach items="${feedbackList}" var="feedback">
                <div class="col-md-6">
                    <div class="card feedback-card">
                        <div class="card-body">
                            <div class="feedback-meta-info">
                                <div class="star-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <span>${i <= feedback.rating ? '★' : '☆'}</span>
                                    </c:forEach>
                                </div>
                                <small class="feedback-meta">
                                    ${feedback.created_at}
                                </small>
                            </div>
                            <div class="feedback-content">
                                <p class="card-text">${fn:substring(feedback.content, 0, 100)}${fn:length(feedback.content) > 100 ? '...' : ''}</p>
                            </div>
                            <div class="product-info">
                                <button type="button" class="btn btn-sm btn-info" 
                                        onclick="showFeedbackContent(this)" 
                                        data-rating="${feedback.rating}"
                                        data-content="${fn:escapeXml(feedback.content)}"
                                        data-created="${feedback.created_at}"
                                        data-product-id="${feedback.product_id}">
                                    View Details
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty feedbackList}">
                <div class="col-12 text-center">
                    <div class="alert alert-info" role="alert">
                        No feedback found.
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Feedback pagination" class="d-flex justify-content-center">
                <ul class="pagination">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="viewfeedback?page=${currentPage - 1}&sortBy=${param.sortBy}&rating=${param.rating}&search=${param.search}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="viewfeedback?page=${i}&sortBy=${param.sortBy}&rating=${param.rating}&search=${param.search}">
                                ${i}
                            </a>
                        </li>
                    </c:forEach>
                    
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="viewfeedback?page=${currentPage + 1}&sortBy=${param.sortBy}&rating=${param.rating}&search=${param.search}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>

    <!-- Feedback Content Modal -->
    <div class="modal fade" id="feedbackContentModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Feedback Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="feedback-meta mb-3">
                        <div class="star-rating mb-2" id="modalFeedbackRating"></div>
                        <small>
                            Created: <span id="modalFeedbackCreated"></span><br>
                            Product ID: <span id="modalFeedbackProductId"></span>
                        </small>
                    </div>
                    <div id="modalFeedbackContent" style="white-space: pre-wrap;"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showFeedbackContent(element) {
            const rating = element.getAttribute('data-rating');
            const content = element.getAttribute('data-content');
            const created = element.getAttribute('data-created');
            const productId = element.getAttribute('data-product-id');
            
            // Create star rating HTML
            let starsHtml = '';
            for (let i = 1; i <= 5; i++) {
                starsHtml += `<span style="color: #ffd700; font-size: 24px;">${i <= rating ? '★' : '☆'}</span>`;
            }
            
            document.getElementById('modalFeedbackRating').innerHTML = starsHtml;
            document.getElementById('modalFeedbackContent').textContent = content;
            document.getElementById('modalFeedbackCreated').textContent = created;
            document.getElementById('modalFeedbackProductId').textContent = productId;
            
            new bootstrap.Modal(document.getElementById('feedbackContentModal')).show();
        }
    </script>
</body>
</html> 