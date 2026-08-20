package com.company.irs941.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.company.irs941.model.User;

@Repository
public class UserDao {

    private static final Logger logger = LogManager.getLogger(UserDao.class);

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final RowMapper<User> USER_ROW_MAPPER = new RowMapper<User>() {
        @Override
        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            User user = new User();
            user.setUserId(rs.getLong("user_id"));
            user.setFullName(rs.getString("full_name"));
            user.setEmail(rs.getString("email"));
            user.setPasswordHash(rs.getString("password_hash"));
            user.setRoleId(rs.getObject("role_id") != null ? rs.getInt("role_id") : null);
            user.setStatus(rs.getString("status"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setUpdatedAt(rs.getTimestamp("updated_at"));
            return user;
        }
    };

    public Optional<User> findByEmail(String email) {
        try {
            String sql = "SELECT * FROM users WHERE email = ?";
            List<User> users = jdbcTemplate.query(sql, USER_ROW_MAPPER, email);
            return users.stream().findFirst();
        } catch (Exception e) {
            logger.error("Error finding user by email: " + email, e);
            return Optional.empty();
        }
    }

    public Optional<User> findById(Long userId) {
        try {
            String sql = "SELECT * FROM users WHERE user_id = ?";
            List<User> users = jdbcTemplate.query(sql, USER_ROW_MAPPER, userId);
            return users.stream().findFirst();
        } catch (Exception e) {
            logger.error("Error finding user by id: " + userId, e);
            return Optional.empty();
        }
    }

    public User createUser(User user) {
        try {
            String sql = "INSERT INTO users (full_name, email, password_hash, role_id, status, created_at, updated_at) " +
                         "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING user_id";
            Long id = jdbcTemplate.queryForObject(sql, Long.class, 
                    user.getFullName(), user.getEmail(), user.getPasswordHash(), 
                    user.getRoleId() != null ? user.getRoleId() : 2, 
                    user.getStatus() != null ? user.getStatus() : "ACTIVE");
            user.setUserId(id);
            return user;
        } catch (Exception e) {
            logger.error("Error creating user: " + user.getEmail(), e);
            throw new RuntimeException("Database error creating user account: " + e.getMessage(), e);
        }
    }

    public boolean updateProfile(Long userId, String fullName, String email) {
        try {
            String sql = "UPDATE users SET full_name = ?, email = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
            return jdbcTemplate.update(sql, fullName, email, userId) > 0;
        } catch (Exception e) {
            logger.error("Error updating user profile: userId=" + userId, e);
            return false;
        }
    }

    public boolean updateEmail(Long userId, String newEmail) {
        try {
            String sql = "UPDATE users SET email = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
            return jdbcTemplate.update(sql, newEmail, userId) > 0;
        } catch (Exception e) {
            logger.error("Error updating user email: userId=" + userId, e);
            return false;
        }
    }

    public boolean updatePassword(Long userId, String newPasswordHash) {
        try {
            String sql = "UPDATE users SET password_hash = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
            return jdbcTemplate.update(sql, newPasswordHash, userId) > 0;
        } catch (Exception e) {
            logger.error("Error updating user password: userId=" + userId, e);
            return false;
        }
    }
}
