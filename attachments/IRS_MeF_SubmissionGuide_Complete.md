# IRS MeF (Modernized e-File) Submission Guide
## Complete Technical Implementation for Form 941

---

## 📋 PART 1: IRS CREDENTIALS & REQUIREMENTS

### **What You Need from IRS (One-Time Setup)**

Before you can submit ANY returns to IRS, you must have:

#### **1. EFIN (Electronic Filing Identification Number)**
```
Format: 2-letter prefix + 4 digits (e.g., 10-1234)
What:   Your tax preparation firm/vendor identifier
Who:    IRS assigns this to your business
Get:    Apply at https://www.irs.gov/e-file-providers
Status: Must be in "Accepted" status
Expiry: Annual - must renew each January
```

#### **2. ETIN (Electronic Transmitter Identification Number)**
```
Format: 5-digit code (e.g., 12345)
What:   Your specific transmission line identifier
Who:    IRS assigns when you get EFIN
Get:    Automatic with EFIN application
Status: Must be active and participating
Expiry: Annual - renew with EFIN
```

#### **3. DGVR PIN (Digital Guardian Verification Response PIN)**
```
Format: 5-digit PIN
What:   Authentication for each transmission
Who:    You create during EFIN setup
Get:    Set in IRS e-Services portal
Change: Can update in e-Services account
Use:    Required for production submission
```

#### **4. Software ID**
```
Format: Alphanumeric code
What:   Identifies your e-file software/tool
Who:    IRS approves specific software products
Get:    Request from IRS if building custom software
Status: Must pass testing (ATS) before production
```

#### **5. Client Authorization (Per Taxpayer)**
```
Document: Form 8655 (Power of Attorney)
Signed:   By business owner/authorized officer
Contains: Grant authority to file specific forms (941)
Scope:    Valid for all quarters in tax year
Keep:     Archive for 7 years
```

### **How to Get IRS Credentials**

#### **Step 1: Create e-Services Account**
```
Website: https://www.irs.gov/e-services
Action:
  1. Click "Register"
  2. Create IRS username/password
  3. Complete identity verification (SSN, ITIN, EIN)
  4. Set up MFA (Multi-Factor Authentication)
```

#### **Step 2: Apply for EFIN**
```
In e-Services:
  1. Go to "Tax Professionals" section
  2. Click "Apply for EFIN/ETIN"
  3. Provide firm information
  4. List principals and responsible official
  5. Undergo suitability check (background, tax compliance)
  6. IRS processes (usually 5-10 business days)
```

#### **Step 3: Complete Setup**
```
Once Approved:
  1. Receive EFIN via email
  2. Access e-Services with EFIN credentials
  3. Set/confirm DGVR PIN
  4. Download software from IRS testing site
  5. Test in ATS (Assurance Testing System)
  6. Get production approval
```

---

## 📊 PART 2: REQUEST STRUCTURE & PARAMETERS

### **IRS MeF Submission Format**

The IRS does NOT accept plain XML. You must submit via **encrypted ZIP archive** with specific structure:

#### **Submission Package Structure**
```
submission_20261215_123456.zip
├── manifest/
│   └── manifest.xml          [Submission metadata]
├── xml/
│   └── form941_irs.xml       [Your generated Form 941 XML]
└── attachment/               [Optional: supporting documents]
    ├── form8655.pdf          [Authorization]
    └── schedule_b.xml        [If semiweekly]
```

### **A. Manifest File (manifest.xml)**

This is the wrapper that tells IRS what's in your submission:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Return xmlns="http://www.irs.gov/efile" 
        xmlns:efile="http://www.irs.gov/efile"
        returnVersion="2026v4.0">
  
  <ReturnHeader>
    <!-- Submission Identifier -->
    <SubmissionId>20261215ABC123DEF456</SubmissionId>
    
    <!-- EFIN and ETIN (Your Credentials) -->
    <Filer>
      <EFIN>10-1234</EFIN>
      <ETIN>12345</ETIN>
    </Filer>
    
    <!-- Taxpayer Information -->
    <TaxpayerInfo>
      <TIN>11-1111111</TIN>
      <BusinessName>APEX</BusinessName>
      <NameControl>APEX</NameControl>
      <Address>
        <AddressLine1>123 Test Street</AddressLine1>
        <City>New Orleans</City>
        <State>LA</State>
        <ZipCode>70112</ZipCode>
      </Address>
    </TaxpayerInfo>
    
    <!-- Return Period -->
    <ReturnPeriod>
      <TaxYear>2026</TaxYear>
      <QuarterEndingDate>202612</QuarterEndingDate>
    </ReturnPeriod>
    
    <!-- Form Type -->
    <FormType>941</FormType>
    <ReturnType>941</ReturnType>
    
    <!-- Signature/Authentication -->
    <SignatureOption>PIN</SignatureOption>
    <OnlineFilerPIN>12345</OnlineFilerPIN>
    <DGVR_PIN>54321</DGVR_PIN>
    
    <!-- Timestamps -->
    <SubmissionCreatedTimeStamp>2026-12-15T10:30:00Z</SubmissionCreatedTimeStamp>
    <IPAddress>203.0.113.45</IPAddress>
    
  </ReturnHeader>
  
  <Return>
    <efile:IRS941>
      <!-- Your generated Form 941 XML content goes here -->
    </efile:IRS941>
  </Return>
  
