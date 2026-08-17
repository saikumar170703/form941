<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="en_US" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Filings - Form 941 E-File Portal</title>
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
            <% request.setAttribute("pageTitle", "My Filings"); %>
            <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
            
            <!-- Content -->
            <div class="content-area">
                
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold m-0" style="color: var(--text-dark);">My Filings</h3>
                        <p class="text-muted mb-0">View all draft and submitted Form 941 quarterly filings.</p>
                    </div>
                    <a href="<%= request.getContextPath() %>/form941/new" class="btn btn-primary px-4 rounded-3" style="background-color: #2563EB; border: none;">+ Start New Return</a>
                </div>

                <div class="tm-card glass-panel p-4 rounded-4 bg-white shadow-sm">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0" id="returnHistoryTable">
                            <thead class="table-light">
                                <tr>
                                    <th>Return ID</th>
                                    <th>Business / EIN</th>
                                    <th>Tax Period</th>
                                    <th>Total Tax Liability</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${filings}" var="filing">
                                    <c:set var="emp" value="${employerMap[filing.employerId]}" />
                                    <tr>
                                        <td><span class="fw-bold text-dark">#${filing.form941Id}</span></td>
                                        <td>
                                            <div class="fw-bold text-dark">${emp != null ? emp.businessName : 'Employer #'.concat(filing.employerId)}</div>
                                            <div class="text-muted small">EIN: ${emp != null ? emp.ein : '12-3456789'}</div>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark border">Q${filing.quarter} ${filing.taxYear}</span>
                                        </td>
                                        <td class="fw-bold">$<fmt:formatNumber value="${filing.getLineValue('12') != null ? filing.getLineValue('12') : (filing.getLineValue('6') != null ? filing.getLineValue('6') : 0)}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${filing.status == 'SUBMITTED'}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill">Submitted</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle px-3 py-2 rounded-pill">Draft</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                          <td class="text-end">
                                              <c:choose>
                                                  <c:when test="${filing.status == 'DRAFT'}">
                                                      <a href="<%= request.getContextPath() %>/form941/exportXml?id=${filing.form941Id}" class="btn btn-sm btn-outline-secondary rounded-pill px-2 me-1" title="Preview IRS XML">XML 📄</a>
                                                      <a href="<%= request.getContextPath() %>/form941/exportMefPackage?id=${filing.form941Id}" class="btn btn-sm btn-outline-dark rounded-pill px-2 me-1" title="Download MeF ZIP Package">ZIP 📦</a>
                                                      <a href="<%= request.getContextPath() %>/form941/resume?id=${filing.form941Id}" class="btn btn-sm btn-primary rounded-pill px-3">Resume Draft &raquo;</a>
                                                  </c:when>
                                                  <c:otherwise>
                                                      <a href="<%= request.getContextPath() %>/form941/exportXml?id=${filing.form941Id}" class="btn btn-sm btn-outline-success rounded-pill px-2 me-1" title="Download IRS MeF XML">XML 💾</a>
                                                      <a href="<%= request.getContextPath() %>/form941/exportMefPackage?id=${filing.form941Id}" class="btn btn-sm btn-outline-primary rounded-pill px-2 me-1" title="Download MeF ZIP Package">ZIP 📦</a>
                                                      <a href="<%= request.getContextPath() %>/form941/resume?id=${filing.form941Id}" class="btn btn-sm btn-outline-secondary rounded-pill px-3">View Return</a>
                                                  </c:otherwise>
                                              </c:choose>
                                          </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty filings}">
                                    <tr>
                                        <td colspan="6" class="text-center py-5">
                                            <div class="text-muted mb-3">
                                                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                                    <polyline points="14 2 14 8 20 8"></polyline>
                                                </svg>
                                            </div>
                                            <h6 class="fw-bold text-dark">No Filings Found</h6>
                                            <p class="text-muted small mb-3">You haven't created any Form 941 quarterly filings yet.</p>
                                            <a href="<%= request.getContextPath() %>/form941/new" class="btn btn-sm btn-outline-primary">Create First Filing</a>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    <div class="p-3 border-top d-flex justify-content-between align-items-center bg-white rounded-bottom mt-2">
                        <small class="text-muted" id="historyPageInfo">Showing entries</small>
                        <nav><ul class="pagination pagination-sm m-0" id="historyPagination"></ul></nav>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            if (typeof setupTablePagination === 'function') {
                setupTablePagination('returnHistoryTable', 'historyPageInfo', 'historyPagination', 10);
            }
        });
    </script>

</body>
</html>

