package com.company.irs941.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.company.irs941.model.EFileSubmission;

@Repository
public class EFileSubmissionDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final RowMapper<EFileSubmission> SUBMISSION_ROW_MAPPER = new RowMapper<EFileSubmission>() {
        @Override
        public EFileSubmission mapRow(ResultSet rs, int rowNum) throws SQLException {
            EFileSubmission sub = new EFileSubmission();
            sub.setSubmissionId(rs.getLong("submission_id"));
            sub.setForm941Id(rs.getObject("form941_id") != null ? rs.getLong("form941_id") : null);
            sub.setSubmissionType(rs.getString("submission_type"));
            sub.setSubmittedByUserId(rs.getObject("submitted_by_user_id") != null ? rs.getLong("submitted_by_user_id") : null);
            sub.setSubmissionTimestamp(rs.getTimestamp("submission_timestamp"));
            sub.setIrsAcknowledgmentCode(rs.getString("irs_acknowledgment_code"));
            sub.setIrsAcknowledgmentDate(rs.getTimestamp("irs_acknowledgment_date"));
            sub.setStatus(rs.getString("status"));
            sub.setRejectionReason(rs.getString("rejection_reason"));
            sub.setTransmissionId(rs.getString("transmission_id"));
            sub.setCreatedAt(rs.getTimestamp("created_at"));
            sub.setUpdatedAt(rs.getTimestamp("updated_at"));
            return sub;
        }
    };

    public EFileSubmission save(EFileSubmission submission) {
        try {
            if (submission.getSubmissionId() != null && submission.getSubmissionId() > 0) {
                String sql = "UPDATE efile_submissions SET status = ?, irs_acknowledgment_code = ?, irs_acknowledgment_date = ?, rejection_reason = ?, updated_at = CURRENT_TIMESTAMP WHERE submission_id = ?";
                jdbcTemplate.update(sql, submission.getStatus(), submission.getIrsAcknowledgmentCode(), submission.getIrsAcknowledgmentDate(), submission.getRejectionReason(), submission.getSubmissionId());
                return submission;
            } else {
                String sql = "INSERT INTO efile_submissions (form941_id, submission_type, submitted_by_user_id, submission_timestamp, irs_acknowledgment_code, irs_acknowledgment_date, status, rejection_reason, transmission_id, created_at, updated_at) " +
                             "VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING submission_id";
                Long id = jdbcTemplate.queryForObject(sql, Long.class,
                        submission.getForm941Id(),
                        submission.getSubmissionType() != null ? submission.getSubmissionType() : "ORIGINAL",
                        submission.getSubmittedByUserId(),
                        submission.getIrsAcknowledgmentCode(),
                        submission.getIrsAcknowledgmentDate(),
                        submission.getStatus() != null ? submission.getStatus() : "SUBMITTED",
                        submission.getRejectionReason(),
                        submission.getTransmissionId());
                submission.setSubmissionId(id);
                return submission;
            }
        } catch (Exception e) {
            System.err.println("EFileSubmissionDao save exception: " + e.getMessage());
            e.printStackTrace();
            return submission;
        }
    }

    public List<EFileSubmission> findByForm941Id(Long form941Id) {
        try {
            String sql = "SELECT * FROM efile_submissions WHERE form941_id = ? ORDER BY submission_timestamp DESC";
            return jdbcTemplate.query(sql, SUBMISSION_ROW_MAPPER, form941Id);
        } catch (Exception e) {
            System.err.println("EFileSubmissionDao findByForm941Id exception: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    public List<EFileSubmission> findByUserId(Long userId) {
        try {
            String sql = "SELECT * FROM efile_submissions WHERE submitted_by_user_id = ? ORDER BY submission_timestamp DESC";
            return jdbcTemplate.query(sql, SUBMISSION_ROW_MAPPER, userId);
        } catch (Exception e) {
            System.err.println("EFileSubmissionDao findByUserId exception: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    public Optional<EFileSubmission> findById(Long submissionId) {
        try {
            String sql = "SELECT * FROM efile_submissions WHERE submission_id = ?";
            List<EFileSubmission> list = jdbcTemplate.query(sql, SUBMISSION_ROW_MAPPER, submissionId);
            return list.stream().findFirst();
        } catch (Exception e) {
            System.err.println("EFileSubmissionDao findById exception: " + e.getMessage());
            return Optional.empty();
        }
    }

    public boolean updateStatus(Long submissionId, String status, String ackCode, String rejectionReason) {
        try {
            String sql = "UPDATE efile_submissions SET status = ?, irs_acknowledgment_code = ?, irs_acknowledgment_date = CURRENT_TIMESTAMP, rejection_reason = ?, updated_at = CURRENT_TIMESTAMP WHERE submission_id = ?";
            return jdbcTemplate.update(sql, status, ackCode, rejectionReason, submissionId) > 0;
        } catch (Exception e) {
            System.err.println("EFileSubmissionDao updateStatus exception: " + e.getMessage());
            return false;
        }
    }
}