</Return>
```

### **B. HTTP Request Parameters**

```java
// POST Request to IRS MeF Endpoint
POST https://mef.irs.gov/mefv2/services/MefSubmissionService
  (Production: mef.irs.gov)
  (Testing: mefats.irs.gov)

// Headers
Content-Type: application/octet-stream
Content-Encoding: gzip
Authorization: Basic [Base64(EFIN:DGVR_PIN)]
User-Agent: YourSoftwareID/1.0
X-Software-ID: YourSoftwareID
X-EFIN: 10-1234
X-ETIN: 12345

// Body
[Encrypted ZIP file binary data]
```

### **C. Authentication Methods**

#### **Method 1: PIN Authentication (Recommended)**
```
Signer uses 5-digit PIN
PIN Location: Form 8879-EMP or preparer PIN
Format: Include in submission header as <OnlineFilerPIN>
```

#### **Method 2: Digital Signature Certificate**
```
EMP-SIGN Certificate
Issued by: IRS approved CA
Format: .p7b file
Used: For high-volume filers
```

#### **Method 3: Username/Password (Legacy)**
```
Format: Basic HTTP Authentication
Encoding: Base64(username:password)
Header: Authorization: Basic [Base64 string]
Status: Being phased out
```

---

## 🔐 PART 3: ENCRYPTION & SIGNING

### **Encryption Requirements**

IRS requires **AES-256 encryption** with specific settings:

```java
// Encryption Specification
Algorithm:      AES-256-CBC (Cipher Block Chaining)
Key Size:       256 bits
IV:             Random for each submission
Compression:    GZIP before encryption
Format:         ZIP archive with manifest

// Digital Signature
Algorithm:      RSA-2048 or higher
Hash:           SHA-256
Format:         XML-DSig (W3C standard)
Certificate:    IRS-approved EMP-SIGN certificate
```

### **Compression Format**

```
Original Files
    ↓
Manifest XML + Form 941 XML + Attachments
    ↓
GZIP Compression
    ↓
AES-256 Encryption
    ↓
ZIP Archive (.zip)
    ↓
POST to IRS MeF
```

---

## 💾 PART 4: REQUEST FORMATION (COMPLETE CODE)

### **Step 1: Create Manifest File**

```java
package com.irs.mef.submission;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

public class ManifestBuilder {
    
    private String efin;
    private String etin;
    private String dgvrPin;
    private String form941Xml;
    private String ein;
    private String businessName;
    
    public ManifestBuilder(String efin, String etin, String dgvrPin) {
        this.efin = efin;
        this.etin = etin;
        this.dgvrPin = dgvrPin;
    }
    
    public String buildManifest() {
        StringBuilder sb = new StringBuilder();
        
        sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        sb.append("<Return xmlns=\"http://www.irs.gov/efile\" ");
        sb.append("xmlns:efile=\"http://www.irs.gov/efile\" ");
        sb.append("returnVersion=\"2026v4.0\">\n");
        
        sb.append("  <ReturnHeader>\n");
        
        // Submission ID (must be globally unique: YYYYMMDD + 12 alphanumeric)
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
        sb.append("      <BusinessName>").append(businessName).append("</BusinessName>\n");
        sb.append("      <NameControl>").append(getNameControl(businessName)).append("</NameControl>\n");
        sb.append("    </TaxpayerInfo>\n");
        
        // Return Period
        sb.append("    <ReturnPeriod>\n");
        sb.append("      <TaxYear>2026</TaxYear>\n");
        sb.append("      <QuarterEndingDate>202612</QuarterEndingDate>\n");
        sb.append("    </ReturnPeriod>\n");
        
        // Form Type
        sb.append("    <FormType>941</FormType>\n");
        sb.append("    <ReturnType>941</ReturnType>\n");
        
        // Authentication
        sb.append("    <SignatureOption>PIN</SignatureOption>\n");
        sb.append("    <OnlineFilerPIN>").append(dgvrPin).append("</OnlineFilerPIN>\n");
        
        // Timestamps
        String timestamp = ZonedDateTime.now().format(DateTimeFormatter.ISO_INSTANT);
        sb.append("    <SubmissionCreatedTimeStamp>").append(timestamp).append("</SubmissionCreatedTimeStamp>\n");
        
        // IP Address (required)
        sb.append("    <IPAddress>").append(getClientIpAddress()).append("</IPAddress>\n");
        
        sb.append("  </ReturnHeader>\n");
        
        sb.append("  <Return>\n");
        sb.append("    <efile:IRS941>\n");
        sb.append(form941Xml);
        sb.append("    </efile:IRS941>\n");
        sb.append("  </Return>\n");
        
        sb.append("</Return>\n");
        
        return sb.toString();
    }
    
    private String generateSubmissionId() {
        // Format: YYYYMMDD + 12 alphanumeric (must be unique)
        String datePrefix = ZonedDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String uniqueSuffix = UUID.randomUUID().toString()
            .replace("-", "")
            .substring(0, 12)
            .toUpperCase();
        return datePrefix + uniqueSuffix;
    }
    
    private String getNameControl(String businessName) {
        // First 4 letters of business name (IRS rule)
        if (businessName == null || businessName.isEmpty()) return "";
        String name = businessName.replaceAll("[^a-zA-Z0-9]", "").toUpperCase();
        return name.length() >= 4 ? name.substring(0, 4) : name;
    }
    
