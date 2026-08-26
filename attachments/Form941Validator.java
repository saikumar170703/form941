package com.irs.form941.validator;

import com.irs.form941.dto.Form941DTO;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Form 941 Validator - Applies IRS Business Rules and Validations
 * Validates DTO against IRS XML Schema requirements and business logic rules
 */
public class Form941Validator {
    
    private List<ValidationError> errors;
    private List<ValidationWarning> warnings;
    
    // IRS Constants
    private static final BigDecimal SS_WAGE_CAP_2026 = new BigDecimal("168600"); // Social Security wage base limit
    private static final BigDecimal SS_TAX_RATE = new BigDecimal("0.124");
    private static final BigDecimal MEDICARE_TAX_RATE = new BigDecimal("0.029");
    private static final BigDecimal ADDITIONAL_MEDICARE_RATE = new BigDecimal("0.009");
    private static final BigDecimal ADDITIONAL_MEDICARE_THRESHOLD = new BigDecimal("200000");
    private static final BigDecimal MINIMUM_BALANCE_THRESHOLD = new BigDecimal("2500");
    
    private static final Pattern EIN_PATTERN = Pattern.compile("\\d{2}-\\d{7}");
    private static final Pattern ZIP_PATTERN = Pattern.compile("\\d{5}(-\\d{4})?");
    private static final Pattern PHONE_PATTERN = Pattern.compile("\\d{3}-\\d{3}-\\d{4}");
    private static final Pattern ROUTING_PATTERN = Pattern.compile("\\d{9}");
    
    public Form941Validator() {
        this.errors = new ArrayList<>();
        this.warnings = new ArrayList<>();
    }
    
    /**
     * Main validation method - runs all business rule checks
     */
    public ValidationResult validate(Form941DTO form) {
        errors.clear();
        warnings.clear();
        
        // SCHEMA VALIDATION - Required Fields
        validateRequiredFields(form);
        
        // BUSINESS RULES VALIDATION
        validateEmployerInformation(form);
        validateQuarterInformation(form);
        validateTaxCalculations(form);
        validateDepositSchedule(form);
        validateBusinessInformation(form);
        validateSignature(form);
        validateInternalConsistency(form);
        
        return new ValidationResult(errors, warnings);
    }
    
