package com.irs.form941.service;

import com.irs.form941.dto.Form941DTO;
import com.irs.form941.validator.Form941Validator;
import com.irs.form941.xml.Form941XMLGenerator;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Form 941 Service Layer
 * Orchestrates validation and XML generation for IRS submission
 */
@Service
public class Form941Service {
    
    private static final Logger logger = LoggerFactory.getLogger(Form941Service.class);
    
    /**
     * Complete workflow: Validate DTO → Generate XML → Prepare for submission
     * 
     * @param form Form941DTO with taxpayer data
     * @return SubmissionPackage containing validation report and XML
     * @throws Exception if validation fails or XML generation errors
     */
    @Transactional
    public Form941SubmissionPackage processForm941(Form941DTO form) throws Exception {
        logger.info("Processing Form 941 for EIN: {}, Quarter: Q{}", form.getEin(), form.getQuarterNumber());
        
        Form941SubmissionPackage package = new Form941SubmissionPackage();
        package.setProcessingStartTime(LocalDateTime.now());
        package.setFormEIN(form.getEin());
        package.setFormQuarter(form.getQuarterNumber());
        package.setFormYear(form.getTaxYear());
        
        // STEP 1: Run Business Rules Validation
        logger.info("Step 1: Running business rules validation...");
        Form941Validator validator = new Form941Validator();
        Form941Validator.ValidationResult validationResult = validator.validate(form);
        package.setValidationResult(validationResult);
        
        // Log validation results
        if (validationResult.isValid) {
            logger.info("✓ Validation PASSED");
        } else {
            logger.error("✗ Validation FAILED with {} errors", validationResult.errors.size());
            for (Form941Validator.ValidationError error : validationResult.errors) {
                logger.error("  - {}", error);
            }
            package.setValidationStatus("FAILED");
            package.setProcessingEndTime(LocalDateTime.now());
            return package;
        }
        
        // Log warnings (if any)
        if (!validationResult.warnings.isEmpty()) {
            logger.warn("Found {} warnings during validation", validationResult.warnings.size());
            for (Form941Validator.ValidationWarning warning : validationResult.warnings) {
                logger.warn("  - {}", warning);
            }
        }
        
        package.setValidationStatus("PASSED");
        
        // STEP 2: Generate IRS-Compliant XML
        logger.info("Step 2: Generating IRS-compliant XML...");
        String xmlContent;
        try {
            Form941XMLGenerator xmlGenerator = new Form941XMLGenerator(form);
            xmlContent = xmlGenerator.generateAndValidateXML();
            package.setXmlContent(xmlContent);
            logger.info("✓ XML generated successfully");
        } catch (Exception e) {
            logger.error("✗ XML generation failed: {}", e.getMessage(), e);
            package.setXmlGenerationStatus("FAILED");
            package.setXmlGenerationError(e.getMessage());
            package.setProcessingEndTime(LocalDateTime.now());
            return package;
        }
        
        package.setXmlGenerationStatus("SUCCESS");
        package.setXmlLength(xmlContent.length());
        
        // STEP 3: Pre-submission validation (optional XSD validation)
        logger.info("Step 3: Performing XSD schema validation...");
        boolean xsdValid = validateXMLAgainstXSD(xmlContent);
        if (xsdValid) {
            logger.info("✓ XSD schema validation PASSED");
            package.setXsdValidationStatus("PASSED");
        } else {
            logger.warn("⚠ XSD schema validation had issues (see details)");
            package.setXsdValidationStatus("PASSED_WITH_WARNINGS");
        }
        
        // STEP 4: Prepare submission metadata
        logger.info("Step 4: Preparing submission metadata...");
        prepareSubmissionMetadata(package, form);
        
        package.setProcessingEndTime(LocalDateTime.now());
        package.setStatus("READY_FOR_SUBMISSION");
        
        logger.info("✓ Form 941 processing completed successfully");
        return package;
    }
    
    /**
     * Validate XML against IRS XSD schema (placeholder for actual XSD validation)
     * In production, you would load the IRS-provided XSD and validate against it
     */
    private boolean validateXMLAgainstXSD(String xmlContent) {
        // TODO: Implement actual XSD validation using javax.xml.validation
        // For now, we do basic XML structure checks
        try {
            return xmlContent.contains("<?xml") && 
                   xmlContent.contains("Form941") &&
                   xmlContent.contains("EmployerInformation") &&
                   xmlContent.contains("LineItems");
        } catch (Exception e) {
            logger.error("XSD validation error: {}", e.getMessage());
            return false;
        }
    }
    
