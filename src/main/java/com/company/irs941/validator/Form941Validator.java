package com.company.irs941.validator;

import com.company.irs941.dto.Form941DTO;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Form 941 Validator - Applies IRS Business Rules (TY2026 / TY2027)
 */
public class Form941Validator {

    private final List<ValidationError> errors = new ArrayList<>();
    private final List<ValidationWarning> warnings = new ArrayList<>();

    private static final BigDecimal SS_TAX_RATE = new BigDecimal("0.124");
    private static final BigDecimal MEDICARE_TAX_RATE = new BigDecimal("0.029");
    private static final BigDecimal ADDL_MEDICARE_RATE = new BigDecimal("0.009");

    private static final Pattern EIN_PATTERN = Pattern.compile("\\d{2}-\\d{7}");
    private static final Pattern ZIP_PATTERN = Pattern.compile("\\d{5}(-\\d{4})?");

    public ValidationResult validate(Form941DTO dto, String ein, String businessName, String state, String zip) {
        errors.clear();
        warnings.clear();

        // 1. Schema & Required Field Validations
        if (ein != null && !ein.isEmpty() && !EIN_PATTERN.matcher(ein).matches()) {
            errors.add(new ValidationError("EIN", "EIN must be in format XX-XXXXXXX"));
        }
        if (zip != null && !zip.isEmpty() && !ZIP_PATTERN.matcher(zip).matches()) {
            errors.add(new ValidationError("ZipCode", "ZIP code format invalid (5 digits)"));
        }
        if (state != null && !state.isEmpty() && state.trim().length() != 2) {
            errors.add(new ValidationError("State", "State must be 2-letter abbreviation"));
        }

        // 2. Tax Calculations Rules
        BigDecimal line2 = parseDecimal(dto.getLineValue("2"));
        BigDecimal line3 = parseDecimal(dto.getLineValue("3"));
        BigDecimal line5aWages = parseDecimal(dto.getLineValue("5a_wages"));
        BigDecimal line5aTax = parseDecimal(dto.getLineValue("5a_tax"));
        BigDecimal line5cWages = parseDecimal(dto.getLineValue("5c_wages"));
        BigDecimal line5cTax = parseDecimal(dto.getLineValue("5c_tax"));

        // Federal income tax cannot be negative
        if (line3.compareTo(BigDecimal.ZERO) < 0) {
            errors.add(new ValidationError("Line3", "Federal income tax withheld cannot be negative"));
        }

        // Validate SS tax calculation (12.4%)
        if (line5aWages.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal expectedSS = line5aWages.multiply(SS_TAX_RATE).setScale(2, RoundingMode.HALF_UP);
            BigDecimal diff = expectedSS.subtract(line5aTax).abs();
            if (diff.compareTo(new BigDecimal("0.05")) > 0) {
                warnings.add(new ValidationWarning("Line5a", "Social Security tax (" + line5aTax + ") differs from calculated 12.4% (" + expectedSS + ")"));
            }
        }

        // Validate Medicare tax calculation (2.9%)
        if (line5cWages.compareTo(BigDecimal.ZERO) > 0) {
            BigDecimal expectedMed = line5cWages.multiply(MEDICARE_TAX_RATE).setScale(2, RoundingMode.HALF_UP);
            BigDecimal diff = expectedMed.subtract(line5cTax).abs();
            if (diff.compareTo(new BigDecimal("0.05")) > 0) {
                warnings.add(new ValidationWarning("Line5c", "Medicare tax (" + line5cTax + ") differs from calculated 2.9% (" + expectedMed + ")"));
            }
        }

        // 3. Deposit Schedule Validation
        String sched = dto.getLineValue("16");
        BigDecimal line12 = parseDecimal(dto.getLineValue("12"));

        if ("monthly".equalsIgnoreCase(sched)) {
            BigDecimal m1 = parseDecimal(dto.getLineValue("sb_m1_total"));
            BigDecimal m2 = parseDecimal(dto.getLineValue("sb_m2_total"));
            BigDecimal m3 = parseDecimal(dto.getLineValue("sb_m3_total"));
            BigDecimal totalMonthly = m1.add(m2).add(m3);

            BigDecimal diff = totalMonthly.subtract(line12).abs();
            if (diff.compareTo(new BigDecimal("0.05")) > 0) {
                errors.add(new ValidationError("Line16", "Sum of monthly liabilities (" + totalMonthly + ") does not equal Line 12 (" + line12 + ")"));
            }
        }

        return new ValidationResult(errors, warnings);
    }

    private BigDecimal parseDecimal(String val) {
        if (val == null || val.trim().isEmpty()) return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        try {
            return new BigDecimal(val.replaceAll("[,\\$]", "").trim()).setScale(2, RoundingMode.HALF_UP);
        } catch (Exception e) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
    }

    public static class ValidationError {
        public String field;
        public String message;
        public ValidationError(String field, String message) {
            this.field = field;
            this.message = message;
        }
        @Override
        public String toString() { return "ERROR [" + field + "]: " + message; }
    }

    public static class ValidationWarning {
        public String field;
        public String message;
        public ValidationWarning(String field, String message) {
            this.field = field;
            this.message = message;
        }
        @Override
        public String toString() { return "WARNING [" + field + "]: " + message; }
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
    }
}