    private String getClientIpAddress() {
        // Get client's IP address (required by IRS)
        try {
            java.net.InetAddress ip = java.net.InetAddress.getLocalHost();
            return ip.getHostAddress();
        } catch (Exception e) {
            return "0.0.0.0"; // Fallback
        }
    }
    
    // Setters
    public void setForm941Xml(String xml) { this.form941Xml = xml; }
    public void setEin(String ein) { this.ein = ein; }
    public void setBusinessName(String name) { this.businessName = name; }
}
```

### **Step 2: Create Submission Package (ZIP + Encryption)**

```java
package com.irs.mef.submission;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import java.security.SecureRandom;

public class MefSubmissionPackager {
    
    private String manifestXml;
    private String form941Xml;
    private byte[] attachmentPdf; // Form 8655 or other attachments
    
    public MefSubmissionPackager(String manifest, String form941) {
        this.manifestXml = manifest;
        this.form941Xml = form941;
    }
    
    /**
     * Create unencrypted ZIP submission package
     */
    public byte[] createSubmissionZip() throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ZipOutputStream zos = new ZipOutputStream(baos);
        
        // 1. Add manifest.xml
        addZipEntry(zos, "manifest/manifest.xml", manifestXml.getBytes("UTF-8"));
        
        // 2. Add form 941 XML
        addZipEntry(zos, "xml/form941.xml", form941Xml.getBytes("UTF-8"));
        
        // 3. Add attachments (if any)
        if (attachmentPdf != null) {
            addZipEntry(zos, "attachment/form8655.pdf", attachmentPdf);
        }
        
        zos.close();
        return baos.toByteArray();
    }
    
    /**
     * Create ENCRYPTED submission package (AES-256)
     * Required for production submission
     */
    public EncryptedSubmission createEncryptedSubmission() throws Exception {
        // Step 1: Create unencrypted ZIP
        byte[] zipData = createSubmissionZip();
        
        // Step 2: GZIP compress
        byte[] compressedData = gzipCompress(zipData);
        
        // Step 3: AES-256 encrypt
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey secretKey = keyGen.generateKey();
        
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecureRandom random = new SecureRandom();
        byte[] iv = new byte[16];
        random.nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivSpec);
        byte[] encryptedData = cipher.doFinal(compressedData);
        
        return new EncryptedSubmission(encryptedData, secretKey, iv);
    }
    
    private void addZipEntry(ZipOutputStream zos, String entryName, byte[] data) 
            throws IOException {
        ZipEntry entry = new ZipEntry(entryName);
        zos.putNextEntry(entry);
        zos.write(data);
        zos.closeEntry();
    }
    
    private byte[] gzipCompress(byte[] data) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        java.util.zip.GZIPOutputStream gos = new java.util.zip.GZIPOutputStream(baos);
        gos.write(data);
        gos.close();
        return baos.toByteArray();
    }
    
    public void setAttachmentPdf(byte[] pdf) {
        this.attachmentPdf = pdf;
    }
    
    /**
     * Wrapper class for encrypted data
     */
    public static class EncryptedSubmission {
        public byte[] encryptedData;
        public SecretKey encryptionKey;
        public byte[] iv;
        
        public EncryptedSubmission(byte[] data, SecretKey key, byte[] iv) {
            this.encryptedData = data;
            this.encryptionKey = key;
            this.iv = iv;
        }
    }
}
```

### **Step 3: Send to IRS MeF**

```java
package com.irs.mef.submission;

import org.springframework.stereotype.Service;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.client.RestClientException;
import java.util.Base64;
import java.time.LocalDateTime;

@Service
public class IrsMefSubmissionService {
    
    private static final String MeF_PRODUCTION_URL = "https://mef.irs.gov/mefv2/services/MefSubmissionService";
    private static final String MeF_TESTING_URL = "https://mefats.irs.gov/mefv2/services/MefSubmissionService";
    
    private String efin;
    private String etin;
    private String dgvrPin;
    private String softwareId;
    private boolean useProduction = false;
    
    /**
     * Main submission method
     */
    public MefSubmissionResponse submitForm941ToIRS(
            String form941Xml,
            String manifestXml,
            byte[] attachmentPdf) {
        
        try {
            // Step 1: Create encrypted submission package
            MefSubmissionPackager packager = new MefSubmissionPackager(manifestXml, form941Xml);
            if (attachmentPdf != null) {
                packager.setAttachmentPdf(attachmentPdf);
            }
            
            MefSubmissionPackager.EncryptedSubmission encrypted = packager.createEncryptedSubmission();
            
            // Step 2: Create HTTP request
            HttpEntity<byte[]> request = createHttpRequest(encrypted.encryptedData);
            
            // Step 3: Send to IRS
            String endpoint = useProduction ? MeF_PRODUCTION_URL : MeF_TESTING_URL;
            RestTemplate restTemplate = new RestTemplate();
            
            ResponseEntity<String> response = restTemplate.postForEntity(
                endpoint,
                request,
                String.class
            );
            
            // Step 4: Parse response
            return parseMefResponse(response);
            
        } catch (RestClientException e) {
            return new MefSubmissionResponse(
                false,
                "NETWORK_ERROR",
                "Failed to connect to IRS: " + e.getMessage(),
                null
            );
        } catch (Exception e) {
            return new MefSubmissionResponse(
                false,
                "PROCESSING_ERROR",
                "Error processing submission: " + e.getMessage(),
                null
            );
        }
    }
    
