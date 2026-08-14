package com.company.irs941.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.company.irs941.model.AuditLog;

@Repository
public class AuditLogDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final RowMapper<AuditLog> AUDIT_ROW_MAPPER = new RowMapper<AuditLog>() {
        @Override
        public AuditLog mapRow(ResultSet rs, int rowNum) throws SQLException {
            AuditLog log = new AuditLog();
            log.setAuditId(rs.getLong("audit_id"));
            log.setTableName(rs.getString("table_name"));
            log.setRecordId(rs.getObject("record_id") != null ? rs.getLong("record_id") : null);
            log.setAction(rs.getString("action"));
            log.setChangedByUserId(rs.getObject("changed_by_user_id") != null ? rs.getLong("changed_by_user_id") : null);
            log.setChangedAt(rs.getTimestamp("changed_at"));
            log.setIpAddress(rs.getString("ip_address"));
            return log;
        }
    };

    public List<AuditLog> findAll() {
        String sql = "SELECT * FROM audit_logs ORDER BY changed_at DESC LIMIT 100";
        return jdbcTemplate.query(sql, AUDIT_ROW_MAPPER);
    }

    public void logAction(String tableName, Long recordId, String action, Long userId, String details, String ipAddress) {
        String sql = "INSERT INTO audit_logs (table_name, record_id, action, changed_by_user_id, changed_at, ip_address) " +
                     "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, ?)";
        jdbcTemplate.update(sql, tableName, recordId, action, userId, ipAddress != null ? ipAddress : "127.0.0.1");
    }
}
