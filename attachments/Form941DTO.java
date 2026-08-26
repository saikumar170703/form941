package com.irs.form941.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * Data Transfer Object for Form 941 - Employer's Quarterly Federal Tax Return
 * Maps to IRS XML Schema for e-file submission
 */
@XmlRootElement(name = "Form941")
public class Form941DTO {
    
    // PART 1: Employer Information
    private String ein; // Employer Identification Number (required)
    private String businessName; // Name (not trade name) - required
    private String tradeName; // Trade name (optional)
    private String addressStreet; // Street address - required
    private String addressSuite; // Suite/room number (optional)
    private String addressCity; // City - required
    private String addressState; // State - required
    private String addressZip; // ZIP code - required
    private String foreignCountry; // For foreign addresses
    private String foreignProvince; // For foreign addresses
    private String foreignPostalCode; // For foreign addresses
    
    // PART 1: Quarter Information
    private Integer quarterNumber; // 1, 2, 3, or 4 - required
    private Integer taxYear; // 2026, 2027, etc. - required
    
    // PART 1: Aggregate Return Filers (optional)
    private String aggregateFilerType; // "Section3504Agent", "CPEO", "OtherThirdParty", or null
    
    // PART 1: Line Items for this Quarter
    private Integer line1EmployeeCount; // Number of employees - required
    private BigDecimal line2WagesTipsCompensation; // Total wages, tips, other compensation - required
    private BigDecimal line3FederalIncomeTax; // Federal income tax withheld - required
    
    // Line 5: Social Security & Medicare Calculations
    private BigDecimal line5aSSWages; // Taxable social security wages - required if applicable
    private BigDecimal line5aSSCalculated; // Auto-calculated: line5aSSWages * 0.124
    private BigDecimal line5bSSTips; // Taxable social security tips
    private BigDecimal line5bSSCalculated; // Auto-calculated: line5bSSTips * 0.124
    private BigDecimal line5cMedicareWages; // Taxable Medicare wages & tips - required if applicable
    private BigDecimal line5cMedicareCalculated; // Auto-calculated: line5cMedicareWages * 0.029
    private BigDecimal line5dAdditionalMedicare; // Wages subject to Additional Medicare Tax
    private BigDecimal line5dAdditionalCalculated; // Auto-calculated: line5dAdditionalMedicare * 0.009
    
    // Line 5e: Total Social Security & Medicare Taxes
    private BigDecimal line5eTotalSSMedicare; // Sum of 5a, 5b, 5c, 5d - auto-calculated
    
    // Line 5f: Section 3121(q) Notice and Demand
    private BigDecimal line5fSection3121q; // Tax due on unreported tips (optional)
    
    // Line 6: Total Taxes Before Adjustments
    private BigDecimal line6TaxesBeforeAdjustments; // line3 + line5e + line5f - auto-calculated
    
    // Lines 7-9: Adjustments
    private BigDecimal line7AdjustmentFractions; // Quarter's adjustment for fractions of cents (optional)
    private BigDecimal line8AdjustmentSickPay; // Quarter's adjustment for sick pay (optional)
    private BigDecimal line9AdjustmentTipsGroupTerm; // Quarter's adjustments for tips and group-term life insurance (optional)
    
    // Line 10: Total Taxes After Adjustments
    private BigDecimal line10TaxesAfterAdjustments; // line6 + line7 + line8 + line9 - auto-calculated
    
    // Line 11: Credits
    private BigDecimal line11QualifiedSmallBusinessCredit; // QSBTC for R&D activities (optional)
    
    // Line 12: Total Taxes After Credits
    private BigDecimal line12TotalTaxesAfterCredits; // line10 - line11 - auto-calculated
    
    // Line 13: Total Deposits
    private BigDecimal line13TotalDeposits; // Total deposits for this quarter - required
    
    // Line 14: Balance Due
    private BigDecimal line14BalanceDue; // line12 - line13 - auto-calculated
    
    // Line 15: Overpayment
    private BigDecimal line15aOverpayment; // Auto-calculated if line13 > line12
    private String line15bOverpaymentAction; // "ApplyToNextReturn" or "SendRefund"
    private String line15cRoutingNumber; // Routing number for direct deposit (if refund)
    private String line15dAccountType; // "Checking" or "Savings"
    private String line15eAccountNumber; // Account number for direct deposit
    
