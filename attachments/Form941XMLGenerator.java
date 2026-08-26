package com.irs.form941.xml;

import com.irs.form941.dto.Form941DTO;
import com.irs.form941.validator.Form941Validator;
import org.w3c.dom.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * Form 941 XML Generator
 * Converts validated Form941DTO to IRS-compliant XML for MeF (Modernized e-File) submission
 * 
 * IRS XML Schema Reference:
 * - Namespace: http://www.irs.gov/efile/schemas/tax/desig941/2026v1.0
 * - Root Element: Form941
 * - Must conform to IRS schema validation rules
 */
public class Form941XMLGenerator {
    
    private static final String IRS_NAMESPACE = "http://www.irs.gov/efile/schemas/tax/desig941/2026v1.0";
    private static final String FORM_VERSION = "2026v1.0";
    private static final String FORM_NAME = "941";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    private Form941DTO form;
    private Form941Validator.ValidationResult validationResult;
    
    public Form941XMLGenerator(Form941DTO form) {
        this.form = form;
    }
    
    /**
     * Main method: Validate and generate XML
     * Returns XML string if validation passes, throws exception if fails
     */
    public String generateAndValidateXML() throws Exception {
        // Step 1: Run validation
        Form941Validator validator = new Form941Validator();
        this.validationResult = validator.validate(form);
        
        // Step 2: Check if validation passed
        if (!this.validationResult.isValid) {
            StringBuilder errorMsg = new StringBuilder("Form 941 validation failed:\n");
            for (Form941Validator.ValidationError error : this.validationResult.errors) {
                errorMsg.append("  - ").append(error.toString()).append("\n");
            }
            throw new IllegalArgumentException(errorMsg.toString());
        }
        
        // Step 3: Generate XML
        return generateXML();
    }
    
    /**
     * Generate IRS-compliant XML from validated DTO
     */
    public String generateXML() throws Exception {
        // Create DOM Document
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.newDocument();
        
        // Create root element with namespace
        Element rootElement = doc.createElementNS(IRS_NAMESPACE, "Form941");
        rootElement.setAttribute("xmlns", IRS_NAMESPACE);
        rootElement.setAttribute("formVersion", FORM_VERSION);
        doc.appendChild(rootElement);
        
        // Create return header (required by IRS)
        Element returnHeader = createReturnHeader(doc);
        rootElement.appendChild(returnHeader);
        
        // Create tax return data
        Element taxReturnData = createTaxReturnData(doc);
        rootElement.appendChild(taxReturnData);
        
        // Convert DOM to XML string
        return domToString(doc);
    }
    
    /**
     * Create Return Header (IRS requires this)
     */
    private Element createReturnHeader(Document doc) {
        Element header = doc.createElement("ReturnHeader");
        
        // Submission ID (unique identifier)
        appendChild(header, "SubmissionId", UUID.randomUUID().toString());
        
        // Tax Period
        Element taxPeriod = doc.createElement("TaxPeriod");
        appendChild(taxPeriod, "Year", String.valueOf(form.getTaxYear()));
        appendChild(taxPeriod, "Quarter", String.valueOf(form.getQuarterNumber()));
        header.appendChild(taxPeriod);
        
        // Form Type
        appendChild(header, "FormType", FORM_NAME);
        
        // Tax Year
        appendChild(header, "TaxYear", String.valueOf(form.getTaxYear()));
        
        // Submission Date (today)
        appendChild(header, "SubmissionDate", LocalDate.now().format(DATE_FORMATTER));
        
        return header;
    }
    
    /**
     * Create Tax Return Data - the actual Form 941 data
     */
    private Element createTaxReturnData(Document doc) {
        Element taxReturnData = doc.createElement("TaxReturnData");
        
        // PART 1: Employer Information
        Element employerInfo = createEmployerInformation(doc);
        taxReturnData.appendChild(employerInfo);
        
        // PART 1: Quarter Information
        Element quarterInfo = createQuarterInformation(doc);
        taxReturnData.appendChild(quarterInfo);
        
        // PART 1: Line Items (Tax Data)
        Element lineItems = createLineItems(doc);
        taxReturnData.appendChild(lineItems);
        
        // PART 2: Deposit Schedule
        Element depositSchedule = createDepositSchedule(doc);
        taxReturnData.appendChild(depositSchedule);
        
        // PART 3: Business Information
        Element businessInfo = createBusinessInformation(doc);
        taxReturnData.appendChild(businessInfo);
        
        // PART 4: Third-Party Designee
        if (form.getHasDesignee() != null && form.getHasDesignee()) {
            Element designee = createDesigneeInfo(doc);
            taxReturnData.appendChild(designee);
        }
        
        // PART 5: Declaration (Signature Info)
        Element declaration = createDeclaration(doc);
        taxReturnData.appendChild(declaration);
        
        return taxReturnData;
    }
    
