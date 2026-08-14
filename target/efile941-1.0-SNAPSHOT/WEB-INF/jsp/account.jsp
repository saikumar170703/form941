<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Account Settings - Form 941 E-File Portal</title>
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
            <% request.setAttribute("pageTitle", "My Account Settings"); %>
            <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

            <!-- Content Area -->
            <div class="content-area">
                
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h3 class="fw-bold m-0" style="color: var(--text-dark);">My Account Profile</h3>
                        <p class="text-muted m-0">Manage your basic profile information, email address, and security password.</p>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Left Column: Basic Information -->
                    <div class="col-lg-7">
                        <div class="tm-card glass-panel p-4 rounded-4 bg-white shadow-sm h-100">
                            <div class="d-flex align-items-center gap-3 mb-4">
                                <div style="background: rgba(37,99,235,0.1); width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #2563EB;">
                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                </div>
                                <div>
                                    <h5 class="fw-bold m-0" style="color: var(--primary-blue);">Basic Information</h5>
                                    <small class="text-muted">Your personal & company contact details fetched directly from database</small>
                                </div>
                            </div>

                            <c:if test="${not empty profileSuccess}">
                                <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm mb-4" role="alert">
                                    <strong>✓ Success:</strong> ${profileSuccess}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>

                            <c:if test="${not empty profileErrors}">
                                <div class="alert alert-danger rounded-3 shadow-sm mb-4" role="alert">
                                    <h6 class="fw-bold mb-2">Validation Errors:</h6>
                                    <ul class="mb-0 ps-3 small">
                                        <c:forEach var="err" items="${profileErrors}">
                                            <li>${err.errorMessage}</li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </c:if>

                            <form action="<%= request.getContextPath() %>/account/update-profile" method="POST">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">First Name</label>
                                        <input type="text" class="form-control" name="firstName" value="${user.firstName}" placeholder="Enter First Name">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Last Name</label>
                                        <input type="text" class="form-control" name="lastName" value="${user.lastName}" placeholder="Enter Last Name">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-12">
                                        <label class="form-label fw-bold">Company / Organization</label>
                                        <input type="text" class="form-control" name="company" value="${user.company}" placeholder="Enter Company Name">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Phone Number</label>
                                        <input type="text" class="form-control" name="phoneNumber" id="accountPhoneNumber" value="${user.phoneNumber}" placeholder="(111) 111-1111" maxlength="14">
                                        <div class="form-text">Format: 10-digit US phone (e.g. (111) 111-1111)</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Email Address <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" name="email" value="${user.email}" placeholder="user@domain.com" required pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$">
                                        <div class="form-text">Format: valid email address (e.g. user@domain.com)</div>
                                    </div>
                                </div>

                                <hr class="my-4">

                                <div class="text-end">
                                    <button type="submit" class="btn btn-primary px-4 rounded-pill" style="background-color: #2563EB; border: none;">Save Basic Information</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Right Column: Security (Change Email & Change Password) -->
                    <div class="col-lg-5">
                        <!-- Change Email Card -->
                        <div class="tm-card glass-panel p-4 rounded-4 bg-white shadow-sm mb-4">
                            <div class="d-flex align-items-center gap-3 mb-3">
                                <div style="background: rgba(16,185,129,0.1); width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #10B981;">
                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                        <polyline points="22,6 12,13 2,6"></polyline>
                                    </svg>
                                </div>
                                <div>
                                    <h5 class="fw-bold m-0" style="color: var(--text-dark);">Change Email</h5>
                                    <small class="text-muted">Update your login email address</small>
                                </div>
                            </div>

                            <c:if test="${not empty emailSuccess}">
                                <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-3" role="alert">
                                    ✓ ${emailSuccess}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty emailErrors}">
                                <div class="alert alert-danger rounded-3 small mb-3" role="alert">
                                    <c:forEach var="err" items="${emailErrors}"><div>${err.errorMessage}</div></c:forEach>
                                </div>
                            </c:if>

                            <form action="<%= request.getContextPath() %>/account/change-email" method="POST" autocomplete="off">
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">New Email Address</label>
                                    <input type="email" class="form-control form-control-sm" name="newEmail" placeholder="Enter new email address" required pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" autocomplete="off" value="">
                                    <div class="form-text">Format: valid email (e.g. user@domain.com)</div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Confirm with Current Password</label>
                                    <input type="password" class="form-control form-control-sm" name="currentPassword" placeholder="Enter current password" required autocomplete="new-password" value="">
                                </div>
                                <button type="submit" class="btn btn-outline-success btn-sm w-100 rounded-pill">Update Email Address</button>
                            </form>
                        </div>

                        <!-- Change Password Card -->
                        <div class="tm-card glass-panel p-4 rounded-4 bg-white shadow-sm">
                            <div class="d-flex align-items-center gap-3 mb-3">
                                <div style="background: rgba(245,158,11,0.1); width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #F59E0B;">
                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    </svg>
                                </div>
                                <div>
                                    <h5 class="fw-bold m-0" style="color: var(--text-dark);">Change Password</h5>
                                    <small class="text-muted">Ensure your account security</small>
                                </div>
                            </div>

                            <c:if test="${not empty passwordSuccess}">
                                <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-3" role="alert">
                                    ✓ ${passwordSuccess}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty passwordErrors}">
                                <div class="alert alert-danger rounded-3 small mb-3" role="alert">
                                    <c:forEach var="err" items="${passwordErrors}"><div>${err.errorMessage}</div></c:forEach>
                                </div>
                            </c:if>

                            <form action="<%= request.getContextPath() %>/account/change-password" method="POST" autocomplete="off">
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Current Password</label>
                                    <input type="password" class="form-control form-control-sm" name="currentPassword" placeholder="Enter current password" required autocomplete="new-password" value="">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">New Password</label>
                                    <input type="password" class="form-control form-control-sm" name="newPassword" placeholder="Min. 8 chars (1 upper, 1 lower, 1 number)" required minlength="8" pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$" autocomplete="new-password" value="">
                                    <div class="form-text">Min 8 chars, 1 uppercase, 1 lowercase & 1 number</div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Confirm New Password</label>
                                    <input type="password" class="form-control form-control-sm" name="confirmPassword" placeholder="Re-type new password" required minlength="8" autocomplete="new-password" value="">
                                </div>
                                <button type="submit" class="btn btn-warning text-white btn-sm w-100 rounded-pill" style="background-color: #F59E0B; border: none;">Update Password</button>
                            </form>


                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<%= request.getContextPath() %>/js/app.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var phoneEl = document.getElementById('accountPhoneNumber');
            if (phoneEl) {
                phoneEl.addEventListener('input', function (e) {
                    var digits = e.target.value.replace(/\D/g, '').substring(0, 10);
                    if (digits.length === 0) {
                        e.target.value = '';
                    } else if (digits.length <= 3) {
                        e.target.value = '(' + digits;
                    } else if (digits.length <= 6) {
                        e.target.value = '(' + digits.substring(0, 3) + ') ' + digits.substring(3);
                    } else {
                        e.target.value = '(' + digits.substring(0, 3) + ') ' + digits.substring(3, 6) + '-' + digits.substring(6);
                    }
                });
                if (phoneEl.value) {
                    var digits = phoneEl.value.replace(/\D/g, '').substring(0, 10);
                    if (digits.length === 10) {
                        phoneEl.value = '(' + digits.substring(0, 3) + ') ' + digits.substring(3, 6) + '-' + digits.substring(6);
                    }
                }
            }
        });
    </script>
</body>
</html>
