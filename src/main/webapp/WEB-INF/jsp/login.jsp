<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Form 941 E-File Portal</title>
    <!-- Bootstrap 5 CSS & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="<%= request.getContextPath() %>/css/style.css?v=25" rel="stylesheet">

    <style>
        .form-field-wrapper {
            position: relative;
            margin-bottom: 14px;
        }
        .form-field-label {
            font-size: 0.82rem;
            font-weight: 700;
            color: #334155;
            margin-bottom: 4px;
            display: block;
        }
        .form-control-custom {
            border: 1px solid #CBD5E1;
            border-radius: 8px;
            padding: 9px 40px 9px 12px;
            font-size: 0.92rem;
            color: #0F172A;
            transition: all 0.2s ease;
        }
        .form-control-custom:focus {
            border-color: #90EE90;
            box-shadow: 0 0 0 3px rgba(144, 238, 144, 0.45);
            outline: none;
        }
        .input-right-icon {
            position: absolute;
            right: 12px;
            bottom: 11px;
            color: #667066;
            font-size: 0.9rem;
            pointer-events: none;
        }
        .input-right-icon.interactive {
            pointer-events: auto;
            cursor: pointer;
        }
        .btn-create-account {
            background-color: #90EE90;
            border: 1px solid #90EE90;
            color: #172017;
            font-weight: 700;
            font-size: 0.95rem;
            border-radius: 8px;
            padding: 10px;
            width: 100%;
            transition: all 0.2s ease;
            box-shadow: 0 2px 6px rgba(23, 32, 23, 0.06);
        }
        .btn-create-account:hover {
            background-color: #76E076;
            border-color: #76E076;
            color: #172017;
            transform: translateY(-1px);
        }
        .btn-google-signup {
            border: 1px solid #CBD5E1;
            background-color: #FFFFFF;
            color: #374151;
            font-weight: 600;
            font-size: 0.9rem;
            border-radius: 8px;
            padding: 9px;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.2s ease;
        }
        .btn-google-signup:hover {
            background-color: #F8FAFC;
            border-color: #94A3B8;
        }
    </style>
