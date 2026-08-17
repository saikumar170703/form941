package com.company.irs941.mef;

import com.company.irs941.dto.Form941DTO;

import java.net.InetAddress;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * IRS MeF Manifest Builder (manifest.xml)
 * Specification per attachments/IRS_MeF_SubmissionGuide_Complete.md
 */
public class MefManifestBuilder {

    private String efin = "10-1234";
    private String etin = "12345";
    private String dgvrPin = "54321";
    private String form941Xml;
    private String ein = "11-1111111";
    private String businessName = "APEX";
    private int taxYear = 2026;
    private int quarter = 1;

    public MefManifestBuilder() {}

    public MefManifestBuilder(Form941DTO dto, String form941Xml, String ein, String businessName) {
        this(dto, form941Xml, ein, businessName, null);
    }

    public MefManifestBuilder(Form941DTO dto, String form941Xml, String ein, String businessName, com.company.irs941.config.MefConfigProperties config) {
        this.form941Xml = form941Xml;
        this.ein = (ein != null && !ein.isEmpty()) ? ein : "11-1111111";
        this.businessName = (businessName != null && !businessName.isEmpty()) ? businessName : "APEX";
        if (config != null) {
            if (config.getEfin() != null) this.efin = config.getEfin();
            if (config.getEtin() != null) this.etin = config.getEtin();
            if (config.getDgvrPin() != null) this.dgvrPin = config.getDgvrPin();
        }
        if (dto != null) {
            if (dto.getTaxYear() != null) this.taxYear = dto.getTaxYear();
            if (dto.getQuarter() != null) this.quarter = dto.getQuarter();
            String p = dto.getLineValue("signaturePin");
            if (p != null && !p.isEmpty()) this.dgvrPin = p;
        }
    }

    public String buildManifest() {
        StringBuilder sb = new StringBuilder();

        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        sb.append("<Return xmlns=\"http://www.irs.gov/efile\" ");
        sb.append("xmlns:efile=\"http://www.irs.gov/efile\" ");
        sb.append("returnVersion=\"2026v4.0\">\n");

        sb.append("  <ReturnHeader>\n");

        // SubmissionId: YYYYMMDD + 12 alphanumeric unique identifier
        String submissionId = generateSubmissionId();
        sb.append("    <SubmissionId>").append(submissionId).append("</SubmissionId>\n");

        // EFIN & ETIN
        sb.append("    <Filer>\n");
        sb.append("      <EFIN>").append(efin).append("</EFIN>\n");
        sb.append("      <ETIN>").append(etin).append("</ETIN>\n");
        sb.append("    </Filer>\n");

        // Taxpayer Info
        sb.append("    <TaxpayerInfo>\n");
        sb.append("      <TIN>").append(ein).append("</TIN>\n");
        sb.append("      <BusinessName>").append(escapeXml(businessName)).append("</BusinessName>\n");
        sb.append("      <NameControl>").append(getNameControl(businessName)).append("</NameControl>\n");
        sb.append("    </TaxpayerInfo>\n");

        // Return Period
        String qtrEnding = taxYear + String.format("%02d", quarter * 3);
        sb.append("    <ReturnPeriod>\n");
        sb.append("      <TaxYear>").append(taxYear).append("</TaxYear>\n");
        sb.append("      <QuarterEndingDate>").append(qtrEnding).append("</QuarterEndingDate>\n");
        sb.append("    </ReturnPeriod>\n");

        // Form Type
        sb.append("    <FormType>941</FormType>\n");
        sb.append("    <ReturnType>941</ReturnType>\n");

        // Authentication PINs
        sb.append("    <SignatureOption>PIN</SignatureOption>\n");
        sb.append("    <OnlineFilerPIN>").append(dgvrPin).append("</OnlineFilerPIN>\n");
        sb.append("    <DGVR_PIN>").append(dgvrPin).append("</DGVR_PIN>\n");

        // Timestamps & IP
        String timestamp = ZonedDateTime.now().format(DateTimeFormatter.ISO_INSTANT);
        sb.append("    <SubmissionCreatedTimeStamp>").append(timestamp).append("</SubmissionCreatedTimeStamp>\n");
        sb.append("    <IPAddress>").append(getClientIpAddress()).append("</IPAddress>\n");

        sb.append("  </ReturnHeader>\n");

        sb.append("  <Return>\n");
        sb.append("    <efile:IRS941>\n");
        if (form941Xml != null) {
            sb.append(form941Xml);
        }
        sb.append("    </efile:IRS941>\n");
        sb.append("  </Return>\n");

        sb.append("</Return>\n");

        return sb.toString();
    }

    private String generateSubmissionId() {
        String datePrefix = ZonedDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String uniqueSuffix = UUID.randomUUID().toString()
                .replace("-", "")
                .substring(0, 12)
                .toUpperCase();
        return datePrefix + uniqueSuffix;
    }

    private String getNameControl(String name) {
        if (name == null || name.isEmpty()) return "APEX";
        String clean = name.replaceAll("[^a-zA-Z0-9]", "").toUpperCase();
        return clean.length() >= 4 ? clean.substring(0, 4) : clean;
    }

    private String getClientIpAddress() {
        try {
            return InetAddress.getLocalHost().getHostAddress();
        } catch (Exception e) {
            return "127.0.0.1";
        }
    }

    private String escapeXml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&apos;");
    }

    public void setEfin(String efin) { this.efin = efin; }
    public void setEtin(String etin) { this.etin = etin; }
    public void setDgvrPin(String pin) { this.dgvrPin = pin; }
    public void setForm941Xml(String xml) { this.form941Xml = xml; }
    public void setEin(String ein) { this.ein = ein; }
    public void setBusinessName(String name) { this.businessName = name; }
    public void setTaxYear(int year) { this.taxYear = year; }
    public void setQuarter(int qtr) { this.quarter = qtr; }
}
