<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Form 941 E-File Portal</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid p-0">
        <div class="row g-0 login-split">
            <!-- Left Side Branding -->
            <div class="col-md-6 login-left d-none d-md-flex">
                <div class="text-center p-5">
                    <h1 class="display-4 fw-bold" style="color: var(--primary-blue);">Form 941 Preparation Portal</h1>
                    <p class="lead text-muted mt-3">Secure, fast, and compliant e-filing for employers.</p>
                </div>
            </div>
            
            <!-- Right Side Login Form -->
            <div class="col-md-6 login-right">
                <div class="login-card">
                    <div class="text-center mb-4">
                        <h2 class="fw-bold" style="color: var(--primary-blue);">Login</h2>
                        <p class="text-muted">Welcome back! Please enter your details.</p>
                    </div>
                    
                    <form action="<%= request.getContextPath() %>/login" method="POST">
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger p-2 text-center" role="alert">
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>
                        <div class="mb-3">
                            <label for="email" class="form-label fw-bold">Email</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                        </div>
                        <div class="mb-4">
                            <div class="d-flex justify-content-between">
                                <label for="password" class="form-label fw-bold">Password</label>
                                <a href="#" class="text-decoration-none" style="color: var(--primary-blue); font-size: 0.875rem;">Forgot password?</a>
                            </div>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                        </div>
                        
                        <button type="submit" class="btn btn-tmOrng w-100 py-2 mb-3">Login</button>
                        
                        <div class="text-center mt-4">
                            <p class="mb-0" style="font-size: 0.875rem;">Don't have an account? <a href="#" class="text-decoration-none fw-bold" style="color: var(--primary-blue);">Sign up</a></p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
