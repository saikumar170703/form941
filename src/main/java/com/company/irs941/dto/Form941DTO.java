package com.company.irs941.dto;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class Form941DTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long form941Id;
    private Long employerId;
    private Integer taxYear;
    private Integer quarter;
    private String status = "DRAFT";
    private Map<String, String> lineValues = new HashMap<>();

    public Form941DTO() {}

    public Long getForm941Id() {
        return form941Id;
    }

    public void setForm941Id(Long form941Id) {
        this.form941Id = form941Id;
    }

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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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
