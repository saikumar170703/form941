package com.company.irs941.controller;

import com.company.irs941.config.PaymentConfigProperties;
import com.company.irs941.dto.PaymentRequestDTO;
import com.company.irs941.service.AuthorizeNetPaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * Payment Controller for Authorize.Net Integration
 */
@Controller
public class PaymentController {

    @Autowired
    private AuthorizeNetPaymentService paymentService;

    @Autowired(required = false)
    private PaymentConfigProperties paymentConfig;

    @PostMapping(value = "/payment/process", produces = "application/json")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> processPayment(@RequestBody PaymentRequestDTO request, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "User session expired. Please log in again.");
            return ResponseEntity.status(401).body(err);
        }

        if (request.getAmount() == null && paymentConfig != null) {
            request.setAmount(paymentConfig.getFilingFee());
        }

        Map<String, Object> result = paymentService.processPayment(request, userId);
        return ResponseEntity.ok(result);
    }

    @GetMapping(value = "/payment/config", produces = "application/json")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getPaymentConfig() {
        Map<String, Object> cfg = new HashMap<>();
        cfg.put("clientKey", (paymentConfig != null) ? paymentConfig.getClientKey() : "CLIENT_KEY_HERE");
        cfg.put("apiLoginId", (paymentConfig != null) ? paymentConfig.getApiLoginId() : "API_LOGIN_ID_HERE");
        cfg.put("environment", (paymentConfig != null) ? paymentConfig.getEnvironment() : "SANDBOX");
        cfg.put("filingFee", (paymentConfig != null) ? paymentConfig.getFilingFee() : new BigDecimal("19.99"));
        return ResponseEntity.ok(cfg);
    }
}
