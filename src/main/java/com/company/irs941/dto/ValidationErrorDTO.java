package com.company.irs941.dto;

public class ValidationErrorDTO {
    private String errorCode;
    private String fieldName;
    private String errorMessage;
    private String severity; // "ERROR" or "WARNING"

    public ValidationErrorDTO() {}

    public ValidationErrorDTO(String fieldName, String errorMessage) {
        this("VAL_ERR", fieldName, errorMessage, "ERROR");
    }

    public ValidationErrorDTO(String errorCode, String fieldName, String errorMessage, String severity) {
        this.errorCode = errorCode;
        this.fieldName = fieldName;
        this.errorMessage = errorMessage;
        this.severity = severity;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }
}
