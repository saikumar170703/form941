<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="uri" value="${pageContext.request.requestURI}" />

<!-- Mobile Sidebar Backdrop Overlay -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

<!-- Main Sidebar Container -->
<div class="sidebar d-flex flex-column flex-shrink-0" id="mainSidebar">
    <div class="p-3 border-bottom d-flex align-items-center justify-content-between" style="border-color: rgba(226,232,240,0.8) !important;">
        <div class="d-flex align-items-center gap-2">
            <div style="background: #2563EB; width: 34px; height: 34px; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M14 2H6C4.89543 2 4 2.89543 4 4V20C4 21.1046 4.89543 22 6 22H18C19.1046 22 20 21.1046 20 20V8L14 2Z" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                    <path d="M14 2V8H20" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                    <path d="M16 13H8" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                    <path d="M16 17H8" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                    <path d="M10 9H9H8" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
            </div>
            <div>
                <h5 class="m-0 text-dark" style="font-weight: 700; line-height: 1.2;">e-File941</h5>
                <small style="color: #64748b; font-size: 0.72rem;">IRS eFile Portal</small>
            </div>
        </div>
        <!-- Close button for Mobile Screen -->
        <button type="button" class="btn-close d-lg-none text-reset p-2" onclick="toggleSidebar()" aria-label="Close"></button>
    </div>

    <ul class="nav nav-pills flex-column mb-auto pt-3">
        <!-- Dashboard Link -->
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/dashboard"
                class="nav-link ${uri.contains('/dashboard') ? 'active' : ''}">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                    <polyline points="9 22 9 12 15 12 15 22"></polyline>
                </svg>
                Dashboard
            </a>
        </li>

        <!-- My Businesses Link -->
        <li>
            <a href="<%= request.getContextPath() %>/employer/list"
                class="nav-link ${uri.contains('/employer') ? 'active' : ''}">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
                My Businesses
            </a>
        </li>

        <!-- My Filings Link -->
        <li>
            <a href="<%= request.getContextPath() %>/filings"
                class="nav-link ${uri.contains('/filings') || uri.contains('/form941') ? 'active' : ''}">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                </svg>
                My Filings
            </a>
        </li>

        <!-- My Account Link -->
        <li>
            <a href="<%= request.getContextPath() %>/account"
                class="nav-link ${uri.contains('/account') ? 'active' : ''}">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <path d="M12 16v-4"></path>
                    <path d="M12 8h.01"></path>
                </svg>
                My Account
            </a>
        </li>
    </ul>

    <div class="p-3 mx-2 mb-3 glass-panel" style="border-radius: 12px; text-align: center;">
        <div style="background: rgba(37, 99, 235, 0.15); width: 40px; height: 40px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px; color: #2563EB;">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path>
            </svg>
        </div>
        <h6 class="fw-bold" style="color: var(--text-dark); margin-bottom: 4px;">Need Help?</h6>
        <p class="text-muted" style="font-size: 0.78rem; margin-bottom: 12px;">IRS Form 941 eFile Portal</p>
    </div>

    <div class="p-3 border-top d-flex align-items-center gap-2 text-muted justify-content-center" style="border-color: rgba(226,232,240,0.8) !important; font-size: 0.85rem;">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
        </svg>
        Application Version <strong>1.0.0</strong>
    </div>
</div>

<script>
    function toggleSidebar() {
        const sb = document.getElementById('mainSidebar');
        const overlay = document.getElementById('sidebarOverlay');
        if (sb && overlay) {
            sb.classList.toggle('show');
            overlay.classList.toggle('show');
        }
    }
</script>