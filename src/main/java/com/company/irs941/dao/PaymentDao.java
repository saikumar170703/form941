package com.company.irs941.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.company.irs941.model.Payment;

@Repository
public class PaymentDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final RowMapper<Payment> PAYMENT_ROW_MAPPER = new RowMapper<Payment>() {
        @Override
        public Payment mapRow(ResultSet rs, int rowNum) throws SQLException {
            Payment p = new Payment();
            p.setPaymentId(rs.getLong("payment_id"));
            p.setForm941Id(rs.getObject("form941_id") != null ? rs.getLong("form941_id") : null);
            p.setPaymentDate(rs.getDate("payment_date"));
            p.setPaymentType(rs.getString("payment_type"));
            p.setAmount(rs.getBigDecimal("amount"));
            p.setPaymentMethod(rs.getString("payment_method"));
            p.setTransactionReference(rs.getString("transaction_reference"));
            p.setCreatedAt(rs.getTimestamp("created_at"));
            p.setUpdatedAt(rs.getTimestamp("updated_at"));
            return p;
        }
    };

    public List<Payment> findAll() {
        String sql = "SELECT * FROM payments ORDER BY created_at DESC";
        return jdbcTemplate.query(sql, PAYMENT_ROW_MAPPER);
    }

    public Payment recordPayment(Payment payment) {
        String sql = "INSERT INTO payments (form941_id, payment_date, payment_type, amount, payment_method, transaction_reference, created_at, updated_at) " +
                     "VALUES (?, CURRENT_DATE, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING payment_id";
        Long id = jdbcTemplate.queryForObject(sql, Long.class,
                payment.getForm941Id(), payment.getPaymentType(), payment.getAmount(),
                payment.getPaymentMethod(), payment.getTransactionReference());
        payment.setPaymentId(id);
        return payment;
    }
}
