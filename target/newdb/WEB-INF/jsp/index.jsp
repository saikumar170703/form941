<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>eFile941 – File IRS Form 941 Online | IRS-Authorized e-File Provider</title>
  <meta name="description" content="File IRS Form 941 online quickly and securely with eFile941. IRS-authorized e-file provider. Get instant acceptance and a secure copy of your filed return.">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=2">
</head>
<body>

  <!-- ===== ANNOUNCEMENT BAR ===== -->
  <div id="announcement-bar" class="announcement-bar">
    <strong>Simple and Affordable way to File your Form 941 Online</strong>
    <a href="login.jsp">File Your Form 941 Now! ↗</a>
    <button id="ann-close" class="ann-close" title="Close">✕</button>
  </div>

  <!-- ===== NAVBAR ===== -->
  <nav class="site-navbar">
    <a href="index.jsp" class="site-logo">
      <div class="logo-badge"><span>e</span>File941</div>
      <div class="logo-sub">IRS-Authorized 941 e-File Provider</div>
    </a>

    <ul class="nav-links">
      <li><a href="#features">Forms ▾</a></li>
      <li><a href="#pricing">Pricing</a></li>
      <li><a href="#features">Resources ▾</a></li>
      <li><a href="#contact" style="color:var(--primary);">Contact Us</a></li>
    </ul>

    <div class="nav-contact">
      <a href="tel:6282674400">📞 (628) 267-4400</a>
      <a href="mailto:support@efile941.com">✉ support@efile941.com</a>
    </div>

    <div class="nav-actions">
      <a href="<%= request.getContextPath() %>/login" class="btn btn-outline" id="nav-login-btn">Login</a>
      <a href="<%= request.getContextPath() %>/login" class="btn btn-primary" id="nav-getstarted-btn">Get Started</a>
    </div>
  </nav>

  <!-- ===== HERO ===== -->
  <section class="hero">
    <div class="hero-inner">
      <div class="hero-eyebrow">✓ IRS-Authorized e-File Provider</div>
      <h1 class="anim-fade-up">
        File IRS Form <span>941</span> Online<br>Quickly and Securely
      </h1>
      <ul class="hero-bullets anim-fade-up-d1">
        <li>e-File Form 941 online in minutes with our IRS-authorized platform.</li>
        <li>Get instant IRS acceptance and a secure copy of your filed return.</li>
        <li>File Employer's Quarterly Federal Tax Returns at an affordable price.</li>
        <li>Trusted by businesses and CPAs nationwide for fast and secure filing.</li>
      </ul>
      <div class="hero-actions anim-fade-up-d2">
        <a href="<%= request.getContextPath() %>/login" class="btn btn-accent btn-lg" id="hero-getstarted-btn">Get Started Free</a>
        <a href="#how-it-works" class="btn btn-lg" style="background:rgba(255,255,255,.15);color:#fff;border:2px solid rgba(255,255,255,.4);">
          How It Works
        </a>
      </div>
    </div>
  </section>

  <!-- ===== FEATURES ===== -->
  <section class="features-section" id="features">
    <div class="section-title">
      <h2>Everything You Need to File Form 941</h2>
      <p>Our platform makes quarterly payroll tax filing simple, fast, and error-free.</p>
      <div class="section-divider"></div>
    </div>
    <div class="features-grid">
      <div class="feature-card anim-fade-up">
        <div class="feature-icon">🏛</div>
        <h3>IRS-Authorized</h3>
        <p>Fully authorized by the IRS to e-file Form 941 on behalf of businesses nationwide.</p>
      </div>
      <div class="feature-card anim-fade-up-d1">
        <div class="feature-icon">⚡</div>
        <h3>Instant Filing</h3>
        <p>File your quarterly return in minutes. Get IRS acceptance notification immediately.</p>
      </div>
      <div class="feature-card anim-fade-up-d2">
        <div class="feature-icon">🔒</div>
        <h3>Bank-Level Security</h3>
        <p>256-bit SSL encryption protects your data at every step of the filing process.</p>
      </div>
      <div class="feature-card anim-fade-up-d3">
        <div class="feature-icon">📋</div>
        <h3>Form 941 & Schedule B</h3>
        <p>File Form 941, Schedule B (daily tax liability), and Form 941-X amendments.</p>
      </div>
      <div class="feature-card anim-fade-up">
        <div class="feature-icon">🏢</div>
        <h3>Multi-Organization</h3>
        <p>Manage and file for multiple businesses or clients from one central dashboard.</p>
      </div>
      <div class="feature-card anim-fade-up-d1">
        <div class="feature-icon">📊</div>
        <h3>Filing History</h3>
        <p>Access all your past filings, download acknowledgements, and track status anytime.</p>
      </div>
    </div>
  </section>

  <!-- ===== HOW IT WORKS ===== -->
  <section style="padding:5rem 2rem; background:var(--bg);" id="how-it-works">
    <div class="section-title">
      <h2>How It Works</h2>
      <p>Three simple steps to file your IRS Form 941 online.</p>
      <div class="section-divider"></div>
    </div>
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:2rem;max-width:900px;margin:0 auto;">
      <div style="text-align:center;padding:2rem 1.5rem;">
        <div style="width:70px;height:70px;border-radius:50%;background:var(--primary);color:#fff;display:flex;align-items:center;justify-content:center;font-size:1.6rem;font-weight:800;margin:0 auto 1.25rem;">1</div>
        <h3 style="font-weight:700;margin-bottom:.5rem;">Create Your Account</h3>
        <p style="color:var(--text-muted);font-size:.9rem;">Sign up for free and add your business/organization in minutes.</p>
      </div>
      <div style="text-align:center;padding:2rem 1.5rem;">
        <div style="width:70px;height:70px;border-radius:50%;background:var(--accent);color:#fff;display:flex;align-items:center;justify-content:center;font-size:1.6rem;font-weight:800;margin:0 auto 1.25rem;">2</div>
        <h3 style="font-weight:700;margin-bottom:.5rem;">Enter Your Tax Info</h3>
        <p style="color:var(--text-muted);font-size:.9rem;">Our guided wizard walks you through every line of Form 941 with built-in error checks.</p>
      </div>
      <div style="text-align:center;padding:2rem 1.5rem;">
        <div style="width:70px;height:70px;border-radius:50%;background:var(--success);color:#fff;display:flex;align-items:center;justify-content:center;font-size:1.6rem;font-weight:800;margin:0 auto 1.25rem;">3</div>
        <h3 style="font-weight:700;margin-bottom:.5rem;">e-File & Get Accepted</h3>
        <p style="color:var(--text-muted);font-size:.9rem;">Submit to the IRS and receive instant acknowledgement. Download your copy anytime.</p>
      </div>
    </div>
  </section>

  <!-- ===== PRICING ===== -->
  <section class="pricing-section" id="pricing">
    <div class="section-title">
      <h2>Simple, Transparent Pricing</h2>
      <p>Affordable rates for businesses of all sizes. No hidden fees.</p>
      <div class="section-divider"></div>
    </div>
    <div class="pricing-grid">
      <div class="pricing-card">
        <div class="pricing-form">Form 941</div>
        <div class="pricing-price"><sup>$</sup>6<sub>.99 / return</sub></div>
        <div class="pricing-desc">For small businesses filing quarterly</div>
        <ul class="pricing-features">
          <li><span class="check-icon">✓</span> Form 941 e-File</li>
          <li><span class="check-icon">✓</span> IRS Acknowledgement</li>
          <li><span class="check-icon">✓</span> PDF Copy of Return</li>
          <li><span class="check-icon">✓</span> Secure Storage (3 years)</li>
        </ul>
        <a href="<%= request.getContextPath() %>/login" class="btn btn-outline btn-full" id="pricing-basic-btn">Get Started</a>
      </div>
      <div class="pricing-card featured">
        <div class="pricing-badge">Most Popular</div>
        <div class="pricing-form">Form 941 + Schedule B</div>
        <div class="pricing-price"><sup>$</sup>9<sub>.99 / return</sub></div>
        <div class="pricing-desc">For businesses with daily tax liability reporting</div>
        <ul class="pricing-features">
          <li><span class="check-icon">✓</span> Form 941 e-File</li>
          <li><span class="check-icon">✓</span> Schedule B Included</li>
          <li><span class="check-icon">✓</span> IRS Acknowledgement</li>
          <li><span class="check-icon">✓</span> PDF Copy of Return</li>
          <li><span class="check-icon">✓</span> Multi-Organization</li>
        </ul>
        <a href="<%= request.getContextPath() %>/login" class="btn btn-primary btn-full" id="pricing-popular-btn">Get Started</a>
      </div>
      <div class="pricing-card">
        <h3 class="pricing-title">Form 941-X (Correction)</h3>
        <div class="pricing-price">$19.95 <span>/ return</span></div>
        <ul class="pricing-features">
          <li><span class="check-icon">✓</span> Amend Previously Filed 941</li>
          <li><span class="check-icon">✓</span> Guided Adjustment Wizard</li>
          <li><span class="check-icon">✓</span> Line-by-Line Validation</li>
          <li><span class="check-icon">✓</span> IRS e-File Transmission</li>
          <li><span class="check-icon">✓</span> Priority Support</li>
        </ul>
        <a href="<%= request.getContextPath() %>/login" class="btn btn-outline btn-full" id="pricing-amendment-btn">Get Started</a>
      </div>
    </div>
  </section>

  <!-- ===== CTA BANNER ===== -->
  <section class="cta-banner">
    <h2>Ready to File Your Form 941?</h2>
    <p>Join thousands of businesses who trust eFile941 for fast, accurate quarterly e-filing.</p>
    <a href="<%= request.getContextPath() %>/login" class="btn-white" id="cta-btn">Start Filing Today – It's Free</a>
  </section>

  <!-- ===== FOOTER ===== -->
  <footer class="site-footer">
    <div class="footer-inner">
      <div class="footer-top">
        <div class="footer-brand">
          <div class="site-logo" style="margin-bottom:.5rem;">
            <div class="logo-badge" style="font-size:1rem;"><span>e</span>File941</div>
          </div>
          <p>IRS-Authorized 941 e-File Provider. File your Employer's Quarterly Federal Tax Return online quickly, securely, and affordably.</p>
        </div>
        <div class="footer-col">
          <h4>Forms</h4>
          <ul>
            <li><a href="#">Form 941</a></li>
            <li><a href="#">Form 941 Schedule B</a></li>
            <li><a href="#">Form 941-X</a></li>
            <li><a href="#">Form 944</a></li>
          </ul>
        </div>
        <div class="footer-col">
          <h4>Company</h4>
          <ul>
            <li><a href="#">About Us</a></li>
            <li><a href="#">Pricing</a></li>
            <li><a href="#">Blog</a></li>
            <li><a href="#">Contact Us</a></li>
          </ul>
        </div>
        <div class="footer-col">
          <h4>Support</h4>
          <ul>
            <li><a href="#">Help Center</a></li>
            <li><a href="#">Privacy Policy</a></li>
            <li><a href="#">Terms of Service</a></li>
            <li><a href="#">Security</a></li>
          </ul>
        </div>
      </div>
      <div class="footer-bottom">
        <span>© 2026 eFile941. All rights reserved.</span>
        <span>📞 (628) 267-4400 &nbsp;|&nbsp; ✉ support@efile941.com</span>
      </div>
    </div>
  </footer>

  <script src="js/app.js"></script>
</body>
</html>
