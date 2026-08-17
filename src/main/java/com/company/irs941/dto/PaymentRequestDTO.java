package com.company.irs941.dto;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Payment Request DTO for Authorize.Net Card Transactions
 */
public class PaymentRequestDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long form941Id;
    private BigDecimal amount;
    private String cardNumber;
    private String expirationMonth; // MM (01-12)
    private String expirationYear;  // YY or YYYY
    private String cvv;
    private String cardholderName;
    private String address;
    private String city;
    private String state;
    private String zip;

    public PaymentRequestDTO() {}

    public Long getForm941Id() { return form941Id; }
    public void setForm941Id(Long form941Id) { this.form941Id = form941Id; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getCardNumber() { return cardNumber; }
    public void setCardNumber(String cardNumber) { this.cardNumber = cardNumber; }

    public String getExpirationMonth() { return expirationMonth; }
    public void setExpirationMonth(String expirationMonth) { this.expirationMonth = expirationMonth; }

    public String getExpirationYear() { return expirationYear; }
    public void setExpirationYear(String expirationYear) { this.expirationYear = expirationYear; }

    public String getCvv() { return cvv; }
    public void setCvv(String cvv) { this.cvv = cvv; }

    public String getCardholderName() { return cardholderName; }
    public void setCardholderName(String cardholderName) { this.cardholderName = cardholderName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getZip() { return zip; }
    public void setZip(String zip) { this.zip = zip; }
}
