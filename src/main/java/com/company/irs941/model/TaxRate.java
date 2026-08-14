package com.company.irs941.model;

import java.math.BigDecimal;
import java.sql.Date;

public class TaxRate {
    private Integer taxRateId;
    private Integer taxYearId;
    private BigDecimal ssRate;
    private BigDecimal ssWageBase;
    private BigDecimal medicareRate;
    private BigDecimal addlMedicareRate;
    private Date effectiveFrom;
    private Date effectiveTo;

    public TaxRate() {}

    public Integer getTaxRateId() {
        return taxRateId;
    }

    public void setTaxRateId(Integer taxRateId) {
        this.taxRateId = taxRateId;
    }

    public Integer getTaxYearId() {
        return taxYearId;
    }

    public void setTaxYearId(Integer taxYearId) {
        this.taxYearId = taxYearId;
    }

    public BigDecimal getSsRate() {
        return ssRate;
    }

    public void setSsRate(BigDecimal ssRate) {
        this.ssRate = ssRate;
    }

    public BigDecimal getSsWageBase() {
        return ssWageBase;
    }

    public void setSsWageBase(BigDecimal ssWageBase) {
        this.ssWageBase = ssWageBase;
    }

    public BigDecimal getMedicareRate() {
        return medicareRate;
    }

    public void setMedicareRate(BigDecimal medicareRate) {
        this.medicareRate = medicareRate;
    }

    public BigDecimal getAddlMedicareRate() {
        return addlMedicareRate;
    }

    public void setAddlMedicareRate(BigDecimal addlMedicareRate) {
        this.addlMedicareRate = addlMedicareRate;
    }

    public Date getEffectiveFrom() {
        return effectiveFrom;
    }

    public void setEffectiveFrom(Date effectiveFrom) {
        this.effectiveFrom = effectiveFrom;
    }

    public Date getEffectiveTo() {
        return effectiveTo;
    }

    public void setEffectiveTo(Date effectiveTo) {
        this.effectiveTo = effectiveTo;
    }
}