</head>
<body>
    <div class="container-fluid p-0 login-container">
        <div class="row g-0 h-100">
            
            <!-- Left Side Branding Hero Section -->
            <div class="col-lg-6 login-left-hero d-none d-lg-flex">
                <!-- Top Brand Header -->
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

                <!-- Hero Content Body -->
                <div class="my-auto py-2" style="max-width: 480px; z-index: 2;">
                    <span class="badge rounded-pill px-3 py-1.5 fw-bold mb-2" style="background: #F1FFF1 !important; color: #172017 !important; border: 1px solid #90EE90 !important; font-size: 0.75rem;">
                        ✨ Next-Gen Tax Preparation
                    </span>
                    <h2 class="fw-extrabold text-white mb-2" style="letter-spacing: -0.02em; line-height: 1.2; font-size: 1.85rem;">
                        Automated IRS Form 941 E-Filing Platform
                    </h2>
                    <p class="small text-white-50 mb-3" style="line-height: 1.5;">
                        Streamline quarterly payroll tax returns with instant tax liability calculation, Schedule B daily breakdown, and direct IRS submission.
                    </p>

                    <!-- Feature Cards -->
                    <div class="login-feature-card">
                        <div style="background: rgba(99, 102, 241, 0.2); width: 34px; height: 34px; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#A5B4FC" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <path d="M12 6v6l4 2"></path>
                            </svg>
                        </div>
                        <div>
                            <h6 class="m-0 fw-bold text-white" style="font-size: 0.85rem;">Real-Time Tax Calculation</h6>
                            <small class="text-white-50" style="font-size: 0.75rem;">Automatic Line 5a–12 calculation & deposit validation</small>
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
                            <h6 class="m-0 fw-bold text-white" style="font-size: 0.85rem;">Schedule B Daily Breakdown</h6>
                            <small class="text-white-50" style="font-size: 0.75rem;">Full Month 1–3 daily tax liability support for semiweekly depositors</small>
                        </div>
                    </div>
                </div>

                <!-- Footer note -->
                <div class="d-flex align-items-center justify-content-between text-white-50 small border-top pt-2" style="border-color: rgba(255,255,255,0.12) !important; font-size: 0.75rem;">
                    <span>© 2026 e-File941 Portal</span>
                    <span>256-Bit SSL Encrypted</span>
                </div>
            </div>

            <!-- Right Side Sign In Form Section (MATCHING REGISTER PAGE DESIGN) -->
            <div class="col-lg-6 login-right-form">
                <div class="login-box my-auto" style="max-width: 440px; width: 100%;">
                    
                    <div class="text-center mb-3">
                        <h4 class="fw-extrabold text-dark mb-1" style="font-size: 1.5rem;">Welcome Back</h4>
                        <p class="text-muted small m-0" style="font-size: 0.82rem;">
                            Sign in to access your Form 941 dashboard
                        </p>
                    </div>

                    <!-- Success Alert -->
                    <c:if test="${param.registered == 'true' || not empty success}">
                        <div class="alert alert-success d-flex align-items-center gap-2 py-2 px-3 mb-3 rounded-3 border-0 shadow-sm" role="alert" style="background-color: #ECFDF5; color: #065F46; border-left: 4px solid #10B981 !important; font-size: 0.82rem;">
                            <i class="fas fa-check-circle text-success"></i>
                            <span>Account created successfully! Please sign in with your new credentials.</span>
                        </div>
                    </c:if>

                    <!-- Error Alert -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger d-flex align-items-center gap-2 py-2 px-3 mb-3 rounded-3 border-0 shadow-sm" role="alert" style="background-color: #FEF2F2; color: #991B1B; border-left: 4px solid #EF4444 !important; font-size: 0.82rem;">
                            <i class="fas fa-exclamation-circle text-danger"></i>
                            <span><c:out value="${error}" /></span>
                        </div>
                    </c:if>

                    <!-- Sign In Form -->
                    <form action="<%= request.getContextPath() %>/login" method="POST" id="loginForm">
                        
                        <!-- Field 1: Email or Username -->
                        <div class="form-field-wrapper">
                            <label for="email" class="form-field-label">Email or Username</label>
                            <input type="text" id="email" name="email" class="form-control form-control-custom" placeholder="name@company.com or username" required autofocus>
                            <i class="far fa-envelope input-right-icon"></i>
                        </div>

                        <!-- Field 2: Password -->
                        <div class="form-field-wrapper">
                            <div class="d-flex justify-content-between align-items-center mb-1">
                                <label for="password" class="form-field-label mb-0">Password</label>
                                <a href="#" class="text-decoration-none small fw-semibold" style="color: #059669; font-size: 0.8rem;">Forgot password?</a>
                            </div>
                            <input type="password" id="password" name="password" class="form-control form-control-custom" placeholder="••••••••" required>
                            <i class="far fa-eye input-right-icon interactive" id="togglePasswordIcon" onclick="togglePasswordVisibility()" title="Show/Hide Password"></i>
                        </div>

                        <!-- Remember Me -->
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="rememberMe">
                            <label class="form-check-label text-muted small cursor-pointer" for="rememberMe" style="font-size: 0.8rem;">
                                Remember me for 30 days
                            </label>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn btn-create-account shadow-sm mt-2">
                            Sign In to Portal &rarr;
                        </button>
                    </form>

                    <!-- Divider -->
                    <div class="my-3 text-center position-relative">
                        <hr class="text-muted opacity-25 my-3">
                        <span class="position-absolute top-50 start-50 translate-middle bg-white px-3 text-muted small fw-semibold">Or sign in with</span>
                    </div>

                    <!-- Google Sign In Button -->
                    <a href="<%= request.getContextPath() %>/auth/google/login" class="btn btn-google-signup mb-3 shadow-sm text-decoration-none d-flex align-items-center justify-content-center gap-2">
                        <svg width="18" height="18" viewBox="0 0 24 24">
                            <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                            <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                            <path fill="#FBBC05" d="M5.84 14.1c-.22-.66-.35-1.36-.35-2.1s.13-1.44.35-2.1V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.62z"/>
                            <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"/>
                        </svg>
                        Sign In with Google
                    </a>

                    <div class="text-center mt-3">
                        <p class="text-muted small m-0" style="font-size: 0.8rem;">
                            Don't have an account? 
                            <a href="<%= request.getContextPath() %>/register" class="text-decoration-none fw-bold" style="color: #059669;">Create Business Account</a>
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- GOOGLE ACCOUNTS CHOOSER MODAL FOR LOGIN -->
    <div class="modal fade" id="googleLoginAccountModal" tabindex="-1" aria-labelledby="googleLoginModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 400px;">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header border-bottom-0 pb-1 pt-4 px-4">
                    <div class="d-flex align-items-center gap-2">
                        <svg width="22" height="22" viewBox="0 0 24 24">
                            <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                            <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                            <path fill="#FBBC05" d="M5.84 14.1c-.22-.66-.35-1.36-.35-2.1s.13-1.44.35-2.1V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.62z"/>
                            <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"/>
                        </svg>
                        <h6 class="modal-title fw-bold text-dark m-0" id="googleLoginModalLabel">Sign in with Google</h6>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body px-4 pt-2 pb-4">
                    <p class="text-muted fs-7 mb-3">Choose an account to continue to <strong class="text-dark">eFile941 Portal</strong></p>
                    
                    <div class="p-2 border rounded-3 mb-2 cursor-pointer bg-light hover-shadow" onclick="submitGoogleLogin('admin@efile941.com', 'Admin User')">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle bg-primary text-white fw-bold d-flex align-items-center justify-content-center" style="width: 38px; height: 38px;">A</div>
                            <div>
                                <h6 class="mb-0 fw-bold text-dark fs-7">Admin User</h6>
                                <span class="text-muted fs-7">admin@efile941.com</span>
                            </div>
                        </div>
                    </div>

                    <div class="p-2 border rounded-3 mb-2 cursor-pointer bg-light hover-shadow" onclick="submitGoogleLogin('user@gmail.com', 'Tax Filer')">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle bg-danger text-white fw-bold d-flex align-items-center justify-content-center" style="width: 38px; height: 38px;">U</div>
                            <div>
                                <h6 class="mb-0 fw-bold text-dark fs-7">Tax Filer</h6>
                                <span class="text-muted fs-7">user@gmail.com</span>
                            </div>
                        </div>
                    </div>

                    <div class="p-2 border rounded-3 cursor-pointer bg-light hover-shadow" onclick="promptCustomGoogleLogin()">
                        <div class="d-flex align-items-center gap-3">
                            <div class="rounded-circle bg-white border text-secondary d-flex align-items-center justify-content-center" style="width: 38px; height: 38px;"><i class="fas fa-user-plus fs-7"></i></div>
                            <div>
                                <h6 class="mb-0 fw-bold text-dark fs-7">Use another account</h6>
                                <span class="text-muted fs-7">Enter your Google email manually</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden Form to submit mock Google login details -->
    <form id="googleMockForm" action="<%= request.getContextPath() %>/login" method="POST" style="display: none;">
        <input type="hidden" id="googleEmail" name="email">
        <input type="hidden" id="googlePassword" name="password" value="GoogleAuthPassword123!">
    </form>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('password');
            const toggleIcon = document.getElementById('togglePasswordIcon');
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                if (toggleIcon) {
                    toggleIcon.classList.remove('fa-eye');
                    toggleIcon.classList.add('fa-eye-slash');
                }
            } else {
                passwordInput.type = 'password';
                if (toggleIcon) {
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                }
            }
        }

        function submitGoogleLogin(email, name) {
            document.getElementById('googleEmail').value = email;
            document.getElementById('googleMockForm').submit();
        }

        function promptCustomGoogleLogin() {
            const userEmail = prompt("Enter your Google Account email address:", "user@gmail.com");
            if (userEmail && userEmail.trim() !== "") {
                submitGoogleLogin(userEmail.trim(), "Google User");
            }
        }
    </script>
</body>
</html>
