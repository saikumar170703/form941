<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Sign in - Google Accounts</title>

            <!-- Google Fonts & Bootstrap 5 -->
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            <style>
                body {
                    background-color: #131314;
                    color: #E3E3E3;
                    font-family: 'Roboto', -apple-system, BlinkMacSystemFont, sans-serif;
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                    justify-content: space-between;
                    padding: 30px 32px 20px;
                    margin: 0;
                    overflow-x: hidden;
                }

                .google-header-logo {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    margin-bottom: 24px;
                }

                .google-signin-title {
                    font-size: 2.2rem;
                    font-weight: 400;
                    color: #E3E3E3;
                    margin-bottom: 8px;
                    letter-spacing: -0.5px;
                }

                .google-signin-subtitle {
                    font-size: 1rem;
                    color: #E3E3E3;
                    margin-bottom: 28px;
                }

                .app-domain-link {
                    color: #A8C7FA;
                    font-weight: 500;
                    text-decoration: none;
                }

                /* Floating Outline Input Box */
                .google-input-wrapper {
                    position: relative;
                    margin-bottom: 12px;
                }

                .google-input-box {
                    background: transparent;
                    border: 1px solid #8E918F;
                    border-radius: 4px;
                    color: #E3E3E3;
                    padding: 16px 14px;
                    font-size: 1rem;
                    width: 100%;
                    transition: border-color 0.2s;
                }

                .google-input-box:focus {
                    border-color: #A8C7FA;
                    box-shadow: 0 0 0 1px #A8C7FA;
                    outline: none;
                    background: transparent;
                    color: #E3E3E3;
                }

                .google-input-label {
                    position: absolute;
                    top: -10px;
                    left: 10px;
                    background: #131314;
                    padding: 0 4px;
                    font-size: 0.75rem;
                    color: #A8C7FA;
                }

                .google-link {
                    color: #A8C7FA;
                    text-decoration: none;
                    font-size: 0.88rem;
                    font-weight: 500;
                }

                .google-link:hover {
                    text-decoration: underline;
                }

                /* Consent Notice Text */
                .google-consent-notice {
                    font-size: 0.84rem;
                    color: #C4C7C5;
                    line-height: 1.45;
                    margin-top: 32px;
                    margin-bottom: 40px;
                }

                .google-consent-notice a {
                    color: #A8C7FA;
                    text-decoration: none;
                    font-weight: 500;
                }

                /* Accounts List Items */
                .account-chooser-card {
                    background: #1E1F20;
                    border: 1px solid #444746;
                    border-radius: 8px;
                    padding: 12px 16px;
                    margin-bottom: 10px;
                    cursor: pointer;
                    transition: background-color 0.2s;
                }

                .account-chooser-card:hover {
                    background: #2D2F31;
                }

                /* Bottom Action Buttons */
                .google-actions {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .btn-create-acc {
                    background: transparent;
                    border: none;
                    color: #A8C7FA;
                    font-size: 0.9rem;
                    font-weight: 500;
                    padding: 8px 12px;
                    border-radius: 20px;
                }

                .btn-create-acc:hover {
                    background: rgba(168, 199, 250, 0.08);
                }

                .btn-next-google {
                    background-color: #A8C7FA;
                    color: #040C21;
                    font-size: 0.9rem;
                    font-weight: 600;
                    border: none;
                    border-radius: 50rem;
                    padding: 10px 24px;
                    transition: opacity 0.2s;
                }

                .btn-next-google:hover {
                    opacity: 0.9;
                }

                /* Footer Links */
                .google-popup-footer {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    font-size: 0.78rem;
                    color: #8E918F;
                    border-top: 1px solid #2D2F31;
                    padding-top: 16px;
                    margin-top: 20px;
                }

                .google-popup-footer a {
                    color: #8E918F;
                    text-decoration: none;
                    margin-left: 16px;
                }

                .google-popup-footer a:hover {
                    color: #E3E3E3;
                }
            </style>
        </head>

        <body>

            <div>
                <!-- Google Header -->
                <div class="google-header-logo">
                    <svg width="24" height="24" viewBox="0 0 24 24">
                        <path fill="#4285F4"
                            d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" />
                        <path fill="#34A853"
                            d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
                        <path fill="#FBBC05"
                            d="M5.84 14.1c-.22-.66-.35-1.36-.35-2.1s.13-1.44.35-2.1V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.62z" />
                        <path fill="#EA4335"
                            d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z" />
                    </svg>
                    <span class="fs-6 fw-normal text-light">Sign in with Google</span>
                </div>

                <h1 class="google-signin-title">Sign in</h1>
                <p class="google-signin-subtitle">
                    to continue to <a href="#" class="app-domain-link">efile941-portal.app</a>
                </p>

                <!-- Google Accounts Selection List -->
                <div class="mb-3">
                    <div class="account-chooser-card d-flex align-items-center gap-3"
                        onclick="selectAccount('user@gmail.com', 'Google User')">
                        <div class="rounded-circle bg-primary text-white fw-bold d-flex align-items-center justify-content-center"
                            style="width: 36px; height: 36px; font-size: 0.9rem;">
                            U
                        </div>
                        <div>
                            <h6 class="m-0 fw-bold text-light fs-7">Google User</h6>
                            <small class="text-secondary" style="font-size: 0.78rem;">user@gmail.com</small>
                        </div>
                    </div>

                    <div class="account-chooser-card d-flex align-items-center gap-3"
                        onclick="selectAccount('admin@efile941.com', 'Admin User')">
                        <div class="rounded-circle bg-danger text-white fw-bold d-flex align-items-center justify-content-center"
                            style="width: 36px; height: 36px; font-size: 0.9rem;">
                            A
                        </div>
                        <div>
                            <h6 class="m-0 fw-bold text-light fs-7">Admin User</h6>
                            <small class="text-secondary" style="font-size: 0.78rem;">admin@efile941.com</small>
                        </div>
                    </div>
                </div>

                <!-- Google Form -->
                <form action="<%= request.getContextPath() %>/auth/google/register" method="POST"
                    id="googleAuthPopupForm">
                    <input type="hidden" name="googleId" id="googleId">
                    <input type="hidden" name="googleEmail" id="googleEmail">
                    <input type="hidden" name="googleName" id="googleName">

                    <div class="google-input-wrapper">
                        <span class="google-input-label">Email or phone</span>
                        <input type="text" id="manualEmail" class="google-input-box" placeholder=""
                            value="user@gmail.com" required>
                    </div>

                    <div class="mb-4">
                        <a href="#" class="google-link">Forgot email?</a>
                    </div>

                    <p class="google-consent-notice">
                        Before using this app, you can review efile941-portal.app's <a href="#">Privacy Policy</a> and
                        <a href="#">Terms of Service</a>.
                    </p>

                    <div class="google-actions">
                        <button type="button" class="btn-create-acc" onclick="submitCurrentEmail()">Create
                            account</button>
                        <button type="button" class="btn-next-google" onclick="submitCurrentEmail()">Next</button>
                    </div>
                </form>
            </div>

            <!-- Footer -->
            <div class="google-popup-footer">
                <select class="bg-transparent border-0 text-secondary fs-7" style="outline: none;">
                    <option>English (United States)</option>
                </select>
                <div>
                    <a href="#">Help</a>
                    <a href="#">Privacy</a>
                    <a href="#">Terms</a>
                </div>
            </div>

            <script>
                function selectAccount(email, name, sub) {
                    var stableSub = sub || ("google-sub-" + Math.abs(email.toLowerCase().hashCode()));
                    document.getElementById('googleId').value = stableSub;
                    document.getElementById('googleEmail').value = email;
                    document.getElementById('googleName').value = name || email.split('@')[0];
                    performSubmission();
                }

                String.prototype.hashCode = function() {
                    var hash = 0, i, chr;
                    if (this.length === 0) return hash;
                    for (i = 0; i < this.length; i++) {
                        chr = this.charCodeAt(i);
                        hash = ((hash << 5) - hash) + chr;
                        hash |= 0;
                    }
                    return hash;
                };

                function submitCurrentEmail() {
                    var val = document.getElementById('manualEmail').value;
                    if (!val || val.trim() === '') {
                        alert('Please enter your email or phone number.');
                        return;
                    }
                    var email = val.trim();
                    var name = email.includes('@') ? email.split('@')[0] : 'Google User';
                    var stableSub = "google-sub-" + Math.abs(email.toLowerCase().hashCode());
                    document.getElementById('googleId').value = stableSub;
                    document.getElementById('googleEmail').value = email;
                    document.getElementById('googleName').value = name;
                    performSubmission();
                }

                function performSubmission() {
                    // Submit form to backend
                    document.getElementById('googleAuthPopupForm').submit();
                }

                // If redirected to dashboard inside popup window, send message to opener window and close popup
                <c:if test="${param.success == 'true'}">
                    if (window.opener) {
                        window.opener.location.href = '<%= request.getContextPath() %>/dashboard';
                    window.close();
            } else {
                        window.location.href = '<%= request.getContextPath() %>/dashboard';
            }
                </c:if>
            </script>
        </body>

        </html>