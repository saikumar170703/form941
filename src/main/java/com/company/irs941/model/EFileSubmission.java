package com.company.irs941.model;

import java.sql.Timestamp;

public class EFileSubmission {
    private Long submissionId;
    private Long form941Id;
    private String submissionType; // e.g. "ORIGINAL", "AMENDED"
    private Long submittedByUserId;
    private Timestamp submissionTimestamp;
    private String irsAcknowledgmentCode; // e.g. "A" for Accepted, "R" for Rejected
    private Timestamp irsAcknowledgmentDate;
    private String status; // e.g. "SUBMITTED", "PENDING", "ACCEPTED", "REJECTED"
    private String rejectionReason;
    private String transmissionId;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public EFileSubmission() {}

    public Long getSubmissionId() {
        return submissionId;
    }

    public void setSubmissionId(Long submissionId) {
        this.submissionId = submissionId;
    }

    public Long getForm941Id() {
        return form941Id;
    }

    public void setForm941Id(Long form941Id) {
        this.form941Id = form941Id;
    }

    public String getSubmissionType() {
        return submissionType;
    }

    public void setSubmissionType(String submissionType) {
        this.submissionType = submissionType;
    }

    public Long getSubmittedByUserId() {
        return submittedByUserId;
    }

    public void setSubmittedByUserId(Long submittedByUserId) {
        this.submittedByUserId = submittedByUserId;
    }

    public Timestamp getSubmissionTimestamp() {
        return submissionTimestamp;
    }

    public void setSubmissionTimestamp(Timestamp submissionTimestamp) {
        this.submissionTimestamp = submissionTimestamp;
    }

    public String getIrsAcknowledgmentCode() {
        return irsAcknowledgmentCode;
    }

    public void setIrsAcknowledgmentCode(String irsAcknowledgmentCode) {
        this.irsAcknowledgmentCode = irsAcknowledgmentCode;
    }

    public Timestamp getIrsAcknowledgmentDate() {
        return irsAcknowledgmentDate;
    }

    public void setIrsAcknowledgmentDate(Timestamp irsAcknowledgmentDate) {
        this.irsAcknowledgmentDate = irsAcknowledgmentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public String getTransmissionId() {
        return transmissionId;
    }

    public void setTransmissionId(String transmissionId) {
        this.transmissionId = transmissionId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
