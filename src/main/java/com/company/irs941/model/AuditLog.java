package com.company.irs941.model;

import java.sql.Timestamp;

public class AuditLog {
    private Long auditId;
    private String tableName;
    private Long recordId;
    private String action;
    private String oldValues;
    private String newValues;
    private Long changedByUserId;
    private Timestamp changedAt;
    private String ipAddress;
    private String performedBy = "System Admin";
    private String details;

    public AuditLog() {}

    public Long getAuditId() {
        return auditId;
    }

    public void setAuditId(Long auditId) {
        this.auditId = auditId;
    }

    public Long getId() {
        return auditId;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getEntityName() {
        return tableName != null ? tableName : "System";
    }

    public Long getRecordId() {
        return recordId;
    }

    public void setRecordId(Long recordId) {
        this.recordId = recordId;
    }

    public Long getEntityId() {
        return recordId != null ? recordId : 0L;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getOldValues() {
        return oldValues;
    }

    public void setOldValues(String oldValues) {
        this.oldValues = oldValues;
    }

    public String getNewValues() {
        return newValues;
    }

    public void setNewValues(String newValues) {
        this.newValues = newValues;
    }

    public Long getChangedByUserId() {
        return changedByUserId;
    }

    public void setChangedByUserId(Long changedByUserId) {
        this.changedByUserId = changedByUserId;
    }

    public String getPerformedBy() {
        return performedBy;
    }

    public void setPerformedBy(String performedBy) {
        this.performedBy = performedBy;
    }

    public Timestamp getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Timestamp changedAt) {
        this.changedAt = changedAt;
    }

    public Timestamp getTimestamp() {
        return changedAt;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getDetails() {
        if (details != null) return details;
        if (newValues != null) return newValues;
        return "Audit event on table " + tableName;
    }

    public void setDetails(String details) {
        this.details = details;
    }
}
