package com.company.irs941.filter;

import java.io.IOException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RequestLoggingFilter implements Filter {

    private static final Logger logger = LogManager.getLogger(RequestLoggingFilter.class);

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        logger.info("RequestLoggingFilter initialized successfully.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (request instanceof HttpServletRequest httpRequest && response instanceof HttpServletResponse httpResponse) {
            long startTime = System.currentTimeMillis();
            String method = httpRequest.getMethod();
            String uri = httpRequest.getRequestURI();
            String queryString = httpRequest.getQueryString() != null ? "?" + httpRequest.getQueryString() : "";
            String remoteAddr = httpRequest.getRemoteAddr();

            logger.info("[HTTP REQUEST] {} {}{} from IP: {}", method, uri, queryString, remoteAddr);

            try {
                chain.doFilter(request, response);
            } catch (Exception ex) {
                long duration = System.currentTimeMillis() - startTime;
                logger.error("[HTTP ERROR] {} {}{} failed after {}ms - Exception: {}", 
                        method, uri, queryString, duration, ex.getMessage(), ex);
                throw ex;
            } finally {
                long duration = System.currentTimeMillis() - startTime;
                int status = httpResponse.getStatus();
                if (status >= 400) {
                    logger.warn("[HTTP RESPONSE] {} {}{} -> Status: {} (Took {}ms)", method, uri, queryString, status, duration);
                } else {
                    logger.info("[HTTP RESPONSE] {} {}{} -> Status: {} (Took {}ms)", method, uri, queryString, status, duration);
                }
            }
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        logger.info("RequestLoggingFilter destroyed.");
    }
}
