package com.company.irs941.controller;

import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.company.irs941.model.User;
import com.company.irs941.service.AuthService;

@Controller
public class AuthController {

    @Autowired
    private AuthService authService;

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
            String name = u.getFullName() != null ? u.getFullName() : "Admin";
            session.setAttribute("userFullName", name);
            String firstName = name.contains(" ") ? name.split(" ")[0] : name;
            session.setAttribute("userFirstName", firstName);
            return "redirect:/dashboard";
        } else {
            model.addAttribute("error", "Invalid email or password. Please use admin@efile941.com / password123.");
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

    @PostMapping("/register")
    public String register(@RequestParam("name") String name,
                           @RequestParam("email") String email,
                           @RequestParam("password") String password,
                           HttpSession session) {
        User u = authService.registerUser(name, email, password);
        session.setAttribute("user", u);
        session.setAttribute("userId", u.getUserId());
        session.setAttribute("userEmail", u.getEmail());
        session.setAttribute("userFullName", u.getFullName());
        String firstName = name.contains(" ") ? name.split(" ")[0] : name;
        session.setAttribute("userFirstName", firstName);
        return "redirect:/dashboard";
    }
}
