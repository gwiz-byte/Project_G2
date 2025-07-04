<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Products" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Product Table</title>
        <style>
            table {
                border-collapse: collapse;
                width: 100%;
                font-family: Arial, sans-serif;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
                cursor: default;
            }
            tbody tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            .colheader {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .selected {
                background-color: #d1e7dd !important;
            }
            .sorted-asc .sort-asc {
                background-color: #28a745 !important;
            }
            .sorted-desc .sort-asc {
                background-color: #dc3545 !important;
            }
            #detailModal .modal-body {
                max-height: 400px;
                overflow-y: auto;
            }
            #specTable {
                width: 100%;
                margin-top: 10px;
            }
            #specTable th, #specTable td {
                border: 1px solid #ddd;
                padding: 5px;
            }
            #specTable th {
                background-color: #f8f9fa;
            }
        </style>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-3">
            <h2>Product Table</h2>
            <div class="buttons mb-3">
                <a href="${pageContext.request.contextPath}/ProductEditServlet?action=new" class="btn btn-primary">New</a>
                <a href="#" class="btn btn-primary" onclick="editSelected()">Edit</a>
                <a href="#" class="btn btn-danger" onclick="deleteSelected()">Delete</a>
            </div>
            <table class="table table-striped table-hover align-middle text-center" id="myTable">
                <thead>
                    <tr>
                        <th><div class="colheader"><span class="sortable" data-col="0">Product ID</span><span><button class="sort-asc btn btn-sm btn-light" data-col="0">↑</button><button class="no-sort btn btn-sm btn-light" data-col="0">F</button></span></div></th>
                        <th><div class="colheader"><span class="sortable" data-col="1">Name</span><span><button class="sort-asc btn btn-sm btn-light" data-col="1">↑</button><button class="no-sort btn btn-sm btn-light" data-col="1">F</button></span></div></th>
                        <th><div class="colheader"><span class="sortable" data-col="2">Brand</span><span><button class="sort-asc btn btn-sm btn-light" data-col="2">↑</button><button class="no-sort btn btn-sm btn-light" data-col="2">F</button></span></div></th>
                        <th><div class="colheader"><span class="sortable" data-col="3">Category</span><span><button class="sort-asc btn btn-sm btn-light" data-col="3">↑</button><button class="no-sort btn btn-sm btn-light" data-col="3">F</button></span></div></th>
                        <th><div class="colheader"><span class="sortable" data-col="4">Price</span><span><button class="sort-asc btn btn-sm btn-light" data-col="4">↑</button><button class="no-sort btn btn-sm btn-light" data-col="4">F</button></span></div></th>
                        <th><div class="colheader"><span class="sortable" data-col="5">Stock</span><span><button class="sort-asc btn btn-sm btn-light" data-col="5">↑</button><button class="no-sort btn btn-sm btn-light" data-col="5">F</button></span></div></th>
                        <th><div class="colheader"><span class="sortable" data-col="6">Image</span><span><button class="sort-asc btn btn-sm btn-light" data-col="6">↑</button><button class="no-sort btn btn-sm btn-light" data-col="6">F</button></span></div></th>
                        <th><div class="colheader"><span class="sortable" data-col="7">Description</span><span><button class="sort-asc btn btn-sm btn-light" data-col="7">↑</button><button class="no-sort btn btn-sm btn-light" data-col="7">F</button></span></div></th>
                        <th><div class="colheader">Specifications</div></th>
                        <th><div class="colheader">View Detail</div></th>
                        <th><div class="colheader"><span class="sortable" data-col="10">Status</span><span><button class="sort-asc btn btn-sm btn-light" data-col="10">↑</button><button class="no-sort btn btn-sm btn-light" data-col="10">F</button></span></div></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td>${product.id}</td>
                            <td>${product.name}</td>
                            <td>${product.brand}</td>
                            <td>${product.categoryName}</td>
                            <td>${product.price / 1000000}M VND</td>
                            <td>${product.stock}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty product.imageUrl}">
                                        <img src="${product.imageUrl}" width="100" alt="Product Image">
                                    </c:when>
                                    <c:otherwise>No Image</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${product.description}</td>
                            <td>                                                
                                <c:forEach var="key" items="${product.specDescription.keySet()}">
                                    <b>${key}:</b> ${product.specDescription[key]}<br>
                                </c:forEach></td>
                            <td>
                                <button 
                                    class="btn btn-info btn-sm view-detail"
                                    data-id="${product.id}"
                                    data-name="${product.name}"
                                    data-brand="${product.brand}"
                                    data-category="${product.categoryName}"
                                    data-price="${product.price}"
                                    data-stock="${product.stock}"
                                    data-image="${product.imageUrl}"
                                    data-description="${product.description}"
                                    data-status="${product.status}"
                                    data-specs='${fn:escapeXml(product.specDescription)}'>
                                    View Detail
                                </button>
                            </td>
                            <td>${product.status}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div id="columnFilterPopup" style="display:none; position:absolute; background:#fff; border:1px solid #ccc; box-shadow:0 2px 8px rgba(0,0,0,0.2); padding:10px; max-height:250px; overflow-y:auto; z-index:1000;">
                <div style="text-align:right;">
                    <button id="closeFilterBtn" type="button" class="btn btn-sm btn-close"></button>
                </div>
                <div id="filterOptionsContainer"></div>
                <button id="applyFilterBtn" type="button" class="btn btn-sm btn-primary mt-2">Apply Filter</button>
            </div>

            <!-- Modal for Product Details -->
            <div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="detailModalLabel">Product Details</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" id="modalProductDetails">
                            <div class="row mb-3">
                                <div class="col-md-6"><strong>Product ID:</strong> <span id="modalProductId"></span></div>
                                <div class="col-md-6"><strong>Name:</strong> <span id="modalProductName"></span></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6"><strong>Brand:</strong> <span id="modalProductBrand"></span></div>
                                <div class="col-md-6"><strong>Category:</strong> <span id="modalProductCategory"></span></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-6"><strong>Price:</strong> <span id="modalProductPrice"></span> VND</div>
                                <div class="col-md-6"><strong>Stock:</strong> <span id="modalProductStock"></span></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12"><strong>Image:</strong> <img id="modalProductImage" src="" alt="Product Image" style="max-width: 200px;"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12"><strong>Description:</strong> <span id="modalProductDescription"></span></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-12"><strong>Status:</strong> <span id="modalProductStatus"></span></div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <strong>Specifications:</strong>
                                    <div id="modalSpecDescription"></div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                    $(document).ready(function () {
                        const table = $('#myTable').DataTable({
                            pagingType: "full_numbers",
                            lengthMenu: [[5, 10, 15], [5, 10, 15]],
                            pageLength: 5,
                            ordering: true,
                            columnDefs: [
                                { orderable: false, targets: 0 } // First column (details-control) not orderable
                            ],
                            language: {
                                paginate: {
                                    first: '??',
                                    previous: '??',
                                    next: '??',
                                    last: '??'
                                }
                            }
                        });

                        $('#myTable thead th').on('click', function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                        });

                        let sortStates = {};
                        let currentFilterCol = null;

                        $('.sortable').on('click', function () {
                            const col = parseInt($(this).data('col'));
                            sortStates[col] = !sortStates[col] || false;
                            const direction = sortStates[col] ? 'asc' : 'desc';
                            sortTable(col, direction);
                            $(this).closest('th').toggleClass('sorted-asc sorted-desc', sortStates[col]);
                            table.draw();
                        });

                        $('.sort-asc').on('click', function (e) {
                            e.stopPropagation();
                            const col = parseInt($(this).data('col'));
                            sortStates[col] = !sortStates[col] || false;
                            const direction = sortStates[col] ? 'asc' : 'desc';
                            sortTable(col, direction);
                            $(this).closest('th').toggleClass('sorted-asc sorted-desc', sortStates[col]);
                            table.draw();
                        });

                        $('.no-sort').on('click', function (e) {
                            e.stopPropagation();
                            currentFilterCol = parseInt($(this).data('col'));
                            const $popup = $('#columnFilterPopup');
                            const $btn = $(this);
                            const offset = $btn.offset();

                            $popup.css({
                                top: offset.top + $btn.outerHeight(),
                                left: offset.left,
                                display: 'block',
                                width: $btn.outerWidth() * 8
                            });

                            let selectHtml = '<select id="popupColumnFilter" style="width:100%; margin-top:5px;"><option value="">-- Select to filter --</option>';
                            let uniqueValues = [];
                            $('#myTable tbody td:nth-child(' + (currentFilterCol + 1) + ')').each(function () {
                                const value = $(this).text().trim();
                                if (value && uniqueValues.indexOf(value) === -1) {
                                    uniqueValues.push(value);
                                }
                            });
                            uniqueValues.sort().forEach(function (val) {
                                selectHtml += '<option value="' + val + '">' + val + '</option>';
                            });
                            selectHtml += '</select>';
                            $('#filterOptionsContainer').html(selectHtml);
                        });

                        $('#closeFilterBtn').on('click', function () {
                            $('#columnFilterPopup').hide();
                        });

                        $('#applyFilterBtn').on('click', function () {
                            const $popup = $('#columnFilterPopup');
                            const selectedVal = $('#popupColumnFilter').val();
                            $popup.hide();
                            if (!selectedVal) {
                                $('#myTable tbody tr').show();
                            } else {
                                $('#myTable tbody tr').hide();
                                $('#myTable tbody tr').each(function () {
                                    const cellText = $(this).find('td:nth-child(' + (currentFilterCol + 1) + ')').text().trim();
                                    if (cellText === selectedVal) {
                                        $(this).show();
                                    }
                                });
                            }
                            table.draw();
                        });

                        function sortTable(col, direction) {
                            const $rows = $('#myTable tbody tr:visible').get();
                            $rows.sort(function (a, b) {
                                const aVal = $(a).find('td:eq(' + col + ')').text().trim();
                                const bVal = $(b).find('td:eq(' + col + ')').text().trim();
                                if (!isNaN(aVal) && !isNaN(bVal)) {
                                    return direction === 'asc' ? aVal - bVal : bVal - aVal;
                                }
                                return direction === 'asc' ? aVal.localeCompare(bVal) : bVal.localeCompare(aVal);
                            });
                            $.each($rows, function (index, row) {
                                $('#myTable tbody').append(row);
                            });
                        }

                        function editSelected() {
                            const $selectedRow = $('#myTable tbody tr.selected');
                            if ($selectedRow.length) {
                                const id = $selectedRow.find('td:first').text();
                                window.location.href = "${pageContext.request.contextPath}/ProductEditServlet?action=edit&id=" + id;
                            } else {
                                alert('Please select a product to edit.');
                            }
                        }

                        function deleteSelected() {
                            const $selectedRow = $('#myTable tbody tr.selected');
                            if ($selectedRow.length) {
                                if (confirm('Are you sure you want to delete this product?')) {
                                    const id = $selectedRow.find('td:first').text();
                                    window.location.href = "${pageContext.request.contextPath}/ProductEditServlet?action=delete&id=" + id;
                                }
                            } else {
                                alert('Please select a product to delete.');
                            }
                        }

                        $('#myTable tbody').on('click', 'tr', function () {
                            if ($(this).hasClass('selected')) {
                                $(this).removeClass('selected');
                            } else {
                                $('#myTable tbody tr').removeClass('selected');
                                $(this).addClass('selected');
                            }
                        });

                        // Handle View Detail button click
                        $('#myTable tbody').on('click', '.view-detail', function () {
                            const $btn = $(this);
                            $('#modalProductId').text($btn.data('id') || 'N/A');
                            $('#modalProductName').text($btn.data('name') || 'N/A');
                            $('#modalProductBrand').text($btn.data('brand') || 'N/A');
                            $('#modalProductCategory').text($btn.data('category') || 'N/A');
                            $('#modalProductPrice').text(($btn.data('price')/1000000).toFixed(2) || 'N/A');
                            $('#modalProductStock').text($btn.data('stock') || 'N/A');
                            $('#modalProductImage').attr('src', $btn.data('image') || '');
                            $('#modalProductDescription').text($btn.data('description') || 'N/A');
                            $('#modalProductStatus').text($btn.data('status') || 'N/A');

                            // Parse specs from data-specs attribute
                            let specs = $btn.attr('data-specs');
                            let specObj = {};
                            try {
                                specObj = JSON.parse(specs);
                            } catch (e) {
                                specObj = {};
                            }
                            let specHtml = '';
                            if (specObj && Object.keys(specObj).length > 0) {
                                for (const key in specObj) {
                                    if (Object.hasOwnProperty.call(specObj, key) && key && specObj[key]) {
                                        specHtml += `<b>${key}:</b> ${specObj[key]}<br>`;
                                    }
                                }
                            } else {
                                specHtml = '<i>No specifications</i>';
                            }
                            $('#modalSpecDescription').html(specHtml);

                            new bootstrap.Modal(document.getElementById('detailModal')).show();
                        });
                    });
        </script>
    </body>
</html>