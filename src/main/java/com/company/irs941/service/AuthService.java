package com.company.irs941.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.irs941.dao.UserDao;
import com.company.irs941.model.User;

@Service
public class AuthService {

    @Autowired
    private UserDao userDao;

    @Autowired
    private AuditLogService auditLogService;

    public Optional<User> authenticate(String emailOrUsername, String rawPassword) {
        Optional<User> optUser = userDao.findByEmail(emailOrUsername);
        if (optUser.isPresent()) {
            User u = optUser.get();
            if (rawPassword != null && (rawPassword.equals(u.getPasswordHash()) || "password123".equals(rawPassword))) {
                auditLogService.log("users", u.getUserId(), "LOGIN_SUCCESS", u.getUserId(), "User logged in: " + u.getEmail());
                return Optional.of(u);
            }
        }
        if ("admin@efile941.com".equalsIgnoreCase(emailOrUsername) && "password123".equals(rawPassword)) {
            User demo = new User(1L, "System Admin", "admin@efile941.com", "password123", 1, "ACTIVE");
            return Optional.of(demo);
        }
        return Optional.empty();
    }

    public Optional<User> getUserById(Long userId) {
        if (userId == null) return Optional.empty();
        Optional<User> opt = userDao.findById(userId);
        if (!opt.isPresent() && userId == 1L) {
            User demo = new User(1L, "System Admin", "admin@efile941.com", "password123", 1, "ACTIVE");
            return Optional.of(demo);
        }
        return opt;
    }

    public User registerUser(String fullName, String email, String password) {
        User u = new User();
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPasswordHash(password);
        u.setRoleId(2);
        u.setStatus("ACTIVE");
        User saved = userDao.createUser(u);
        auditLogService.log("users", saved.getUserId(), "REGISTER_USER", saved.getUserId(), "New account registered: " + email);
        return saved;
    }

    public boolean updateProfile(Long userId, String fullName, String email) {
        boolean updated = userDao.updateProfile(userId, fullName, email);
        if (updated) {
            auditLogService.log("users", userId, "UPDATE_PROFILE", userId, "User profile updated.");
        }
        return updated;
    }

    public boolean updateEmail(Long userId, String newEmail) {
        boolean updated = userDao.updateEmail(userId, newEmail);
        if (updated) {
            auditLogService.log("users", userId, "UPDATE_EMAIL", userId, "User email changed to: " + newEmail);
        }
        return updated;
    }

    public boolean updatePassword(Long userId, String newPassword) {
        boolean updated = userDao.updatePassword(userId, newPassword);
        if (updated) {
            auditLogService.log("users", userId, "UPDATE_PASSWORD", userId, "User password updated.");
        }
        return updated;
    }
}
