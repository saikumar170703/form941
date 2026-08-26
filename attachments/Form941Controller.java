package com.irs.form941.controller;

import com.irs.form941.dto.Form941DTO;
import com.irs.form941.service.Form941Service;
import com.irs.form941.service.Form941SubmissionPackage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

/**
 * Form 941 REST Controller
 * Handles Form 941 submission workflow via REST API
 * 
 * Usage:
 * POST /api/form941/validate-and-generate - Validates DTO and generates XML
 * GET /api/form941/example - Returns example DTO for testing
 */
@RestController
@RequestMapping("/api/form941")
public class Form941Controller {
    
    private static final Logger logger = LoggerFactory.getLogger(Form941Controller.class);
    
    @Autowired
    private Form941Service form941Service;
    
    /**
     * Main endpoint: Validate Form 941 DTO and generate IRS-compliant XML
     * 
     * Flow:
     * 1. Receive Form941DTO from client UI
     * 2. Run business rules validation
     * 3. Generate IRS XML
     * 4. Return submission package with XML and status
     */
    @PostMapping("/validate-and-generate")
    public ResponseEntity<?> validateAndGenerateXML(@RequestBody Form941DTO form) {
        logger.info("Received Form 941 submission request for EIN: {}", form.getEin());
        
        try {
            // Process the form (validate + generate XML)
            Form941SubmissionPackage submissionPackage = form941Service.processForm941(form);
            
            // Return response
            Map<String, Object> response = new HashMap<>();
            response.put("status", submissionPackage.getStatus());
            response.put("validationStatus", submissionPackage.getValidationStatus());
            response.put("xmlGenerationStatus", submissionPackage.getXmlGenerationStatus());
            response.put("xsdValidationStatus", submissionPackage.getXsdValidationStatus());
            
            if (submissionPackage.getValidationResult() != null) {
                Map<String, Object> validationDetails = new HashMap<>();
                validationDetails.put("errorCount", submissionPackage.getValidationResult().errors.size());
                validationDetails.put("warningCount", submissionPackage.getValidationResult().warnings.size());
                
                if (!submissionPackage.getValidationResult().errors.isEmpty()) {
                    validationDetails.put("errors", submissionPackage.getValidationResult().errors);
                }
                if (!submissionPackage.getValidationResult().warnings.isEmpty()) {
                    validationDetails.put("warnings", submissionPackage.getValidationResult().warnings);
                }
                
                response.put("validationDetails", validationDetails);
            }
            
            // Include XML only if generation was successful
            if ("SUCCESS".equals(submissionPackage.getXmlGenerationStatus())) {
                response.put("xmlContent", submissionPackage.getXmlContent());
                response.put("xmlLength", submissionPackage.getXmlLength());
            } else if (submissionPackage.getXmlGenerationError() != null) {
                response.put("xmlError", submissionPackage.getXmlGenerationError());
            }
            
            response.put("metadata", submissionPackage.getMetadata());
            response.put("irsRequirements", submissionPackage.getIrsRequirements());
            response.put("processingTime", calculateProcessingTime(submissionPackage));
            
            // Determine HTTP status based on validation result
            HttpStatus httpStatus = "READY_FOR_SUBMISSION".equals(submissionPackage.getStatus()) ? 
                HttpStatus.OK : HttpStatus.BAD_REQUEST;
            
            return new ResponseEntity<>(response, httpStatus);
            
        } catch (Exception e) {
            logger.error("Error processing Form 941: {}", e.getMessage(), e);
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", "ERROR");
            errorResponse.put("message", e.getMessage());
            errorResponse.put("timestamp", LocalDate.now().toString());
            
            return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    /**
     * Helper endpoint: Get example Form 941 DTO for testing/documentation
     */
    @GetMapping("/example")
    public ResponseEntity<?> getExampleForm() {
        logger.info("Generating example Form 941 DTO");
        
        Form941DTO example = new Form941DTO();
        
        // Employer Information
        example.setEin("12-3456789");
        example.setBusinessName("ACME Manufacturing Corporation");
        example.setTradeName("ACME");
        example.setAddressStreet("123 Business Street");
        example.setAddressSuite("Suite 100");
        example.setAddressCity("Springfield");
        example.setAddressState("IL");
        example.setAddressZip("62701");
        
        // Quarter Information
        example.setQuarterNumber(2); // Q2
        example.setTaxYear(2026);
        
        // Line Items
        example.setLine1EmployeeCount(50);
        example.setLine2WagesTipsCompensation(new BigDecimal("500000.00"));
        example.setLine3FederalIncomeTax(new BigDecimal("75000.00"));
        
        // Social Security Wages
        example.setLine5aSSWages(new BigDecimal("500000.00"));
        // Automatically calculated: 500000 * 0.124 = 62000
        
        // Medicare Wages
        example.setLine5cMedicareWages(new BigDecimal("500000.00"));
        // Automatically calculated: 500000 * 0.029 = 14500
        
        // Deposits
        example.setLine13TotalDeposits(new BigDecimal("151500.00"));
        
        // Deposit Schedule
        example.setDepositScheduleType("MonthlyScheduler");
        example.setMonth1TaxLiability(new BigDecimal("50500.00"));
        example.setMonth2TaxLiability(new BigDecimal("50500.00"));
        example.setMonth3TaxLiability(new BigDecimal("50500.00"));
        
        // Signature Information
        example.setSignerName("John Smith");
        example.setSignerTitle("Owner");
        example.setSignatureDate(LocalDate.now());
        example.setDayPhoneNumber("217-555-1234");
        
        Map<String, Object> response = new HashMap<>();
        response.put("example", example);
        response.put("notes", new String[]{
            "1. All monetary amounts should be BigDecimal with 2 decimal places",
            "2. Line calculations are done automatically (e.g., Line 5a = wages * 0.124)",
            "3. Validation runs automatically when submitted",
            "4. XML is generated only if validation passes",
            "5. For semiweekly depositors, attach Schedule B with daily tax liability",
            "6. Required fields: EIN, BusinessName, Address, Quarter, TaxYear, Deposit amounts, Signature info"
        });
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * Helper endpoint: Validate without XML generation
     * Useful for client-side validation feedback
     */
    @PostMapping("/validate-only")
    public ResponseEntity<?> validateOnly(@RequestBody Form941DTO form) {
        logger.info("Running validation only for EIN: {}", form.getEin());
        
        try {
            Form941SubmissionPackage submissionPackage = form941Service.processForm941(form);
            
            Map<String, Object> response = new HashMap<>();
            response.put("validationStatus", submissionPackage.getValidationStatus());
            response.put("isValid", "PASSED".equals(submissionPackage.getValidationStatus()));
            
            if (submissionPackage.getValidationResult() != null) {
                response.put("errorCount", submissionPackage.getValidationResult().errors.size());
                response.put("warningCount", submissionPackage.getValidationResult().warnings.size());
                
                if (!submissionPackage.getValidationResult().errors.isEmpty()) {
                    response.put("errors", submissionPackage.getValidationResult().errors);
                }
                if (!submissionPackage.getValidationResult().warnings.isEmpty()) {
                    response.put("warnings", submissionPackage.getValidationResult().warnings);
                }
            }
            
            HttpStatus httpStatus = "PASSED".equals(submissionPackage.getValidationStatus()) ? 
                HttpStatus.OK : HttpStatus.BAD_REQUEST;
            
            return new ResponseEntity<>(response, httpStatus);
            
        } catch (Exception e) {
            logger.error("Validation error: {}", e.getMessage(), e);
            
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("validationStatus", "ERROR");
            errorResponse.put("message", e.getMessage());
            
            return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    /**
     * Helper endpoint: Get XML schema information
     */
    @GetMapping("/schema-info")
    public ResponseEntity<?> getSchemaInfo() {
        Map<String, Object> schemaInfo = new HashMap<>();
        
        schemaInfo.put("formName", "Form 941");
        schemaInfo.put("formVersion", "2026v1.0");
        schemaInfo.put("irsNamespace", "http://www.irs.gov/efile/schemas/tax/desig941/2026v1.0");
        schemaInfo.put("meFileFormatType", "941-XML");
        
        Map<String, String> requiredFields = new HashMap<>();
        requiredFields.put("EIN", "Employer Identification Number (XX-XXXXXXX format)");
        requiredFields.put("BusinessName", "Name of employer (max 57 chars)");
        requiredFields.put("Address", "Full US address with City, State, ZIP");
        requiredFields.put("QuarterNumber", "1, 2, 3, or 4");
        requiredFields.put("TaxYear", "2020-2030");
        requiredFields.put("EmployeeCount", "Number of employees (Line 1)");
        requiredFields.put("TotalWages", "Total wages, tips, compensation (Line 2)");
        requiredFields.put("FederalIncomeTax", "Federal income tax withheld (Line 3)");
        requiredFields.put("TotalDeposits", "Total deposits for quarter (Line 13)");
        requiredFields.put("DepositScheduleType", "MonthlyScheduler or SemiweeklyScheduler");
        requiredFields.put("SignerName", "Name of person signing the form");
        requiredFields.put("SignerTitle", "Title of signer");
        requiredFields.put("SignatureDate", "Date of signature (YYYY-MM-DD)");
        
        schemaInfo.put("requiredFields", requiredFields);
        
        Map<String, String> validationRules = new HashMap<>();
        validationRules.put("SSWageCap2026", "$168,600 annual limit");
        validationRules.put("SSTaxRate", "12.4% (0.124)");
        validationRules.put("MedicareTaxRate", "2.9% (0.029)");
        validationRules.put("AdditionalMedicareTaxRate", "0.9% (0.009) for wages > $200,000");
        validationRules.put("FITValidation", "Cannot exceed total wages");
        validationRules.put("TaxConsistency", "Line 12 = Line 10 - Line 11");
        validationRules.put("NoNegativeTaxes", "Total taxes after credits must be >= 0");
        
        schemaInfo.put("validationRules", validationRules);
        
        Map<String, String> irsRequirements = new HashMap<>();
        irsRequirements.put("EFIN", "Electronic Filing Identification Number (must be IRS-assigned)");
        irsRequirements.put("ETIN", "Electronic Transmitter Identification Number");
        irsRequirements.put("Signature", "Form 8879-EMP or 94x Online Signature PIN");
        irsRequirements.put("Authorization", "Form 8655 (Power of Attorney) from employer");
        irsRequirements.put("Platform", "IRS Modernized e-File (MeF)");
        irsRequirements.put("Encryption", "Must transmit via secure HTTPS");
        irsRequirements.put("AuditTrail", "Keep records of submission and IRS ACK");
        
        schemaInfo.put("irsRequirements", irsRequirements);
        
        return ResponseEntity.ok(schemaInfo);
    }
    
    // Helper method
    private String calculateProcessingTime(Form941SubmissionPackage pkg) {
        if (pkg.getProcessingStartTime() != null && pkg.getProcessingEndTime() != null) {
            long millis = java.time.temporal.ChronoUnit.MILLIS.between(
                pkg.getProcessingStartTime(), 
                pkg.getProcessingEndTime()
            );
            return millis + "ms";
        }
        return "N/A";
    }
}

/**
 * USAGE EXAMPLE: Complete workflow in a Spring Boot application
 * 
 * 1. Create Form 941 DTO from UI input
 * 2. POST to /api/form941/validate-and-generate
 * 3. Receive validation results + XML
 * 4. If valid, store XML and prepare for IRS submission
 * 5. Transmit via IRS MeF platform with EFIN/ETIN credentials
 * 
 * Example cURL:
 * 
 * curl -X POST http://localhost:8080/api/form941/validate-and-generate \
 *   -H "Content-Type: application/json" \
 *   -d '{
 *     "ein": "12-3456789",
 *     "businessName": "ACME Corp",
 *     "addressStreet": "123 Main St",
 *     "addressCity": "Springfield",
 *     "addressState": "IL",
 *     "addressZip": "62701",
 *     "quarterNumber": 2,
 *     "taxYear": 2026,
 *     "line1EmployeeCount": 50,
 *     "line2WagesTipsCompensation": 500000.00,
 *     "line3FederalIncomeTax": 75000.00,
 *     "line5aSSWages": 500000.00,
 *     "line5cMedicareWages": 500000.00,
 *     "line13TotalDeposits": 151500.00,
 *     "depositScheduleType": "MonthlyScheduler",
 *     "month1TaxLiability": 50500.00,
 *     "month2TaxLiability": 50500.00,
 *     "month3TaxLiability": 50500.00,
 *     "signerName": "John Smith",
 *     "signerTitle": "Owner",
 *     "signatureDate": "2026-06-15"
 *   }'
 */