    /**
     * Create Employer Information Section
     */
    private Element createEmployerInformation(Document doc) {
        Element employer = doc.createElement("EmployerInformation");
        
        appendChild(employer, "EIN", form.getEin());
        appendChild(employer, "BusinessName", form.getBusinessName());
        
        if (form.getTradeName() != null && !form.getTradeName().isEmpty()) {
            appendChild(employer, "TradeName", form.getTradeName());
        }
        
        // Address
        Element address = doc.createElement("Address");
        appendChild(address, "Street", form.getAddressStreet());
        if (form.getAddressSuite() != null && !form.getAddressSuite().isEmpty()) {
            appendChild(address, "Suite", form.getAddressSuite());
        }
        appendChild(address, "City", form.getAddressCity());
        appendChild(address, "State", form.getAddressState());
        appendChild(address, "ZipCode", form.getAddressZip());
        
        // Foreign address (if applicable)
        if (form.getForeignCountry() != null && !form.getForeignCountry().isEmpty()) {
            appendChild(address, "ForeignCountry", form.getForeignCountry());
        }
        
        employer.appendChild(address);
        
        return employer;
    }
    
    /**
     * Create Quarter Information Section
     */
    private Element createQuarterInformation(Document doc) {
        Element quarter = doc.createElement("QuarterInformation");
        
        appendChild(quarter, "TaxYear", String.valueOf(form.getTaxYear()));
        appendChild(quarter, "QuarterNumber", String.valueOf(form.getQuarterNumber()));
        
        // Get quarter month range for display
        String quarterRange = getQuarterMonthRange(form.getQuarterNumber());
        appendChild(quarter, "QuarterDescription", quarterRange);
        
        // Aggregate Return Filers section (if applicable)
        if (form.getAggregateFilerType() != null && !form.getAggregateFilerType().isEmpty()) {
            Element aggregateFilers = doc.createElement("AggregateReturnFilersOnly");
            appendChild(aggregateFilers, "FilerType", form.getAggregateFilerType());
            quarter.appendChild(aggregateFilers);
        }
        
        return quarter;
    }
    
