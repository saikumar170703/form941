<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Business Account - Form 941 E-File Portal</title>
    <!-- Bootstrap 5 CSS & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="<%= request.getContextPath() %>/css/style.css?v=6" rel="stylesheet">

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
            border-color: #2563EB;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
            outline: none;
        }
        .input-right-icon {
            position: absolute;
            right: 12px;
            bottom: 11px;
            color: #94A3B8;
            font-size: 0.9rem;
            pointer-events: none;
        }
        .input-right-icon.interactive {
            pointer-events: auto;
            cursor: pointer;
        }
        .btn-create-account {
            background-color: #2563EB;
            border: 1px solid #2563EB;
            color: #FFFFFF;
            font-weight: 700;
            font-size: 0.95rem;
            border-radius: 8px;
            padding: 10px;
            width: 100%;
            transition: all 0.2s ease;
        }
        .btn-create-account:hover {
            background-color: #1D4ED8;
            border-color: #1D4ED8;
            color: #FFFFFF;
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
            
            <!-- Left Side Branding Hero Section (MATCHING LOGIN PAGE) -->
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

                <!-- Footer note -->
                <div class="d-flex align-items-center justify-content-between text-white-50 small border-top pt-2" style="border-color: rgba(255,255,255,0.12) !important; font-size: 0.75rem;">
                    <span>© 2026 e-File941 Portal</span>
                    <span>IRS Security Compliant</span>
                </div>
            </div>

            <!-- Right Side Registration Form Section (EXACT 4 FIELDS & TAXBANDITS STYLE) -->
            <div class="col-lg-6 login-right-form">
                <div class="register-box my-auto" style="max-width: 440px; width: 100%;">
                    
                    <div class="text-center mb-3">
                        <h4 class="fw-extrabold text-dark mb-1" style="font-size: 1.5rem;">Create Your Account</h4>
                        <p class="text-muted small m-0" style="font-size: 0.82rem;">
                            Account Type: <strong class="text-dark">Business Owner</strong> 
                            <a href="#" class="ms-1" style="color: #2563EB; font-weight: 600; text-decoration: none;">Change</a>
                        </p>
                    </div>

                    <!-- Error Alert -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger d-flex align-items-center gap-2 py-2 px-3 mb-3 rounded-3 border-0 shadow-sm" role="alert" style="background-color: #FEF2F2; color: #991B1B; border-left: 4px solid #EF4444 !important; font-size: 0.82rem;">
                            <i class="fas fa-exclamation-circle text-danger"></i>
                            <span><c:out value="${error}" /></span>
                        </div>
                    </c:if>

                    <!-- Registration Form with EXACT 4 Specified Fields -->
                    <form action="<%= request.getContextPath() %>/register" method="POST" id="registerForm">
                        
                        <!-- Field 1: Work email -->
                        <div class="form-field-wrapper">
                            <label for="email" class="form-field-label">Work email</label>
                            <input type="email" id="email" name="email" class="form-control form-control-custom" placeholder="" required autofocus>
                            <i class="far fa-envelope input-right-icon"></i>
                        </div>

                        <!-- Field 2: Contact name -->
                        <div class="form-field-wrapper">
                            <label for="name" class="form-field-label">Contact name</label>
                            <input type="text" id="name" name="name" class="form-control form-control-custom" placeholder="" required>
                            <i class="far fa-user input-right-icon"></i>
                        </div>

                        <!-- Field 3: Password -->
                        <div class="form-field-wrapper">
                            <label for="password" class="form-field-label">Password</label>
                            <input type="password" id="password" name="password" class="form-control form-control-custom" placeholder="" required>
                            <i class="far fa-eye input-right-icon interactive" id="togglePasswordIcon" onclick="togglePasswordVisibility()" title="Show/Hide Password"></i>
                        </div>

                        <!-- Field 4: Phone number -->
                        <div class="form-field-wrapper">
                            <label for="phone" class="form-field-label">Phone number</label>
                            <input type="tel" id="phone" name="phone" class="form-control form-control-custom" placeholder="">
                            <i class="fas fa-phone input-right-icon"></i>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn btn-create-account shadow-sm mt-2">
                            Create Account
                        </button>
                    </form>

                    <!-- Divider -->
                    <div class="my-3 text-center position-relative">
                        <hr class="text-muted opacity-25 my-3">
                        <span class="position-absolute top-50 start-50 translate-middle bg-white px-3 text-muted small fw-semibold">Or create account with</span>
                    </div>

                    <!-- Google Sign Up Button (Launches Official Google OAuth Popup Window) -->
                    <form action="<%= request.getContextPath() %>/auth/google/register" method="POST" id="googleSignUpForm">
                        <input type="hidden" name="googleEmail" id="googleEmailInput">
                        <input type="hidden" name="googleName" id="googleNameInput">
                        
                        <button type="button" class="btn btn-google-signup mb-3 shadow-sm" onclick="openGoogleOAuthPopupWindow()">
                            <svg width="18" height="18" viewBox="0 0 24 24">
                                <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                                <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                                <path fill="#FBBC05" d="M5.84 14.1c-.22-.66-.35-1.36-.35-2.1s.13-1.44.35-2.1V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.62z"/>
                                <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"/>
                            </svg>
                            Google
                        </button>
                    </form>

                    <!-- Footer Consent Text -->
                    <div class="text-center text-muted mt-3" style="font-size: 0.76rem; line-height: 1.45;">
                        <p class="mb-1">
                            By creating an account, you agree to our <a href="#" style="color: #2563EB; text-decoration: underline;">Terms and Conditions</a>
                        </p>
                        <p class="mb-0">
                            You also agree to receive emails regarding your tax return status, IRS notifications, and upcoming deadlines from eFile941. Read our <a href="#" style="color: #2563EB; text-decoration: underline;">Privacy Policy</a>.
                        </p>
                    </div>

                    <div class="text-center mt-3 pt-1">
                        <p class="text-muted small m-0" style="font-size: 0.82rem;">
                            Already have an account? 
                            <a href="<%= request.getContextPath() %>/login" class="text-decoration-none fw-bold" style="color: #2563EB;">Sign In</a>
                        </p>
                    </div>

                </div>
            </div>

        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- JavaScript Functions -->
    <script>
        function togglePasswordVisibility() {
            const passInput = document.getElementById('password');
            const icon = document.getElementById('togglePasswordIcon');
            if (passInput.type === 'password') {
                passInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        // Opens Official Google OAuth Popup Dialog Window
        function openGoogleOAuthPopupWindow() {
            const width = 500;
            const height = 620;
            const left = Math.max(0, (window.screen.width / 2) - (width / 2));
            const top = Math.max(0, (window.screen.height / 2) - (height / 2));

            const popup = window.open(
                '<%= request.getContextPath() %>/auth/google/popup',
                'Sign in - Google Accounts',
                'width=' + width + ',height=' + height + ',top=' + top + ',left=' + left + ',scrollbars=yes,status=yes,resizable=yes'
            );

            if (!popup) {
                // Fallback if popups blocked
                alert('Please allow popups to sign in with Google.');
            }
        }
    </script>
</body>
</html>
