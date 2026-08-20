package com.company.irs941.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.company.irs941.model.Employer;

@Repository
public class EmployerDao {

    private static final Logger logger = LogManager.getLogger(EmployerDao.class);

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final RowMapper<Employer> EMPLOYER_ROW_MAPPER = new RowMapper<Employer>() {
        @Override
        public Employer mapRow(ResultSet rs, int rowNum) throws SQLException {
            Employer emp = new Employer();
            emp.setEmployerId(rs.getLong("employer_id"));
            emp.setEin(rs.getString("ein"));
            emp.setBusinessName(rs.getString("business_name"));
            emp.setTradeName(rs.getString("trade_name"));
            emp.setAddressLine1(rs.getString("address_line1"));
            emp.setAddressLine2(rs.getString("address_line2"));
            emp.setCity(rs.getString("city"));
            emp.setState(rs.getString("state"));
            emp.setZip(rs.getString("zip"));
            emp.setPhone(rs.getString("phone"));
            emp.setIndustryCode(rs.getString("industry_code"));
            emp.setContactName(rs.getString("contact_name"));
            emp.setContactTitle(rs.getString("contact_title"));
            emp.setEmail(rs.getString("email"));
            try {
                emp.setCreatedBy(rs.getLong("created_by"));
            } catch (Exception ignored) {}
            emp.setCreatedAt(rs.getTimestamp("created_at"));
            emp.setUpdatedAt(rs.getTimestamp("updated_at"));
            return emp;
        }
    };