    /**
     * Create Line Items (the actual tax calculation data)
     */
    private Element createLineItems(Document doc) {
        Element lineItems = doc.createElement("LineItems");
        
        // Line 1: Employee Count
        appendBigDecimalElement(lineItems, "Line1EmployeeCount", 
            new BigDecimal(form.getLine1EmployeeCount()));
        
        // Line 2: Wages, Tips, Other Compensation
        appendBigDecimalElement(lineItems, "Line2WagesTipsCompensation", 
            form.getLine2WagesTipsCompensation());
        
        // Line 3: Federal Income Tax Withheld
        appendBigDecimalElement(lineItems, "Line3FederalIncomeTaxWithheld", 
            form.getLine3FederalIncomeTax());
        
        // Line 5a: Taxable Social Security Wages
        if (form.getLine5aSSWages() != null && form.getLine5aSSWages().compareTo(BigDecimal.ZERO) > 0) {
            Element line5a = doc.createElement("Line5a");
            appendBigDecimalElement(line5a, "WagesAmount", form.getLine5aSSWages());
            appendBigDecimalElement(line5a, "TaxRate", new BigDecimal("0.124"));
            appendBigDecimalElement(line5a, "CalculatedTax", form.getLine5aSSCalculated());
            lineItems.appendChild(line5a);
        }
        
        // Line 5b: Taxable Social Security Tips
        if (form.getLine5bSSTips() != null && form.getLine5bSSTips().compareTo(BigDecimal.ZERO) > 0) {
            Element line5b = doc.createElement("Line5b");
            appendBigDecimalElement(line5b, "TipsAmount", form.getLine5bSSTips());
            appendBigDecimalElement(line5b, "TaxRate", new BigDecimal("0.124"));
            appendBigDecimalElement(line5b, "CalculatedTax", form.getLine5bSSCalculated());
            lineItems.appendChild(line5b);
        }
        
        // Line 5c: Taxable Medicare Wages & Tips
        if (form.getLine5cMedicareWages() != null && form.getLine5cMedicareWages().compareTo(BigDecimal.ZERO) > 0) {
            Element line5c = doc.createElement("Line5c");
            appendBigDecimalElement(line5c, "WagesAmount", form.getLine5cMedicareWages());
            appendBigDecimalElement(line5c, "TaxRate", new BigDecimal("0.029"));
            appendBigDecimalElement(line5c, "CalculatedTax", form.getLine5cMedicareCalculated());
            lineItems.appendChild(line5c);
        }
        
        // Line 5d: Additional Medicare Tax
        if (form.getLine5dAdditionalMedicare() != null && 
            form.getLine5dAdditionalMedicare().compareTo(BigDecimal.ZERO) > 0) {
            Element line5d = doc.createElement("Line5d");
            appendBigDecimalElement(line5d, "WagesAmount", form.getLine5dAdditionalMedicare());
            appendBigDecimalElement(line5d, "TaxRate", new BigDecimal("0.009"));
            appendBigDecimalElement(line5d, "CalculatedTax", form.getLine5dAdditionalCalculated());
            lineItems.appendChild(line5d);
        }
        
        // Line 5e: Total Social Security and Medicare Taxes
        appendBigDecimalElement(lineItems, "Line5eTotalSSMedicareTaxes", 
            form.getLine5eTotalSSMedicare());
        
        // Line 5f: Section 3121(q) Notice and Demand
        if (form.getLine5fSection3121q() != null && form.getLine5fSection3121q().compareTo(BigDecimal.ZERO) > 0) {
            appendBigDecimalElement(lineItems, "Line5fSection3121q", form.getLine5fSection3121q());
        }
        
        // Line 6: Total Taxes Before Adjustments
        appendBigDecimalElement(lineItems, "Line6TaxesBeforeAdjustments", 
            form.getLine6TaxesBeforeAdjustments());
        
        // Line 7: Adjustment for Fractions of Cents
        if (form.getLine7AdjustmentFractions() != null) {
            appendBigDecimalElement(lineItems, "Line7AdjustmentFractions", 
                form.getLine7AdjustmentFractions());
        }
        
        // Line 8: Adjustment for Sick Pay
        if (form.getLine8AdjustmentSickPay() != null) {
            appendBigDecimalElement(lineItems, "Line8AdjustmentSickPay", 
                form.getLine8AdjustmentSickPay());
        }
        
        // Line 9: Adjustment for Tips and Group-Term Life Insurance
        if (form.getLine9AdjustmentTipsGroupTerm() != null) {
            appendBigDecimalElement(lineItems, "Line9AdjustmentTipsGroupTerm", 
                form.getLine9AdjustmentTipsGroupTerm());
        }
        
        // Line 10: Total Taxes After Adjustments
        appendBigDecimalElement(lineItems, "Line10TaxesAfterAdjustments", 
            form.getLine10TaxesAfterAdjustments());
        
        // Line 11: Credits
        if (form.getLine11QualifiedSmallBusinessCredit() != null && 
            form.getLine11QualifiedSmallBusinessCredit().compareTo(BigDecimal.ZERO) > 0) {
            appendBigDecimalElement(lineItems, "Line11QualifiedSmallBusinessCredit", 
                form.getLine11QualifiedSmallBusinessCredit());
        }
        
        // Line 12: Total Taxes After Credits
        appendBigDecimalElement(lineItems, "Line12TotalTaxesAfterCredits", 
            form.getLine12TotalTaxesAfterCredits());
        
        // Line 13: Total Deposits
        appendBigDecimalElement(lineItems, "Line13TotalDeposits", 
            form.getLine13TotalDeposits());
        
        // Line 14: Balance Due
        if (form.getLine14BalanceDue().compareTo(BigDecimal.ZERO) > 0) {
            appendBigDecimalElement(lineItems, "Line14BalanceDue", 
                form.getLine14BalanceDue());
        }
        
        // Line 15: Overpayment
        if (form.getLine15aOverpayment().compareTo(BigDecimal.ZERO) > 0) {
            Element line15 = doc.createElement("Line15Overpayment");
            appendBigDecimalElement(line15, "Amount", form.getLine15aOverpayment());
            appendChild(line15, "Action", form.getLine15bOverpaymentAction());
            lineItems.appendChild(line15);
        }
        
        return lineItems;
    }
    
