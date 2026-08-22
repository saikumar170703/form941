package com.company.irs941.controller;

import java.util.Optional;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.company.irs941.model.Employer;
import com.company.irs941.model.User;
import com.company.irs941.service.AuthService;
import com.company.irs941.service.EmployerService;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Controller
public class AuthController {

    private static final Logger logger = LogManager.getLogger(AuthController.class);

    @Autowired
    private AuthService authService;

    @Autowired(required = false)
    private EmployerService employerService;

    @GetMapping({ "/", "/index", "/home", "/index.html", "/landing" })
    public String showHomePage() {
        logger.info("[AUTH] Displaying Form 941 public home page.");
        return "index";
    }

    @GetMapping("/login")
    public String showLoginPage() {
        logger.info("[AUTH] Displaying login page.");
        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {
        logger.info("[AUTH LOGIN ATTEMPT] Email: {}", email);
        Optional<User> optUser = authService.authenticate(email, password);
        if (optUser.isPresent()) {
            User u = optUser.get();
            session.setAttribute("user", u);
            session.setAttribute("userId", u.getUserId());
            session.setAttribute("userEmail", u.getEmail());
            String name = u.getFullName() != null ? u.getFullName() : "User";
            session.setAttribute("userFullName", name);
            String firstName = name.contains(" ") ? name.split(" ")[0] : name;
            session.setAttribute("userFirstName", firstName);
            logger.info("[AUTH LOGIN SUCCESS] User ID: {}, Email: {} redirected to /dashboard", u.getUserId(),
                    u.getEmail());
            return "redirect:/dashboard";
        } else {
            logger.warn("[AUTH LOGIN FAILED] Invalid credentials attempt for email: {}", email);
            model.addAttribute("error",
                    "Invalid email/username or password. Please check your credentials or create a new account.");
            return "login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login";
    }

    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam(value = "businessName", required = false) String businessName,
            @RequestParam(value = "ein", required = false) String ein,
            HttpSession session,
            Model model) {
        try {
            User u = authService.registerUser(name, email, password);
            if (u == null || u.getUserId() == null) {
                model.addAttribute("error", "Failed to create user account. Please try again.");
                return "register";
            }

            // Create business profile if Business Name or EIN provided
            if ((businessName != null && !businessName.trim().isEmpty()) || (ein != null && !ein.trim().isEmpty())) {
                if (employerService != null) {
                    Employer emp = new Employer();
                    emp.setBusinessName(businessName != null ? businessName.trim() : "My Business");
                    emp.setEin(ein != null ? ein.trim() : "");
                    emp.setContactName(name);
                    emp.setEmail(email);
                    emp.setCreatedBy(u.getUserId());
                    employerService.saveEmployer(emp, u.getUserId());
                }
            }

            session.setAttribute("user", u);
            session.setAttribute("userId", u.getUserId());
            session.setAttribute("userEmail", u.getEmail());
            session.setAttribute("userFullName", u.getFullName());
            String firstName = name.contains(" ") ? name.split(" ")[0] : name;
            session.setAttribute("userFirstName", firstName);
            return "redirect:/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", "Error creating account: " + e.getMessage());
            return "register";
        }
    }

    @GetMapping("/auth/google/popup")
    public String showGooglePopupPage() {
        return "google_popup";
    }

    @PostMapping({ "/auth/google/register", "/register/google" })
    public String registerWithGoogle(@RequestParam(value = "googleEmail", required = false) String googleEmail,
            @RequestParam(value = "googleName", required = false) String googleName,
            @RequestParam(value = "email", required = false) String fallbackEmail,
            @RequestParam(value = "name", required = false) String fallbackName,
            HttpSession session,
            Model model) {
        String rawEmail = (googleEmail != null && !googleEmail.trim().isEmpty()) ? googleEmail : fallbackEmail;
        String rawName = (googleName != null && !googleName.trim().isEmpty()) ? googleName : fallbackName;

        if (rawEmail == null || rawEmail.trim().isEmpty()) {
            model.addAttribute("error", "Google email address is required for registration.");
            return "register";
        }

        String email = rawEmail.trim().toLowerCase();
        String name = (rawName != null && !rawName.trim().isEmpty()) ? rawName.trim() : email.split("@")[0];

        try {
            logger.info("[GOOGLE REGISTRATION ATTEMPT] Email: {}, Name: {}", email, name);
            Optional<User> existingUser = authService.getUserByEmail(email);
            User u;
            if (existingUser.isPresent()) {
                u = existingUser.get();
                logger.info("[GOOGLE REGISTRATION] Existing user found in DB: {}, logging in.", email);
            } else {
                // Save user in DB creating username as mail and password (hashed version of
                // email)
                u = authService.registerUser(name, email, email);
                logger.info("[GOOGLE REGISTRATION SUCCESS] New user created & saved in DB with username/email: {}",
                        email);
            }

            if (u != null && u.getUserId() != null) {
                session.setAttribute("user", u);
                session.setAttribute("userId", u.getUserId());
                session.setAttribute("userEmail", u.getEmail());
                session.setAttribute("userFullName", u.getFullName());
                String firstName = name.contains(" ") ? name.split(" ")[0] : name;
                session.setAttribute("userFirstName", firstName);
                return "redirect:/dashboard";
            } else {
                model.addAttribute("error", "Failed to create account with Google. Please try again.");
                return "register";
            }
        } catch (Exception e) {
            logger.error("[GOOGLE REGISTRATION ERROR] {}", e.getMessage(), e);
            model.addAttribute("error", "Google registration failed: " + e.getMessage());
            return "register";
        }
    }
}