    // PART 2: Deposit Schedule Information
    private String depositScheduleType; // "MonthlyScheduler" or "SemiweeklyScheduler" - required
    
    // For Monthly Schedule Depositors
    private BigDecimal month1TaxLiability; // (optional)
    private BigDecimal month2TaxLiability; // (optional)
    private BigDecimal month3TaxLiability; // (optional)
    private BigDecimal totalQuarterlyLiability; // Sum of 3 months - optional
    
    // Schedule B (for semiweekly depositors) - stored as separate object
    private ScheduleBData scheduleB; // Contains daily tax liability data
    
    // PART 3: Business Information
    private Boolean businessClosed; // Whether business closed this quarter
    private LocalDate businessClosureDate; // Date of closure (required if closed)
    private Boolean seasonalEmployer; // Whether business is seasonal
    
    // PART 4: Third-Party Designee
    private Boolean hasDesignee; // Whether allowing third-party discussion
    private String designeeName; // Designee's name
    private String designeePhone; // Designee's phone number
    private String designeePIN; // 5-digit PIN
    
    // PART 5: Signature/Declaration
    private String signerName; // Name of person signing - required
    private String signerTitle; // Title of signer - required
    private LocalDate signatureDate; // Date of signature - required
    private String dayPhoneNumber; // Best daytime phone number
    
    // Paid Preparer Information (if applicable)
    private Boolean preparedByThirdParty; // Is this prepared by a paid preparer?
    private String preparerName; // Preparer's name
    private String preparerPTIN; // Preparer's PTIN
    private LocalDate preparerSignatureDate; // Date preparer signed
    private Boolean preparerSelfEmployed; // Is preparer self-employed?
    private String preparerFirmName; // Firm name
    private String preparerFirmEIN; // Firm's EIN
    private String preparerFirmPhone; // Firm's phone
    private String preparerFirmAddress; // Full address
    
    // Meta Information
    private String taxYear2026Quarter; // "Q1", "Q2", "Q3", "Q4"
    private LocalDate submissionDate; // When submitted
    private String submissionStatus; // "Draft", "Submitted", "Accepted", "Rejected"
    private String irsAckNumber; // IRS Acknowledgment number after submission
    
    // Constructors
    public Form941DTO() {
    }
    
    public Form941DTO(String ein, String businessName, String addressCity, String addressState) {
        this.ein = ein;
        this.businessName = businessName;
        this.addressCity = addressCity;
        this.addressState = addressState;
    }
    