    /**
     * Step 1: Validate all required fields per IRS schema
     */
    private void validateRequiredFields(Form941DTO form) {
        // Employer Information (Required)
        if (form.getEin() == null || form.getEin().isEmpty()) {
            errors.add(new ValidationError("EIN", "Employer Identification Number is required"));
        } else if (!EIN_PATTERN.matcher(form.getEin()).matches()) {
            errors.add(new ValidationError("EIN", "EIN must be in format XX-XXXXXXX"));
        }
        
        if (form.getBusinessName() == null || form.getBusinessName().isEmpty()) {
            errors.add(new ValidationError("BusinessName", "Business name is required"));
        } else if (form.getBusinessName().length() > 57) {
            errors.add(new ValidationError("BusinessName", "Business name cannot exceed 57 characters"));
        }
        
        if (form.getAddressStreet() == null || form.getAddressStreet().isEmpty()) {
            errors.add(new ValidationError("AddressStreet", "Street address is required"));
        }
        if (form.getAddressCity() == null || form.getAddressCity().isEmpty()) {
            errors.add(new ValidationError("AddressCity", "City is required"));
        }
        if (form.getAddressState() == null || form.getAddressState().isEmpty()) {
            errors.add(new ValidationError("AddressState", "State is required"));
        } else if (form.getAddressState().length() != 2) {
            errors.add(new ValidationError("AddressState", "State must be 2-letter abbreviation"));
        }
        if (form.getAddressZip() == null || form.getAddressZip().isEmpty()) {
            errors.add(new ValidationError("AddressZip", "ZIP code is required"));
        } else if (!ZIP_PATTERN.matcher(form.getAddressZip()).matches()) {
            errors.add(new ValidationError("AddressZip", "ZIP code format invalid (XXXXX or XXXXX-XXXX)"));
        }
        
        // Quarter Information (Required)
        if (form.getQuarterNumber() == null || form.getQuarterNumber() < 1 || form.getQuarterNumber() > 4) {
            errors.add(new ValidationError("QuarterNumber", "Quarter must be 1, 2, 3, or 4"));
        }
        if (form.getTaxYear() == null || form.getTaxYear() < 2020 || form.getTaxYear() > 2030) {
            errors.add(new ValidationError("TaxYear", "Tax year must be between 2020 and 2030"));
        }
        
        // Line Items (Required)
        if (form.getLine1EmployeeCount() == null || form.getLine1EmployeeCount() < 0) {
            errors.add(new ValidationError("Line1EmployeeCount", "Employee count is required and must be >= 0"));
        }
        if (form.getLine2WagesTipsCompensation() == null) {
            errors.add(new ValidationError("Line2WagesTipsCompensation", "Total wages/tips/compensation is required"));
        }
        if (form.getLine3FederalIncomeTax() == null) {
            errors.add(new ValidationError("Line3FederalIncomeTax", "Federal income tax withheld is required"));
        }
        
        // Wage Lines (Required if applicable)
        if (form.getLine5aSSWages() != null || form.getLine5bSSTips() != null || 
            form.getLine5cMedicareWages() != null) {
            // At least one SS/Medicare wage line required if employees exist
            if (form.getLine1EmployeeCount() != null && form.getLine1EmployeeCount() > 0) {
                if (form.getLine5cMedicareWages() == null) {
                    warnings.add(new ValidationWarning("Line5cMedicareWages", 
                        "Medicare wages should be reported if employees exist"));
                }
            }
        }
        
        // Deposit Schedule (Required)
        if (form.getDepositScheduleType() == null || form.getDepositScheduleType().isEmpty()) {
            errors.add(new ValidationError("DepositScheduleType", "Deposit schedule type is required (MonthlyScheduler or SemiweeklyScheduler)"));
        } else if (!form.getDepositScheduleType().matches("MonthlyScheduler|SemiweeklyScheduler")) {
            errors.add(new ValidationError("DepositScheduleType", "Must be 'MonthlyScheduler' or 'SemiweeklyScheduler'"));
        }
        
        // Deposits (Required)
        if (form.getLine13TotalDeposits() == null) {
            errors.add(new ValidationError("Line13TotalDeposits", "Total deposits for quarter is required"));
        }
        
        // Signature (Required)
        if (form.getSignerName() == null || form.getSignerName().isEmpty()) {
            errors.add(new ValidationError("SignerName", "Signer name is required"));
        }
        if (form.getSignerTitle() == null || form.getSignerTitle().isEmpty()) {
            errors.add(new ValidationError("SignerTitle", "Signer title is required"));
        }
        if (form.getSignatureDate() == null) {
            errors.add(new ValidationError("SignatureDate", "Signature date is required"));
        }
    }
    
    /**
     * Step 2: Validate employer information rules
     */
    private void validateEmployerInformation(Form941DTO form) {
        // EIN cannot be "Applied For" once in system
        if ("Applied For".equals(form.getEin())) {
            errors.add(new ValidationError("EIN", "EIN must be issued before filing Form 941"));
        }
        
        // Business name cannot contain special characters (except apostrophes, hyphens)
        if (form.getBusinessName() != null && !form.getBusinessName().matches("[a-zA-Z0-9\\s\\-'&,\\.]+")) {
            errors.add(new ValidationError("BusinessName", "Business name contains invalid characters"));
        }
        
        // Trade name optional but if provided, cannot exceed 57 chars
        if (form.getTradeName() != null && form.getTradeName().length() > 57) {
            errors.add(new ValidationError("TradeName", "Trade name cannot exceed 57 characters"));
        }
    }
    