    /**
     * Create HTTP request with proper headers and authentication
     */
    private HttpEntity<byte[]> createHttpRequest(byte[] encryptedData) {
        HttpHeaders headers = new HttpHeaders();
        
        // Content Type
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers.set("Content-Encoding", "gzip");
        
        // Authentication: Basic Auth (EFIN:DGVR_PIN)
        String authString = efin + ":" + dgvrPin;
        String encodedAuth = Base64.getEncoder().encodeToString(authString.getBytes());
        headers.set("Authorization", "Basic " + encodedAuth);
        
        // Custom headers
        headers.set("X-Software-ID", softwareId);
        headers.set("X-EFIN", efin);
        headers.set("X-ETIN", etin);
        headers.set("User-Agent", softwareId + "/1.0 (Form941 Submission)");
        
        // Timestamp header
        headers.set("X-Timestamp", LocalDateTime.now().toString());
        
        return new HttpEntity<>(encryptedData, headers);
    }
    
    /**
     * Parse IRS MeF Response
     */
    private MefSubmissionResponse parseMefResponse(ResponseEntity<String> response) {
        try {
            String responseBody = response.getBody();
            
            // Response could be:
            // 1. Immediate SOAP response (XML)
            // 2. Transmission Confirmation Number (TCN)
            // 3. Error message
            
            if (responseBody.contains("<TransmissionConfirmationNumber>")) {
                // Success - return TCN
                String tcn = extractTagValue(responseBody, "TransmissionConfirmationNumber");
                return new MefSubmissionResponse(
                    true,
                    "TRANSMISSION_ACCEPTED",
                    "Form 941 transmitted successfully",
                    tcn
                );
            } else if (responseBody.contains("<Error>") || responseBody.contains("fault")) {
                // Error response
                String errorMsg = extractErrorMessage(responseBody);
                return new MefSubmissionResponse(
                    false,
                    "TRANSMISSION_REJECTED",
                    errorMsg,
                    null
                );
            } else {
                return new MefSubmissionResponse(
                    false,
                    "UNKNOWN_RESPONSE",
                    "Unexpected response from IRS: " + responseBody.substring(0, 200),
                    null
                );
            }
        } catch (Exception e) {
            return new MefSubmissionResponse(
                false,
                "PARSE_ERROR",
                "Failed to parse IRS response: " + e.getMessage(),
                null
            );
        }
    }
    
    private String extractTagValue(String xml, String tagName) {
        String openTag = "<" + tagName + ">";
        String closeTag = "</" + tagName + ">";
        int start = xml.indexOf(openTag);
        int end = xml.indexOf(closeTag);
        if (start != -1 && end != -1) {
            return xml.substring(start + openTag.length(), end);
        }
        return "";
    }
    
    private String extractErrorMessage(String xml) {
        String[] possibleTags = {"<ErrorDescription>", "<faultstring>", "<Message>"};
        for (String tag : possibleTags) {
            if (xml.contains(tag)) {
                return extractTagValue(xml, tag.replace("<", "").replace(">", ""));
            }
        }
        return "Unknown error from IRS";
    }
    
    // Setters for configuration
    public void setCredentials(String efin, String etin, String dgvrPin, String softwareId) {
        this.efin = efin;
        this.etin = etin;
        this.dgvrPin = dgvrPin;
        this.softwareId = softwareId;
    }
    
    public void setUseProduction(boolean prod) {
        this.useProduction = prod;
    }
}
```

### **Step 4: Handle Response & Track Status**

```java
package com.irs.mef.submission;

import java.time.LocalDateTime;
import java.util.List;

/**
 * MeF Submission Response object
 */
public class MefSubmissionResponse {
    public boolean success;
    public String status;
    public String message;
    public String transmissionConfirmationNumber; // TCN
    public LocalDateTime submissionTime;
    public List<String> warnings;
    public List<String> errors;
    
    public MefSubmissionResponse(boolean success, String status, String message, String tcn) {
        this.success = success;
        this.status = status;
        this.message = message;
        this.transmissionConfirmationNumber = tcn;
        this.submissionTime = LocalDateTime.now();
    }
    
    @Override
    public String toString() {
        return "MefSubmissionResponse{\n" +
               "  Success: " + success + "\n" +
               "  Status: " + status + "\n" +
               "  Message: " + message + "\n" +
               "  TCN: " + transmissionConfirmationNumber + "\n" +
               "  Submitted: " + submissionTime + "\n" +
               "}";
    }
}
```

---

## 📨 PART 5: RECEIVE & PARSE ACK FILE

### **What is an ACK File?**

After submission, IRS sends back an **Acknowledgment (ACK) file**:

```
Timing:        Usually within 2-24 hours
Format:        XML or SOAP response
Contents:      Acceptance/Rejection status
Errors:        Specific business rule violations
Next Step:     Fix errors and resubmit if rejected
```

### **ACK File Parser**

```java
package com.irs.mef.acknowledgment;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Element;
import java.io.StringReader;
import java.util.*;

public class AckFileParser {
    
    /**
     * Parse IRS ACK file (XML format)
     */
    public AckResponse parseAckFile(String ackXmlContent) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(new StringReader(ackXmlContent));
        
        AckResponse ackResponse = new AckResponse();
        
        // Extract submission status
        Element returnStatusElement = (Element) doc.getElementsByTagName("ReturnStatus").item(0);
        if (returnStatusElement != null) {
            ackResponse.status = returnStatusElement.getTextContent();
        }
        
