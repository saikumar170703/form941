<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="en_US" />
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - E-File Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/style.css?v=2" rel="stylesheet">
</head>

<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

        <!-- Main Content Wrapper -->
        <div class="main-wrapper bg-light">
            <!-- Header -->
            <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

            <!-- Dashboard Content Area -->
            <div class="content-area">

                <!-- Stat Cards Row -->
                <div class="row g-3 g-md-4 mb-4">
                    <!-- Stat Card 1: Total Filings -->
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card glass-panel h-100">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <div class="d-flex gap-3 align-items-center">
                                    <div class="stat-icon-wrapper stat-icon-blue">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                            <polyline points="14 2 14 8 20 8"></polyline>
                                            <line x1="16" y1="13" x2="8" y2="13"></line>
                                            <line x1="16" y1="17" x2="8" y2="17"></line>
                                        </svg>
                                    </div>
                                    <div>
                                        <div class="stat-label">Total Filings</div>
                                        <div class="stat-value">
                                            <c:out value="${totalFilingsCount != null ? totalFilingsCount : 0}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between align-items-end mt-2">
                                <span class="stat-bottom-text">All time filings</span>
                            </div>
                        </div>
                    </div>

                    <!-- Stat Card 2: In Progress -->
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card glass-panel h-100">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <div class="d-flex gap-3 align-items-center">
                                    <div class="stat-icon-wrapper stat-icon-green">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 16 14"></polyline>
                                        </svg>
                                    </div>
                                    <div>
                                        <div class="stat-label">In Progress</div>
                                        <div class="stat-value">
                                            <c:out value="${inProgressCount != null ? inProgressCount : 0}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between align-items-end mt-2">
                                <span class="stat-bottom-text">Draft filings</span>
                            </div>
                        </div>
                    </div>

                    <!-- Stat Card 3: Businesses -->
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card glass-panel h-100">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <div class="d-flex gap-3 align-items-center">
                                    <div class="stat-icon-wrapper stat-icon-orange">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="9" cy="7" r="4"></circle>
                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <div class="stat-label">Businesses</div>
                                        <div class="stat-value">
                                            <c:out value="${employersCount != null ? employersCount : 0}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between align-items-end mt-2">
                                <span class="stat-bottom-text">Registered</span>
                            </div>
                        </div>
                    </div>

                    <!-- Stat Card 4: Completed -->
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="stat-card glass-panel h-100">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <div class="d-flex gap-3 align-items-center">
                                    <div class="stat-icon-wrapper stat-icon-purple">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                        </svg>
                                    </div>
                                    <div>
                                        <div class="stat-label">Completed</div>
                                        <div class="stat-value">
                                            <c:out value="${completedCount != null ? completedCount : 0}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between align-items-end mt-2">
                                <span class="stat-bottom-text">Filed successfully</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Filings Card -->
                <div class="table-card glass-panel">
                    <div class="table-card-header">
                        <div class="d-flex align-items-center">
                            <div class="table-icon">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                </svg>
                            </div>
                            <div>
                                <h5 class="m-0 fw-bold" style="color: var(--text-dark);">Recent Filings</h5>
                                <small class="text-muted">Showing 5 filings per page</small>
                            </div>
                        </div>
                        <a href="<%= request.getContextPath() %>/form941/new"
                            class="btn btn-outline-primary btn-sm px-3 py-2 d-flex align-items-center gap-2 rounded-pill ms-auto ms-sm-0">
                            Start New Filing
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table mb-0 align-middle" id="recentFilingsTable">
                            <thead>
                                <tr>
                                    <th style="padding-left: 1.5rem;">Filing ID</th>
                                    <th>Business Name</th>
                                    <th>Tax Year</th>
                                    <th>Quarter</th>
                                    <th>Status</th>
                                    <th class="text-end" style="padding-right: 1.5rem;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty recentFilings}">
                                        <c:forEach var="filing" items="${recentFilings}">
                                            <tr>
                                                <td style="padding-left: 1.5rem;" class="fw-bold">#${filing.returnId}</td>
                                                <c:set var="emp" value="${employerMap[filing.employerId]}" />
                                                <td class="text-primary fw-semibold">${emp != null ? emp.businessName : 'Employer #'.concat(filing.employerId)}</td>
                                                <td>${filing.taxYear}</td>
                                                <td>Q${filing.quarter}</td>
                                                <td>
                                                    <span class="badge ${filing.status == 'SUBMITTED' ? 'badge-submitted' : 'badge-draft'} rounded-pill px-3 py-2">
                                                        <c:out value="${filing.status != null ? filing.status : 'DRAFT'}" />
                                                    </span>
                                                </td>
                                                <td class="text-end" style="padding-right: 1.5rem;">
                                                    <a href="<%= request.getContextPath() %>/form941/resume?id=${filing.returnId}" class="btn btn-outline-primary btn-sm px-3 rounded-pill">
                                                        <c:out value="${filing.status == 'SUBMITTED' ? 'View' : 'Resume'}" />
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">No recent filings found. Click "Start New Filing" to begin.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <div class="p-3 border-top d-flex justify-content-between align-items-center bg-white rounded-bottom flex-wrap gap-2">
                        <small class="text-muted" id="recentFilingsPageInfo">Showing entries</small>
                        <nav>
                            <ul class="pagination pagination-sm m-0" id="recentFilingsPagination"></ul>
                        </nav>
                    </div>
                </div>

                <!-- My Business Card -->
                <div class="table-card glass-panel">
                    <div class="table-card-header">
                        <div class="d-flex align-items-center">
                            <div class="table-icon">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M3 21h18"></path>
                                    <path d="M9 21V9h6v12"></path>
                                </svg>
                            </div>
                            <div>
                                <h5 class="m-0 fw-bold" style="color: var(--text-dark);">My Business</h5>
                                <small class="text-muted">Showing 5 Business per page</small>
                            </div>
                        </div>
                        <a href="<%= request.getContextPath() %>/employer/edit"
                            class="btn btn-primary btn-sm px-3 py-2 d-flex align-items-center gap-2 rounded-pill ms-auto ms-sm-0"
                            style="background-color: #2563EB; border: none;">
                            Add New Business
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table mb-0 align-middle" id="employersTable">
                            <thead>
                                <tr>
                                    <th style="padding-left: 1.5rem;">Name</th>
                                    <th>EIN</th>
                                    <th>Location</th>
                                    <th class="text-end" style="padding-right: 1.5rem;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty employers}">
                                        <c:forEach var="emp" items="${employers}">
                                            <tr>
                                                <td style="padding-left: 1.5rem;" class="fw-bold text-dark">${emp.businessName}</td>
                                                <td><code class="text-dark bg-light px-2 py-1 rounded">${emp.ein}</code></td>
                                                <td>${emp.city != null ? emp.city : ''}${emp.state != null ? ', '.concat(emp.state) : ''}</td>
                                                <td class="text-end" style="padding-right: 1.5rem;">
                                                    <a href="<%= request.getContextPath() %>/employer/edit?id=${emp.id}" class="action-link me-3">Edit</a>
                                                    <a href="<%= request.getContextPath() %>/employer/delete?id=${emp.id}" class="text-danger action-link" onclick="return confirm('Are you sure you want to delete this business?')">Delete</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="text-center text-muted py-4">No businesses found. Click "Add New Business" to register one.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <div class="p-3 border-top d-flex justify-content-between align-items-center bg-white rounded-bottom flex-wrap gap-2">
                        <small class="text-muted" id="employersPageInfo">Showing entries</small>
                        <nav>
                            <ul class="pagination pagination-sm m-0" id="employersPagination"></ul>
                        </nav>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function setupPagination(tableId, pageInfoId, paginationId, rowsPerPage = 5) {
            const table = document.getElementById(tableId);
            if (!table) return;
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr')).filter(tr => !tr.querySelector('td[colspan]'));
            
            if (rows.length === 0) return;

            let currentPage = 1;
            const totalPages = Math.ceil(rows.length / rowsPerPage);

            function showPage(page) {
                currentPage = page;
                const start = (page - 1) * rowsPerPage;
                const end = start + rowsPerPage;

                rows.forEach((row, index) => {
                    if (index >= start && index < end) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });

                const pageInfo = document.getElementById(pageInfoId);
                if (pageInfo) {
                    pageInfo.textContent = 'Showing ' + (start + 1) + ' to ' + Math.min(end, rows.length) + ' of ' + rows.length + ' entries';
                }

                renderPagination();
            }

            function renderPagination() {
                const pagination = document.getElementById(paginationId);
                if (!pagination) return;
                pagination.innerHTML = '';

                if (totalPages <= 1) return;

                const prevLi = document.createElement('li');
                prevLi.className = 'page-item ' + (currentPage === 1 ? 'disabled' : '');
                prevLi.innerHTML = '<a class="page-link" href="#">Prev</a>';
                prevLi.addEventListener('click', (e) => {
                    e.preventDefault();
                    if (currentPage > 1) showPage(currentPage - 1);
                });
                pagination.appendChild(prevLi);

                for (let i = 1; i <= totalPages; i++) {
                    const li = document.createElement('li');
                    li.className = 'page-item ' + (i === currentPage ? 'active' : '');
                    li.innerHTML = '<a class="page-link" href="#">' + i + '</a>';
                    li.addEventListener('click', (e) => {
                        e.preventDefault();
                        showPage(i);
                    });
                    pagination.appendChild(li);
                }

                const nextLi = document.createElement('li');
                nextLi.className = 'page-item ' + (currentPage === totalPages ? 'disabled' : '');
                nextLi.innerHTML = '<a class="page-link" href="#">Next</a>';
                nextLi.addEventListener('click', (e) => {
                    e.preventDefault();
                    if (currentPage < totalPages) showPage(currentPage + 1);
                });
                pagination.appendChild(nextLi);
            }

            showPage(1);
        }

        document.addEventListener('DOMContentLoaded', function() {
            setupPagination('recentFilingsTable', 'recentFilingsPageInfo', 'recentFilingsPagination', 5);
            setupPagination('employersTable', 'employersPageInfo', 'employersPagination', 5);
        });
    </script>
</body>

</html>