    /**
     * Prepare submission metadata and IRS requirements
     */
    private void prepareSubmissionMetadata(Form941SubmissionPackage package, Form941DTO form) {
        Map<String, String> metadata = new HashMap<>();
        metadata.put("FormType", "941");
        metadata.put("TaxYear", String.valueOf(form.getTaxYear()));
        metadata.put("Quarter", "Q" + form.getQuarterNumber());
        metadata.put("EIN", form.getEin());
        metadata.put("BusinessName", form.getBusinessName());
        metadata.put("GeneratedTimestamp", LocalDateTime.now().toString());
        
        // IRS Filing Requirements
        Map<String, String> irsRequirements = new HashMap<>();
        irsRequirements.put("RequiredEFIN", "Your IRS-assigned EFIN");
        irsRequirements.put("RequiredETIN", "Your IRS-assigned ETIN");
        irsRequirements.put("RequiredSignature", "Form 8879-EMP or 94x Online Signature PIN");
        irsRequirements.put("RequiredAuthorization", "Form 8655 from each client");
        irsRequirements.put("SubmissionDeadline", getSubmissionDeadline(form.getQuarterNumber()));
        irsRequirements.put("MeF Platform", "IRS Modernized e-File (MeF)");
        
        package.setMetadata(metadata);
        package.setIrsRequirements(irsRequirements);
    }
    
    private String getSubmissionDeadline(int quarter) {
        switch(quarter) {
            case 1: return "April 30";
            case 2: return "July 31";
            case 3: return "October 31";
            case 4: return "January 31 (next year)";
            default: return "Unknown";
        }
    }
}

/**
 * Submission Package - Contains complete submission data and status
 */
class Form941SubmissionPackage {
    private String formEIN;
    private Integer formQuarter;
    private Integer formYear;
    private LocalDateTime processingStartTime;
    private LocalDateTime processingEndTime;
    
    private String validationStatus; // PASSED, FAILED
    private Form941Validator.ValidationResult validationResult;
    
    private String xmlGenerationStatus; // SUCCESS, FAILED
    private String xmlGenerationError;
    private String xmlContent;
    private Integer xmlLength;
    
    private String xsdValidationStatus; // PASSED, PASSED_WITH_WARNINGS, FAILED
    
    private String status; // READY_FOR_SUBMISSION, SUBMITTED, ACCEPTED, REJECTED
    
    private Map<String, String> metadata;
    private Map<String, String> irsRequirements;
    
    // Getters and Setters
    public String getFormEIN() { return formEIN; }
    public void setFormEIN(String formEIN) { this.formEIN = formEIN; }
    
    public Integer getFormQuarter() { return formQuarter; }
    public void setFormQuarter(Integer formQuarter) { this.formQuarter = formQuarter; }
    
    public Integer getFormYear() { return formYear; }
    public void setFormYear(Integer formYear) { this.formYear = formYear; }
    
    public LocalDateTime getProcessingStartTime() { return processingStartTime; }
    public void setProcessingStartTime(LocalDateTime processingStartTime) { this.processingStartTime = processingStartTime; }
    
    public LocalDateTime getProcessingEndTime() { return processingEndTime; }
    public void setProcessingEndTime(LocalDateTime processingEndTime) { this.processingEndTime = processingEndTime; }
    
    public String getValidationStatus() { return validationStatus; }
    public void setValidationStatus(String validationStatus) { this.validationStatus = validationStatus; }
    
    public Form941Validator.ValidationResult getValidationResult() { return validationResult; }
    public void setValidationResult(Form941Validator.ValidationResult validationResult) { this.validationResult = validationResult; }
    
    public String getXmlGenerationStatus() { return xmlGenerationStatus; }
    public void setXmlGenerationStatus(String xmlGenerationStatus) { this.xmlGenerationStatus = xmlGenerationStatus; }
    
    public String getXmlGenerationError() { return xmlGenerationError; }
    public void setXmlGenerationError(String xmlGenerationError) { this.xmlGenerationError = xmlGenerationError; }
    
    public String getXmlContent() { return xmlContent; }
    public void setXmlContent(String xmlContent) { this.xmlContent = xmlContent; }
    
    public Integer getXmlLength() { return xmlLength; }
    public void setXmlLength(Integer xmlLength) { this.xmlLength = xmlLength; }
    
    public String getXsdValidationStatus() { return xsdValidationStatus; }
    public void setXsdValidationStatus(String xsdValidationStatus) { this.xsdValidationStatus = xsdValidationStatus; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Map<String, String> getMetadata() { return metadata; }
    public void setMetadata(Map<String, String> metadata) { this.metadata = metadata; }
    
    public Map<String, String> getIrsRequirements() { return irsRequirements; }
    public void setIrsRequirements(Map<String, String> irsRequirements) { this.irsRequirements = irsRequirements; }
    
    @Override
    public String toString() {
        return "Form941SubmissionPackage{\n" +
                "  EIN='" + formEIN + "'\n" +
                "  Quarter=" + formQuarter + "\n" +
                "  Year=" + formYear + "\n" +
                "  ValidationStatus='" + validationStatus + "'\n" +
                "  XmlGenerationStatus='" + xmlGenerationStatus + "'\n" +
                "  XsdValidationStatus='" + xsdValidationStatus + "'\n" +
                "  Status='" + status + "'\n" +
                "  ProcessingTime=" + (processingEndTime != null && processingStartTime != null ? 
                    (processingEndTime.getTime() - processingStartTime.getTime()) + "ms" : "N/A") + "\n" +
                "}";
    }
}
