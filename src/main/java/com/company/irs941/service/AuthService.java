package com.company.irs941.service;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Optional;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.irs941.dao.UserDao;
import com.company.irs941.model.User;

@Service
public class AuthService {

    private static final Logger logger = LogManager.getLogger(AuthService.class);

    @Autowired
    private UserDao userDao;

    @Autowired
    private AuditLogService auditLogService;

    public Optional<User> authenticate(String emailOrUsername, String rawPassword) {
        if (emailOrUsername == null || rawPassword == null) {
            return Optional.empty();
        }

        Optional<User> optUser = userDao.findByEmail(emailOrUsername.trim());
        if (optUser.isPresent()) {
            User u = optUser.get();
            String hashedInput = hashPassword(rawPassword);
            if (verifyPassword(rawPassword, u.getPasswordHash())) {
                // Auto-upgrade plain text password to SHA-256 hash in DB
                if (rawPassword.equals(u.getPasswordHash())) {
                    userDao.updatePassword(u.getUserId(), hashedInput);
                    u.setPasswordHash(hashedInput);
                }
                auditLogService.log("users", u.getUserId(), "LOGIN_SUCCESS", u.getUserId(), "User logged in: " + u.getEmail());
                logger.info("Authentication successful for user: " + u.getEmail());
                return Optional.of(u);
            }
        }

        logger.warn("Authentication failed for user identifier: " + emailOrUsername);
        return Optional.empty();
    }

    public Optional<User> getUserById(Long userId) {
        if (userId == null) return Optional.empty();
        return userDao.findById(userId);
    }

    public User registerUser(String fullName, String email, String password) {
        User u = new User();
        u.setFullName(fullName != null ? fullName.trim() : "");
        u.setEmail(email != null ? email.trim().toLowerCase() : "");
        u.setPasswordHash(hashPassword(password));
        u.setRoleId(2);
        u.setStatus("ACTIVE");

        User saved = userDao.createUser(u);
        if (saved != null && saved.getUserId() != null) {
            auditLogService.log("users", saved.getUserId(), "REGISTER_USER", saved.getUserId(), "New user registered: " + email);
            logger.info("New user registered successfully: " + email);
        }
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
        String hashed = hashPassword(newPassword);
        boolean updated = userDao.updatePassword(userId, hashed);
        if (updated) {
            auditLogService.log("users", userId, "UPDATE_PASSWORD", userId, "User password updated.");
        }
        return updated;
    }

    public static String hashPassword(String password) {
        if (password == null) return "";
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            return password;
        }
    }

    public static boolean verifyPassword(String rawPassword, String storedHash) {
        if (rawPassword == null || storedHash == null) return false;
        // Support legacy plain text or hashed passwords securely
        if (rawPassword.equals(storedHash)) return true;
        String hashed = hashPassword(rawPassword);
        return hashed.equals(storedHash);
    }
}