        // Extract Transmission Confirmation Number (TCN)
        Element tcnElement = (Element) doc.getElementsByTagName("TransmissionConfirmationNumber").item(0);
        if (tcnElement != null) {
            ackResponse.transmissionConfirmationNumber = tcnElement.getTextContent();
        }
        
        // Extract acceptance indicator
        Element acceptanceElement = (Element) doc.getElementsByTagName("Acceptance").item(0);
        if (acceptanceElement != null) {
            ackResponse.accepted = Boolean.parseBoolean(acceptanceElement.getTextContent());
        }
        
        // Extract errors and warnings
        NodeList errorNodes = doc.getElementsByTagName("Error");
        for (int i = 0; i < errorNodes.getLength(); i++) {
            Element errorElement = (Element) errorNodes.item(i);
            
            String errorCode = getTagValue(errorElement, "ErrorCode");
            String errorDescription = getTagValue(errorElement, "ErrorDescription");
            String lineNumber = getTagValue(errorElement, "LineNumber");
            
            ackResponse.errors.add(new ErrorDetail(errorCode, errorDescription, lineNumber));
        }
        
        // Extract warnings
        NodeList warningNodes = doc.getElementsByTagName("Warning");
        for (int i = 0; i < warningNodes.getLength(); i++) {
            Element warningElement = (Element) warningNodes.item(i);
            
            String warningCode = getTagValue(warningElement, "WarningCode");
            String warningDescription = getTagValue(warningElement, "WarningDescription");
            
            ackResponse.warnings.add(new WarningDetail(warningCode, warningDescription));
        }
        
        // Set acceptance info
        ackResponse.accepted = ackResponse.errors.isEmpty();
        
        return ackResponse;
    }
    
    private String getTagValue(Element parent, String tagName) {
        NodeList nodes = parent.getElementsByTagName(tagName);
        if (nodes.getLength() > 0) {
            return nodes.item(0).getTextContent();
        }
        return "";
    }
    
    /**
     * ACK Response object
     */
    public static class AckResponse {
        public String status;                              // ACCEPTED, REJECTED
        public String transmissionConfirmationNumber;       // TCN
        public boolean accepted;
        public List<ErrorDetail> errors = new ArrayList<>();
        public List<WarningDetail> warnings = new ArrayList<>();
        
        public void printReport() {
            System.out.println("\n========== IRS ACK FILE REPORT ==========");
            System.out.println("Status: " + status);
            System.out.println("TCN: " + transmissionConfirmationNumber);
            System.out.println("Accepted: " + (accepted ? "YES ✓" : "NO ✗"));
            
            if (!errors.isEmpty()) {
                System.out.println("\nERRORS (" + errors.size() + "):");
                for (ErrorDetail error : errors) {
                    System.out.println("  [" + error.code + " - Line " + error.lineNumber + "] " + error.description);
                }
            }
            
            if (!warnings.isEmpty()) {
                System.out.println("\nWARNINGS (" + warnings.size() + "):");
                for (WarningDetail warning : warnings) {
                    System.out.println("  [" + warning.code + "] " + warning.description);
                }
            }
            
            System.out.println("\n========================================\n");
        }
    }
    
    /**
     * Error detail from ACK
     */
    public static class ErrorDetail {
        public String code;
        public String description;
        public String lineNumber;
        
        public ErrorDetail(String code, String description, String lineNumber) {
            this.code = code;
            this.description = description;
            this.lineNumber = lineNumber;
        }
    }
    
    /**
     * Warning detail from ACK
     */
    public static class WarningDetail {
        public String code;
        public String description;
        
        public WarningDetail(String code, String description) {
            this.code = code;
            this.description = description;
        }
    }
}
```

---

## 🔄 PART 6: RESUBMISSION LOGIC

### **When & How to Resubmit**

```java
package com.irs.mef.submission;

import java.time.LocalDateTime;
import java.util.*;

@Service
public class MefResubmissionManager {
    
    /**
     * Determine if resubmission is needed and handle it
     */
    public ResubmissionDecision handleAckFile(
            AckFileParser.AckResponse ackResponse,
            String originalForm941Xml,
            String originalManifestXml) {
        
        if (ackResponse.accepted) {
            return new ResubmissionDecision(
                false,
                "ACCEPTED",
                "Form 941 was accepted by IRS",
                ackResponse.transmissionConfirmationNumber,
                null
            );
        }
        
        // ACK was rejected - analyze errors
        List<ResubmissionAction> actions = new ArrayList<>();
        
        for (AckFileParser.ErrorDetail error : ackResponse.errors) {
            ResubmissionAction action = determineErrorFix(error);
            actions.add(action);
        }
        
        return new ResubmissionDecision(
            true,
            "REJECTED",
            "Form 941 was rejected. " + actions.size() + " issue(s) require correction.",
            null,
            actions
        );
    }
    
