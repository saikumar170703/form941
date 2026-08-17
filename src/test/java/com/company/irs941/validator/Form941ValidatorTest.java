package com.company.irs941.validator;

import com.company.irs941.dto.Form941DTO;

public class Form941ValidatorTest {

    public static void main(String[] args) {
        Form941Validator validator = new Form941Validator();

        // Test 1: Valid Form 941
        Form941DTO dto = new Form941DTO();
        dto.setForm941Id(15L);
        dto.setTaxYear(2026);
        dto.setQuarter(1);
        dto.setLineValue("ein", "12-3456789");
        dto.setLineValue("businessName", "Acme Corporation");
        dto.setLineValue("addressLine1", "100 Main Street");
        dto.setLineValue("city", "Baton Rouge");
        dto.setLineValue("state", "LA");
        dto.setLineValue("zip", "70801");
        dto.setLineValue("1", "50");
        dto.setLineValue("2", "500000.00");
        dto.setLineValue("3", "75000.00");
        dto.setLineValue("5a_wages", "500000.00");
        dto.setLineValue("5a_tax", "62000.00");
        dto.setLineValue("5c_wages", "500000.00");
        dto.setLineValue("5c_tax", "14500.00");
        dto.setLineValue("5e", "76500.00");
        dto.setLineValue("6", "151500.00");
        dto.setLineValue("10", "151500.00");
        dto.setLineValue("12", "151500.00");

        Form941Validator.ValidationResult result = validator.validate(dto, "12-3456789", "Acme Corporation", "LA", "70801");
        System.out.println("Form941ValidatorTest - Valid Form Status: " + result.isValid + " (Errors: " + result.errors.size() + ")");

        // Test 2: Invalid EIN
        Form941Validator.ValidationResult einResult = validator.validate(dto, "123456789", "Acme Corporation", "LA", "70801");
        System.out.println("Form941ValidatorTest - Invalid EIN Status: " + einResult.isValid + " (Errors: " + einResult.errors.size() + ")");
    }
}
