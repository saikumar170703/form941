<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="displayName"
            value="${not empty sessionScope.userFirstName ? sessionScope.userFirstName : (not empty sessionScope.username ? sessionScope.username : 'User')}" />

        <!-- Global Step & API Processing Loading Overlay -->
        <div class="loader-overlay" id="globalLoadingOverlay">
            <div class="loader-spinner-wrapper">
                <div class="loader-spinner"></div>
                <div class="loader-logo-icon">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5"
                        stroke-linecap="round" stroke-linejoin="round">
                        <path
                            d="M14 2H6C4.89543 2 4 2.89543 4 4V20C4 21.1046 4.89543 22 6 22H18C19.1046 22 20 21.1046 20 20V8L14 2Z" />
                        <path d="M14 2V8H20" />
                        <path d="M16 13H8" />
                        <path d="M16 17H8" />
                    </svg>
                </div>
            </div>
            <div class="loader-title" id="loaderTitle">Processing Form 941...</div>
            <div class="loader-subtitle" id="loaderSubtitle">Saving return data & communicating with server</div>
        </div>

        <div class="topbar w-100 glass-panel" style="min-height: 70px; border-bottom: none !important;">
            <div class="d-flex align-items-center gap-3 ms-2 ms-md-4">
                <!-- Mobile Sidebar Toggle Button -->
                <button type="button" class="btn btn-light border d-lg-none p-2 rounded-3 text-secondary shadow-sm"
                    onclick="toggleSidebar()" aria-label="Toggle navigation">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                        stroke-linecap="round" stroke-linejoin="round">
                        <line x1="3" y1="12" x2="21" y2="12"></line>
                        <line x1="3" y1="6" x2="21" y2="6"></line>
                        <line x1="3" y1="18" x2="21" y2="18"></line>
                    </svg>
                </button>

                <div>
                    <h4 class="m-0 fw-bold" style="color: var(--text-dark); font-size: calc(1.1rem + 0.3vw);">Hi!
                        ${displayName} 👋</h4>
                    <small class="text-muted d-none d-sm-inline">Here's an overview of your account.</small>
                </div>
            </div>

            <div class="d-flex align-items-center gap-3 me-2 me-md-4">
                <!-- Bell Icon -->
                <div class="position-relative p-2 rounded-circle hover-bg-light" style="cursor: pointer;">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#64748b" stroke-width="2"
                        stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                    <span
                        class="position-absolute top-0 start-100 translate-middle p-1 border rounded-circle"
                        style="width: 10px; height: 10px; background-color: #90EE90 !important; border-color: #172017 !important;">
                        <span class="visually-hidden">New alerts</span>
                    </span>
                </div>

                <div class="dropdown">
                    <a href="#" class="d-flex align-items-center link-dark text-decoration-none dropdown-toggle gap-2"
                        id="dropdownUser" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="https://github.com/mdo.png" alt="User Profile" width="36" height="36"
                            class="rounded-circle border">
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end text-small shadow border-0 mt-2"
                        aria-labelledby="dropdownUser">
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/account">Profile</a></li>
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/account">Settings</a></li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item text-danger" href="<%= request.getContextPath() %>/logout">Sign out</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <script>
            function showLoadingOverlay(titleText, subtitleText) {
                const overlay = document.getElementById('globalLoadingOverlay');
                const title = document.getElementById('loaderTitle');
                const subtitle = document.getElementById('loaderSubtitle');
                if (overlay) {
                    if (titleText && title) title.innerText = titleText;
                    if (subtitleText && subtitle) subtitle.innerText = subtitleText;
                    overlay.classList.add('show');
                }
            }

            function hideLoadingOverlay() {
                const overlay = document.getElementById('globalLoadingOverlay');
                if (overlay) overlay.classList.remove('show');
            }

            document.addEventListener('DOMContentLoaded', function () {
                // Automatically trigger smooth loading spinner animation whenever form steps are submitted
                document.querySelectorAll('form').forEach(function (form) {
                    form.addEventListener('submit', function (e) {
                        // If form is valid or submit hasn't been cancelled by step validation
                        setTimeout(function () {
                            if (!e.defaultPrevented) {
                                showLoadingOverlay('Processing to Next Step...', 'Validating details and submitting request to server');
                            }
                        }, 50);
                    });
                });

                // Hide overlay on page back/forward navigation
                window.addEventListener('pageshow', function (event) {
                    hideLoadingOverlay();
                });
            });
        </script>