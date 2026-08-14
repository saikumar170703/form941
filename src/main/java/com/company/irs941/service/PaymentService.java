package com.company.irs941.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.irs941.dao.PaymentDao;
import com.company.irs941.model.Payment;

@Service
public class PaymentService {

    @Autowired
    private PaymentDao paymentDao;

    @Autowired
    private AuditLogService auditLogService;

    public List<Payment> getAllPayments() {
        return paymentDao.findAll();
    }

    public Payment recordPayment(Payment payment, Long userId) {
        Payment saved = paymentDao.recordPayment(payment);
        auditLogService.log("payments", saved.getPaymentId(), "RECORD_PAYMENT", userId,
                "Tax payment recorded: $" + saved.getAmount() + " via " + saved.getPaymentMethod());
        return saved;
    }
}