    /**
     * Step 3: Validate quarter and tax year information
     */
    private void validateQuarterInformation(Form941DTO form) {
        // Quarter must be valid (1-4)
        if (form.getQuarterNumber() != null && (form.getQuarterNumber() < 1 || form.getQuarterNumber() > 4)) {
            errors.add(new ValidationError("QuarterNumber", "Quarter must be between 1 and 4"));
        }
        
        // Signature date must be within reasonable range
        if (form.getSignatureDate() != null) {
            LocalDate now = LocalDate.now();
            LocalDate sigDate = form.getSignatureDate();
            
            if (sigDate.isAfter(now.plusDays(5))) {
                errors.add(new ValidationError("SignatureDate", "Signature date cannot be more than 5 days in future"));
            }
            if (sigDate.isBefore(now.minusYears(1))) {
                warnings.add(new ValidationWarning("SignatureDate", "Signature date is more than 1 year old"));
            }
        }
    }
    
    /**
     * Step 4: Validate all tax calculations - the most critical business rules
     */
    private void validateTaxCalculations(Form941DTO form) {
        BigDecimal line2 = form.getLine2WagesTipsCompensation() != null ? form.getLine2WagesTipsCompensation() : BigDecimal.ZERO;
        BigDecimal line3 = form.getLine3FederalIncomeTax() != null ? form.getLine3FederalIncomeTax() : BigDecimal.ZERO;
        
        // RULE 1: Federal income tax withheld cannot be negative
        if (line3.compareTo(BigDecimal.ZERO) < 0) {
            errors.add(new ValidationError("Line3FederalIncomeTax", "Federal income tax cannot be negative"));
        }
        
        // RULE 2: Federal income tax cannot exceed total wages
        if (line3.compareTo(line2) > 0) {
            errors.add(new ValidationError("Line3FederalIncomeTax", 
                "Federal income tax withheld (" + line3 + ") cannot exceed total wages (" + line2 + ")"));
        }
        
        // RULE 3: Validate Social Security wage calculations
        if (form.getLine5aSSWages() != null) {
            BigDecimal line5a = form.getLine5aSSWages();
            
            // SS wages cannot exceed annual cap per quarter
            if (line5a.compareTo(SS_WAGE_CAP_2026) > 0) {
                errors.add(new ValidationError("Line5aSSWages", 
                    "Social Security wages per quarter cannot exceed " + SS_WAGE_CAP_2026 + 
                    " (annual cap is $" + SS_WAGE_CAP_2026 + ")"));
            }
            
            // SS wages cannot exceed total wages
            if (line5a.compareTo(line2) > 0) {
                errors.add(new ValidationError("Line5aSSWages", 
                    "Taxable SS wages (" + line5a + ") cannot exceed total wages (" + line2 + ")"));
            }
            
            // Validate calculated tax
            BigDecimal expectedSSCalc = line5a.multiply(SS_TAX_RATE).setScale(2, BigDecimal.ROUND_HALF_UP);
            BigDecimal actualSSCalc = form.getLine5aSSCalculated();
            if (actualSSCalc.compareTo(expectedSSCalc) != 0) {
                errors.add(new ValidationError("Line5aSSCalculation", 
                    "Social Security tax calculation incorrect. Expected: " + expectedSSCalc + ", Got: " + actualSSCalc));
            }
        }
        
        // RULE 4: Validate Medicare wage calculations
        if (form.getLine5cMedicareWages() != null) {
            BigDecimal line5c = form.getLine5cMedicareWages();
            
            // Medicare wages cannot exceed total wages
            if (line5c.compareTo(line2) > 0) {
                errors.add(new ValidationError("Line5cMedicareWages", 
                    "Taxable Medicare wages (" + line5c + ") cannot exceed total wages (" + line2 + ")"));
            }
            
            // Validate calculated tax
            BigDecimal expectedMedicareCalc = line5c.multiply(MEDICARE_TAX_RATE).setScale(2, BigDecimal.ROUND_HALF_UP);
            BigDecimal actualMedicareCalc = form.getLine5cMedicareCalculated();
            if (actualMedicareCalc.compareTo(expectedMedicareCalc) != 0) {
                errors.add(new ValidationError("Line5cMedicareCalculation", 
                    "Medicare tax calculation incorrect. Expected: " + expectedMedicareCalc + ", Got: " + actualMedicareCalc));
            }
        }
        
        // RULE 5: Validate Additional Medicare Tax (>$200k wages)
        if (form.getLine5dAdditionalMedicare() != null && form.getLine5dAdditionalMedicare().compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal line5d = form.getLine5dAdditionalMedicare();
            
            // Additional Medicare applies only if wages exceed threshold
            if (line2.compareTo(ADDITIONAL_MEDICARE_THRESHOLD) < 0) {
                warnings.add(new ValidationWarning("Line5dAdditionalMedicare", 
                    "Additional Medicare Tax typically applies only when wages exceed $200,000"));
            }
            
            // Validate calculation
            BigDecimal expectedAdditionalCalc = line5d.multiply(ADDITIONAL_MEDICARE_RATE).setScale(2, BigDecimal.ROUND_HALF_UP);
            BigDecimal actualAdditionalCalc = form.getLine5dAdditionalCalculated();
            if (actualAdditionalCalc.compareTo(expectedAdditionalCalc) != 0) {
                errors.add(new ValidationError("Line5dAdditionalCalculation", 
                    "Additional Medicare tax calculation incorrect"));
            }
        }
        
        // RULE 6: Total taxes before adjustments must be positive if there are wages
        BigDecimal line6 = form.getLine6TaxesBeforeAdjustments();
        if (line2.compareTo(BigDecimal.ZERO) > 0 && line6.compareTo(BigDecimal.ZERO) <= 0) {
            warnings.add(new ValidationWarning("Line6TaxesBeforeAdjustments", 
                "Total taxes is zero or negative despite having wages - verify correctness"));
        }
        
        // RULE 7: Adjustments should not cause negative taxes
        BigDecimal line10 = form.getLine10TaxesAfterAdjustments();
        if (line10.compareTo(BigDecimal.ZERO) < 0) {
            errors.add(new ValidationError("Line10TaxesAfterAdjustments", 
                "Total taxes after adjustments cannot be negative"));
        }
        
        // RULE 8: Credits cannot exceed total taxes
        BigDecimal line11 = form.getLine11QualifiedSmallBusinessCredit() != null ? 
            form.getLine11QualifiedSmallBusinessCredit() : BigDecimal.ZERO;
        if (line11.compareTo(line10) > 0) {
            errors.add(new ValidationError("Line11QualifiedSmallBusinessCredit", 
                "Total credits (" + line11 + ") cannot exceed total taxes after adjustments (" + line10 + ")"));
        }
        
        // RULE 9: Line 12 (total taxes after credits) must be non-negative
        BigDecimal line12 = form.getLine12TotalTaxesAfterCredits();
        if (line12.compareTo(BigDecimal.ZERO) < 0) {
            errors.add(new ValidationError("Line12TotalTaxesAfterCredits", 
                "Total taxes after credits cannot be negative"));
        }
        
        // RULE 10: Deposits must be non-negative
        BigDecimal line13 = form.getLine13TotalDeposits() != null ? form.getLine13TotalDeposits() : BigDecimal.ZERO;
        if (line13.compareTo(BigDecimal.ZERO) < 0) {
            errors.add(new ValidationError("Line13TotalDeposits", "Total deposits cannot be negative"));
        }
    }
    