    public List<Employer> findAll() {
        try {
            String sql = "SELECT * FROM employers ORDER BY created_at DESC";
            return jdbcTemplate.query(sql, EMPLOYER_ROW_MAPPER);
        } catch (Exception e) {
            System.err.println("EmployerDao findAll exception: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    public List<Employer> findByUserId(Long userId) {
        try {
            if (userId == null) return Collections.emptyList();
            String sql = "SELECT * FROM employers WHERE created_by = ? ORDER BY created_at DESC";
            return jdbcTemplate.query(sql, EMPLOYER_ROW_MAPPER, userId);
        } catch (Exception e) {
            System.err.println("EmployerDao findByUserId exception: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    public Optional<Employer> findById(Long employerId) {
        try {
            String sql = "SELECT * FROM employers WHERE employer_id = ?";
            List<Employer> list = jdbcTemplate.query(sql, EMPLOYER_ROW_MAPPER, employerId);
            return list.stream().findFirst();
        } catch (Exception e) {
            System.err.println("EmployerDao findById exception: " + e.getMessage());
            return Optional.empty();
        }
    }

    public Optional<Employer> findByIdAndUserId(Long employerId, Long userId) {
        try {
            String sql = "SELECT * FROM employers WHERE employer_id = ? AND created_by = ?";
            List<Employer> list = jdbcTemplate.query(sql, EMPLOYER_ROW_MAPPER, employerId, userId);
            return list.stream().findFirst();
        } catch (Exception e) {
            System.err.println("EmployerDao findByIdAndUserId exception: " + e.getMessage());
            return Optional.empty();
        }
    }

    public Optional<Employer> findByEin(String ein) {
        try {
            if (ein == null || ein.trim().isEmpty()) return Optional.empty();
            String sql = "SELECT * FROM employers WHERE ein = ?";
            List<Employer> list = jdbcTemplate.query(sql, EMPLOYER_ROW_MAPPER, ein.trim());
            return list.stream().findFirst();
        } catch (Exception e) {
            System.err.println("EmployerDao findByEin exception: " + e.getMessage());
            return Optional.empty();
        }
    }

    public List<Employer> search(String term) {
        try {
            if (term == null || term.trim().isEmpty()) {
                return findAll();
            }
            String pattern = "%" + term.trim() + "%";
            String sql = "SELECT * FROM employers WHERE ein LIKE ? OR business_name ILIKE ? OR trade_name ILIKE ? ORDER BY created_at DESC";
            return jdbcTemplate.query(sql, EMPLOYER_ROW_MAPPER, pattern, pattern, pattern);
        } catch (Exception e) {
            System.err.println("EmployerDao search exception: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    public List<Employer> searchByUserId(String term, Long userId) {
        try {
            if (term == null || term.trim().isEmpty()) {
                return findByUserId(userId);
            }
            String pattern = "%" + term.trim() + "%";
            String sql = "SELECT * FROM employers WHERE created_by = ? AND (ein LIKE ? OR business_name ILIKE ? OR trade_name ILIKE ?) ORDER BY created_at DESC";
            return jdbcTemplate.query(sql, EMPLOYER_ROW_MAPPER, userId, pattern, pattern, pattern);
        } catch (Exception e) {
            System.err.println("EmployerDao searchByUserId exception: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    public Employer save(Employer employer) {
        try {
            Long creatorId = employer.getCreatedBy() != null ? employer.getCreatedBy() : 1L;
            if (employer.getEmployerId() != null && employer.getEmployerId() > 0) {
                String sql = "UPDATE employers SET ein = ?, business_name = ?, trade_name = ?, address_line1 = ?, " +
                             "city = ?, state = ?, zip = ?, phone = ?, industry_code = ?, contact_name = ?, contact_title = ?, email = ?, updated_at = CURRENT_TIMESTAMP WHERE employer_id = ?";
                jdbcTemplate.update(sql, employer.getEin(), employer.getBusinessName(), employer.getTradeName(),
                        employer.getAddressLine1(), employer.getCity(), employer.getState(), employer.getZip(),
                        employer.getPhone(), employer.getIndustryCode() != null ? employer.getIndustryCode() : "541211",
                        employer.getContactName(), employer.getContactTitle(), employer.getEmail(),
                        employer.getEmployerId());
                return employer;
            } else {
                Optional<Employer> existing = findByEin(employer.getEin());
                if (existing.isPresent()) {
                    employer.setEmployerId(existing.get().getEmployerId());
                    return save(employer);
                }

                String sql = "INSERT INTO employers (ein, business_name, trade_name, address_line1, city, state, zip, phone, industry_code, contact_name, contact_title, email, created_by, created_at, updated_at) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING employer_id";
                Long id = jdbcTemplate.queryForObject(sql, Long.class,
                        employer.getEin(), employer.getBusinessName(), employer.getTradeName(),
                        employer.getAddressLine1(), employer.getCity(), employer.getState(), employer.getZip(),
                        employer.getPhone(), employer.getIndustryCode() != null ? employer.getIndustryCode() : "541211",
                        employer.getContactName(), employer.getContactTitle(), employer.getEmail(), creatorId);
                employer.setEmployerId(id);
                return employer;
            }
        } catch (Exception e) {
            System.err.println("EmployerDao save exception: " + e.getMessage());
            e.printStackTrace();
            return employer;
        }
    }

    public boolean delete(Long employerId, Long userId) {
        try {
            String sql = "DELETE FROM employers WHERE employer_id = ? AND created_by = ?";
            return jdbcTemplate.update(sql, employerId, userId) > 0;
        } catch (Exception e) {
            System.err.println("EmployerDao delete exception: " + e.getMessage());
            return true;
        }
    }

    public int count() {
        try {
            String sql = "SELECT COUNT(*) FROM employers";
            Integer total = jdbcTemplate.queryForObject(sql, Integer.class);
            return total != null ? total : 0;
        } catch (Exception e) {
            System.err.println("EmployerDao count exception: " + e.getMessage());
            return 0;
        }
    }

    public int countByUserId(Long userId) {
        try {
            String sql = "SELECT COUNT(*) FROM employers WHERE created_by = ?";
            Integer total = jdbcTemplate.queryForObject(sql, Integer.class, userId);
            return total != null ? total : 0;
        } catch (Exception e) {
            System.err.println("EmployerDao countByUserId exception: " + e.getMessage());
            return 0;
        }
    }
}
