package com.company.irs941.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * Authentication Interceptor with OWASP Security Headers Enforcer
 */
public class AuthInterceptor implements HandlerInterceptor {

    private static final Logger logger = LogManager.getLogger(AuthInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // Enforce OWASP Security Headers on all HTTP responses
        response.setHeader("X-Frame-Options", "SAMEORIGIN");
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("X-XSS-Protection", "1; mode=block");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // Allow public static resources, authentication endpoints, and internal WEB-INF view forwards
        if (path.isEmpty() || path.equals("") || path.equals("/") || path.equals("/index") || path.equals("/index.jsp") || path.equals("/home") || path.equals("/index.html") || path.equals("/landing") || 
            path.startsWith("/login") || path.startsWith("/register") || path.startsWith("/auth/") || path.startsWith("/oauth2/") ||
            path.equals("/health") || path.equals("/payment/config") ||
            path.startsWith("/assets/") || path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/") ||
            path.startsWith("/WEB-INF/")) {
            return true;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || session.getAttribute("user") == null) {
            logger.warn("[AUTH INTERCEPTOR] Unauthorized access attempt to URI: {} from IP: {}. Redirecting to /login", path, request.getRemoteAddr());
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        return true;
    }
}