    /**
     * Step 5: Validate deposit schedule information
     */
    private void validateDepositSchedule(Form941DTO form) {
        String scheduleType = form.getDepositScheduleType();
        BigDecimal line12 = form.getLine12TotalTaxesAfterCredits();
        
        if ("MonthlyScheduler".equals(scheduleType)) {
            // For monthly depositors, need month breakdown
            BigDecimal month1 = form.getMonth1TaxLiability() != null ? form.getMonth1TaxLiability() : BigDecimal.ZERO;
            BigDecimal month2 = form.getMonth2TaxLiability() != null ? form.getMonth2TaxLiability() : BigDecimal.ZERO;
            BigDecimal month3 = form.getMonth3TaxLiability() != null ? form.getMonth3TaxLiability() : BigDecimal.ZERO;
            
            BigDecimal totalMonthly = month1.add(month2).add(month3);
            
            // RULE: Monthly liability total must equal line 12 (allow small rounding differences)
            BigDecimal difference = totalMonthly.subtract(line12).abs();
            if (difference.compareTo(new BigDecimal("0.02")) > 0) { // Allow 2 cent rounding
                errors.add(new ValidationError("MonthlyLiability", 
                    "Sum of monthly liabilities (" + totalMonthly + ") does not equal Line 12 (" + line12 + ")"));
            }
            
            // RULE: Each month must be non-negative
            if (month1.compareTo(BigDecimal.ZERO) < 0) {
                errors.add(new ValidationError("Month1TaxLiability", "Month 1 liability cannot be negative"));
            }
            if (month2.compareTo(BigDecimal.ZERO) < 0) {
                errors.add(new ValidationError("Month2TaxLiability", "Month 2 liability cannot be negative"));
            }
            if (month3.compareTo(BigDecimal.ZERO) < 0) {
                errors.add(new ValidationError("Month3TaxLiability", "Month 3 liability cannot be negative"));
            }
            
        } else if ("SemiweeklyScheduler".equals(scheduleType)) {
            // For semiweekly depositors, Schedule B is required (not validated in detail here)
            if (form.getScheduleB() == null) {
                warnings.add(new ValidationWarning("ScheduleB", 
                    "Schedule B (daily tax liability) should be attached for semiweekly depositors"));
            }
        }
    }
    
