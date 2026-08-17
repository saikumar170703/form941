package com.company.irs941.mef;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.zip.GZIPOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * IRS MeF Submission Packager
 * Packages manifest.xml and form941.xml into standard ZIP archive
 * Supports AES-256 encryption & GZIP compression per attachments/IRS_MeF_SubmissionGuide_Complete.md
 */
public class MefSubmissionPackager {

    private final String manifestXml;
    private final String form941Xml;
    private byte[] attachmentPdf;

    public MefSubmissionPackager(String manifestXml, String form941Xml) {
        this.manifestXml = manifestXml;
        this.form941Xml = form941Xml;
    }

    /**
     * Create standard unencrypted ZIP submission package
     */
    public byte[] createSubmissionZip() throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ZipOutputStream zos = new ZipOutputStream(baos);

        // 1. Add manifest/manifest.xml
        addZipEntry(zos, "manifest/manifest.xml", manifestXml.getBytes(StandardCharsets.UTF_8));

        // 2. Add xml/form941.xml
        addZipEntry(zos, "xml/form941.xml", form941Xml.getBytes(StandardCharsets.UTF_8));

        // 3. Add supporting attachments (if provided)
        if (attachmentPdf != null && attachmentPdf.length > 0) {
            addZipEntry(zos, "attachment/form8655.pdf", attachmentPdf);
        }

        zos.close();
        return baos.toByteArray();
    }

    /**
     * Create ENCRYPTED submission package (GZIP + AES-256-CBC)
     */
    public EncryptedSubmission createEncryptedSubmission() throws Exception {
        byte[] zipData = createSubmissionZip();
        byte[] compressedData = gzipCompress(zipData);

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

    private void addZipEntry(ZipOutputStream zos, String entryName, byte[] data) throws IOException {
        ZipEntry entry = new ZipEntry(entryName);
        zos.putNextEntry(entry);
        zos.write(data);
        zos.closeEntry();
    }

    private byte[] gzipCompress(byte[] data) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        GZIPOutputStream gos = new GZIPOutputStream(baos);
        gos.write(data);
        gos.close();
        return baos.toByteArray();
    }

    public void setAttachmentPdf(byte[] pdf) {
        this.attachmentPdf = pdf;
    }

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
