package com.company.irs941.config;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import jakarta.servlet.http.HttpServletRequest;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LogManager.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(Exception.class)
    public String handleAllExceptions(Exception ex, HttpServletRequest request, Model model) {
        String requestUri = request.getRequestURI();
        String method = request.getMethod();

        logger.error("[GLOBAL EXCEPTION] Unhandled exception occurred processing {} {}: {}", 
                method, requestUri, ex.getMessage(), ex);

        model.addAttribute("errorMessage", "An unexpected system error occurred: " + ex.getMessage());
        model.addAttribute("exceptionType", ex.getClass().getSimpleName());
        model.addAttribute("requestUri", requestUri);

        return "error";
    }
}