    /**
     * Step 6: Validate business information
     */
    private void validateBusinessInformation(Form941DTO form) {
        if (form.getBusinessClosed() != null && form.getBusinessClosed()) {
            if (form.getBusinessClosureDate() == null) {
                errors.add(new ValidationError("BusinessClosureDate", 
                    "Business closure date is required if business has closed"));
            } else if (form.getBusinessClosureDate().isAfter(LocalDate.now())) {
                errors.add(new ValidationError("BusinessClosureDate", 
                    "Business closure date cannot be in the future"));
            }
        }
    }
    
    /**
     * Step 7: Validate signature and declaration
     */
    private void validateSignature(Form941DTO form) {
        // Signer name required
        if (form.getSignerName() == null || form.getSignerName().isEmpty()) {
            errors.add(new ValidationError("SignerName", "Name of person signing is required"));
        }
        
        // Signer title required
        if (form.getSignerTitle() == null || form.getSignerTitle().isEmpty()) {
            errors.add(new ValidationError("SignerTitle", "Title of signer is required"));
        }
        
        // Signature date required
        if (form.getSignatureDate() == null) {
            errors.add(new ValidationError("SignatureDate", "Date of signature is required"));
        }
        
        // If paid preparer, require preparer info
        if (form.getPreparedByThirdParty() != null && form.getPreparedByThirdParty()) {
            if (form.getPreparerName() == null || form.getPreparerName().isEmpty()) {
                errors.add(new ValidationError("PreparerName", "Preparer name is required if form is prepared by third party"));
            }
            if (form.getPreparerPTIN() == null || form.getPreparerPTIN().isEmpty()) {
                errors.add(new ValidationError("PreparerPTIN", "Preparer PTIN is required"));
            } else if (!form.getPreparerPTIN().matches("\\d{11}")) {
                errors.add(new ValidationError("PreparerPTIN", "PTIN must be 11 digits"));
            }
        }
    }
    
