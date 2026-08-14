<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Account | eFile941 – IRS-Authorized 941 e-File Provider</title>
  <meta name="description" content="Create your free eFile941 account and start filing IRS Form 941 online today.">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="auth-page">

  <!-- ===== AUTH NAVBAR ===== -->
  <nav class="auth-navbar">
    <a href="index.jsp" class="site-logo">
      <div class="logo-badge"><span>e</span>File941</div>
      <div class="logo-sub">IRS-Authorized 941 e-File Provider</div>
    </a>
    <div class="auth-navbar-right">
      <span>Already have an account?</span>
      <a href="login.jsp" class="btn btn-outline" id="nav-login-link" style="font-size:.82rem;padding:.4rem 1rem;">Login</a>
    </div>
  </nav>

  <!-- ===== SPLIT LAYOUT ===== -->
  <div class="auth-container">

    <!-- LEFT PANEL -->
    <div class="auth-left">
      <img
        src="images/login-illustration.png"
        alt="Create your eFile941 account"
        class="auth-illustration anim-fade-in"
        onerror="this.style.display='none'"
      >
      <div class="auth-left-text anim-fade-up-d1">
        <h2>Start filing Form 941 in minutes!</h2>
        <p>
          Create your free account today and join over 50,000 businesses that rely on
          eFile941 for fast, accurate, and IRS-authorized quarterly tax filings.
          No subscription required — pay only when you file.
        </p>
        <div style="display:flex;flex-direction:column;gap:.65rem;margin-top:1.5rem;text-align:left;">
          <div style="display:flex;align-items:center;gap:.65rem;font-size:.875rem;color:var(--primary-dark);font-weight:500;">
            <span style="width:24px;height:24px;background:var(--primary);border-radius:50%;color:#fff;display:flex;align-items:center;justify-content:center;font-size:.7rem;font-weight:800;flex-shrink:0;">✓</span>
            Free to create an account — no credit card required
          </div>
          <div style="display:flex;align-items:center;gap:.65rem;font-size:.875rem;color:var(--primary-dark);font-weight:500;">
            <span style="width:24px;height:24px;background:var(--primary);border-radius:50%;color:#fff;display:flex;align-items:center;justify-content:center;font-size:.7rem;font-weight:800;flex-shrink:0;">✓</span>
            File from any device — desktop, tablet, or mobile
          </div>
          <div style="display:flex;align-items:center;gap:.65rem;font-size:.875rem;color:var(--primary-dark);font-weight:500;">
            <span style="width:24px;height:24px;background:var(--primary);border-radius:50%;color:#fff;display:flex;align-items:center;justify-content:center;font-size:.7rem;font-weight:800;flex-shrink:0;">✓</span>
            256-bit SSL encryption keeps your data safe
          </div>
          <div style="display:flex;align-items:center;gap:.65rem;font-size:.875rem;color:var(--primary-dark);font-weight:500;">
            <span style="width:24px;height:24px;background:var(--primary);border-radius:50%;color:#fff;display:flex;align-items:center;justify-content:center;font-size:.7rem;font-weight:800;flex-shrink:0;">✓</span>
            Instant IRS acknowledgement and acceptance
          </div>
        </div>
      </div>
    </div>

    <!-- RIGHT PANEL -->
    <div class="auth-right">
      <div class="auth-logo-wrap anim-fade-in">
        <div class="logo-badge"><span>e</span>File941</div>
        <div class="auth-logo-tagline">IRS-Authorized 941 e-File Provider</div>
      </div>

      <div class="auth-form-box anim-fade-up">
        <h1>CREATE ACCOUNT</h1>
        <p class="sub-line">Already have an account? <a href="login.jsp" id="login-link">Sign in</a></p>

        <div id="reg-alert" class="alert-msg"></div>

        <form id="register-form" novalidate autocomplete="off">

          <div class="form-group">
            <label for="reg-name">Full Name <span class="req">*</span></label>
            <input
              type="text"
              id="reg-name"
              name="name"
              class="form-control"
              placeholder="Enter your Full Name"
              autocomplete="name"
            >
            <div id="name-error" class="form-error"></div>
          </div>

          <div class="form-group">
            <label for="reg-email">E-Mail Address <span class="req">*</span></label>
            <input
              type="email"
              id="reg-email"
              name="email"
              class="form-control"
              placeholder="Enter your Email Address"
              autocomplete="email"
            >
            <div id="reg-email-error" class="form-error"></div>
          </div>

          <div class="form-group">
            <label for="reg-password">Password <span class="req">*</span></label>
            <div class="input-wrap">
              <input
                type="password"
                id="reg-password"
                name="password"
                class="form-control"
                placeholder="Create a Password (min. 8 characters)"
                autocomplete="new-password"
              >
              <button type="button" class="toggle-pw" title="Show password">👁</button>
            </div>
            <div id="reg-pass-error" class="form-error"></div>
          </div>

          <div class="form-group">
            <label for="reg-confirm">Confirm Password <span class="req">*</span></label>
            <div class="input-wrap">
              <input
                type="password"
                id="reg-confirm"
                name="confirm"
                class="form-control"
                placeholder="Re-enter your Password"
                autocomplete="new-password"
              >
              <button type="button" class="toggle-pw" title="Show password">👁</button>
            </div>
            <div id="reg-confirm-error" class="form-error"></div>
          </div>

          <div style="font-size:.78rem;color:var(--text-muted);margin-bottom:1.25rem;line-height:1.5;">
            By creating an account you agree to our
            <a href="#" style="color:var(--primary);">Terms of Service</a> and
            <a href="#" style="color:var(--primary);">Privacy Policy</a>.
          </div>

          <button type="submit" id="reg-btn" class="btn btn-accent btn-full btn-lg">Create Account</button>

        </form>

        <div class="divider-or">or</div>

        <div style="text-align:center;font-size:.85rem;color:var(--text-muted);">
          Already registered?
          <a href="login.jsp" style="color:var(--primary);font-weight:600;margin-left:.3rem;" id="back-login-link">Back to Login →</a>
        </div>
      </div>
    </div>

  </div><!-- /auth-container -->

  <script src="js/app.js"></script>
</body>
</html>
