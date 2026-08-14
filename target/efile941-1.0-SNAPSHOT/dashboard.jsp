<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - E-File Portal</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">
        <style>
            .stat-card {
                border-radius: 12px;
                padding: 1.5rem;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .stat-icon-wrapper {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .stat-icon-blue {
                background: #EEF2FF;
                color: #4F46E5;
            }

            .stat-icon-green {
                background: #ECFDF5;
                color: #10B981;
            }

            .stat-icon-orange {
                background: #FFF7ED;
                color: #F97316;
            }

            .stat-icon-purple {
                background: #F5F3FF;
                color: #8B5CF6;
            }

            .stat-value {
                font-size: 2rem;
                font-weight: 700;
                color: var(--text-dark);
                margin: 0;
                line-height: 1;
            }

            .stat-label {
                color: #64748b;
                font-size: 0.875rem;
                font-weight: 500;
                margin-bottom: 4px;
            }

            .stat-bottom-text {
                color: #94a3b8;
                font-size: 0.75rem;
            }

            .mini-chart {
                width: 60px;
                height: 30px;
            }

            .table-card {
                border-radius: 12px;
                overflow: hidden;
                margin-bottom: 1.5rem;
            }

            .table-card-header {
                padding: 1.5rem;
                display: flex;
                align-items: flex-start;
                justify-content: space-between;
                border-bottom: 1px solid rgba(255, 255, 255, 0.4);
            }

            .table-icon {
                width: 40px;
                height: 40px;
                border-radius: 8px;
                background: #EEF2FF;
                color: #4F46E5;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 12px;
            }

            .table th {
                color: #64748b;
                font-weight: 600;
                font-size: 0.875rem;
                padding: 1rem 1.5rem;
                background: #F8FAFC;
                border-bottom: none;
            }

            .table td {
                padding: 1rem 1.5rem;
                vertical-align: middle;
                color: var(--text-dark);
                font-size: 0.9rem;
                border-bottom: 1px solid var(--sidebar-border);
            }

            .badge-draft {
                background: #FFF7ED;
                color: #F97316;
                border: 1px solid #FFEDD5;
            }

            .action-link {
                color: #2563EB;
                font-weight: 500;
                text-decoration: none;
                font-size: 0.9rem;
            }

            .action-link:hover {
                text-decoration: underline;
            }
        </style>
    </head>

    <body>
        <div class="d-flex">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

            <!-- Main Content Wrapper -->
            <div class="main-wrapper" style="background: transparent;">
                <!-- Header -->
                <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

                <!-- Dashboard Content -->
                <div class="content-area p-4" style="max-width: 1200px; margin: 0 auto;">

                    <!-- Stat Cards Row -->
                    <div class="row g-4 mb-4">
                        <!-- Total Filings -->
                        <div class="col-md-3">
                            <div class="stat-card glass-panel h-100">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="d-flex gap-3">
                                        <div class="stat-icon-wrapper stat-icon-blue">
                                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z">
                                                </path>
                                                <polyline points="14 2 14 8 20 8"></polyline>
                                                <line x1="16" y1="13" x2="8" y2="13"></line>
                                                <line x1="16" y1="17" x2="8" y2="17"></line>
                                                <polyline points="10 9 9 9 8 9"></polyline>
                                            </svg>
                                        </div>
                                        <div>
                                            <div class="stat-label">Total Filings</div>
                                            <div class="stat-value">1</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-end mt-2">
                                    <span class="stat-bottom-text">All time filings</span>
                                    <svg class="mini-chart" viewBox="0 0 60 30" preserveAspectRatio="none">
                                        <path d="M0 25 L15 20 L30 25 L45 10 L60 5" fill="none" stroke="#4F46E5"
                                            stroke-width="2" />
                                    </svg>
                                </div>
                            </div>
                        </div>
                        <!-- In Progress -->
                        <div class="col-md-3">
                            <div class="stat-card glass-panel h-100">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="d-flex gap-3">
                                        <div class="stat-icon-wrapper stat-icon-green">
                                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                        </div>
                                        <div>
                                            <div class="stat-label">In Progress</div>
                                            <div class="stat-value">1</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-end mt-2">
                                    <span class="stat-bottom-text">Draft filings</span>
                                    <svg class="mini-chart" viewBox="0 0 60 30" preserveAspectRatio="none">
                                        <path d="M0 25 L15 25 L30 20 L45 15 L60 5" fill="none" stroke="#10B981"
                                            stroke-width="2" />
                                    </svg>
                                </div>
                            </div>
                        </div>
                        <!-- Employers -->
                        <div class="col-md-3">
                            <div class="stat-card glass-panel h-100">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="d-flex gap-3">
                                        <div class="stat-icon-wrapper stat-icon-orange">
                                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="9" cy="7" r="4"></circle>
                                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                            </svg>
                                        </div>
                                        <div>
                                            <div class="stat-label">Employers</div>
                                            <div class="stat-value">1</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-end mt-2">
                                    <span class="stat-bottom-text">Registered</span>
                                    <svg class="mini-chart" viewBox="0 0 60 30" preserveAspectRatio="none">
                                        <path d="M0 20 L15 25 L30 15 L45 10 L60 5" fill="none" stroke="#F97316"
                                            stroke-width="2" />
                                    </svg>
                                </div>
                            </div>
                        </div>
                        <!-- Completed -->
                        <div class="col-md-3">
                            <div class="stat-card glass-panel h-100">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div class="d-flex gap-3">
                                        <div class="stat-icon-wrapper stat-icon-purple">
                                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                            </svg>
                                        </div>
                                        <div>
                                            <div class="stat-label">Completed</div>
                                            <div class="stat-value">0</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-end mt-2">
                                    <span class="stat-bottom-text">Filed successfully</span>
                                    <svg class="mini-chart" viewBox="0 0 60 30" preserveAspectRatio="none">
                                        <path d="M0 25 L15 25 L30 25 L45 20 L60 15" fill="none" stroke="#8B5CF6"
                                            stroke-width="2" />
                                    </svg>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Filings Card -->
                    <div class="table-card glass-panel">
                        <div class="table-card-header">
                            <div class="d-flex">
                                <div class="table-icon">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                        <polyline points="10 9 9 9 8 9"></polyline>
                                    </svg>
                                </div>
                                <div>
                                    <h5 class="m-0 fw-bold" style="color: var(--text-dark);">Recent Filings</h5>
                                    <small class="text-muted">Your most recent filing activity.</small>
                                </div>
                            </div>
                            <a href="<%= request.getContextPath() %>/form941/step1.jsp"
                                class="btn btn-outline-primary btn-sm px-3 py-2 d-flex align-items-center gap-2 rounded-pill"
                                style="color: #2563EB; border-color: #E2E8F0; font-weight: 500;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                                Start New Filing
                            </a>
                        </div>
                        <div class="table-responsive">
                            <table class="table mb-0">
                                <thead>
                                    <tr>
                                        <th style="padding-left: 1.5rem;">Date</th>
                                        <th>Organization Name</th>
                                        <th>EIN</th>
                                        <th>Tax Year</th>
                                        <th>Quarter</th>
                                        <th>Status</th>
                                        <th class="text-end" style="padding-right: 1.5rem;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td style="padding-left: 1.5rem;">
                                            <div class="d-flex align-items-center gap-2">
                                                <div
                                                    style="width: 32px; height: 32px; background: #F8FAFC; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                        stroke="#64748b" stroke-width="2">
                                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                                    </svg>
                                                </div>
                                                07-30-2026
                                            </div>
                                        </td>
                                        <td style="color: #2563EB; font-weight: 500;">SAMPLE BUSINESS INC</td>
                                        <td>12-3456789</td>
                                        <td>2026</td>
                                        <td>Q1</td>
                                        <td><span class="badge badge-draft rounded-pill px-3 py-2">Draft</span></td>
                                        <td class="text-end" style="padding-right: 1.5rem;">
                                            <a href="<%= request.getContextPath() %>/form941/step5.jsp"
                                                class="btn btn-outline-primary btn-sm px-3 rounded-pill"
                                                style="color: #2563EB; border-color: #BFDBFE;">Resume</a>
                                            <button class="btn btn-sm text-muted ms-1"><svg width="16" height="16"
                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <circle cx="12" cy="12" r="1"></circle>
                                                    <circle cx="12" cy="5" r="1"></circle>
                                                    <circle cx="12" cy="19" r="1"></circle>
                                                </svg></button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="p-3 text-center" style="border-top: 1px solid var(--sidebar-border);">
                            <a href="<%= request.getContextPath() %>/filings/list.jsp"
                                class="action-link d-flex align-items-center justify-content-center gap-2">
                                View all filings <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </a>
                        </div>
                    </div>

                    <!-- My Employers Card -->
                    <div class="table-card glass-panel">
                        <div class="table-card-header">
                            <div class="d-flex">
                                <div class="table-icon">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                        stroke-width="2">
                                        <path d="M3 21h18"></path>
                                        <path d="M19 21v-4"></path>
                                        <path d="M5 21v-4"></path>
                                        <path d="M9 21V9h6v12"></path>
                                        <path d="M9 5h6"></path>
                                        <path d="M12 9v12"></path>
                                    </svg>
                                </div>
                                <div>
                                    <h5 class="m-0 fw-bold" style="color: var(--text-dark);">My Businesses</h5>
                                    <small class="text-muted">Manage your registered Business.</small>
                                </div>
                            </div>
                            <a href="<%= request.getContextPath() %>/employer/edit.jsp"
                                class="btn btn-primary btn-sm px-3 py-2 d-flex align-items-center gap-2 rounded-pill"
                                style="background-color: #2563EB; border: none; font-weight: 500;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white"
                                    stroke-width="2">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                                Add New Employer
                            </a>
                        </div>
                        <div class="table-responsive">
                            <table class="table mb-0">
                                <thead>
                                    <tr>
                                        <th style="padding-left: 1.5rem;">Name</th>
                                        <th>EIN</th>
                                        <th>Contact</th>
                                        <th class="text-end" style="padding-right: 1.5rem;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td style="padding-left: 1.5rem;">
                                            <div class="d-flex align-items-center gap-3">
                                                <div
                                                    style="width: 40px; height: 40px; background: #EEF2FF; color: #4F46E5; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <path d="M3 21h18"></path>
                                                        <path d="M9 21V9h6v12"></path>
                                                        <path d="M9 5h6"></path>
                                                    </svg>
                                                </div>
                                                <span style="color: #2563EB; font-weight: 500;">SAMPLE BUSINESS
                                                    INC</span>
                                            </div>
                                        </td>
                                        <td>12-3456789</td>
                                        <td>contact@sample.com</td>
                                        <td class="text-end" style="padding-right: 1.5rem;">
                                            <a href="#" class="btn btn-outline-primary btn-sm px-4 rounded-pill"
                                                style="color: #2563EB; border-color: #BFDBFE;">Edit</a>
                                            <button class="btn btn-sm text-muted ms-1"><svg width="16" height="16"
                                                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                    stroke-width="2">
                                                    <circle cx="12" cy="12" r="1"></circle>
                                                    <circle cx="12" cy="5" r="1"></circle>
                                                    <circle cx="12" cy="19" r="1"></circle>
                                                </svg></button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="p-3 text-center" style="border-top: 1px solid var(--sidebar-border);">
                            <a href="<%= request.getContextPath() %>/employer/list.jsp"
                                class="action-link d-flex align-items-center justify-content-center gap-2">
                                View all employers <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                    stroke="currentColor" stroke-width="2">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </a>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>