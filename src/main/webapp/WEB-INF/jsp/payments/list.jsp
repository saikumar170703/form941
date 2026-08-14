<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tax Payments & Deposits - IRS eFile Portal</title>
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
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/payments/list">Payments & Deposits</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/filings">Filing History</a></li>
      </ul>
      <span class="navbar-text text-white me-3">Welcome, ${sessionScope.userFirstName}</span>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">Logout</a>
    </div>
  </div>
</nav>

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="h3 font-bold text-dark mb-1">Tax Payments & Deposits</h2>
            <p class="text-muted mb-0">Record federal tax deposits, balance due payments, and EFTPS traces</p>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#paymentModal">+ Record Payment</button>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>Payment ID</th>
                            <th>Form 941 ID</th>
                            <th>Payment Type</th>
                            <th>Method</th>
                            <th>Amount ($)</th>
                            <th>Reference / EFTPS Trace</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty payments}">
                                <c:forEach var="p" items="${payments}">
                                    <tr>
                                        <td><strong>PAY-#${p.payment_id}</strong></td>
                                        <td>Form 941 #${p.form_941_id}</td>
                                        <td><span class="badge bg-info text-dark">${p.payment_type}</span></td>
                                        <td>${p.payment_method}</td>
                                        <td class="font-bold text-success">$${p.amount}</td>
                                        <td><code>${p.transaction_reference}</code></td>
                                        <td>${p.payment_date}</td>
                                        <td><span class="badge bg-success">${p.status}</span></td>
                                    </tr>
                                </c:forEach>
                            </c:cWhen>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="text-center py-4 text-muted">
                                        No payments recorded yet. Click <strong>+ Record Payment</strong> above to add an EFTPS or Direct Pay entry.
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

<!-- Modal -->
<div class="modal fade" id="paymentModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/payments/record" method="POST">
        <div class="modal-header bg-dark text-white">
          <h5 class="modal-title font-bold">Record Federal Tax Payment</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label font-medium">Payment Type</label>
            <select name="paymentType" class="form-select" required>
              <option value="FEDERAL_TAX_DEPOSIT">FEDERAL_TAX_DEPOSIT</option>
              <option value="BALANCE_DUE">BALANCE_DUE</option>
              <option value="OTHER">OTHER</option>
            </select>
          </div>
          <div class="mb-3">
            <label class="form-label font-medium">Payment Method</label>
            <select name="paymentMethod" class="form-select" required>
              <option value="EFTPS">EFTPS (Electronic Federal Tax Payment System)</option>
              <option value="IRS_DIRECT_PAY">IRS Direct Pay</option>
              <option value="ACH">ACH Transfer</option>
              <option value="CHECK">Check / Money Order</option>
            </select>
          </div>
          <div class="mb-3">
            <label class="form-label font-medium">Payment Amount ($)</label>
            <input type="number" step="0.01" name="amount" class="form-control" placeholder="0.00" required>
          </div>
          <div class="mb-3">
            <label class="form-label font-medium">EFTPS Trace / Transaction Reference</label>
            <input type="text" name="refNumber" class="form-control" placeholder="e.g. EFTPS-84920491" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary font-bold">Submit Payment</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
