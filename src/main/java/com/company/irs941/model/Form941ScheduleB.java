package com.company.irs941.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Form941ScheduleB {
    private Long schedulebId;
    private Long form941Id;
    private Integer monthNumber;
    private BigDecimal depositAmount;
    private Timestamp createdAt;

    public Form941ScheduleB() {}

    public Long getSchedulebId() {
        return schedulebId;
    }

    public void setSchedulebId(Long schedulebId) {
        this.schedulebId = schedulebId;
    }

    public Long getForm941Id() {
        return form941Id;
    }

    public void setForm941Id(Long form941Id) {
        this.form941Id = form941Id;
    }

    public Integer getMonthNumber() {
        return monthNumber;
    }

    public void setMonthNumber(Integer monthNumber) {
        this.monthNumber = monthNumber;
    }

    public BigDecimal getDepositAmount() {
        return depositAmount;
    }

    public void setDepositAmount(BigDecimal depositAmount) {
        this.depositAmount = depositAmount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
