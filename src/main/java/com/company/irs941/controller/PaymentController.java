package com.company.irs941.controller;

import java.math.BigDecimal;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.company.irs941.model.Payment;
import com.company.irs941.service.PaymentService;

@Controller
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @GetMapping("/payments/list")
    public String listPayments(Model model) {
        List<Payment> payments = paymentService.getAllPayments();
        model.addAttribute("payments", payments);
        return "payments/list";
    }

    @PostMapping("/payments/record")
    public String recordPayment(@RequestParam(value = "form941Id", required = false) Long form941Id,
                                @RequestParam("paymentType") String paymentType,
                                @RequestParam("paymentMethod") String paymentMethod,
                                @RequestParam("amount") BigDecimal amount,
                                @RequestParam("refNumber") String refNumber,
                                HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        Payment p = new Payment();
        p.setForm941Id(form941Id != null ? form941Id : 1L);
        p.setPaymentType(paymentType);
        p.setPaymentMethod(paymentMethod);
        p.setAmount(amount);
        p.setTransactionReference(refNumber);
        paymentService.recordPayment(p, userId != null ? userId : 1L);
        return "redirect:/payments/list";
    }
}