    /**
     * Create Deposit Schedule Information
     */
    private Element createDepositSchedule(Document doc) {
        Element schedule = doc.createElement("DepositScheduleInformation");
        
        appendChild(schedule, "ScheduleType", form.getDepositScheduleType());
        
        if ("MonthlyScheduler".equals(form.getDepositScheduleType())) {
            Element monthly = doc.createElement("MonthlySchedule");
            
            if (form.getMonth1TaxLiability() != null) {
                appendBigDecimalElement(monthly, "Month1Liability", form.getMonth1TaxLiability());
            }
            if (form.getMonth2TaxLiability() != null) {
                appendBigDecimalElement(monthly, "Month2Liability", form.getMonth2TaxLiability());
            }
            if (form.getMonth3TaxLiability() != null) {
                appendBigDecimalElement(monthly, "Month3Liability", form.getMonth3TaxLiability());
            }
            
            schedule.appendChild(monthly);
        } else if ("SemiweeklyScheduler".equals(form.getDepositScheduleType())) {
            // Schedule B data would be added here
            Element scheduleB = doc.createElement("ScheduleBRequired");
            appendChild(scheduleB, "Status", "AttachScheduleB");
            schedule.appendChild(scheduleB);
        }
        
        return schedule;
    }
    
    /**
     * Create Business Information Section
     */
    private Element createBusinessInformation(Document doc) {
        Element business = doc.createElement("BusinessInformation");
        
        if (form.getBusinessClosed() != null && form.getBusinessClosed()) {
            Element closed = doc.createElement("ClosedBusiness");
            appendChild(closed, "Status", "Yes");
            if (form.getBusinessClosureDate() != null) {
                appendChild(closed, "ClosureDate", form.getBusinessClosureDate().format(DATE_FORMATTER));
            }
            business.appendChild(closed);
        }
        
        if (form.getSeasonalEmployer() != null && form.getSeasonalEmployer()) {
            appendChild(business, "SeasonalEmployer", "Yes");
        }
        
        return business;
    }
    
    /**
     * Create Designee Information (Third-Party Representative)
     */
    private Element createDesigneeInfo(Document doc) {
        Element designee = doc.createElement("DesigneeInformation");
        
        appendChild(designee, "DesigneeName", form.getDesigneeName());
        appendChild(designee, "DesigneePhone", form.getDesigneePhone());
        appendChild(designee, "DesigneePIN", form.getDesigneePIN());
        
        return designee;
    }
    
    /**
     * Create Declaration (Signature Section)
     */
    private Element createDeclaration(Document doc) {
        Element declaration = doc.createElement("Declaration");
        
        appendChild(declaration, "SignerName", form.getSignerName());
        appendChild(declaration, "SignerTitle", form.getSignerTitle());
        appendChild(declaration, "SignatureDate", form.getSignatureDate().format(DATE_FORMATTER));
        
        if (form.getDayPhoneNumber() != null) {
            appendChild(declaration, "DayPhoneNumber", form.getDayPhoneNumber());
        }
        
        // Paid Preparer Information (if applicable)
        if (form.getPreparedByThirdParty() != null && form.getPreparedByThirdParty()) {
            Element preparer = doc.createElement("PaidPreparer");
            appendChild(preparer, "PreparerName", form.getPreparerName());
            appendChild(preparer, "PreparerPTIN", form.getPreparerPTIN());
            if (form.getPreparerSignatureDate() != null) {
                appendChild(preparer, "PreparerSignatureDate", form.getPreparerSignatureDate().format(DATE_FORMATTER));
            }
            if (form.getPreparerFirmName() != null) {
                appendChild(preparer, "FirmName", form.getPreparerFirmName());
            }
            if (form.getPreparerFirmEIN() != null) {
                appendChild(preparer, "FirmEIN", form.getPreparerFirmEIN());
            }
            declaration.appendChild(preparer);
        }
        
        return declaration;
    }
    
    // Helper Methods
    
    private void appendChild(Element parent, String elementName, String value) {
        if (value != null && !value.isEmpty()) {
            Element child = parent.getOwnerDocument().createElement(elementName);
            child.setTextContent(value);
            parent.appendChild(child);
        }
    }
    
    private void appendBigDecimalElement(Element parent, String elementName, BigDecimal value) {
        if (value != null) {
            Element child = parent.getOwnerDocument().createElement(elementName);
            // Format to 2 decimal places for currency
            child.setTextContent(value.setScale(2, BigDecimal.ROUND_HALF_UP).toPlainString());
            parent.appendChild(child);
        }
    }
    
    private String getQuarterMonthRange(int quarter) {
        switch(quarter) {
            case 1: return "January, February, March";
            case 2: return "April, May, June";
            case 3: return "July, August, September";
            case 4: return "October, November, December";
            default: return "Unknown Quarter";
        }
    }
    
    private String domToString(Document doc) throws Exception {
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        transformer.setOutputProperty("indent", "yes");
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
        transformer.setOutputProperty("encoding", "UTF-8");
        
        StringWriter sw = new StringWriter();
        transformer.transform(new DOMSource(doc), new StreamResult(sw));
        return sw.toString();
    }
}
