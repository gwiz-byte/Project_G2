<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>PC Builder</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link href="css/homePage.css" rel="stylesheet">
        <style>
            .list-group-item {
                font-size: 1.1rem;
                padding: 14px 18px;
                border: none;
                border-bottom: 1px solid #f0f0f0;
                background: #fff;
                transition: background 0.2s;
            }
            .list-group-item:hover {
                background: #f5f7fa;
            }
            .list-group {
                border-radius: 12px;
                overflow: hidden;
            }
            .sidebar {
                background: #f8f9fa;
                border-radius: 12px;
                padding-top: 30px;
                padding-bottom: 30px;
                min-height: 100%;
                height: 100%;
            }
            .main-content {
                padding-top: 30px;
            }
            .component-card {
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border: none;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            .component-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            }
            .component-header {
                background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
                color: white;
                padding: 15px;
                border-radius: 8px 8px 0 0;
            }
            .component-body {
                padding: 20px;
            }
            .form-select {
                border: 1px solid #dee2e6;
                border-radius: 8px;
                padding: 10px;
                font-size: 1rem;
            }
            .form-select:focus {
                border-color: #0d6efd;
                box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
            }
            .total-price {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-top: 30px;
            }
            .total-price h4 {
                color: #0d6efd;
                margin: 0;
            }
            .btn-build {
                background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
                color: white;
                padding: 12px 30px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s ease;
            }
            .btn-build:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(13, 110, 253, 0.3);
            }
            .page-header {
                background: linear-gradient(135deg, rgba(102, 126, 234, 0.7) 0%, rgba(118, 75, 162, 0.7) 100%), url('https://images.unsplash.com/photo-1587202372775-e229f172b9d7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1920&q=80');
                background-size: cover;
                background-position: center;
                color: white;
                padding: 60px 0;
                margin-bottom: 40px;
                text-align: center;
            }
            .page-header h2 {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 1rem;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            }
            .page-header p {
                font-size: 1.2rem;
                opacity: 0.9;
                text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
            }
            .component-icon {
                font-size: 2rem;
                margin-bottom: 10px;
                color: #0d6efd;
            }
            @media (min-width: 768px) {
                .equal-height {
                    display: flex;
                    align-items: stretch;
                }
                .sidebar, .content-col {
                    height: 100%;
                }
            }
            .sidebar-container {
                width: 260px;
                background: #f8f9fa;
                border-radius: 10px;
                padding: 18px 0 0 0;
                box-shadow: 0 2px 12px rgba(0,0,0,0.08);
                position: relative;
            }
            .sidebar-search {
                padding: 0 18px 12px 18px;
            }
            .sidebar-search input {
                width: 100%;
                padding: 8px 12px;
                border-radius: 6px;
                border: 1px solid #ddd;
                font-size: 1rem;
            }
            .sidebar-menu {
                list-style: none;
                margin: 0;
                padding: 0;
            }
            .menu-item {
                position: relative;
                user-select: none;
            }
            .menu-item > a {
                display: flex;
                align-items: center;
                padding: 14px 18px;
                color: #222;
                text-decoration: none;
                font-weight: 500;
                transition: background 0.2s, color 0.2s;
                border-radius: 0 20px 20px 0;
                justify-content: flex-start;
                gap: 10px;
                text-align: left;
            }
            .menu-item > a i {
                min-width: 22px;
                text-align: center;
            }
            .menu-item > a:hover, .menu-item.active > a {
                background: #0d6efd;
                color: #fff;
            }
            .menu-item.has-submenu > a .submenu-arrow {
                margin-left: 8px;
                font-size: 1.2em;
                color: #888;
                transition: color 0.2s;
            }
            .menu-item.has-submenu > a:hover .submenu-arrow {
                color: #fff;
            }
            .submenu {
                display: none;
                opacity: 0;
                pointer-events: none;
                position: absolute;
                left: 100%;
                top: 0;
                min-width: 340px;
                background: #fff;
                box-shadow: 0 2px 12px rgba(0,0,0,0.12);
                border-radius: 8px;
                z-index: 100;
                padding: 20px 30px;
                white-space: nowrap;
                flex-direction: row;
                gap: 30px;
                transition: opacity 0.25s;
            }
            .menu-item.has-submenu:hover > .submenu,
            .menu-item.has-submenu:focus-within > .submenu,
            .menu-item.show > .submenu {
                display: flex;
                opacity: 1;
                pointer-events: auto;
            }
            .submenu-col {
                margin-right: 30px;
            }
            .submenu-col h6 {
                font-weight: bold;
                margin-bottom: 10px;
            }
            .submenu-col ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }
            .submenu-col ul li a {
                color: #333;
                text-decoration: none;
                display: block;
                padding: 4px 0;
                border-radius: 4px;
                transition: background 0.2s, color 0.2s;
            }
            .submenu-col ul li a:hover {
                color: #0d6efd;
                background: #f0f4ff;
            }
            @media (max-width: 767px) {
                .sidebar-container {
                    width: 100%;
                    border-radius: 0;
                    box-shadow: none;
                    padding: 0;
                }
                .sidebar-menu {
                    width: 100%;
                }
                .menu-item > a {
                    border-radius: 0;
                }
                .submenu {
                    position: static;
                    min-width: 0;
                    box-shadow: none;
                    padding: 10px 18px;
                    flex-direction: column;
                    gap: 0;
                    border-radius: 0;
                    transition: max-height 0.3s, opacity 0.3s;
                    max-height: 0;
                    overflow: hidden;
                    opacity: 0;
                    display: block;
                }
                .menu-item.show > .submenu {
                    max-height: 1000px;
                    opacity: 1;
                    pointer-events: auto;
                }
            }
            .breadcrumb-nav {
                margin: 18px 0 0 0;
                font-size: 1rem;
                color: #666;
            }
            .breadcrumb-nav a {
                color: #0d6efd;
                text-decoration: none;
            }
            .breadcrumb-sep {
                margin: 0 6px;
            }
            .pc-builder-bg {
                position: relative;
                background: url('assets/backgroeoe.jpg.jpg') center/cover no-repeat;
                color: #fff;
                min-height: 964px;
                overflow: hidden;
                border-radius: 12px;
            }
            .pc-builder-bg .bg-overlay {
                position: absolute;
                inset: 0;
                background: rgba(0,0,0,0.45);
                z-index: 1;
                border-radius: 12px;
                height: 100%;
                width: 100%;
            }
            .pc-builder-bg > *:not(.bg-overlay) {
                position: relative;
                z-index: 2;
            }
            .pc-builder-bg h2,
            .pc-builder-bg p {
                z-index: 2;
                position: relative;
            }
            .btn-pcbuilder-white {
                background: #fff !important;
                color: #0d6efd !important;
                border: 2px solid #0d6efd !important;
                font-weight: 600;
                box-shadow: 0 2px 8px rgba(13,110,253,0.08);
                transition: background 0.2s, color 0.2s, box-shadow 0.2s;
            }
            .btn-pcbuilder-white:hover, .btn-pcbuilder-white:focus {
                background: #0d6efd !important;
                color: #fff !important;
                box-shadow: 0 4px 16px rgba(13,110,253,0.15);
            }
            /* Modern tech style for modal popup in pcBuilder.jsp */
            #viewProductModal .modal-content {
                border-radius: 18px;
                box-shadow: 0 8px 32px rgba(0,0,0,0.18), 0 1.5px 8px rgba(0,123,255,0.08);
                border: none;
                background: rgba(255,255,255,0.98);
                overflow: hidden;
                animation: modalFadeIn 0.4s cubic-bezier(.4,0,.2,1);
            }
            #viewProductModal .modal-header {
                background: linear-gradient(90deg, #0d6efd 0%, #00c6ff 100%);
                color: #fff;
                border-bottom: none;
                padding: 1.2rem 2rem 1.2rem 2rem;
                align-items: center;
                justify-content: space-between;
            }
            #viewProductModal .modal-title {
                font-size: 1.5rem;
                font-weight: 700;
                letter-spacing: 1px;
                text-shadow: 0 2px 8px rgba(0,0,0,0.08);
                margin: 0 auto;
            }
            #viewProductModal .btn-back {
                background: #fff url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="%230d6efd" stroke-width="3" viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>') center/1.2em auto no-repeat;
                border-radius: 50%;
                width: 2.5rem;
                height: 2.5rem;
                opacity: 0.85;
                transition: background 0.2s, box-shadow 0.2s;
                box-shadow: 0 2px 8px rgba(13,110,253,0.08);
                border: none;
                margin-right: auto;
            }
            #viewProductModal .btn-back:hover {
                background-color: #e3f0ff;
                opacity: 1;
            }
            #viewProductModal .btn-forward {
                background: #fff url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="%230d6efd" stroke-width="3" viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>') center/1.2em auto no-repeat;
                border-radius: 50%;
                width: 2.5rem;
                height: 2.5rem;
                opacity: 0.85;
                transition: background 0.2s, box-shadow 0.2s;
                box-shadow: 0 2px 8px rgba(13,110,253,0.08);
                border: none;
                margin-left: 0.5rem;
            }
            #viewProductModal .btn-forward:hover {
                background-color: #e3f0ff;
                opacity: 1;
            }
            #viewProductModal .btn-reset {
                background: #fff url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="%230d6efd" stroke-width="3" viewBox="0 0 24 24"><path d="M3 12a9 9 0 1 1 9 9M3 12h9M3 12l3-3M3 12l3 3"/></svg>') center/1.2em auto no-repeat;
                border-radius: 50%;
                width: 2.5rem;
                height: 2.5rem;
                opacity: 0.85;
                transition: background 0.2s, box-shadow 0.2s;
                box-shadow: 0 2px 8px rgba(13,110,253,0.08);
                border: none;
                margin-left: 0.5rem;
            }
            #viewProductModal .btn-reset:hover {
                background-color: #e3f0ff;
                opacity: 1;
            }
            #viewProductModal .btn-close {
                background: #fff url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="none" stroke="%230d6efd" stroke-width="3" viewBox="0 0 24 24"><path d="M6 6l12 12M6 18L18 6"/></svg>') center/1.5em auto no-repeat;
                border-radius: 50%;
                width: 2.5rem;
                height: 2.5rem;
                opacity: 0.85;
                transition: background 0.2s, box-shadow 0.2s;
                box-shadow: 0 2px 8px rgba(13,110,253,0.08);
                margin-left: 0.5rem;
            }
            #viewProductModal .btn-close:hover {
                background-color: #e3f0ff;
                opacity: 1;
            }
            #viewProductModal .modal-body {
                background: linear-gradient(120deg, #f8fafd 60%, #e3f0ff 100%);
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 80vh;
                min-height: 400px;
                max-height: 90vh;
                overflow: hidden;
            }
            #viewProductModal iframe {
                border-radius: 0 0 18px 18px;
                background: transparent;
                box-shadow: none;
                transition: box-shadow 0.2s;
                max-width: 100%;
                max-height: 100%;
                width: 100%;
                height: 100%;
                overflow-x: auto;
                display: block;
                scrollbar-color: #0d6efd #e3f0ff;
                scrollbar-width: thin;
            }
            @keyframes modalFadeIn {
                from { transform: translateY(40px) scale(0.98); opacity: 0; }
                to { transform: none; opacity: 1; }
            }
            #productSelectModal .table-responsive {
                margin: 0;
                padding: 0;
            }
            #productSelectModal table {
                width: 100%;
                table-layout: auto;
                word-break: break-word;
            }
            #productSelectModal th, #productSelectModal td {
                white-space: normal !important;
                word-break: break-word;
                vertical-align: middle;
                font-size: 1rem;
                padding: 0.5rem 0.75rem;
            }
            #productSelectModal .modal-dialog {
                max-width: 98vw;
                width: 98vw;
                margin: 0 auto;
            }
            #productSelectModal .modal-content {
                width: 100%;
                min-height: 80vh;
                max-height: 95vh;
            }
            #productSelectModal .modal-body {
                overflow: visible !important;
                max-height: none !important;
                padding: 0;
            }
            #productSelectModal .table-responsive {
                overflow-x: visible !important;
            }
            #productSelectModal table {
                width: 100%;
                table-layout: auto;
            }
            #productSelectModal table,
            #productSelectModal th,
            #productSelectModal td {
                font-size: 0.92em;
                padding: 0.3em 0.5em;
            }
            /* Tuỳ chọn: scale nhỏ bảng để vừa modal */
            #productSelectModal .table-responsive {
                transform: scale(0.85);
                transform-origin: top left;
                width: 117.6%; /* 1/0.85 để bù lại scale */
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp"/>
        <div class="container-fluid py-4">
            
            <form action="PCBuilderServlet" method="post">
                <div class="row equal-height">
                    <!-- Sidebar Megamenu -->
                    <div class="col-md-3 sidebar mb-4 mb-md-0">
                        <div class="sidebar-section mb-4">
                            <h5 class="mb-3">Build Case PC</h5>
                            <ul class="sidebar-menu">
                                <!-- CPU Section -->
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-microchip fa-fw me-2"></i> CPU</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <c:forEach var="brand" items="${brandsMap['CPU']}">
                                                    <li><a href="#" data-component="cpu" data-brand="${brand}">${brand}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Series</h6>
                                            <ul>
                                                <c:forEach var="series" items="${seriesMap['CPU']}">
                                                    <li><a href="#" data-component="cpu" data-series="${series}">${series}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                
                                <!-- Mainboard Section -->
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-server fa-fw me-2"></i> Mainboard</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <c:forEach var="brand" items="${brandsMap['Mainboard']}">
                                                    <li><a href="#" data-component="mainboard" data-brand="${brand}">${brand}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Series</h6>
                                            <ul>
                                                <c:forEach var="series" items="${seriesMap['Mainboard']}">
                                                    <li><a href="#" data-component="mainboard" data-series="${series}">${series}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                
                                <!-- RAM Section -->
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-memory fa-fw me-2"></i> RAM</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <c:forEach var="brand" items="${brandsMap['RAM']}">
                                                    <li><a href="#" data-component="ram" data-brand="${brand}">${brand}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Series</h6>
                                            <ul>
                                                <c:forEach var="series" items="${seriesMap['RAM']}">
                                                    <li><a href="#" data-component="ram" data-series="${series}">${series}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                
                                <!-- GPU Section -->
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-video fa-fw me-2"></i> GPU</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <c:forEach var="brand" items="${brandsMap['GPU']}">
                                                    <li><a href="#" data-component="gpu" data-brand="${brand}">${brand}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Series</h6>
                                            <ul>
                                                <c:forEach var="series" items="${seriesMap['GPU']}">
                                                    <li><a href="#" data-component="gpu" data-series="${series}">${series}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                
                                <!-- Storage Section -->
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-hdd fa-fw me-2"></i> Storage</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <c:forEach var="brand" items="${brandsMap['Storage']}">
                                                    <li><a href="#" data-component="storage" data-brand="${brand}">${brand}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Series</h6>
                                            <ul>
                                                <c:forEach var="series" items="${seriesMap['Storage']}">
                                                    <li><a href="#" data-component="storage" data-series="${series}">${series}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                
                                <!-- PSU Section -->
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-plug fa-fw me-2"></i> PSU</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <c:forEach var="brand" items="${brandsMap['PSU']}">
                                                    <li><a href="#" data-component="psu" data-brand="${brand}">${brand}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Series</h6>
                                            <ul>
                                                <c:forEach var="series" items="${seriesMap['PSU']}">
                                                    <li><a href="#" data-component="psu" data-series="${series}">${series}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                
                                <!-- Case Section -->
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-desktop fa-fw me-2"></i> Case</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <c:forEach var="brand" items="${brandsMap['Case']}">
                                                    <li><a href="#" data-component="case" data-brand="${brand}">${brand}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Series</h6>
                                            <ul>
                                                <c:forEach var="series" items="${seriesMap['Case']}">
                                                    <li><a href="#" data-component="case" data-series="${series}">${series}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                
                                <!-- Cooler Section -->
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-fan fa-fw me-2"></i> Cooler</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <c:forEach var="brand" items="${brandsMap['Cooler']}">
                                                    <li><a href="#" data-component="cooler" data-brand="${brand}">${brand}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Series</h6>
                                            <ul>
                                                <c:forEach var="series" items="${seriesMap['Cooler']}">
                                                    <li><a href="#" data-component="cooler" data-series="${series}">${series}</a></li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="sidebar-section">
                            <h5 class="mb-3">Accessories</h5>
                            <ul class="sidebar-menu">
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-mouse fa-fw me-2"></i> Mouse</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <li><a href="#">Logitech</a></li>
                                                <li><a href="#">Razer</a></li>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Type</h6>
                                            <ul>
                                                <li><a href="#">Gaming Mouse</a></li>
                                                <li><a href="#">Wireless Mouse</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-keyboard fa-fw me-2"></i> Keyboard</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <li><a href="#">DareU</a></li>
                                                <li><a href="#">Logitech</a></li>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Type</h6>
                                            <ul>
                                                <li><a href="#">Mechanical</a></li>
                                                <li><a href="#">Wireless</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-headphones fa-fw me-2"></i> Headphone</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <li><a href="#">HyperX</a></li>
                                                <li><a href="#">Sony</a></li>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Type</h6>
                                            <ul>
                                                <li><a href="#">Gaming</a></li>
                                                <li><a href="#">Bluetooth</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-tv fa-fw me-2"></i> Monitor</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <li><a href="#">LG</a></li>
                                                <li><a href="#">Samsung</a></li>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Type</h6>
                                            <ul>
                                                <li><a href="#">Gaming</a></li>
                                                <li><a href="#">Graphic Design</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                                <li class="menu-item has-submenu">
                                    <a href="#"><i class="fas fa-chair fa-fw me-2"></i> Chair & Desk</a>
                                    <div class="submenu">
                                        <div class="submenu-col">
                                            <h6>Brand</h6>
                                            <ul>
                                                <li><a href="#">E-Dra</a></li>
                                                <li><a href="#">DXRacer</a></li>
                                            </ul>
                                        </div>
                                        <div class="submenu-col">
                                            <h6>Type</h6>
                                            <ul>
                                                <li><a href="#">Gaming Chair</a></li>
                                                <li><a href="#">Gaming Desk</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <!-- Content chọn linh kiện -->
                    <div class="col-md-9 content-col">
                        <div class="pc-builder-bg component-card text-center p-4 mb-4" style="position: relative;">
                            <div class="bg-overlay" style="background: none; position: static; z-index: auto; height: auto; width: auto;">
                                <!-- Build Case PC Progress Tracker -->
                                <div class="container py-3">
                                    <div class="row justify-content-center">
                                        <div class="col-12">
                                            <div class="progress-tracker mb-3">
                                                <ul class="progress-steps d-flex flex-wrap justify-content-center list-unstyled mb-0" style="gap: 18px;">
                                                    <li class="step" id="step-cpu">
                                                        <span class="step-label">CPU</span>
                                                        <div class="step-selected" id="selected-cpu" style="font-size:0.95em;color:#0d6efd;"></div>
                                                    </li>
                                                    <li class="step" id="step-mainboard">
                                                        <span class="step-label">Mainboard</span>
                                                        <div class="step-selected" id="selected-mainboard"></div>
                                                    </li>
                                                    <li class="step" id="step-ram">
                                                        <span class="step-label">RAM</span>
                                                        <div class="step-selected" id="selected-ram"></div>
                                                    </li>
                                                    <li class="step" id="step-gpu">
                                                        <span class="step-label">GPU</span>
                                                        <div class="step-selected" id="selected-gpu"></div>
                                                    </li>
                                                    <li class="step" id="step-storage">
                                                        <span class="step-label">Storage</span>
                                                        <div class="step-selected" id="selected-storage"></div>
                                                    </li>
                                                    <li class="step" id="step-psu">
                                                        <span class="step-label">PSU</span>
                                                        <div class="step-selected" id="selected-psu"></div>
                                                    </li>
                                                    <li class="step" id="step-case">
                                                        <span class="step-label">Case</span>
                                                        <div class="step-selected" id="selected-case"></div>
                                                    </li>
                                                    <li class="step" id="step-cooler">
                                                        <span class="step-label">Cooler</span>
                                                        <div class="step-selected" id="selected-cooler"></div>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="progress" style="height: 8px;">
                                                <div class="progress-bar bg-primary" id="build-progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- Dãy nút chọn linh kiện tích hợp vào đây -->
                            <div class="container mb-4">
                                <div class="row mb-2 justify-content-center">
                                    <div class="col-auto mb-2">
                                        <button class="btn btn-pcbuilder-white btn-lg" onclick="selectComponent('cpu')"><i class="fas fa-microchip me-2"></i>Select CPU</button>
                                    </div>
                                    <div class="col-auto mb-2">
                                        <button class="btn btn-pcbuilder-white btn-lg" onclick="selectComponent('mainboard')"><i class="fas fa-server me-2"></i>Select Mainboard</button>
                                    </div>
                                    <div class="col-auto mb-2">
                                        <button class="btn btn-pcbuilder-white btn-lg" onclick="selectComponent('ram')"><i class="fas fa-memory me-2"></i>Select RAM</button>
                                    </div>
                                    <div class="col-auto mb-2">
                                        <button class="btn btn-pcbuilder-white btn-lg" onclick="selectComponent('gpu')"><i class="fas fa-video me-2"></i>Select GPU</button>
                                    </div>
                                    <div class="col-auto mb-2">
                                        <button class="btn btn-pcbuilder-white btn-lg" onclick="selectComponent('storage')"><i class="fas fa-hdd me-2"></i>Select Storage</button>
                                    </div>
                                    <div class="col-auto mb-2">
                                        <button class="btn btn-pcbuilder-white btn-lg" onclick="selectComponent('psu')"><i class="fas fa-plug me-2"></i>Select PSU</button>
                                    </div>
                                    <div class="col-auto mb-2">
                                        <button class="btn btn-pcbuilder-white btn-lg" onclick="selectComponent('case')"><i class="fas fa-desktop me-2"></i>Select Case</button>
                                    </div>
                                    <div class="col-auto mb-2">
                                        <button class="btn btn-pcbuilder-white btn-lg" onclick="selectComponent('cooler')"><i class="fas fa-fan me-2"></i>Select Cooler</button>
                                    </div>
                                </div>
                            </div>
                            <!-- Vùng hiển thị sản phẩm động -->
                            <div id="productList" class="mt-4"></div>
                        </div>
                    </div>
                </div>
            </form>
            <!-- Total Price Display -->
            <div class="total-price text-center">
                <h4>Total Price: $<span id="totalPrice">0.00</span></h4>
            </div>
        </div>
        <div class="container mt-5">
            <h3 class="mb-4">Danh sách Series và Model theo từng loại linh kiện</h3>
            <div class="row">
                <c:set var="typeNames" value="CPU,Mainboard,RAM,GPU,Storage,PSU,Case,Cooler" />
                <c:forEach var="typeId" begin="1" end="8" varStatus="status">
                    <div class="col-md-3 mb-4">
                        <div class="card h-100 shadow-sm">
                            <div class="card-header bg-primary text-white">
                                <strong>
                                    <c:out value="${fn:split(typeNames, ',')[typeId-1]}" />
                                </strong>
                            </div>
                            <div class="card-body">
                                <strong>Series:</strong>
                                <ul class="mb-2" style="font-size:0.97em;">
                                    <c:forEach var="series" items="${allSeriesMap[typeId]}">
                                        <li>${series}</li>
                                    </c:forEach>
                                </ul>
                                <strong>Model:</strong>
                                <ul style="font-size:0.97em;">
                                    <c:forEach var="model" items="${allModelMap[typeId]}">
                                        <li>${model}</li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <jsp:include page="footer.jsp"/>
        <script>
        //<![CDATA[
            // Add JavaScript to calculate total price when components are selected
            document.querySelectorAll('select').forEach(select => {
                select.addEventListener('change', calculateTotal);
            });
            function calculateTotal() {
                let total = 0;
                document.querySelectorAll('select').forEach(select => {
                    const selectedOption = select.options[select.selectedIndex];
                    if (selectedOption.value) {
                        const price = parseFloat(selectedOption.text.split('$')[1]);
                        total += price;
                    }
                });
                document.getElementById('totalPrice').textContent = total.toFixed(2);
            }
            // Tìm kiếm danh mục
            if (document.getElementById('sidebarSearch')) {
                document.getElementById('sidebarSearch').addEventListener('input', function() {
                    const filter = this.value.toLowerCase();
                    document.querySelectorAll('.sidebar-menu .menu-item').forEach(item => {
                        const text = item.textContent.toLowerCase();
                        item.style.display = text.includes(filter) ? '' : 'none';
                    });
                });
            }
            // Mobile: toggle submenu khi click
            if (window.innerWidth < 768) {
                document.querySelectorAll('.menu-item.has-submenu > a').forEach(link => {
                    link.addEventListener('click', function(e) {
                        e.preventDefault();
                        const parent = this.parentElement;
                        parent.classList.toggle('show');
                        // Đóng các submenu khác
                        document.querySelectorAll('.menu-item.has-submenu').forEach(item => {
                            if (item !== parent) item.classList.remove('show');
                        });
                    });
                });
            }
            // Desktop: giữ submenu khi di chuyển giữa cha và submenu
            if (window.innerWidth >= 768) {
                document.querySelectorAll('.menu-item.has-submenu').forEach(item => {
                    let timer;
                    item.addEventListener('mouseenter', function() {
                        clearTimeout(timer);
                        item.classList.add('show');
                    });
                    item.addEventListener('mouseleave', function() {
                        timer = setTimeout(() => item.classList.remove('show'), 200);
                    });
                    // Đảm bảo submenu không bị ẩn khi di chuyển chuột giữa cha và submenu
                    const submenu = item.querySelector('.submenu');
                    if (submenu) {
                        submenu.addEventListener('mouseenter', () => clearTimeout(timer));
                        submenu.addEventListener('mouseleave', () => {
                            timer = setTimeout(() => item.classList.remove('show'), 200);
                        });
                    }
                });
            }
            // Breadcrumb: cập nhật khi click submenu
            if (document.getElementById('breadcrumbNav')) {
                document.querySelectorAll('.submenu-col ul li a').forEach(link => {
                    link.addEventListener('click', function(e) {
                        // Breadcrumb hiển thị: Trang chủ > Danh mục > Subcategory
                        const category = this.closest('.menu-item').querySelector('a').textContent.trim();
                        const sub = this.textContent.trim();
                        document.getElementById('breadcrumbCategory').textContent = category;
                        document.getElementById('breadcrumbSub').textContent = sub;
                        document.getElementById('breadcrumbNav').style.display = '';
                        document.getElementById('breadcrumbSubSep').style.display = '';
                        // Nếu muốn chuyển trang thực sự, bỏ comment dòng dưới
                        // window.location = this.href;
                        // e.preventDefault();
                    });
                });
            }
            // Hiển thị sản phẩm khi bấm submenu (giống GearVN)
            const typeMap = {
                "CPU": 1,
                "GPU": 4,
                "Mainboard": 2,
                "RAM": 3,
                "Storage": 5,
                "PSU": 6,
                "Case": 7,
                "Cooler": 8
            };
            
            document.querySelectorAll('.submenu-col ul li a').forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const component = this.getAttribute('data-component');
                    const brand = this.getAttribute('data-brand');
                    const series = this.getAttribute('data-series');
                    
                    console.log('Đã click vào:', component, brand, series);
                    
                    if (component) {
                        let url = 'PCBuilderServlet?action=getProducts&componentType=' + component;
                        if (brand) url += '&brand=' + encodeURIComponent(brand);
                        if (series) url += '&series=' + encodeURIComponent(series);
                        
                        fetch(url)
                            .then(res => res.json())
                            .then(products => {
                                let html = `<h4 class="mb-3">Products: ${component.toUpperCase()}`;
                                if (brand) html += ` - ${brand}`;
                                if (series) html += ` - ${series}`;
                                html += `</h4>`;
                                
                                if (products.length > 0) {
                                    html += '<div class="row">';
                                    products.forEach(p => {
                                        html += `
                                            <div class="col-md-4 mb-3">
                                                <div class="card component-card">
                                                    <img src="${p.image_url || 'assets/images/default-product.jpg'}" 
                                                         class="card-img-top" alt="${p.name}" 
                                                         style="height: 200px; object-fit: cover;">
                                                    <div class="card-body">
                                                        <h5 class="card-title">${p.name}</h5>
                                                        <p class="card-text">
                                                            <strong>Brand:</strong> ${p.brandName}<br>
                                                            <strong>Series:</strong> ${p.seriesName || 'N/A'}<br>
                                                            <strong>Model:</strong> ${p.modelName || 'N/A'}<br>
                                                            <strong>Price:</strong> $${p.price}<br>
                                                            <strong>Stock:</strong> ${p.stock}
                                                        </p>
                                                        <p class="card-text">${p.description || ''}</p>
                                                        <button class="btn btn-primary" onclick="selectComponent(componentType, ${p.product_id}, '${p.name}', ${p.price})">
                                                            Select ${component.toUpperCase()}
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        `;
                                    });
                                    html += '</div>';
                                } else {
                                    html += '<p>No products found.</p>';
                                }
                                document.getElementById('productList').innerHTML = html;
                            })
                            .catch(error => {
                                console.error('Error fetching products:', error);
                                document.getElementById('productList').innerHTML = '<p>Error loading products.</p>';
                            });
                    } else {
                        document.getElementById('productList').innerHTML = '<p>Component type not supported.</p>';
                    }
                });
            });
            
            // Function to select a component and update progress
            function selectComponent(componentType) {
                // Gọi API lấy sản phẩm theo loại linh kiện
                const url = `PCBuilderServlet?action=getProducts&componentType=${componentType}`;
                fetch(url)
                    .then(res => res.json())
                    .then(products => {
                        let html = `
                            <div class="row mb-3">
                                <div class="col">
                                    <input type="text" id="searchInput" class="form-control" placeholder="Tìm kiếm...">
                                </div>
                                <div class="col">
                                    <select id="brandFilter" class="form-select">
                                        <option value="">Tất cả Brand</option>
                                        <!-- Options sẽ được JS render -->
                                    </select>
                                </div>
                                <div class="col">
                                    <select id="seriesFilter" class="form-select">
                                        <option value="">Tất cả Series</option>
                                        <!-- Options sẽ được JS render -->
                                    </select>
                                </div>
                            </div>
                            <table class="table table-bordered align-middle" id="productTable">
                                <thead>
                                    <tr>
                                        <th>Tên</th>
                                        <th>Brand</th>
                                        <th>Series</th>
                                        <th>Model</th>
                                        <th>Giá</th>
                                        <th>Stock</th>
                                        <th>Chọn</th>
                                    </tr>
                                </thead>
                                <tbody>
                        `;
                        products.forEach(p => {
                            html += `
                                <tr>
                                    <td>${p.name}</td>
                                    <td>${p.brandName}</td>
                                    <td>${p.seriesName || ''}</td>
                                    <td>${p.modelName || ''}</td>
                                    <td>${p.price}</td>
                                    <td>${p.stock}</td>
                                    <td>
                                        <button class="btn btn-primary btn-sm" onclick="confirmSelectComponent('${componentType}', ${p.product_id}, '${p.name}', ${p.price})">Chọn</button>
                                    </td>
                                </tr>
                            `;
                        });
                        html += `</tbody></table>`;
                        document.getElementById('productSelectModalBody').innerHTML = html;
                        // Hiện modal
                        const modal = new bootstrap.Modal(document.getElementById('productSelectModal'));
                        modal.show();

                        // Thêm filter search
                        document.getElementById('searchInput').addEventListener('input', filterTable);
                        document.getElementById('brandFilter').addEventListener('change', filterTable);
                        document.getElementById('seriesFilter').addEventListener('change', filterTable);
                        function filterTable() {
                            const search = document.getElementById('searchInput').value.toLowerCase();
                            const brand = document.getElementById('brandFilter').value;
                            const series = document.getElementById('seriesFilter').value;
                            document.querySelectorAll('#productTable tbody tr').forEach(row => {
                                const cells = row.children;
                                const matchSearch = cells[0].textContent.toLowerCase().includes(search);
                                const matchBrand = !brand || cells[1].textContent === brand;
                                const matchSeries = !series || cells[2].textContent === series;
                                row.style.display = (matchSearch && matchBrand && matchSeries) ? '' : 'none';
                            });
                        }

                        // Sau khi fetch xong products:
                        const brands = [...new Set(products.map(p => p.brandName))].filter(Boolean);
                        const series = [...new Set(products.map(p => p.seriesName))].filter(Boolean);
                        const brandFilter = document.getElementById('brandFilter');
                        const seriesFilter = document.getElementById('seriesFilter');
                        if (brandFilter) brandFilter.innerHTML = '<option value="">Tất cả Brand</option>' + brands.map(b => `<option value="${b}">${b}</option>`).join('');
                        if (seriesFilter) seriesFilter.innerHTML = '<option value="">Tất cả Series</option>' + series.map(s => `<option value="${s}">${s}</option>`).join('');
                    })
                    .catch(error => {
                        document.getElementById('productSelectModalBody').innerHTML = '<p>Lỗi khi tải sản phẩm.</p>';
                        const modal = new bootstrap.Modal(document.getElementById('productSelectModal'));
                        modal.show();
                    });
            }
            
            // Function to update progress bar
            function updateProgressBar() {
                const components = ['cpu', 'mainboard', 'ram', 'gpu', 'storage', 'psu', 'case', 'cooler'];
                let selectedCount = 0;
                
                components.forEach(component => {
                    const selected = sessionStorage.getItem(`selected_${component}`);
                    if (selected) {
                        selectedCount++;
                    }
                });
                
                const progressPercentage = (selectedCount / components.length) * 100;
                const progressBar = document.getElementById('build-progress-bar');
                if (progressBar) {
                    progressBar.style.width = progressPercentage + '%';
                    progressBar.setAttribute('aria-valuenow', progressPercentage);
                }
            }
            
            // Function to show notifications
            function showNotification(message, type = 'info') {
                const notification = document.createElement('div');
                notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
                notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
                notification.innerHTML = `
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                `;
                document.body.appendChild(notification);
                
                // Auto remove after 3 seconds
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.remove();
                    }
                }, 3000);
            }
            
            // Hàm xác nhận chọn linh kiện trong modal
            function confirmSelectComponent(componentType, productId, productName, price) {
                // Đóng modal
                const modal = bootstrap.Modal.getInstance(document.getElementById('productSelectModal'));
                if (modal) modal.hide();
                // Cập nhật cấu hình như cũ
                const stepElement = document.getElementById(`step-${componentType.toLowerCase()}`);
                const selectedElement = document.getElementById(`selected-${componentType.toLowerCase()}`);
                if (stepElement && selectedElement) {
                    stepElement.classList.add('selected');
                    selectedElement.textContent = productName;
                    selectedElement.style.color = '#28a745';
                }
                updateProgressBar();
                const selection = {
                    productId: productId,
                    productName: productName,
                    price: price,
                    componentType: componentType
                };
                sessionStorage.setItem(`selected_${componentType}`, JSON.stringify(selection));
                showNotification(`Đã chọn ${componentType.toUpperCase()}: ${productName}`, 'success');
            }
            
            // Load saved selections on page load
            window.addEventListener('load', function() {
                updateProgressBar();
            });

            // Gắn sự kiện cho các nút chọn linh kiện để mở modal chứa viewProduct.jsp
            window.addEventListener('DOMContentLoaded', function() {
                document.querySelectorAll('.btn.btn-pcbuilder-white.btn-lg').forEach(btn => {
                    btn.addEventListener('click', function(e) {
                        e.preventDefault();
                        const modal = new bootstrap.Modal(document.getElementById('viewProductModal'));
                        modal.show();
                    });
                });
            });

            // Hàm đóng modal sản phẩm
            function closeProductModal() {
                const modal = bootstrap.Modal.getInstance(document.getElementById('viewProductModal'));
                if (modal) modal.hide();
            }

            // Hàm quay lại bước trước đó trong iframe
            function backProductModal() {
                const iframe = document.getElementById('viewProductIframe');
                try {
                    // Thử gọi history.back() trong iframe
                    iframe.contentWindow.history.back();
                } catch (e) {
                    // Nếu không thể truy cập iframe (CORS), reload về trang đầu
                    iframe.src = 'productservlet?service=viewProduct';
                }
            }

            // Hàm tiến tới (reload iframe)
            function forwardProductModal() {
                const iframe = document.getElementById('viewProductIframe');
                iframe.src = iframe.src;
            }

            // Hàm reset (về trang đầu)
            function resetProductModal() {
                const iframe = document.getElementById('viewProductIframe');
                iframe.src = 'productservlet?service=viewProduct';
            }
        //]]>
        </script>
        <!-- Modal popup viewProduct -->
        <div class="modal fade" id="viewProductModal" tabindex="-1" aria-labelledby="viewProductModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="d-flex align-items-center">
                            <button type="button" class="btn-back" onclick="backProductModal()" aria-label="Quay lại"></button>
                            <button type="button" class="btn-forward" onclick="forwardProductModal()" aria-label="Tiến tới"></button>
                            <button type="button" class="btn-reset" onclick="resetProductModal()" aria-label="Làm mới"></button>
                        </div>
                        <h5 class="modal-title" id="viewProductModalLabel">Select Components</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body p-0" style="height:80vh;">
                        <iframe id="viewProductIframe" src="productservlet?service=viewProduct" style="width:100%;height:100%;border:none;"></iframe>
                    </div>
                </div>
            </div>
        </div>
        
    </body>
</html> 