package com.company.irs941.model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

public class Form941 {
    private Long form941Id;
    private Long employerId;
    private Integer taxYearId;
    private Integer taxYear; // Useful display helper
    private Integer quarter;
    private Date filingPeriodStart;
    private Date filingPeriodEnd;
    private String status;
    private Long createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Boolean isAmended;
    private Map<String, String> lineValues = new HashMap<>();

    public Form941() {}

    public Long getForm941Id() {
        return form941Id;
    }

    public void setForm941Id(Long form941Id) {
        this.form941Id = form941Id;
    }

    // Alias for JSP EL convenience
    public Long getReturnId() {
        return form941Id;
    }

    public void setReturnId(Long returnId) {
        this.form941Id = returnId;
    }

    public Long getEmployerId() {
        return employerId;
    }

    public void setEmployerId(Long employerId) {
        this.employerId = employerId;
    }

    public Integer getTaxYearId() {
        return taxYearId;
    }

    public void setTaxYearId(Integer taxYearId) {
        this.taxYearId = taxYearId;
    }

    public Integer getTaxYear() {
        return taxYear;
    }

    public void setTaxYear(Integer taxYear) {
        this.taxYear = taxYear;
    }

    public Integer getQuarter() {
        return quarter;
    }

    public void setQuarter(Integer quarter) {
        this.quarter = quarter;
    }

    public Date getFilingPeriodStart() {
        return filingPeriodStart;
    }

    public void setFilingPeriodStart(Date filingPeriodStart) {
        this.filingPeriodStart = filingPeriodStart;
    }

    public Date getFilingPeriodEnd() {
        return filingPeriodEnd;
    }

    public void setFilingPeriodEnd(Date filingPeriodEnd) {
        this.filingPeriodEnd = filingPeriodEnd;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
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

    public Boolean getIsAmended() {
        return isAmended;
    }

    public void setIsAmended(Boolean isAmended) {
        this.isAmended = isAmended;
    }

    public Map<String, String> getLineValues() {
        return lineValues;
    }

    public void setLineValues(Map<String, String> lineValues) {
        this.lineValues = lineValues;
    }

    public String getLineValue(String key) {
        if (lineValues == null || key == null) return null;
        return lineValues.get(key);
    }

    public void setLineValue(String key, String value) {
        if (this.lineValues == null) {
            this.lineValues = new HashMap<>();
        }
        if (key != null) {
            this.lineValues.put(key, value);
        }
    }
}