    // Getters and Setters
    public String getEin() { return ein; }
    public void setEin(String ein) { this.ein = ein; }
    
    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }
    
    public String getTradeName() { return tradeName; }
    public void setTradeName(String tradeName) { this.tradeName = tradeName; }
    
    public String getAddressStreet() { return addressStreet; }
    public void setAddressStreet(String addressStreet) { this.addressStreet = addressStreet; }
    
    public String getAddressSuite() { return addressSuite; }
    public void setAddressSuite(String addressSuite) { this.addressSuite = addressSuite; }
    
    public String getAddressCity() { return addressCity; }
    public void setAddressCity(String addressCity) { this.addressCity = addressCity; }
    
    public String getAddressState() { return addressState; }
    public void setAddressState(String addressState) { this.addressState = addressState; }
    
    public String getAddressZip() { return addressZip; }
    public void setAddressZip(String addressZip) { this.addressZip = addressZip; }
    
    public Integer getQuarterNumber() { return quarterNumber; }
    public void setQuarterNumber(Integer quarterNumber) { this.quarterNumber = quarterNumber; }
    
    public Integer getTaxYear() { return taxYear; }
    public void setTaxYear(Integer taxYear) { this.taxYear = taxYear; }
    
    public Integer getLine1EmployeeCount() { return line1EmployeeCount; }
    public void setLine1EmployeeCount(Integer line1EmployeeCount) { this.line1EmployeeCount = line1EmployeeCount; }
    
    public BigDecimal getLine2WagesTipsCompensation() { return line2WagesTipsCompensation; }
    public void setLine2WagesTipsCompensation(BigDecimal line2WagesTipsCompensation) { this.line2WagesTipsCompensation = line2WagesTipsCompensation; }
    
    public BigDecimal getLine3FederalIncomeTax() { return line3FederalIncomeTax; }
    public void setLine3FederalIncomeTax(BigDecimal line3FederalIncomeTax) { this.line3FederalIncomeTax = line3FederalIncomeTax; }
    
    public BigDecimal getLine5aSSWages() { return line5aSSWages; }
    public void setLine5aSSWages(BigDecimal line5aSSWages) { this.line5aSSWages = line5aSSWages; }
    
    public BigDecimal getLine5bSSTips() { return line5bSSTips; }
    public void setLine5bSSTips(BigDecimal line5bSSTips) { this.line5bSSTips = line5bSSTips; }
    
    public BigDecimal getLine5cMedicareWages() { return line5cMedicareWages; }
    public void setLine5cMedicareWages(BigDecimal line5cMedicareWages) { this.line5cMedicareWages = line5cMedicareWages; }
    
    public BigDecimal getLine5dAdditionalMedicare() { return line5dAdditionalMedicare; }
    public void setLine5dAdditionalMedicare(BigDecimal line5dAdditionalMedicare) { this.line5dAdditionalMedicare = line5dAdditionalMedicare; }
    
    public BigDecimal getLine5fSection3121q() { return line5fSection3121q; }
    public void setLine5fSection3121q(BigDecimal line5fSection3121q) { this.line5fSection3121q = line5fSection3121q; }
    
    public BigDecimal getLine7AdjustmentFractions() { return line7AdjustmentFractions; }
    public void setLine7AdjustmentFractions(BigDecimal line7AdjustmentFractions) { this.line7AdjustmentFractions = line7AdjustmentFractions; }
    
    public BigDecimal getLine8AdjustmentSickPay() { return line8AdjustmentSickPay; }
    public void setLine8AdjustmentSickPay(BigDecimal line8AdjustmentSickPay) { this.line8AdjustmentSickPay = line8AdjustmentSickPay; }
    
    public BigDecimal getLine9AdjustmentTipsGroupTerm() { return line9AdjustmentTipsGroupTerm; }
    public void setLine9AdjustmentTipsGroupTerm(BigDecimal line9AdjustmentTipsGroupTerm) { this.line9AdjustmentTipsGroupTerm = line9AdjustmentTipsGroupTerm; }
    
    public BigDecimal getLine11QualifiedSmallBusinessCredit() { return line11QualifiedSmallBusinessCredit; }
    public void setLine11QualifiedSmallBusinessCredit(BigDecimal line11QualifiedSmallBusinessCredit) { this.line11QualifiedSmallBusinessCredit = line11QualifiedSmallBusinessCredit; }
    
    public BigDecimal getLine13TotalDeposits() { return line13TotalDeposits; }
    public void setLine13TotalDeposits(BigDecimal line13TotalDeposits) { this.line13TotalDeposits = line13TotalDeposits; }
    
    public String getDepositScheduleType() { return depositScheduleType; }
    public void setDepositScheduleType(String depositScheduleType) { this.depositScheduleType = depositScheduleType; }
    
    public BigDecimal getMonth1TaxLiability() { return month1TaxLiability; }
    public void setMonth1TaxLiability(BigDecimal month1TaxLiability) { this.month1TaxLiability = month1TaxLiability; }
    
    public BigDecimal getMonth2TaxLiability() { return month2TaxLiability; }
    public void setMonth2TaxLiability(BigDecimal month2TaxLiability) { this.month2TaxLiability = month2TaxLiability; }
    
    public BigDecimal getMonth3TaxLiability() { return month3TaxLiability; }
    public void setMonth3TaxLiability(BigDecimal month3TaxLiability) { this.month3TaxLiability = month3TaxLiability; }
    
    public String getSignerName() { return signerName; }
    public void setSignerName(String signerName) { this.signerName = signerName; }
    
    public String getSignerTitle() { return signerTitle; }
    public void setSignerTitle(String signerTitle) { this.signerTitle = signerTitle; }
    
    public LocalDate getSignatureDate() { return signatureDate; }
    public void setSignatureDate(LocalDate signatureDate) { this.signatureDate = signatureDate; }
    
    // Computed fields
    public BigDecimal getLine5aSSCalculated() {
        if (line5aSSWages != null) {
            return line5aSSWages.multiply(new BigDecimal("0.124"));
        }
        return BigDecimal.ZERO;
    }
    
    public BigDecimal getLine5bSSCalculated() {
        if (line5bSSTips != null) {
            return line5bSSTips.multiply(new BigDecimal("0.124"));
        }
        return BigDecimal.ZERO;
    }
    
    public BigDecimal getLine5cMedicareCalculated() {
        if (line5cMedicareWages != null) {
            return line5cMedicareWages.multiply(new BigDecimal("0.029"));
        }
        return BigDecimal.ZERO;
    }
    
    public BigDecimal getLine5dAdditionalCalculated() {
        if (line5dAdditionalMedicare != null) {
            return line5dAdditionalMedicare.multiply(new BigDecimal("0.009"));
        }
        return BigDecimal.ZERO;
    }
    
    public BigDecimal getLine5eTotalSSMedicare() {
        BigDecimal total = BigDecimal.ZERO;
        if (line5aSSCalculated != null) total = total.add(line5aSSCalculated);
        if (line5bSSCalculated != null) total = total.add(line5bSSCalculated);
        if (line5cMedicareCalculated != null) total = total.add(line5cMedicareCalculated);
        if (line5dAdditionalCalculated != null) total = total.add(line5dAdditionalCalculated);
        return total;
    }
    
    public BigDecimal getLine6TaxesBeforeAdjustments() {
        BigDecimal total = BigDecimal.ZERO;
        if (line3FederalIncomeTax != null) total = total.add(line3FederalIncomeTax);
        total = total.add(getLine5eTotalSSMedicare());
        if (line5fSection3121q != null) total = total.add(line5fSection3121q);
        return total;
    }
    
    public BigDecimal getLine10TaxesAfterAdjustments() {
        BigDecimal total = getLine6TaxesBeforeAdjustments();
        if (line7AdjustmentFractions != null) total = total.add(line7AdjustmentFractions);
        if (line8AdjustmentSickPay != null) total = total.add(line8AdjustmentSickPay);
        if (line9AdjustmentTipsGroupTerm != null) total = total.add(line9AdjustmentTipsGroupTerm);
        return total;
    }
    
    public BigDecimal getLine12TotalTaxesAfterCredits() {
        BigDecimal total = getLine10TaxesAfterAdjustments();
        if (line11QualifiedSmallBusinessCredit != null) {
            total = total.subtract(line11QualifiedSmallBusinessCredit);
        }
        return total;
    }
    
    public BigDecimal getLine14BalanceDue() {
        BigDecimal due = getLine12TotalTaxesAfterCredits();
        if (line13TotalDeposits != null) {
            due = due.subtract(line13TotalDeposits);
        }
        if (due.compareTo(BigDecimal.ZERO) < 0) {
            return BigDecimal.ZERO; // No balance due if overpayment
        }
        return due;
    }
    
    public BigDecimal getLine15aOverpayment() {
        BigDecimal deposits = line13TotalDeposits != null ? line13TotalDeposits : BigDecimal.ZERO;
        BigDecimal taxes = getLine12TotalTaxesAfterCredits();
        if (deposits.compareTo(taxes) > 0) {
            return deposits.subtract(taxes);
        }
        return BigDecimal.ZERO;
    }
    
    // Additional getters
    public Boolean getBusinessClosed() { return businessClosed; }
    public void setBusinessClosed(Boolean businessClosed) { this.businessClosed = businessClosed; }
    
    public LocalDate getBusinessClosureDate() { return businessClosureDate; }
    public void setBusinessClosureDate(LocalDate businessClosureDate) { this.businessClosureDate = businessClosureDate; }
    
    public Boolean getSeasonalEmployer() { return seasonalEmployer; }
    public void setSeasonalEmployer(Boolean seasonalEmployer) { this.seasonalEmployer = seasonalEmployer; }
    
    public String getForeignCountry() { return foreignCountry; }
    public void setForeignCountry(String foreignCountry) { this.foreignCountry = foreignCountry; }
    
    public String getAggregateFilerType() { return aggregateFilerType; }
    public void setAggregateFilerType(String aggregateFilerType) { this.aggregateFilerType = aggregateFilerType; }
}


/**
 * Helper class for Schedule B (daily tax liability for semiweekly depositors)
 */
class ScheduleBData {
    // Would contain daily tax liability entries
    // Structure depends on IRS schema requirements
}
