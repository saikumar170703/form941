<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>eFile941 – IRS-Authorized Form 941 E-File Portal | File Quarterly Tax Returns Online</title>
        <meta name="description"
            content="File official IRS Form 941 quarterly payroll tax returns online. Automated tax calculations, Schedule B support, error audits, and instant IRS e-file confirmation." />

        <!-- Google Fonts & FontAwesome -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap"
            rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            :root {
                --app-primary: #90EE90;
                --app-primary-hover: #76E076;
                --app-navy-dark: #172017;
                --app-slate-bg: #FFFFFF;
                --app-border: #E5E9E5;
            }

            body {
                font-family: 'Plus Jakarta Sans', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                color: #172017;
                background-color: #FFFFFF;
            }

            /* Top Announcement Bar */
            .top-stripe {
                background-color: #172017;
                border-bottom: 1px solid #283628;
                color: #E5E9E5;
                font-size: 0.85rem;
                padding: 8px 0;
                font-weight: 500;
            }

            .top-stripe a {
                color: #90EE90;
                text-decoration: underline;
                font-weight: 600;
            }

            /* Sub-Utility Navbar */
            .subnav {
                background-color: #F1FFF1;
                border-bottom: 1px solid var(--app-border);
                font-size: 0.82rem;
                padding: 6px 0;
            }

            .subnav a {
                color: #667066;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.2s;
            }

            .subnav a:hover {
                color: #172017;
            }

            /* Main Navigation Bar */
            .main-navbar {
                background: #FFFFFF;
                border-bottom: 1px solid var(--app-border);
                box-shadow: 0 2px 12px rgba(23, 32, 23, 0.03);
                padding: 14px 0;
            }

            .brand-logo {
                font-size: 1.5rem;
                font-weight: 800;
                color: #172017;
                letter-spacing: -0.5px;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .irs-seal-badge {
                background: #F1FFF1;
                color: #172017;
                border: 1px solid #90EE90;
                font-size: 0.72rem;
                font-weight: 700;
                padding: 3px 10px;
                border-radius: 20px;
                letter-spacing: 0.5px;
                text-transform: uppercase;
            }

            /* Buttons */
            .btn-signin {
                border: 1.5px solid var(--app-border);
                color: #172017;
                font-weight: 700;
                border-radius: 50rem;
                padding: 7px 24px;
                transition: all 0.2s ease;
                background: #FFFFFF;
            }

            .btn-signin:hover {
                background-color: #F1FFF1;
                border-color: #90EE90;
                color: #172017;
            }

            .btn-signup {
                background-color: #90EE90;
                border: 1px solid #90EE90;
                color: #172017;
                font-weight: 700;
                border-radius: 50rem;
                padding: 8px 26px;
                box-shadow: 0 2px 6px rgba(23, 32, 23, 0.06);
                transition: all 0.2s ease;
            }

            .btn-signup:hover {
                background-color: #76E076;
                border-color: #76E076;
                color: #172017;
                transform: translateY(-1px);
            }

            /* Senior UI/UX Dark Forest Hero Section with #90EE90 Light Green Accents */
            .hero-banner {
                background: #172017;
                color: #FFFFFF;
                padding: 48px 0 52px;
                position: relative;
                overflow: hidden;
            }

            .hero-banner::before {
                content: '';
                position: absolute;
                top: -20%;
                right: -10%;
                width: 500px;
                height: 500px;
                background: radial-gradient(circle, rgba(144, 238, 144, 0.18) 0%, rgba(23, 32, 23, 0) 70%);
                border-radius: 50%;
                pointer-events: none;
            }

            .hero-title {
                font-size: 2.35rem;
                font-weight: 800;
                line-height: 1.2;
                letter-spacing: -0.02em;
                color: #FFFFFF;
            }

            .hero-subtitle {
                font-size: 0.98rem;
                color: #E5E9E5;
                margin-top: 12px;
                margin-bottom: 20px;
                line-height: 1.55;
            }

            /* Compact Executive White Estimator Card Component */
            .estimator-card-white {
                background: #FFFFFF;
                border: 1px solid #E5E9E5;
                border-radius: 16px;
                padding: 22px 24px;
                box-shadow: 0 16px 36px rgba(0, 0, 0, 0.18);
                color: #172017;
                max-width: 450px;
                margin-left: auto;
            }

            .estimator-card-title {
                font-size: 1.1rem;
                font-weight: 800;
                color: #172017;
                margin-bottom: 2px;
            }

            .estimator-card-subtitle {
                font-size: 0.78rem;
                color: #667066;
                margin-bottom: 16px;
            }

            /* Compact Rounded Individual Field Box */
            .field-rounded-box {
                background: #FAFCFA;
                border: 1px solid #E5E9E5;
                border-radius: 12px;
                padding: 10px 14px;
            }

            .field-label {
                font-size: 0.78rem;
                font-weight: 700;
                color: #172017;
                margin-bottom: 4px;
                display: block;
            }

            .field-input-wages {
                background: #FFFFFF;
                border: 1.5px solid #E5E9E5;
                border-radius: 8px;
                color: #172017;
                font-weight: 800;
                font-size: 1.05rem;
                padding: 6px 12px;
            }

            .field-input-wages:focus {
                border-color: #90EE90;
                box-shadow: 0 0 0 3px rgba(144, 238, 144, 0.45);
                outline: none;
            }

            .field-stat-value {
                font-size: 1.1rem;
                font-weight: 800;
                color: #172017;
                margin-top: 2px;
            }

            /* Compact Executive Summary Box */
            .field-summary-box {
                background: #F1FFF1;
                border: 1.5px solid #90EE90;
                border-radius: 14px;
                padding: 12px 16px;
            }

            .field-summary-label {
                font-size: 0.72rem;
                font-weight: 700;
                color: #667066;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                display: block;
            }

            .field-summary-total {
                font-size: 1.55rem;
                font-weight: 900;
                color: #172017;
                line-height: 1.1;
            }

            /* Quarter Pill Badge */
            .quarter-pill {
                background: rgba(255, 255, 255, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 50rem;
                padding: 4px 14px;
                font-size: 0.8rem;
                font-weight: 600;
                color: #F1FFF1;
            }

            /* Feature Cards */
            .feature-card {
                background: #FFFFFF;
                border: 1px solid var(--app-border);
                border-radius: 14px;
                padding: 30px;
                height: 100%;
                transition: all 0.25s ease;
                box-shadow: 0 4px 12px rgba(23, 32, 23, 0.03);
            }

            .feature-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 12px 24px rgba(23, 32, 23, 0.08);
                border-color: #90EE90;
            }

            .feature-icon {
                width: 52px;
                height: 52px;
                border-radius: 12px;
                background: #F1FFF1;
                color: #172017;
                border: 1px solid #90EE90;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.4rem;
                margin-bottom: 20px;
            }

            /* Step Circle */
            .step-circle {
                width: 42px;
                height: 42px;
                border-radius: 50%;
                background: #90EE90;
                color: #172017;
                font-weight: 800;
                font-size: 1.1rem;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 14px;
                border: 1px solid #76E076;
            }

            /* Pricing Card */
            .pricing-card {
                background: #FFFFFF;
                border: 2px solid #90EE90;
                border-radius: 20px;
                padding: 40px 32px;
                box-shadow: 0 12px 28px rgba(23, 32, 23, 0.06);
                position: relative;
            }

            /* Footer */
            .footer-dark {
                background: #172017;
                color: #E5E9E5;
                padding: 65px 0 35px;
                font-size: 0.9rem;
            }

            .footer-dark a {
                color: #E5E9E5;
                text-decoration: none;
                transition: color 0.2s;
            }

            .footer-dark a:hover {
                color: #90EE90;
            }
        </style>
    </head>

    <body>

        <!-- 1. TOP ANNOUNCEMENT BAR -->
        <div class="top-stripe text-center">
            <div class="container">
                <span><i class="fas fa-shield-alt me-1 text-primary"></i> IRS-Authorized MeF E-File Portal for Form 941
                    (Q1, Q2, Q3, Q4) | Built-in Audit Validation</span>
                <a href="<%= request.getContextPath() %>/register" class="ms-2">Start E-Filing &rarr;</a>
            </div>
        </div>

        <!-- 2. UTILITY SUB-NAVBAR -->
        <div class="subnav d-none d-md-block">
            <div class="container d-flex justify-content-between align-items-center">
                <div class="d-flex gap-4">
                    <a href="#"><i class="fas fa-building me-1"></i> Employers & Small Business</a>
                    <a href="#"><i class="fas fa-user-tie me-1"></i> CPAs & Tax Professionals</a>
                    <a href="#"><i class="fas fa-briefcase me-1"></i> Enterprise Payroll</a>
                    <a href="#"><i class="fas fa-code me-1"></i> Developer API</a>
                </div>
                <div>
                    <a href="#"><i class="fas fa-headset me-1"></i> US Support: (800) 555-0941</a>
                </div>
            </div>
        </div>

        <!-- 3. MAIN NAVIGATION BAR -->
        <nav class="main-navbar sticky-top">
            <div class="container d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center gap-3">
                    <a href="<%= request.getContextPath() %>/" class="brand-logo">
                        <i class="fas fa-file-invoice text-primary"></i> eFile941
                    </a>
                    <span class="irs-seal-badge"><i class="fas fa-check-circle me-1"></i> IRS Authorized</span>
                </div>

                <!-- Navigation Links -->
                <div class="d-none d-lg-flex align-items-center gap-4 fw-semibold text-secondary">
                    <div class="dropdown">
                        <a href="#" class="text-dark text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">Tax Forms</a>
                        <ul class="dropdown-menu shadow border-0 rounded-3">
                            <li>
                                <a class="dropdown-item fw-bold text-primary py-2" href="<%= request.getContextPath() %>/register">
                                    <i class="fas fa-file-alt me-2"></i> Form 941 (Quarterly Tax)
                                </a>
                            </li>
                        </ul>
                    </div>
                    <a href="#features" class="text-dark text-decoration-none">Features</a>
                    <a href="#pricing" class="text-dark text-decoration-none">Pricing</a>
                    <a href="#how-it-works" class="text-dark text-decoration-none">How It Works</a>
                    <a href="#faq" class="text-dark text-decoration-none">FAQ</a>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex align-items-center gap-2">
                    <a href="<%= request.getContextPath() %>/login" class="btn btn-signin text-decoration-none">Sign
                        In</a>
                    <a href="<%= request.getContextPath() %>/register" class="btn btn-signup text-decoration-none">Sign
                        Up Free</a>
                </div>
            </div>
        </nav>

        <!-- 4. RICH BLUE HERO BANNER WITH EXECUTIVE WHITE ESTIMATOR CARD -->
        <section class="hero-banner">
            <div class="container">
                <div class="row align-items-center gy-5">
                    <div class="col-lg-6">
                        <!-- Quarter Badges -->
                        <div class="d-flex flex-wrap gap-2 mb-3">
                            <span class="quarter-pill"><i class="fas fa-check me-1" style="color: #90EE90;"></i> Q1 (Jan - Mar)</span>
                            <span class="quarter-pill"><i class="fas fa-check me-1" style="color: #90EE90;"></i> Q2 (Apr - Jun)</span>
                            <span class="quarter-pill"><i class="fas fa-check me-1" style="color: #90EE90;"></i> Q3 (Jul - Sep)</span>
                            <span class="quarter-pill"><i class="fas fa-check me-1" style="color: #90EE90;"></i> Q4 (Oct - Dec)</span>
                        </div>

                        <h1 class="hero-title">E-File IRS Form 941 Online Securely & Accurately</h1>
                        <p class="hero-subtitle">
                            Report quarterly employee wages, federal income tax withheld, and Social Security & Medicare
                            taxes directly to the IRS. Built with automated tax calculations and instant error audits.
                        </p>

                        <div class="d-flex flex-wrap gap-3">
                            <a href="<%= request.getContextPath() %>/register"
                                class="btn btn-primary fw-bold px-4 py-2.5 rounded-pill shadow-sm" style="background-color: #90EE90 !important; border-color: #90EE90 !important; color: #172017 !important;">
                                Start Filing Form 941 &rarr;
                            </a>
                            <a href="<%= request.getContextPath() %>/login"
                                class="btn btn-outline-light fw-semibold px-4 py-2.5 rounded-pill" style="border-color: rgba(255,255,255,0.3) !important; color: #FFFFFF !important;">
                                Sign In to Account
                            </a>
                        </div>

                        <div class="d-flex align-items-center gap-4 mt-3 pt-1 text-slate-300 fs-7">
                            <div><i class="fas fa-check-circle me-1" style="color: #90EE90;"></i> Instant IRS Receipt</div>
                            <div><i class="fas fa-check-circle me-1" style="color: #90EE90;"></i> Free Retransmit</div>
                            <div><i class="fas fa-check-circle me-1" style="color: #90EE90;"></i> 256-Bit Security</div>
                        </div>
                    </div>

                    <!-- Executive White Form 941 Estimator Component -->
                    <div class="col-lg-6">
                        <div class="estimator-card-white">
                            <h4 class="estimator-card-title d-flex align-items-center gap-2">
                                <i class="fas fa-calculator" style="color: #172017;"></i> Form 941 Line-by-Line Estimator
                            </h4>
                            <p class="estimator-card-subtitle">Instant Line 5a (Social Security) & Line 6 (Total Taxes)
                                estimator.</p>

                            <!-- Box 1: Quarterly Total Wages (Line 2) -->
                            <div class="field-rounded-box mb-3">
                                <label class="field-label">Quarterly Total Wages (Line 2)</label>
                                <div class="input-group">
                                    <span
                                        class="input-group-text bg-white border-end-0 text-secondary fw-bold fs-5">$</span>
                                    <input type="number" id="calcWages"
                                        class="form-control field-input-wages border-start-0" value="50000"
                                        oninput="calculatePreview()">
                                </div>
                            </div>

                            <!-- Box 2 & 3: Social Security & Medicare Taxes -->
                            <div class="row g-3 mb-3">
                                <div class="col-6">
                                    <div class="field-rounded-box">
                                        <span class="field-label">Social Security (12.4%)</span>
                                        <div id="calcSocSec" class="field-stat-value">$6,200.00</div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="field-rounded-box">
                                        <span class="field-label">Medicare Tax (2.9%)</span>
                                        <div id="calcMedicare" class="field-stat-value">$1,450.00</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Summary Box: Estimated Total Taxes (Line 6) -->
                            <div class="field-summary-box d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="field-summary-label">Estimated Total Taxes (Line 6)</span>
                                    <div id="calcTotal" class="field-summary-total">$7,650.00</div>
                                </div>
                                <a href="<%= request.getContextPath() %>/register"
                                    class="btn btn-primary btn-md fw-bold px-4 py-2.5 rounded-pill shadow-sm">
                                    Create Account &rarr;
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 5. HOW IT WORKS SECTION -->
        <section id="how-it-works" class="py-5 bg-white">
            <div class="container py-4">
                <div class="text-center max-w-2xl mx-auto mb-5">
                    <h2 class="fw-extrabold fs-2">File Form 941 in 3 Easy Steps</h2>
                    <p class="text-muted fs-6">E-file your quarterly return online without manual paperwork.</p>
                </div>
                <div class="row g-4 text-center">
                    <div class="col-md-4">
                        <div class="p-4 rounded-4 bg-slate-50 border h-100">
                            <div class="step-circle">1</div>
                            <h4 class="fw-bold fs-5 mt-2">Enter Employer & Wage Data</h4>
                            <p class="text-muted fs-7">Input your Business EIN, contact info, employee count, and
                                quarterly taxable wages.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-4 rounded-4 bg-slate-50 border h-100">
                            <div class="step-circle">2</div>
                            <h4 class="fw-bold fs-5 mt-2">Auto-Calculate & Validate Schedule B</h4>
                            <p class="text-muted fs-7">System calculates Social Security, Medicare, and total tax
                                liability for Schedule B depositors.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-4 rounded-4 bg-slate-50 border h-100">
                            <div class="step-circle">3</div>
                            <h4 class="fw-bold fs-5 mt-2">E-Sign & E-File to IRS</h4>
                            <p class="text-muted fs-7">Sign electronically with Online Signature PIN or Form 8453-EMP
                                and transmit directly to the IRS.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 6. KEY FEATURES GRID -->
        <section id="features" class="py-5">
            <div class="container py-4">
                <div class="text-center max-w-2xl mx-auto mb-5">
                    <h2 class="fw-extrabold fs-2">Engineered for IRS Compliance</h2>
                    <p class="text-muted fs-6">Complete e-filing tools designed for business owners, CPAs, and payroll
                        tax managers.</p>
                </div>

                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon"><i class="fas fa-check-double"></i></div>
                            <h3 class="fw-bold fs-5">MeF Schema & Business Rule Audits</h3>
                            <p class="text-muted fs-7">Validates all tax math and required fields against IRS Modernized
                                e-File business rules before submission.</p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon"><i class="fas fa-calendar-alt"></i></div>
                            <h3 class="fw-bold fs-5">Automated Schedule B Generation</h3>
                            <p class="text-muted fs-7">Semi-weekly depositors get automatic daily tax liability entry
                                with instant total validation.</p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon"><i class="fas fa-redo"></i></div>
                            <h3 class="fw-bold fs-5">Free Re-transmission</h3>
                            <p class="text-muted fs-7">If the IRS rejects your return due to an EIN or name control
                                mismatch, fix errors and re-transmit for free.</p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon"><i class="fas fa-shield-alt"></i></div>
                            <h3 class="fw-bold fs-5">Bank-Grade 256-Bit Security</h3>
                            <p class="text-muted fs-7">Data is encrypted at rest and in transit adhering strictly to IRS
                                Publication 1075 security standards.</p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon"><i class="fas fa-users"></i></div>
                            <h3 class="fw-bold fs-5">Multi-Employer Management</h3>
                            <p class="text-muted fs-7">CPAs and tax pros can manage and file Form 941 for multiple
                                client businesses under a single login.</p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon"><i class="fas fa-bell"></i></div>
                            <h3 class="fw-bold fs-5">Instant Status Tracking & Notifications</h3>
                            <p class="text-muted fs-7">Track IRS processing status in real time and receive official
                                submission receipt PDFs via email.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 7. PRICING SECTION -->
        <section id="pricing" class="py-5 bg-white">
            <div class="container py-4">
                <div class="text-center max-w-xl mx-auto mb-5">
                    <h2 class="fw-extrabold fs-2">Simple, Transparent Pricing</h2>
                    <p class="text-muted fs-6">Pay only when you e-file. No recurring monthly fees or hidden charges.
                    </p>
                </div>
                <div class="row justify-content-center">
                    <div class="col-md-6 col-lg-5">
                        <div class="pricing-card text-center">
                            <span
                                class="position-absolute top-0 start-50 translate-middle badge bg-primary px-3 py-2 rounded-pill fw-bold text-uppercase fs-7">IRS
                                Authorized</span>
                            <h3 class="fw-bold fs-4 mt-2">Form 941 Quarterly Filing</h3>
                            <div class="my-4">
                                <span class="display-4 fw-extrabold text-primary">$5.95</span>
                                <span class="text-muted fs-6">/ return</span>
                            </div>
                            <ul class="list-unstyled text-start fs-7 mb-4 space-y-2">
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> Complete Form 941 &
                                    Schedule B Filing</li>
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> Automated IRS MeF Error
                                    Audits</li>
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> Free Re-transmission on
                                    Rejections</li>
                                <li class="mb-2"><i class="fas fa-check text-primary me-2"></i> Official IRS
                                    Confirmation Copy PDF</li>
                            </ul>
                            <a href="<%= request.getContextPath() %>/register"
                                class="btn btn-primary btn-lg w-100 fw-bold rounded-pill shadow">
                                Create Free Account to Start &rarr;
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 8. FREQUENTLY ASKED QUESTIONS (FAQ) -->
        <section id="faq" class="py-5">
            <div class="container py-4 max-w-3xl">
                <div class="text-center mb-5">
                    <h2 class="fw-extrabold fs-2">Frequently Asked Questions</h2>
                    <p class="text-muted fs-6">Everything you need to know about e-filing IRS Form 941.</p>
                </div>
                <div class="accordion shadow-sm rounded-4" id="faqAccordion">
                    <div class="accordion-item border-0 border-bottom">
                        <h2 class="accordion-header">
                            <button class="accordion-button fw-bold fs-6 py-3" type="button" data-bs-toggle="collapse"
                                data-bs-target="#faq1">
                                What is IRS Form 941 and who is required to file it?
                            </button>
                        </h2>
                        <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                            <div class="accordion-body text-muted fs-7">
                                Form 941 (Employer's QUARTERLY Federal Tax Return) is used by employers to report
                                federal income tax withheld from employee wages, as well as the employer and employee
                                shares of Social Security and Medicare taxes. Most employers who pay wages subject to
                                federal tax withholding must file Form 941 quarterly.
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item border-0 border-bottom">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-bold fs-6 py-3" type="button"
                                data-bs-toggle="collapse" data-bs-target="#faq2">
                                When are the quarterly filing deadlines for Form 941?
                            </button>
                        </h2>
                        <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                            <div class="accordion-body text-muted fs-7">
                                Form 941 is due four times a year on the last day of the month following the end of the
                                quarter:
                                <ul class="mt-2 mb-0">
                                    <li><strong>Q1 (Jan - Mar):</strong> April 30</li>
                                    <li><strong>Q2 (Apr - Jun):</strong> July 31</li>
                                    <li><strong>Q3 (Jul - Sep):</strong> October 31</li>
                                    <li><strong>Q4 (Oct - Dec):</strong> January 31</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item border-0">
                        <h2 class="accordion-header">
                            <button class="accordion-button collapsed fw-bold fs-6 py-3" type="button"
                                data-bs-toggle="collapse" data-bs-target="#faq3">
                                What happens if the IRS rejects my e-filed Form 941?
                            </button>
                        </h2>
                        <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                            <div class="accordion-body text-muted fs-7">
                                If your return is rejected due to a name mismatch, incorrect EIN, or missing details,
                                eFile941 provides the exact IRS error code and description. You can fix the error and
                                re-transmit your return for free.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 9. FOOTER SECTION -->
        <footer class="footer-dark">
            <div class="container">
                <div class="row g-4 mb-5">
                    <div class="col-lg-4">
                        <a href="<%= request.getContextPath() %>/" class="brand-logo text-white mb-3 d-inline-block">
                            <i class="fas fa-file-invoice text-primary"></i> eFile941
                        </a>
                        <p class="fs-7 text-slate-400">
                            Official IRS-Authorized Modernized e-File (MeF) Provider offering fast, accurate, and secure
                            electronic filing solutions for Form 941 quarterly payroll tax returns.
                        </p>
                        <span class="badge bg-secondary bg-opacity-50 text-slate-200 fs-7 p-2 rounded">
                            <i class="fas fa-shield-alt text-primary me-1"></i> IRS Publication 1075 Security Compliant
                        </span>
                    </div>
                    <div class="col-6 col-lg-2 ms-auto">
                        <h5 class="text-white fs-6 fw-bold mb-3">Payroll Forms</h5>
                        <ul class="list-unstyled space-y-2 fs-7">
                            <li><a href="<%= request.getContextPath() %>/register">Form 941 (Quarterly Tax)</a></li>
                        </ul>
                    </div>
                    <div class="col-6 col-lg-2">
                        <h5 class="text-white fs-6 fw-bold mb-3">Quick Links</h5>
                        <ul class="list-unstyled space-y-2 fs-7">
                            <li><a href="<%= request.getContextPath() %>/login">Sign In</a></li>
                            <li><a href="<%= request.getContextPath() %>/register">Create Account</a></li>
                            <li><a href="#features">Features</a></li>
                            <li><a href="#pricing">Pricing</a></li>
                            <li><a href="#faq">FAQ</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-3">
                        <h5 class="text-white fs-6 fw-bold mb-3">Support & Legal</h5>
                        <p class="fs-7 text-slate-400 mb-1"><i class="fas fa-envelope text-primary me-2"></i>
                            support@efile941.com</p>
                        <p class="fs-7 text-slate-400 mb-3"><i class="fas fa-phone text-primary me-2"></i> (800)
                            555-0941</p>
                        <p class="fs-7 text-slate-400">&copy; 2026 eFile941 Portal. All rights reserved.</p>
                    </div>
                </div>
            </div>
        </footer>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Real-Time Tax Calculator Script -->
        <script>
            function calculatePreview() {
                var wages = parseFloat(document.getElementById('calcWages').value) || 0;
                var socSec = wages * 0.124;
                var medicare = wages * 0.029;
                var total = socSec + medicare;

                document.getElementById('calcSocSec').innerText = '$' + socSec.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                document.getElementById('calcMedicare').innerText = '$' + medicare.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                document.getElementById('calcTotal').innerText = '$' + total.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            }
        </script>
    </body>

    </html>