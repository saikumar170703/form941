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

@Controller
public class AuthController {

    @Autowired
    private AuthService authService;

    @Autowired(required = false)
    private EmployerService employerService;

    @GetMapping("/login")
    public String showLoginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam("email") String email,
                               @RequestParam("password") String password,
                               HttpSession session,
                               Model model) {
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
            return "redirect:/dashboard";
        } else {
            model.addAttribute("error", "Invalid email/username or password. Please check your credentials or create a new account.");
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
}
