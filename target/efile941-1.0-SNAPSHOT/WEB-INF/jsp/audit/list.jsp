<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Audit Logs - IRS eFile Portal</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand font-bold" href="${pageContext.request.contextPath}/dashboard">IRS eFile Portal</a>
    <div class="collapse navbar-collapse">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/form941/new">New 941 Return</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/form941x/list">Form 941-X (Amended)</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/payments/list">Payments</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/filings">Filing History</a></li>
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/audit/list">Audit Logs</a></li>
      </ul>
      <span class="navbar-text text-white me-3">Welcome, ${sessionScope.userFirstName}</span>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
  </div>
</nav>

<div class="container py-4">
    <div class="mb-4">
        <h2 class="h3 font-bold text-dark mb-1">System Audit Trail</h2>
        <p class="text-muted">Immutable audit logs captured by PostgreSQL triggers and application events</p>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>Audit ID</th>
                            <th>Action</th>
                            <th>Target Module</th>
                            <th>Record ID</th>
                            <th>Performed By</th>
                            <th>Details</th>
                            <th>Timestamp</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty logs}">
                                <c:forEach var="log" items="${logs}">
                                    <tr>
                                        <td>#${log.id}</td>
                                        <td><span class="badge bg-secondary">${log.action}</span></td>
                                        <td><code>${log.entityName}</code></td>
                                        <td>${log.entityId}</td>
                                        <td>${log.performedBy}</td>
                                        <td>${log.details}</td>
                                        <td class="small text-muted">${log.timestamp}</td>
                                    </tr>
                                </c:forEach>
                            </c:cWhen>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">
                                        No audit log entries recorded yet.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

</body>
</html>
