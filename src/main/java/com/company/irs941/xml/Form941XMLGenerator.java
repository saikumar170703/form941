package com.company.irs941.xml;

import com.company.irs941.dto.Form941DTO;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * IRS Form 941 MeF XML Generator
 * Conforms to IRS MeF XSD Schema (attachments/941xsd.txt)
 * Namespace: http://www.irs.gov/efile
 */
public class Form941XMLGenerator {

    private static final String IRS_NAMESPACE = "http://www.irs.gov/efile";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    private final Form941DTO dto;

    public Form941XMLGenerator(Form941DTO dto) {
        this.dto = dto;
    }

    public String generateXML() throws Exception {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document doc = db.newDocument();

        // Root element <IRS941>
        Element root = doc.createElementNS(IRS_NAMESPACE, "IRS941");
        root.setAttribute("documentName", "IRS941");
        doc.appendChild(root);

        // <ReturnHeader>
        Element header = doc.createElement("ReturnHeader");
        appendChild(header, "SubmissionId", "IRS941-" + UUID.randomUUID().toString().substring(0, 18).toUpperCase());
        
        Element taxPeriod = doc.createElement("TaxPeriod");
        appendChild(taxPeriod, "Year", String.valueOf(dto.getTaxYear() != null ? dto.getTaxYear() : 2026));
        appendChild(taxPeriod, "Quarter", String.valueOf(dto.getQuarter() != null ? dto.getQuarter() : 1));
        header.appendChild(taxPeriod);

        appendChild(header, "FormType", "941");
        appendChild(header, "TaxYear", String.valueOf(dto.getTaxYear() != null ? dto.getTaxYear() : 2026));
        appendChild(header, "SubmissionDate", LocalDate.now().format(DATE_FORMATTER));
        root.appendChild(header);

        // <IRS941Type> Content Model
        Element returnData = doc.createElement("TaxReturnData");

        // Line 1: EmployeeCnt
        appendChild(returnData, "EmployeeCnt", getVal("1", "0"));

        // Line 2: WagesAmt
        appendAmount(returnData, "WagesAmt", getDecimal("2"));

        // Line 3: FederalIncomeTaxWithheldAmt
        appendAmount(returnData, "FederalIncomeTaxWithheldAmt", getDecimal("3"));

        // Line 4: WagesNotSubjToSSMedcrTaxInd
        if ("true".equalsIgnoreCase(getVal("4"))) {
            appendChild(returnData, "WagesNotSubjToSSMedcrTaxInd", "X");
        }

        // Line 5a: SocialSecurityWageAndTaxGrp
        BigDecimal ssWages = getDecimal("5a_wages");
        if (ssWages.compareTo(BigDecimal.ZERO) > 0) {
            Element grp = doc.createElement("SocialSecurityWageAndTaxGrp");
            appendAmount(grp, "SocialSecurityTaxCashWagesAmt", ssWages);
            appendAmount(grp, "SocialSecurityTaxAmt", getDecimal("5a_tax"));
            returnData.appendChild(grp);
        }

        // Line 5b: SocialSecurityTipsAndTaxGrp
        BigDecimal ssTips = getDecimal("5b_tips");
        if (ssTips.compareTo(BigDecimal.ZERO) > 0) {
            Element grp = doc.createElement("SocialSecurityTipsAndTaxGrp");
            appendAmount(grp, "TaxableSocSecTipsAmt", ssTips);
            appendAmount(grp, "TaxOnSocialSecurityTipsAmt", getDecimal("5b_tax"));
            returnData.appendChild(grp);
        }

        // Line 5c: MedicareWageTipsAndTaxGrp
        BigDecimal medWages = getDecimal("5c_wages");
        if (medWages.compareTo(BigDecimal.ZERO) > 0) {
            Element grp = doc.createElement("MedicareWageTipsAndTaxGrp");
            appendAmount(grp, "TaxableMedicareWagesTipsAmt", medWages);
            appendAmount(grp, "TaxOnMedicareWagesTipsAmt", getDecimal("5c_tax"));
            returnData.appendChild(grp);
        }

        // Line 5d: AddnlMedicareWageTipsAndTaxGrp
        BigDecimal addlWages = getDecimal("5d_wages");
        if (addlWages.compareTo(BigDecimal.ZERO) > 0) {
            Element grp = doc.createElement("AddnlMedicareWageTipsAndTaxGrp");
            appendAmount(grp, "TxblWageTipsSubjAddnlMedcrAmt", addlWages);
            appendAmount(grp, "TaxOnWageTipsSubjAddnlMedcrAmt", getDecimal("5d_tax"));
            returnData.appendChild(grp);
        }

        // Line 5e: TotalSSMdcrTaxAmt
        appendAmount(returnData, "TotalSSMdcrTaxAmt", getDecimal("5e"));

        // Line 5f: TaxOnUnreportedTips3121qAmt
        BigDecimal line5f = getDecimal("5f");
        if (line5f.compareTo(BigDecimal.ZERO) > 0) {
            appendAmount(returnData, "TaxOnUnreportedTips3121qAmt", line5f);
        }

        // Line 6: TotalTaxBeforeAdjustmentAmt
        appendAmount(returnData, "TotalTaxBeforeAdjustmentAmt", getDecimal("6"));

        // Line 7: CurrentQtrFractionsCentsAmt
        BigDecimal line7 = getDecimal("7");
        if (line7.compareTo(BigDecimal.ZERO) != 0) {
            appendAmount(returnData, "CurrentQtrFractionsCentsAmt", line7);
        }

        // Line 8: CurrentQuarterSickPaymentAmt
        BigDecimal line8 = getDecimal("8");
        if (line8.compareTo(BigDecimal.ZERO) != 0) {
            appendAmount(returnData, "CurrentQuarterSickPaymentAmt", line8);
        }

        // Line 9: CurrQtrTipGrpTermLifeInsAdjAmt
        BigDecimal line9 = getDecimal("9");
        if (line9.compareTo(BigDecimal.ZERO) != 0) {
            appendAmount(returnData, "CurrQtrTipGrpTermLifeInsAdjAmt", line9);
        }

        // Line 10: TotalTaxAfterAdjustmentAmt
        appendAmount(returnData, "TotalTaxAfterAdjustmentAmt", getDecimal("10"));

        // Line 11: PayrollTaxCreditAmt
        BigDecimal line11 = getDecimal("11");
        if (line11.compareTo(BigDecimal.ZERO) > 0) {
            appendAmount(returnData, "PayrollTaxCreditAmt", line11);
        }

        // Line 12: TotalTaxAmt
        appendAmount(returnData, "TotalTaxAmt", getDecimal("12"));

        // Line 13: TotalTaxDepositAmt
        appendAmount(returnData, "TotalTaxDepositAmt", getDecimal("13"));

        // Line 14 / Line 15 Choice
        BigDecimal line14 = getDecimal("14");
        BigDecimal line15a = getDecimal("15a");

        if (line14.compareTo(BigDecimal.ZERO) > 0) {
            appendAmount(returnData, "BalanceDueAmt", line14);
        } else if (line15a.compareTo(BigDecimal.ZERO) > 0) {
            Element overpaymentGrp = doc.createElement("OverpaymentGrp");
            appendAmount(overpaymentGrp, "OverpaidAmt", line15a);
            String choice = getVal("15b");
            if ("REFUND".equalsIgnoreCase(choice) || "SendRefund".equalsIgnoreCase(choice)) {
                appendChild(overpaymentGrp, "RefundOverpaymentInd", "X");
            } else {
                appendChild(overpaymentGrp, "ApplyOverpaymentNextReturnInd", "X");
            }
            returnData.appendChild(overpaymentGrp);
        }

        // DirectDepositGrp (Lines 15c-e)
        String routing = getVal("15c");
        if (routing != null && !routing.isEmpty()) {
            Element ddGrp = doc.createElement("DirectDepositGrp");
            appendChild(ddGrp, "RoutingTransitNum", routing);
            appendChild(ddGrp, "AccountTypeCd", "CHECKING".equalsIgnoreCase(getVal("15d")) ? "1" : "2");
            appendChild(ddGrp, "BankAccountNum", getVal("15e"));
            returnData.appendChild(ddGrp);
        }

        // Part 2: Deposit Schedule Information (Line 16)
        String sched = getVal("16");
        if ("lessThan2500".equalsIgnoreCase(sched)) {
            appendChild(returnData, "TotalTaxLessThanLimitAmtInd", "X");
        } else if ("monthly".equalsIgnoreCase(sched)) {
            Element mGrp = doc.createElement("MonthlyScheduleDepositorGrp");
            appendChild(mGrp, "MonthlyScheduleDepositorInd", "X");
            appendAmount(mGrp, "TaxLiabilityMonth1Amt", getDecimal("sb_m1_total"));
            appendAmount(mGrp, "TaxLiabilityMonth2Amt", getDecimal("sb_m2_total"));
            appendAmount(mGrp, "TaxLiabilityMonth3Amt", getDecimal("sb_m3_total"));
            appendAmount(mGrp, "TotalQuarterTaxLiabilityAmt", getDecimal("sb_quarter_total"));
            returnData.appendChild(mGrp);
        } else if ("semiweekly".equalsIgnoreCase(sched)) {
            appendChild(returnData, "SemiweeklyScheduleDepositorInd", "X");
        }

        // Part 3: Business Information (Line 17 & 18)
        if ("true".equalsIgnoreCase(getVal("line17")) || "true".equalsIgnoreCase(getVal("17"))) {
            Element closedGrp = doc.createElement("BusinessClosedGrp");
            appendChild(closedGrp, "FutureFilingNotRequiredInd", "X");
            String dt = getVal("finalDateWages");
            if (dt != null && !dt.isEmpty()) {
                appendChild(closedGrp, "FinalWagesPaidDt", dt);
            }
            returnData.appendChild(closedGrp);
        }

        if ("true".equalsIgnoreCase(getVal("line18")) || "true".equalsIgnoreCase(getVal("18"))) {
            appendChild(returnData, "SeasonalEmployerInd", "X");
        }

        // Part 4: Third-Party Designee Information
        if ("yes".equalsIgnoreCase(getVal("designeeChoice"))) {
            Element desGrp = doc.createElement("DesigneeInformation");
            appendChild(desGrp, "DesigneeName", getVal("designeeName"));
            appendChild(desGrp, "DesigneePhone", getVal("designeePhone"));
            appendChild(desGrp, "DesigneePIN", getVal("designeePin"));
            returnData.appendChild(desGrp);
        }

        // Part 5: Signature & Paid Preparer Information
        Element decl = doc.createElement("Declaration");
        appendChild(decl, "SignerName", getVal("signatureName"));
        appendChild(decl, "SignerTitle", getVal("signatureTitle"));
        appendChild(decl, "SignatureDate", getVal("signatureDate"));
        appendChild(decl, "DayPhoneNumber", getVal("signaturePhone"));

        if ("true".equalsIgnoreCase(getVal("paidPreparerCheck"))) {
            Element prep = doc.createElement("PaidPreparer");
            appendChild(prep, "PreparerName", getVal("preparerName"));
            appendChild(prep, "PreparerPTIN", getVal("preparerPtin"));
            appendChild(prep, "PreparerSignatureDate", getVal("preparerDate"));
            appendChild(prep, "FirmName", getVal("preparerFirmName"));
            appendChild(prep, "FirmEIN", getVal("preparerEin"));
            decl.appendChild(prep);
        }
        returnData.appendChild(decl);

        root.appendChild(returnData);

        return domToString(doc);
    }