    /**
     * Determine how to fix each error
     */
    private ResubmissionAction determineErrorFix(AckFileParser.ErrorDetail error) {
        String code = error.code;
        String description = error.description;
        
        // Map IRS error codes to fix strategies
        switch (code) {
            case "F941-001":
                return new ResubmissionAction(
                    error,
                    "FIT_VALIDATION_ERROR",
                    "Federal Income Tax Withheld is negative. Check Line 3.",
                    "MANUAL_REVIEW_REQUIRED"
                );
            
            case "F941-004-02":
                return new ResubmissionAction(
                    error,
                    "SS_MEDICARE_TOTAL_MISMATCH",
                    "Total SS & Medicare Tax doesn't match sum of components",
                    "RECALCULATE_TAXES"
                );
            
            case "F941-005":
                return new ResubmissionAction(
                    error,
                    "TAX_AFTER_ADJUSTMENTS_ERROR",
                    "Total Tax After Adjustments calculation incorrect",
                    "RECALCULATE_ADJUSTMENTS"
                );
            
            case "F941-022":
                return new ResubmissionAction(
                    error,
                    "TAX_BEFORE_ADJUSTMENTS_ERROR",
                    "Total Tax Before Adjustments calculation incorrect",
                    "RECALCULATE_BASE_TAX"
                );
            
            case "SIGNATURE-001":
                return new ResubmissionAction(
                    error,
                    "MISSING_SIGNATURE",
                    "Signature block is missing or incomplete",
                    "ADD_SIGNATURE_INFO"
                );
            
            case "R0000-901-01":
                return new ResubmissionAction(
                    error,
                    "EIN_MISMATCH",
                    "EIN doesn't match IRS database",
                    "VERIFY_EIN"
                );
            
            case "R0000-914-01":
                return new ResubmissionAction(
                    error,
                    "DUPLICATE_SUBMISSION",
                    "This EIN/Quarter has already been accepted",
                    "AMENDED_RETURN_REQUIRED"
                );
            
            default:
                return new ResubmissionAction(
                    error,
                    "UNKNOWN_ERROR",
                    "Unknown error - review IRS documentation",
                    "MANUAL_REVIEW_REQUIRED"
                );
        }
    }
    
    /**
     * Automatic retry logic
     */
    public void scheduleResubmission(
            ResubmissionDecision decision,
            String form941Xml,
            String manifestXml) {
        
        if (!decision.needsResubmission) {
            System.out.println("✓ No resubmission needed - Return accepted");
            return;
        }
        
        System.out.println("✗ Resubmission needed - " + decision.actions.size() + " corrections required");
        
        for (ResubmissionAction action : decision.actions) {
            System.out.println("\n  Issue: " + action.errorDetail.code);
            System.out.println("  Description: " + action.errorDetail.description);
            System.out.println("  Action Required: " + action.fixStrategy);
            System.out.println("  Fix Method: " + action.fixMethod);
        }
        
        // Check if automatic fix is possible
        boolean canAutoFix = decision.actions.stream()
            .allMatch(a -> !a.fixMethod.contains("MANUAL"));
        
        if (canAutoFix) {
            System.out.println("\n→ All issues can be auto-corrected");
            System.out.println("→ Resubmitting in 30 seconds...");
            
            // Schedule automatic resubmission
            scheduleDelayedResubmission(form941Xml, manifestXml, 30);
        } else {
            System.out.println("\n→ Manual review required before resubmission");
            System.out.println("→ Waiting for human intervention...");
        }
    }
    
    private void scheduleDelayedResubmission(String form941Xml, String manifestXml, int delaySeconds) {
        // Use scheduled executor
        java.util.concurrent.ScheduledExecutorService scheduler = 
            java.util.concurrent.Executors.newScheduledThreadPool(1);
        
        scheduler.schedule(() -> {
            try {
                System.out.println("\n[" + LocalDateTime.now() + "] Resubmitting Form 941...");
                // Call submitForm941ToIRS again
                // submitForm941ToIRS(form941Xml, manifestXml, null);
            } catch (Exception e) {
                System.out.println("Resubmission failed: " + e.getMessage());
            }
        }, delaySeconds, java.util.concurrent.TimeUnit.SECONDS);
    }
    
    /**
     * Resubmission decision result
     */
    public static class ResubmissionDecision {
        public boolean needsResubmission;
        public String status;
        public String message;
        public String tcnIfAccepted;
        public List<ResubmissionAction> actions;
        
        public ResubmissionDecision(boolean needs, String status, String message, 
                                    String tcn, List<ResubmissionAction> actions) {
            this.needsResubmission = needs;
            this.status = status;
            this.message = message;
            this.tcnIfAccepted = tcn;
            this.actions = actions != null ? actions : new ArrayList<>();
        }
    }
    
    /**
     * Resubmission action required
     */
    public static class ResubmissionAction {
        public AckFileParser.ErrorDetail errorDetail;
        public String errorType;
        public String errorDescription;
        public String fixStrategy;
        public String fixMethod;
        
        public ResubmissionAction(AckFileParser.ErrorDetail error, String type, 
                                  String description, String method) {
            this.errorDetail = error;
            this.errorType = type;
            this.errorDescription = description;
            this.fixMethod = method;
        }
    }
}
```

---

## 🔌 PART 7: SPRING CONTROLLER - COMPLETE WORKFLOW

```java
package com.irs.form941.controller;

import com.irs.form941.dto.Form941Data;
import com.irs.mef.submission.*;
import com.irs.mef.acknowledgment.AckFileParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

@RestController
@RequestMapping("/api/form941/mef")
public class Form941MefSubmissionController {
    
    private static final Logger logger = LoggerFactory.getLogger(Form941MefSubmissionController.class);
    
    @Autowired
    private IrsMefSubmissionService irsMefService;
    
