package com.company.irs941.model;

import java.math.BigDecimal;

public class Form941TaxLiabilityBreakdown {
    private Long breakdownId;
    private Long form941Id;
    private String taxType;
    private BigDecimal taxableWages;
    private BigDecimal taxRate;
    private BigDecimal taxAmount;

    public Form941TaxLiabilityBreakdown() {}

    public Long getBreakdownId() {
        return breakdownId;
    }

    public void setBreakdownId(Long breakdownId) {
        this.breakdownId = breakdownId;
    }

    public Long getForm941Id() {
        return form941Id;
    }

    public void setForm941Id(Long form941Id) {
        this.form941Id = form941Id;
    }

    public String getTaxType() {
        return taxType;
    }

    public void setTaxType(String taxType) {
        this.taxType = taxType;
    }

    public BigDecimal getTaxableWages() {
        return taxableWages;
    }

    public void setTaxableWages(BigDecimal taxableWages) {
        this.taxableWages = taxableWages;
    }

    public BigDecimal getTaxRate() {
        return taxRate;
    }

    public void setTaxRate(BigDecimal taxRate) {
        this.taxRate = taxRate;
    }

    public BigDecimal getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(BigDecimal taxAmount) {
        this.taxAmount = taxAmount;
    }
}