    /**
     * Step 8: Cross-field validation and internal consistency
     */
    private void validateInternalConsistency(Form941DTO form) {
        // If aggregate filer, must have filer type specified
        if (form.getAggregateFilerType() != null && !form.getAggregateFilerType().isEmpty()) {
            if (!form.getAggregateFilerType().matches("Section3504Agent|CPEO|OtherThirdParty")) {
                errors.add(new ValidationError("AggregateFilerType", 
                    "Invalid aggregate filer type. Must be Section3504Agent, CPEO, or OtherThirdParty"));
            }
        }
        
        // Overpayment handling validation
        BigDecimal line12 = form.getLine12TotalTaxesAfterCredits();
        BigDecimal line13 = form.getLine13TotalDeposits() != null ? form.getLine13TotalDeposits() : BigDecimal.ZERO;
        BigDecimal overpayment = form.getLine15aOverpayment();
        
        if (line13.compareTo(line12) > 0) {
            // There IS an overpayment
            if (overpayment == null || overpayment.compareTo(BigDecimal.ZERO) <= 0) {
                errors.add(new ValidationError("Line15aOverpayment", 
                    "Overpayment amount is required when deposits exceed taxes"));
            }
            
            // Must specify action (refund or apply)
            if (form.getLine15bOverpaymentAction() == null) {
                errors.add(new ValidationError("Line15bOverpaymentAction", 
                    "Must specify action for overpayment (ApplyToNextReturn or SendRefund)"));
            }
            
            // If refund, need banking info
            if ("SendRefund".equals(form.getLine15bOverpaymentAction())) {
                if (form.getLine15cRoutingNumber() == null || !ROUTING_PATTERN.matcher(form.getLine15cRoutingNumber()).matches()) {
                    errors.add(new ValidationError("Line15cRoutingNumber", "Valid routing number required for direct deposit refund"));
                }
                if (form.getLine15dAccountType() == null) {
                    errors.add(new ValidationError("Line15dAccountType", "Account type required for direct deposit refund"));
                }
                if (form.getLine15eAccountNumber() == null || form.getLine15eAccountNumber().isEmpty()) {
                    errors.add(new ValidationError("Line15eAccountNumber", "Account number required for direct deposit refund"));
                }
            }
        }
    }
    
    // Inner classes for error/warning reporting
    public static class ValidationError {
        public String field;
        public String message;
        
        public ValidationError(String field, String message) {
            this.field = field;
            this.message = message;
        }
        
        @Override
        public String toString() {
            return "ERROR [" + field + "]: " + message;
        }
    }
    
    public static class ValidationWarning {
        public String field;
        public String message;
        
        public ValidationWarning(String field, String message) {
            this.field = field;
            this.message = message;
        }
        
        @Override
        public String toString() {
            return "WARNING [" + field + "]: " + message;
        }
    }
    
    public static class ValidationResult {
        public List<ValidationError> errors;
        public List<ValidationWarning> warnings;
        public boolean isValid;
        
        public ValidationResult(List<ValidationError> errors, List<ValidationWarning> warnings) {
            this.errors = errors;
            this.warnings = warnings;
            this.isValid = errors.isEmpty();
        }
        
        public void printReport() {
            System.out.println("\n=== FORM 941 VALIDATION REPORT ===");
            if (isValid) {
                System.out.println("✓ VALIDATION PASSED - No errors found\n");
            } else {
                System.out.println("✗ VALIDATION FAILED - " + errors.size() + " error(s) found\n");
            }
            
            if (!errors.isEmpty()) {
                System.out.println("ERRORS:");
                for (ValidationError error : errors) {
                    System.out.println("  " + error);
                }
            }
            
            if (!warnings.isEmpty()) {
                System.out.println("\nWARNINGS:");
                for (ValidationWarning warning : warnings) {
                    System.out.println("  " + warning);
                }
            }
            
            System.out.println("\n=== END REPORT ===\n");
        }
    }
}