    private String getVal(String key) {
        if (dto == null) return null;
        return dto.getLineValue(key);
    }

    private String getVal(String key, String defaultVal) {
        String v = getVal(key);
        return (v != null && !v.trim().isEmpty()) ? v : defaultVal;
    }

    private BigDecimal getDecimal(String key) {
        String v = getVal(key);
        if (v == null || v.trim().isEmpty()) return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        try {
            String clean = v.replaceAll("[,\\$]", "").trim();
            return new BigDecimal(clean).setScale(2, RoundingMode.HALF_UP);
        } catch (Exception e) {
            return BigDecimal.ZERO.setScale(2, RoundingMode.HALF_UP);
        }
    }

    private void appendChild(Element parent, String name, String val) {
        if (val != null && !val.trim().isEmpty()) {
            Element child = parent.getOwnerDocument().createElement(name);
            child.setTextContent(val.trim());
            parent.appendChild(child);
        }
    }

    private void appendAmount(Element parent, String name, BigDecimal amt) {
        if (amt != null) {
            Element child = parent.getOwnerDocument().createElement(name);
            child.setTextContent(amt.setScale(2, RoundingMode.HALF_UP).toPlainString());
            parent.appendChild(child);
        }
    }

    private String domToString(Document doc) throws Exception {
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer transformer = tf.newTransformer();
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");

        StringWriter sw = new StringWriter();
        transformer.transform(new DOMSource(doc), new StreamResult(sw));
        return sw.toString();
    }
}
