package com.company.irs941.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Form941Detail {
    private Long detailId;
    private Long form941Id;
    private BigDecimal line1TotalWagesTips;
    private BigDecimal line2FederalIncomeTax;
    private BigDecimal line3SocialSecurityWages;
    private BigDecimal line4SocialSecurityTax;
    private BigDecimal line5MedicareWagesTips;
    private BigDecimal line6MedicareTax;
    private BigDecimal line7AdditionalMedicareTax;
    private BigDecimal line8TotalTaxBeforeAdj;
    private BigDecimal line9AdvanceEicPayments;
    private BigDecimal line10TotalTaxAfterAdj;
    private BigDecimal line11TotalDeposits;
    private BigDecimal line12BalanceDue;
    private BigDecimal line13Overpayment;
    private BigDecimal line14OverpaymentApplied;
    private BigDecimal line15BalanceDueAfter;
    private BigDecimal line16TotalCredits;
    private BigDecimal line17TotalPayments;
    private BigDecimal line18TotalDeposit;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Form941Detail() {}

    public Long getDetailId() {
        return detailId;
    }

    public void setDetailId(Long detailId) {
        this.detailId = detailId;
    }

    public Long getForm941Id() {
        return form941Id;
    }

    public void setForm941Id(Long form941Id) {
        this.form941Id = form941Id;
    }

    public BigDecimal getLine1TotalWagesTips() {
        return line1TotalWagesTips;
    }

    public void setLine1TotalWagesTips(BigDecimal line1TotalWagesTips) {
        this.line1TotalWagesTips = line1TotalWagesTips;
    }

    public BigDecimal getLine2FederalIncomeTax() {
        return line2FederalIncomeTax;
    }

    public void setLine2FederalIncomeTax(BigDecimal line2FederalIncomeTax) {
        this.line2FederalIncomeTax = line2FederalIncomeTax;
    }

    public BigDecimal getLine3SocialSecurityWages() {
        return line3SocialSecurityWages;
    }

    public void setLine3SocialSecurityWages(BigDecimal line3SocialSecurityWages) {
        this.line3SocialSecurityWages = line3SocialSecurityWages;
    }

    public BigDecimal getLine4SocialSecurityTax() {
        return line4SocialSecurityTax;
    }

    public void setLine4SocialSecurityTax(BigDecimal line4SocialSecurityTax) {
        this.line4SocialSecurityTax = line4SocialSecurityTax;
    }

    public BigDecimal getLine5MedicareWagesTips() {
        return line5MedicareWagesTips;
    }

    public void setLine5MedicareWagesTips(BigDecimal line5MedicareWagesTips) {
        this.line5MedicareWagesTips = line5MedicareWagesTips;
    }

    public BigDecimal getLine6MedicareTax() {
        return line6MedicareTax;
    }

    public void setLine6MedicareTax(BigDecimal line6MedicareTax) {
        this.line6MedicareTax = line6MedicareTax;
    }

    public BigDecimal getLine7AdditionalMedicareTax() {
        return line7AdditionalMedicareTax;
    }

    public void setLine7AdditionalMedicareTax(BigDecimal line7AdditionalMedicareTax) {
        this.line7AdditionalMedicareTax = line7AdditionalMedicareTax;
    }

    public BigDecimal getLine8TotalTaxBeforeAdj() {
        return line8TotalTaxBeforeAdj;
    }

    public void setLine8TotalTaxBeforeAdj(BigDecimal line8TotalTaxBeforeAdj) {
        this.line8TotalTaxBeforeAdj = line8TotalTaxBeforeAdj;
    }

    public BigDecimal getLine9AdvanceEicPayments() {
        return line9AdvanceEicPayments;
    }

    public void setLine9AdvanceEicPayments(BigDecimal line9AdvanceEicPayments) {
        this.line9AdvanceEicPayments = line9AdvanceEicPayments;
    }

    public BigDecimal getLine10TotalTaxAfterAdj() {
        return line10TotalTaxAfterAdj;
    }

    public void setLine10TotalTaxAfterAdj(BigDecimal line10TotalTaxAfterAdj) {
        this.line10TotalTaxAfterAdj = line10TotalTaxAfterAdj;
    }

    public BigDecimal getLine11TotalDeposits() {
        return line11TotalDeposits;
    }

    public void setLine11TotalDeposits(BigDecimal line11TotalDeposits) {
        this.line11TotalDeposits = line11TotalDeposits;
    }

    public BigDecimal getLine12BalanceDue() {
        return line12BalanceDue;
    }

    public void setLine12BalanceDue(BigDecimal line12BalanceDue) {
        this.line12BalanceDue = line12BalanceDue;
    }

    public BigDecimal getLine13Overpayment() {
        return line13Overpayment;
    }

    public void setLine13Overpayment(BigDecimal line13Overpayment) {
        this.line13Overpayment = line13Overpayment;
    }

    public BigDecimal getLine14OverpaymentApplied() {
        return line14OverpaymentApplied;
    }

    public void setLine14OverpaymentApplied(BigDecimal line14OverpaymentApplied) {
        this.line14OverpaymentApplied = line14OverpaymentApplied;
    }

    public BigDecimal getLine15BalanceDueAfter() {
        return line15BalanceDueAfter;
    }

    public void setLine15BalanceDueAfter(BigDecimal line15BalanceDueAfter) {
        this.line15BalanceDueAfter = line15BalanceDueAfter;
    }

    public BigDecimal getLine16TotalCredits() {
        return line16TotalCredits;
    }

    public void setLine16TotalCredits(BigDecimal line16TotalCredits) {
        this.line16TotalCredits = line16TotalCredits;
    }

    public BigDecimal getLine17TotalPayments() {
        return line17TotalPayments;
    }

    public void setLine17TotalPayments(BigDecimal line17TotalPayments) {
        this.line17TotalPayments = line17TotalPayments;
    }

    public BigDecimal getLine18TotalDeposit() {
        return line18TotalDeposit;
    }

    public void setLine18TotalDeposit(BigDecimal line18TotalDeposit) {
        this.line18TotalDeposit = line18TotalDeposit;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
