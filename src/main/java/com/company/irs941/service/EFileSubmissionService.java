package com.company.irs941.service;

import java.util.List;
import java.util.Optional;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.irs941.dao.EFileSubmissionDao;
import com.company.irs941.model.EFileSubmission;

@Service
public class EFileSubmissionService {

    private static final Logger logger = LogManager.getLogger(EFileSubmissionService.class);

    @Autowired
    private EFileSubmissionDao eFileSubmissionDao;

    @Autowired
    private AuditLogService auditLogService;

    public EFileSubmission recordSubmission(Long form941Id, Long userId, String submissionType) {
        try {
            logger.info("[EFILE SUBMIT] Recording submission for Form 941 ID: {}, User ID: {}, Type: {}", 
                    form941Id, userId, submissionType);

            EFileSubmission sub = new EFileSubmission();
            sub.setForm941Id(form941Id);
            sub.setSubmittedByUserId(userId != null ? userId : 1L);
            sub.setSubmissionType(submissionType != null ? submissionType : "ORIGINAL");
            sub.setStatus("SUBMITTED");
            sub.setIrsAcknowledgmentCode("A"); // Accepted for internal e-file transmission

            // Generate unique IRS Transmission ID e.g. IRS941-20260812-XXXXXX
            String transmissionId = "IRS941-" + System.currentTimeMillis() + "-" + (int)(Math.random() * 900000 + 100000);
            sub.setTransmissionId(transmissionId);

            EFileSubmission saved = eFileSubmissionDao.save(sub);

            auditLogService.log("efile_submissions", saved.getSubmissionId(), "EFILE_SUBMIT", userId != null ? userId : 1L,
                    "Form 941 (ID: " + form941Id + ") e-filed to IRS. Transmission ID: " + transmissionId);

            logger.info("[EFILE SUBMIT SUCCESS] Submission ID: {}, Transmission ID: {}", saved.getSubmissionId(), transmissionId);
            return saved;
        } catch (Exception e) {
            logger.error("[EFILE SUBMIT ERROR] Failed recording submission for Form 941 ID: {}, User ID: {}", form941Id, userId, e);
            throw e;
        }
    }

    public List<EFileSubmission> getSubmissionsByFormId(Long form941Id) {
        return eFileSubmissionDao.findByForm941Id(form941Id);
    }

    public List<EFileSubmission> getSubmissionsByUserId(Long userId) {
        return eFileSubmissionDao.findByUserId(userId);
    }

    public Optional<EFileSubmission> getSubmissionById(Long submissionId) {
        return eFileSubmissionDao.findById(submissionId);
    }

    public boolean updateSubmissionStatus(Long submissionId, String status, String ackCode, String rejectionReason, Long userId) {
        try {
            logger.info("[EFILE STATUS UPDATE] Updating Submission ID: {} to Status: {}", submissionId, status);
            boolean updated = eFileSubmissionDao.updateStatus(submissionId, status, ackCode, rejectionReason);
            if (updated) {
                auditLogService.log("efile_submissions", submissionId, "UPDATE_STATUS", userId != null ? userId : 1L,
                        "Submission ID: " + submissionId + " status updated to " + status);
            }
            return updated;
        } catch (Exception e) {
            logger.error("[EFILE STATUS UPDATE ERROR] Failed updating Submission ID: {}", submissionId, e);
            throw e;
        }
    }
}
