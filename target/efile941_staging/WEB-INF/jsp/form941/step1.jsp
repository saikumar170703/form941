<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form 941 - Step 1: Return Information</title>
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
            <% request.setAttribute("pageTitle", "Form 941 - Step 1: Return Information" ); %>
            <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

            <!-- Wizard Content -->
            <div class="content-area">
                <div class="tm-card p-3 p-md-4 rounded-4 bg-white shadow-sm">
                    <% request.setAttribute("currentStep", 1); %>
                    <jsp:include page="/WEB-INF/jsp/layout/progress.jsp" />

                    <!-- Read-Only Banner for Submitted Returns -->
                    <c:if test="${formDTO.status == 'SUBMITTED'}">
                        <div class="alert alert-info border-info border-2 rounded-3 shadow-sm mb-4">
                            <div class="d-flex align-items-center">
                                <span class="fs-4 me-2">🔒</span>
                                <div>
                                    <h6 class="fw-bold m-0">Submitted Return #${formDTO.form941Id} (Read-Only Mode)</h6>
                                    <small>This return has already been submitted to the IRS and cannot be edited.</small>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <h4 class="fw-bold mb-4" style="color: var(--primary-blue);">Return Information</h4>

                    <form action="<%= request.getContextPath() %>/form941/step2" method="POST">
                        <div class="row g-3 mb-3">
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-bold">Select Business <span class="text-danger">*</span></label>
                                <select class="form-select" name="employerId" required onchange="handleEmployerSelect(this)" ${formDTO.status == 'SUBMITTED' ? 'disabled' : ''}>
                                    <option value="" disabled ${empty formDTO.employerId ? 'selected' : ''}>Business</option>
                                    <c:forEach var="entry" items="${employers}">
                                        <option value="${entry.key}" ${formDTO.employerId == entry.key ? 'selected' : ''}>${entry.value}</option>
                                    </c:forEach>
                                    <c:if test="${formDTO.status != 'SUBMITTED'}">
                                        <option value="ADD_NEW" style="font-weight: bold; color: #2563EB;">➕ Add New Business</option>
                                    </c:if>
                                </select>
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-bold">Tax Year <span class="text-danger">*</span></label>
                                <select class="form-select" name="taxYear" required ${formDTO.status == 'SUBMITTED' ? 'disabled' : ''}>
                                    <option value="" disabled ${empty formDTO.taxYear ? 'selected' : ''}>Select Tax Year</option>
                                    <c:forEach var="year" items="${taxYears}">
                                        <option value="${year}" ${formDTO.taxYear == year || (empty formDTO.taxYear && year == 2026) ? 'selected' : ''}>${year}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-12 col-md-6">
                                <label class="form-label fw-bold">Quarter <span class="text-danger">*</span></label>
                                <select class="form-select" name="quarter" required ${formDTO.status == 'SUBMITTED' ? 'disabled' : ''}>
                                    <option value="" disabled ${empty formDTO.quarter ? 'selected' : ''}>Select Quarter</option>
                                    <c:forEach var="q" items="${quarters}">
                                        <option value="${q.key}" ${formDTO.quarter == q.key ? 'selected' : ''}>${q.value}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <hr class="my-4">

                        <div class="d-flex justify-content-between flex-wrap gap-2">
                            <a href="<%= request.getContextPath() %>/filings" class="btn btn-outline-secondary px-4">Back to Filings</a>
                            <c:choose>
                                <c:when test="${formDTO.status == 'SUBMITTED'}">
                                    <a href="<%= request.getContextPath() %>/form941/step2" class="btn btn-primary px-5">View Step 2 &raquo;</a>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" class="btn btn-proceed px-5">Proceed</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function handleEmployerSelect(selectEl) {
            if (selectEl.value === 'ADD_NEW') {
                window.location.href = '<%= request.getContextPath() %>/employer/edit';
            }
        }
    </script>
</body>
</html>