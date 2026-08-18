<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Business Account - Form 941 E-File Portal</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/style.css?v=5" rel="stylesheet">
</head>
<body>
    <div class="container-fluid p-0 login-container">
        <div class="row g-0 h-100">
            
            <!-- Left Side Branding Hero Section -->
            <div class="col-lg-6 login-left-hero d-none d-lg-flex">
                <div class="d-flex align-items-center gap-3">
                    <div style="background: rgba(255,255,255,0.15); width: 40px; height: 40px; border-radius: 10px; display: flex; align-items: center; justify-content: center; backdrop-filter: blur(10px);">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 2H6C4.89543 2 4 2.89543 4 4V20C4 21.1046 4.89543 22 6 22H18C19.1046 22 20 21.1046 20 20V8L14 2Z" />
                            <path d="M14 2V8H20" />
                            <path d="M16 13H8" />
                            <path d="M16 17H8" />
                        </svg>
                    </div>
                    <div>
                        <h5 class="m-0 fw-bold text-white">e-File941</h5>
                        <span class="badge bg-white-10 text-white-50 small font-monospace" style="background: rgba(255,255,255,0.15); font-size: 0.7rem;">IRS Authorized E-File Provider</span>
                    </div>
                </div>

                <div class="my-auto py-2" style="max-width: 480px; z-index: 2;">
                    <span class="badge bg-primary-subtle text-primary-emphasis rounded-pill px-3 py-1.5 fw-semibold mb-2" style="background: rgba(99, 102, 241, 0.25) !important; color: #A5B4FC !important; font-size: 0.75rem;">
                        🏢 Business E-Filing Account
                    </span>
                    <h2 class="fw-extrabold text-white mb-2" style="letter-spacing: -0.02em; line-height: 1.2; font-size: 1.85rem;">
                        Start Filing Form 941 Electronically Today
                    </h2>
                    <p class="small text-white-50 mb-3" style="line-height: 1.5;">
                        Create your account to file quarterly Form 941 payroll tax returns, compute tax liabilities, manage multiple employers, and submit directly to the IRS.
                    </p>

                    <div class="login-feature-card">
                        <div style="background: rgba(99, 102, 241, 0.2); width: 34px; height: 34px; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#A5B4FC" stroke-width="2">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                        </div>
                        <div>
                            <h6 class="m-0 fw-bold text-white" style="font-size: 0.85rem;">Instant Account Setup</h6>
                            <small class="text-white-50" style="font-size: 0.75rem;">Get started in less than 2 minutes with automated validation</small>
                        </div>
                    </div>

                    <div class="login-feature-card">
                        <div style="background: rgba(16, 185, 129, 0.2); width: 34px; height: 34px; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#6EE7B7" stroke-width="2">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                            </svg>
                        </div>
                        <div>
                            <h6 class="m-0 fw-bold text-white" style="font-size: 0.85rem;">256-Bit Bank Grade Encryption</h6>
                            <small class="text-white-50" style="font-size: 0.75rem;">IRS Modernized e-File security standards & encrypted storage</small>
                        </div>
                    </div>
                </div>

                <div class="d-flex align-items-center justify-content-between text-white-50 small border-top pt-2" style="border-color: rgba(255,255,255,0.12) !important; font-size: 0.75rem;">
                    <span>© 2026 e-File941 Portal</span>
                    <span>IRS Security Compliant</span>
                </div>
            </div>

            <!-- Right Side Registration Form -->
            <div class="col-lg-6 login-right-form">
                <div class="register-box my-auto">
                    <div class="text-center mb-3">
                        <div class="d-inline-flex align-items-center justify-content-center mb-2 d-lg-none" style="background: #4F46E5; width: 42px; height: 42px; border-radius: 10px; color: white;">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M14 2H6C4.89543 2 4 2.89543 4 4V20C4 21.1046 4.89543 22 6 22H18C19.1046 22 20 21.1046 20 20V8L14 2Z" />
                            </svg>
                        </div>
                        <h4 class="fw-extrabold text-dark mb-1" style="font-size: 1.45rem;">Create Business Account</h4>
                        <p class="text-muted small m-0" style="font-size: 0.8rem;">Set up your credentials for Form 941 electronic filing</p>
                    </div>

                    <!-- Error Alert -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger d-flex align-items-center gap-2 py-2 px-3 mb-2.5 rounded-3 border-0 shadow-sm" role="alert" style="background-color: #FEF2F2; color: #991B1B; border-left: 4px solid #EF4444 !important; font-size: 0.8rem;">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" flex-shrink="0">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                            <span class="fw-semibold"><c:out value="${error}" /></span>
                        </div>
                    </c:if>

                    <form action="<%= request.getContextPath() %>/register" method="POST" id="registerForm" onsubmit="return validateRegistrationForm()">
                        <!-- Full Name -->
                        <div class="mb-2.5">
                            <label for="name" class="form-label fw-bold text-dark small mb-1">Full Name / Contact Person <span class="text-danger">*</span></label>
                            <div class="input-icon-group">
                                <span class="input-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                </span>
                                <input type="text" class="form-control py-2" id="name" name="name" placeholder="e.g. Jane Doe" required autofocus>
                            </div>
                        </div>

                        <!-- Business Name & EIN Row -->
                        <div class="row g-2 mb-2.5">
                            <div class="col-md-7">
                                <label for="businessName" class="form-label fw-bold text-dark small mb-1">Business Name</label>
                                <div class="input-icon-group">
                                    <span class="input-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M3 21h18M3 7v14M21 7v14M6 10h4M6 14h4M6 18h4M14 10h4M14 14h4M14 18h4M9 3h6v4H9z"></path>
                                        </svg>
                                    </span>
                                    <input type="text" class="form-control py-2" id="businessName" name="businessName" placeholder="Acme Enterprises LLC">
                                </div>
                            </div>
                            <div class="col-md-5">
                                <label for="ein" class="form-label fw-bold text-dark small mb-1">EIN</label>
                                <div class="input-icon-group">
                                    <span class="input-icon">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <rect x="2" y="4" width="20" height="16" rx="2"></rect>
                                            <path d="M7 15h4M15 15h2M7 11h2M13 11h4"></path>
                                        </svg>
                                    </span>
                                    <input type="text" class="form-control py-2 font-monospace" id="ein" name="ein" placeholder="12-3456789" maxlength="10" oninput="formatEinInput(this)">
                                </div>
                            </div>
                        </div>

                        <!-- Email / Username -->
                        <div class="mb-2.5">
                            <label for="email" class="form-label fw-bold text-dark small mb-1">Work Email (Username) <span class="text-danger">*</span></label>
                            <div class="input-icon-group">
                                <span class="input-icon">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                        <polyline points="22,6 12,13 2,6"></polyline>
                                    </svg>
                                </span>
                                <input type="email" class="form-control py-2" id="email" name="email" placeholder="name@company.com" required>
                            </div>
                        </div>

                        <!-- Password & Confirm Password Row -->
                        <div class="row g-2 mb-2.5">
                            <div class="col-md-6">
                                <label for="password" class="form-label fw-bold text-dark small mb-1">Password <span class="text-danger">*</span></label>
                                <div class="input-icon-group">
                                    <span class="input-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                    </span>
                                    <input type="password" class="form-control py-2" id="password" name="password" placeholder="••••••••" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="confirmPassword" class="form-label fw-bold text-dark small mb-1">Confirm Password <span class="text-danger">*</span></label>
                                <div class="input-icon-group">
                                    <span class="input-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                    </span>
                                    <input type="password" class="form-control py-2" id="confirmPassword" name="confirmPassword" placeholder="••••••••" required>
                                </div>
                            </div>
                        </div>

                        <!-- Terms Checkbox -->
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="termsCheck" required>
                            <label class="form-check-label text-muted small cursor-pointer" for="termsCheck" style="font-size: 0.78rem;">
                                I agree to the <a href="#" class="text-decoration-none" style="color: var(--primary-indigo);">Terms of Service</a> & <a href="#" class="text-decoration-none" style="color: var(--primary-indigo);">IRS E-File Privacy Policy</a>
                            </label>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 shadow-sm rounded-3 fw-bold" style="font-size: 0.95rem;">
                            Create Account & Continue &rarr;
                        </button>

                        <div class="text-center mt-2.5">
                            <p class="text-muted small m-0" style="font-size: 0.8rem;">
                                Already have an account? 
                                <a href="<%= request.getContextPath() %>/login" class="text-decoration-none fw-bold" style="color: var(--primary-indigo);">Sign In</a>
                            </p>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function formatEinInput(input) {
            let val = input.value.replace(/\D/g, '');
            if (val.length > 2) {
                input.value = val.substring(0, 2) + '-' + val.substring(2, 9);
            } else {
                input.value = val;
            }
        }

        function validateRegistrationForm() {
            const pass = document.getElementById('password').value;
            const confirmPass = document.getElementById('confirmPassword').value;

            if (pass !== confirmPass) {
                alert('Passwords do not match. Please re-enter passwords.');
                return false;
            }
            if (pass.length < 6) {
                alert('Password must be at least 6 characters long.');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
