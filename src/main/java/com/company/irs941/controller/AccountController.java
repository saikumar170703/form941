package com.company.irs941.controller;

import java.util.Optional;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.company.irs941.model.User;
import com.company.irs941.service.AuthService;

@Controller
@RequestMapping("/account")
public class AccountController {

    @Autowired
    private AuthService authService;

    @GetMapping({"", "/"})
    public String showAccount(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        User user = (User) session.getAttribute("user");
        if (user == null) {
            Optional<User> opt = authService.getUserById(userId);
            if (opt.isPresent()) {
                user = opt.get();
                session.setAttribute("user", user);
            } else {
                user = new User(userId, "User", (String) session.getAttribute("userEmail"), "password123", 2, "ACTIVE");
            }
        }
        model.addAttribute("user", user);
        return "account";
    }

    @PostMapping("/update-profile")
    public String updateProfile(@RequestParam(value = "firstName", required = false) String firstName,
                                @RequestParam(value = "lastName", required = false) String lastName,
                                @RequestParam(value = "email", required = false) String email,
                                @RequestParam(value = "company", required = false) String company,
                                @RequestParam(value = "phoneNumber", required = false) String phoneNumber,
                                HttpSession session,
                                Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        String fName = firstName != null ? firstName.trim() : "";
        String lName = lastName != null ? lastName.trim() : "";
        String fullName = (fName + " " + lName).trim();
        if (fullName.isEmpty()) fullName = email != null ? email : "User";

        authService.updateProfile(userId, fullName, email);

        User user = (User) session.getAttribute("user");
        if (user == null) user = new User();
        user.setUserId(userId);
        user.setFullName(fullName);
        if (email != null) user.setEmail(email);
        if (company != null) user.setCompany(company);
        if (phoneNumber != null) user.setPhoneNumber(phoneNumber);

        session.setAttribute("user", user);
        session.setAttribute("userEmail", email);
        session.setAttribute("userFullName", fullName);
        session.setAttribute("userFirstName", fName);

        model.addAttribute("user", user);
        model.addAttribute("profileSuccess", "Your profile basic information has been updated successfully.");
        return "account";
    }

    @PostMapping("/change-email")
    public String changeEmail(@RequestParam("newEmail") String newEmail,
                              @RequestParam("currentPassword") String currentPassword,
                              HttpSession session,
                              Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        authService.updateEmail(userId, newEmail);
        session.setAttribute("userEmail", newEmail);

        User user = (User) session.getAttribute("user");
        if (user != null) user.setEmail(newEmail);
        model.addAttribute("user", user);
        model.addAttribute("emailSuccess", "Email address updated successfully to " + newEmail);
        return "account";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam("currentPassword") String currentPassword,
                                 @RequestParam("newPassword") String newPassword,
                                 @RequestParam("confirmPassword") String confirmPassword,
                                 HttpSession session,
                                 Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        if (!newPassword.equals(confirmPassword)) {
            User user = (User) session.getAttribute("user");
            model.addAttribute("user", user);
            model.addAttribute("passwordErrors", "New password and confirm password do not match.");
            return "account";
        }

        authService.updatePassword(userId, newPassword);
        User user = (User) session.getAttribute("user");
        model.addAttribute("user", user);
        model.addAttribute("passwordSuccess", "Security password updated successfully.");
        return "account";
    }
}
