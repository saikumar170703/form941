package com.company.irs941.model;

public class TaxYear {
    private Integer taxYearId;
    private Integer year;
    private String status;

    public TaxYear() {}

    public TaxYear(Integer taxYearId, Integer year, String status) {
        this.taxYearId = taxYearId;
        this.year = year;
        this.status = status;
    }

    public Integer getTaxYearId() {
        return taxYearId;
    }

    public void setTaxYearId(Integer taxYearId) {
        this.taxYearId = taxYearId;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