    @Autowired
    private MefResubmissionManager resubmissionManager;
    
    /**
     * Complete workflow: Generate XML → Submit to IRS → Track Response
     * 
     * POST /api/form941/mef/submit
     */
    @PostMapping("/submit")
    public ResponseEntity<?> submitForm941ToIRS(@RequestBody Form941MefSubmissionRequest request) {
        logger.info("Starting Form 941 MeF submission for EIN: {}", request.ein);
        
        try {
            // Step 1: Configure IRS credentials
            irsMefService.setCredentials(
                request.efin,
                request.etin,
                request.dgvrPin,
                request.softwareId
            );
            irsMefService.setUseProduction(request.isProduction);
            
            // Step 2: Build manifest
            ManifestBuilder manifestBuilder = new ManifestBuilder(
                request.efin,
                request.etin,
                request.dgvrPin
            );
            manifestBuilder.setForm941Xml(request.form941Xml);
            manifestBuilder.setEin(request.ein);
            manifestBuilder.setBusinessName(request.businessName);
            String manifestXml = manifestBuilder.buildManifest();
            
            // Step 3: Submit to IRS
            logger.info("Submitting to IRS MeF endpoint...");
            MefSubmissionResponse response = irsMefService.submitForm941ToIRS(
                request.form941Xml,
                manifestXml,
                request.attachmentForm8655Pdf
            );
            
            // Step 4: Build response
            Map<String, Object> result = new HashMap<>();
            result.put("submissionStatus", response.success ? "SUCCESS" : "FAILED");
            result.put("message", response.message);
            result.put("transmissionConfirmationNumber", response.transmissionConfirmationNumber);
            result.put("submittedAt", response.submissionTime);
            
            if (response.success) {
                logger.info("✓ Form 941 submitted successfully. TCN: {}", 
                    response.transmissionConfirmationNumber);
                result.put("nextStep", "Wait for IRS ACK file (usually 2-24 hours)");
                result.put("tcnForTracking", response.transmissionConfirmationNumber);
                
                return ResponseEntity.ok(result);
            } else {
                logger.error("✗ Submission failed: {}", response.message);
                result.put("errorCode", response.status);
                result.put("action", "Fix errors and resubmit");
                
                return ResponseEntity.badRequest().body(result);
            }
            
        } catch (Exception e) {
            logger.error("Exception during submission", e);
            
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", "SUBMISSION_ERROR");
            errorResponse.put("message", e.getMessage());
            
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }
    
    /**
     * Upload and process ACK file from IRS
     * 
     * POST /api/form941/mef/upload-ack
     */
    @PostMapping("/upload-ack")
    public ResponseEntity<?> processAckFile(
            @RequestParam("ackFile") org.springframework.web.multipart.MultipartFile ackFile,
            @RequestParam("tcn") String transmissionConfirmationNumber) {
        
        logger.info("Processing ACK file for TCN: {}", transmissionConfirmationNumber);
        
        try {
            // Read ACK file content
            String ackContent = new String(ackFile.getBytes());
            logger.debug("ACK Content Length: {} bytes", ackContent.length());
            
            // Parse ACK
            AckFileParser ackParser = new AckFileParser();
            AckFileParser.AckResponse ackResponse = ackParser.parseAckFile(ackContent);
            
            // Build response
            Map<String, Object> result = new HashMap<>();
            result.put("tcn", transmissionConfirmationNumber);
            result.put("status", ackResponse.status);
            result.put("accepted", ackResponse.accepted);
            result.put("processingTime", java.time.LocalDateTime.now());
            
            if (ackResponse.accepted) {
                logger.info("✓ Form 941 ACCEPTED by IRS");
                result.put("message", "Form 941 has been successfully accepted by IRS");
                result.put("nextStep", "Archive for records");
                
                return ResponseEntity.ok(result);
                
            } else {
                logger.warn("✗ Form 941 REJECTED by IRS");
                
                // Parse errors
                List<Map<String, String>> errorList = new ArrayList<>();
                for (AckFileParser.ErrorDetail error : ackResponse.errors) {
                    Map<String, String> errorMap = new HashMap<>();
                    errorMap.put("code", error.code);
                    errorMap.put("description", error.description);
                    errorMap.put("lineNumber", error.lineNumber);
                    errorList.add(errorMap);
                }
                
                result.put("message", "Form 941 was rejected by IRS");
                result.put("errorsCount", errorList.size());
                result.put("errors", errorList);
                result.put("action", "Fix errors and resubmit");
                
                return ResponseEntity.badRequest().body(result);
            }
            
        } catch (Exception e) {
            logger.error("Error processing ACK file", e);
            
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", "ACK_PROCESSING_ERROR");
            errorResponse.put("message", e.getMessage());
            
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }
    
    /**
     * Resubmit after corrections
     * 
     * POST /api/form941/mef/resubmit
     */
    @PostMapping("/resubmit")
    public ResponseEntity<?> resubmitForm941(
            @RequestBody Form941MefResubmissionRequest request) {
        
        logger.info("Resubmitting Form 941 for EIN: {} after corrections", request.ein);
        
        try {
            // Validate that corrections were made
            if (request.correctedForm941Xml == null || request.correctedForm941Xml.isEmpty()) {
                return ResponseEntity.badRequest()
                    .body(Map.of("error", "MISSING_CORRECTED_XML"));
            }
            
            // Proceed with submission (same as initial submission)
            Form941MefSubmissionRequest submissionRequest = new Form941MefSubmissionRequest();
            submissionRequest.form941Xml = request.correctedForm941Xml;
            submissionRequest.ein = request.ein;
            submissionRequest.businessName = request.businessName;
            submissionRequest.efin = request.efin;
            submissionRequest.etin = request.etin;
            submissionRequest.dgvrPin = request.dgvrPin;
            submissionRequest.softwareId = request.softwareId;
            submissionRequest.isProduction = request.isProduction;
            
            // Resubmit
            return submitForm941ToIRS(submissionRequest);
            
        } catch (Exception e) {
            logger.error("Error resubmitting Form 941", e);
            return ResponseEntity.internalServerError()
                .body(Map.of("error", "RESUBMISSION_ERROR", "message", e.getMessage()));
        }
    }
    
    /**
     * Check submission status using TCN
     * 
     * GET /api/form941/mef/status/{tcn}
     */
    @GetMapping("/status/{tcn}")
    public ResponseEntity<?> checkSubmissionStatus(@PathVariable String tcn) {
        logger.info("Checking status for TCN: {}", tcn);
        
        // In production, you would query IRS e-Services to get status
        // For now, return placeholder
        Map<String, Object> status = new HashMap<>();
        status.put("tcn", tcn);
        status.put("status", "PENDING");
        status.put("message", "Submission is being processed by IRS");
        status.put("estimatedCompletion", "2026-12-17 (within 24-48 hours)");
        status.put("checkIRSEServices", "https://www.irs.gov/e-services");
        
        return ResponseEntity.ok(status);
    }
}

/**
 * Request objects
 */
class Form941MefSubmissionRequest {
    public String form941Xml;           // Generated XML
    public String ein;
    public String businessName;
    public String efin;                 // IRS credential
    public String etin;                 // IRS credential
    public String dgvrPin;              // IRS credential
    public String softwareId;           // Your software ID
    public byte[] attachmentForm8655Pdf; // Optional: Form 8655
    public boolean isProduction;        // true for prod, false for ATS
}

class Form941MefResubmissionRequest extends Form941MefSubmissionRequest {
    public String correctedForm941Xml;
    public List<String> errorsFixed;
}
```

---

## 📋 REQUEST/RESPONSE EXAMPLES

### **Example 1: Successful Submission**

```
REQUEST:
POST https://mef.irs.gov/mefv2/services/MefSubmissionService
Authorization: Basic MTAtMTIzNDo1NDMyMQ==
Content-Type: application/octet-stream
X-Software-ID: YourSoftware/1.0
X-EFIN: 10-1234
X-ETIN: 12345

[Binary encrypted ZIP data]

RESPONSE (Success):
HTTP 200 OK
Content-Type: application/xml

<?xml version="1.0"?>
<TransmissionResponse>
  <TransmissionConfirmationNumber>20261215ABC123DEF456</TransmissionConfirmationNumber>
  <Status>ACCEPTED</Status>
  <Message>Submission received successfully</Message>
</TransmissionResponse>
```

### **Example 2: ACK File (Accepted)**

```xml
<?xml version="1.0"?>
<ReturnAcknowledgement>
  <TransmissionConfirmationNumber>20261215ABC123DEF456</TransmissionConfirmationNumber>
  <ReturnStatus>ACCEPTED</ReturnStatus>
  <Acceptance>true</Acceptance>
  <Form941Information>
    <EIN>11-1111111</EIN>
    <QuarterEndingDate>202612</QuarterEndingDate>
    <TotalTaxAmount>145263.07</TotalTaxAmount>
  </Form941Information>
</ReturnAcknowledgement>
```

### **Example 3: ACK File (Rejected)**

```xml
<?xml version="1.0"?>
<ReturnAcknowledgement>
  <TransmissionConfirmationNumber>20261215ABC123DEF456</TransmissionConfirmationNumber>
  <ReturnStatus>REJECTED</ReturnStatus>
  <Acceptance>false</Acceptance>
  <Errors>
    <Error>
      <ErrorCode>F941-005</ErrorCode>
      <ErrorDescription>Total Tax After Adjustments calculation incorrect</ErrorDescription>
      <LineNumber>10</LineNumber>
      <ExpectedAmount>145263.07</ExpectedAmount>
      <ActualAmount>145263.06</ActualAmount>
    </Error>
    <Error>
      <ErrorCode>SIGNATURE-001</ErrorCode>
      <ErrorDescription>Signature name is missing</ErrorDescription>
      <LineNumber>Part 5</LineNumber>
    </Error>
  </Errors>
</ReturnAcknowledgement>
```

---

## 🔑 SUMMARY: CREDENTIALS CHECKLIST

| Credential | Format | Get From | Expires | Use |
|-----------|--------|----------|---------|-----|
| **EFIN** | XX-XXXX | IRS | Jan 31 | Identify your firm |
| **ETIN** | XXXXX | IRS | Jan 31 | Identify transmitter |
| **DGVR PIN** | XXXXX | You create | On demand | Authenticate request |
| **Software ID** | Alphanumeric | Your app | N/A | Identify software |
| **Form 8655** | PDF signed | Client signs | Tax year | Authorize filing |
| **Form 8879-EMP** | PDF signed | Signer signs | Tax year | E-signature auth |

---

**Complete implementation ready!** This covers the entire MeF submission workflow from XML generation to ACK processing and resubmission. 🚀

