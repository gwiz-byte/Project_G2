<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Product Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .rating {
            color: #ffd700;
            font-size: 20px;
        }
        .feedback-card {
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .feedback-card:hover {
            transform: translateY(-5px);
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
        }
        .filter-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .pagination {
            margin-top: 30px;
        }
        .action-buttons {
            margin-top: 10px;
            display: flex;
            gap: 10px;
        }
        .rating-input {
            display: inline-flex;
            flex-direction: row-reverse;
            gap: 5px;
        }
        .rating-input input {
            display: none;
        }
        .rating-input label {
            cursor: pointer;
            font-size: 25px;
            color: #ddd;
        }
        .rating-input label:hover,
        .rating-input label:hover ~ label,
        .rating-input input:checked ~ label {
            color: #ffd700;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center mb-4">Product Feedback</h1>
        
        <!-- Add New Feedback Button -->
        <div class="text-end mb-4">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addFeedbackModal">
                Add New Feedback
            </button>
        </div>

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
                <div class="col-md-3">
                    <label class="form-label">Sort By:</label>
                    <select name="sortBy" class="form-select" onchange="this.form.submit()">
                        <option value="newest" ${param.sortBy == 'newest' ? 'selected' : ''}>Newest First</option>
                        <option value="oldest" ${param.sortBy == 'oldest' ? 'selected' : ''}>Oldest First</option>
                        <option value="rating" ${param.sortBy == 'rating' ? 'selected' : ''}>Highest Rating</option>
                    </select>
                </div>
                <div class="col-md-3">
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
                <div class="col-md-6">
                    <label class="form-label">Search:</label>
                    <input type="text" name="search" class="form-control" placeholder="Search in feedback..." 
                           value="${param.search}" onkeyup="if(event.keyCode === 13) this.form.submit();">
                </div>
            </form>
        </div>

        <!-- Feedback Display -->
        <div class="row">
            <c:forEach items="${feedbackList}" var="feedback">
                <div class="col-md-6">
                    <div class="card feedback-card">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="star-rating">
                                    <c:forEach begin="1" end="5" var="i">
                                        <span>${i <= feedback.rating ? '★' : '☆'}</span>
                                    </c:forEach>
                                </div>
                                <small class="feedback-meta">
                                    ${feedback.created_at}
                                </small>
                            </div>
                            <p class="card-text">${feedback.content}</p>
                            <div class="feedback-meta mt-3">
                                <small>Product ID: ${feedback.product_id} | User ID: ${feedback.user_id}</small>
                            </div>
                            <div class="action-buttons">
                                <button type="button" class="btn btn-sm btn-primary" 
                                        onclick="editFeedback(${feedback.id}, ${feedback.product_id}, ${feedback.user_id}, ${feedback.rating}, '${feedback.content}')"
                                        data-bs-toggle="modal" data-bs-target="#editFeedbackModal">
                                    Edit
                                </button>
                                <button type="button" class="btn btn-sm btn-danger" 
                                        onclick="deleteFeedback(${feedback.id})"
                                        data-bs-toggle="modal" data-bs-target="#deleteFeedbackModal">
                                    Delete
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

    <!-- Add Feedback Modal -->
    <div class="modal fade" id="addFeedbackModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Feedback</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="feedback_control" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label class="form-label">Product ID:</label>
                            <input type="number" class="form-control" name="product_id" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">User ID:</label>
                            <input type="number" class="form-control" name="user_id" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Rating:</label>
                            <div class="rating-input">
                                <input type="radio" id="star5" name="rating" value="5" required>
                                <label for="star5">★</label>
                                <input type="radio" id="star4" name="rating" value="4">
                                <label for="star4">★</label>
                                <input type="radio" id="star3" name="rating" value="3">
                                <label for="star3">★</label>
                                <input type="radio" id="star2" name="rating" value="2">
                                <label for="star2">★</label>
                                <input type="radio" id="star1" name="rating" value="1">
                                <label for="star1">★</label>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Content:</label>
                            <textarea class="form-control" name="content" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Add Feedback</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Feedback Modal -->
    <div class="modal fade" id="editFeedbackModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Feedback</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="feedback_control" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="feedback_id" id="edit_feedback_id">
                        <input type="hidden" name="user_id" id="edit_user_id">
                        
                        <div class="mb-3">
                            <label class="form-label">Rating:</label>
                            <div class="rating-input">
                                <input type="radio" id="edit_star5" name="rating" value="5">
                                <label for="edit_star5">★</label>
                                <input type="radio" id="edit_star4" name="rating" value="4">
                                <label for="edit_star4">★</label>
                                <input type="radio" id="edit_star3" name="rating" value="3">
                                <label for="edit_star3">★</label>
                                <input type="radio" id="edit_star2" name="rating" value="2">
                                <label for="edit_star2">★</label>
                                <input type="radio" id="edit_star1" name="rating" value="1">
                                <label for="edit_star1">★</label>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Content:</label>
                            <textarea class="form-control" name="content" id="edit_content" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Update Feedback</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Feedback Modal -->
    <div class="modal fade" id="deleteFeedbackModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Delete Feedback</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="feedback_control" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="feedback_id" id="delete_feedback_id">
                        <p>Are you sure you want to delete this feedback? This action cannot be undone.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editFeedback(id, productId, userId, rating, content) {
            document.getElementById('edit_feedback_id').value = id;
            document.getElementById('edit_user_id').value = userId;
            document.getElementById('edit_content').value = content;
            document.querySelector(`#editFeedbackModal input[value="\${rating}"]`).checked = true;
        }
        
        function deleteFeedback(id) {
            document.getElementById('delete_feedback_id').value = id;
        }
    </script>
</body>
</html> 