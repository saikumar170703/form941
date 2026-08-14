package com.company.irs941.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.irs941.dao.Form941Dao;
import com.company.irs941.dto.Form941DTO;
import com.company.irs941.dto.ValidationErrorDTO;
import com.company.irs941.model.Form941;

@Service
public class Form941Service {

    @Autowired
    private Form941Dao form941Dao;

    @Autowired
    private Form941CalculationService calculationService;

    @Autowired
    private AuditLogService auditLogService;

    @Autowired
    private EFileSubmissionService eFileSubmissionService;

    public List<Form941> getAllFilings() {
        return form941Dao.findAllFilings();
    }

    public List<Form941> getFilingsByUserId(Long userId) {
        if (userId == null) return form941Dao.findAllFilings();
        return form941Dao.findFilingsByUserId(userId);
    }

    public Optional<Form941> getFilingById(Long id) {
        return form941Dao.findById(id);
    }

    public Form941DTO getFilingDtoById(Long id) {
        return form941Dao.findDtoById(id);
    }

    public Form941DTO getFilingDtoByIdAndUserId(Long id, Long userId) {
        if (userId == null) return form941Dao.findDtoById(id);
        return form941Dao.findDtoByIdAndUserId(id, userId);
    }

    public List<ValidationErrorDTO> validateForm(Form941DTO dto) {
        return calculationService.calculateAndValidate(dto);
    }

    public Long saveDraft(Form941DTO dto, Long userId) {
        calculationService.calculateAndValidate(dto);
        if (!"SUBMITTED".equals(dto.getStatus())) {
            dto.setStatus("DRAFT");
        }
        Long id = form941Dao.saveForm941(dto, userId);
        auditLogService.log("form_941", id, "SAVE_DRAFT", userId != null ? userId : 1L, "Form 941 draft saved.");
        return id;
    }

    public Long submitReturn(Form941DTO dto, Long userId) {
        calculationService.calculateAndValidate(dto);
        dto.setStatus("SUBMITTED");
        Long id = form941Dao.saveForm941(dto, userId);
        auditLogService.log("form_941", id, "SUBMIT_RETURN", userId != null ? userId : 1L, "Form 941 submitted internally to database.");

        // Record submission in efile_submissions table
        eFileSubmissionService.recordSubmission(id, userId, "ORIGINAL");

        return id;
    }

    public int getTotalFilingsCount(Long userId) {
        if (userId == null) return 0;
        return form941Dao.countByUserId(userId);
    }

    public int getDraftsCount(Long userId) {
        if (userId == null) return 0;
        return form941Dao.countByUserIdAndStatus(userId, "DRAFT");
    }

    public int getSubmittedCount(Long userId) {
        if (userId == null) return 0;
        return form941Dao.countByUserIdAndStatus(userId, "SUBMITTED");
    }
}
