package com.company.irs941.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.irs941.dao.AuditLogDao;
import com.company.irs941.model.AuditLog;

@Service
public class AuditLogService {

    @Autowired
    private AuditLogDao auditLogDao;

    public List<AuditLog> getAllAuditLogs() {
        return auditLogDao.findAll();
    }

    public void log(String tableName, Long recordId, String action, Long userId, String details) {
        try {
            auditLogDao.logAction(tableName, recordId, action, userId, details, "127.0.0.1");
        } catch (Exception ignored) {
            // Ignore audit failure so main workflow doesn't break
        }
    }
}
