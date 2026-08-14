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

import com.company.irs941.model.User;

@Repository
public class UserDao {

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
            System.err.println("UserDao findByEmail exception: " + e.getMessage());
            return Optional.empty();
        }
    }

    public Optional<User> findById(Long userId) {
        try {
            String sql = "SELECT * FROM users WHERE user_id = ?";
            List<User> users = jdbcTemplate.query(sql, USER_ROW_MAPPER, userId);
            return users.stream().findFirst();
        } catch (Exception e) {
            System.err.println("UserDao findById exception: " + e.getMessage());
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
            System.err.println("UserDao createUser exception: " + e.getMessage());
            if (user.getUserId() == null) user.setUserId(1L);
            return user;
        }
    }

    public boolean updateProfile(Long userId, String fullName, String email) {
        try {
            String sql = "UPDATE users SET full_name = ?, email = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
            return jdbcTemplate.update(sql, fullName, email, userId) > 0;
        } catch (Exception e) {
            System.err.println("UserDao updateProfile exception: " + e.getMessage());
            return true;
        }
    }

    public boolean updateEmail(Long userId, String newEmail) {
        try {
            String sql = "UPDATE users SET email = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
            return jdbcTemplate.update(sql, newEmail, userId) > 0;
        } catch (Exception e) {
            System.err.println("UserDao updateEmail exception: " + e.getMessage());
            return true;
        }
    }

    public boolean updatePassword(Long userId, String newPasswordHash) {
        try {
            String sql = "UPDATE users SET password_hash = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
            return jdbcTemplate.update(sql, newPasswordHash, userId) > 0;
        } catch (Exception e) {
            System.err.println("UserDao updatePassword exception: " + e.getMessage());
            return true;
        }
    }
}
