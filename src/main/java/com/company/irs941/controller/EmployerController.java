package com.company.irs941.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import jakarta.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.company.irs941.model.Employer;
import com.company.irs941.service.EmployerService;

@Controller
@RequestMapping("/employer")
public class EmployerController {

    private static final Logger logger = LogManager.getLogger(EmployerController.class);

    @Autowired
    private EmployerService employerService;

    @GetMapping("/list")
    public String listEmployers(@RequestParam(value = "search", required = false) String search, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            logger.warn("[EMPLOYER LIST] Session null or expired. Redirecting to /login.");
            return "redirect:/login";
        }

        try {
            logger.info("[EMPLOYER LIST] Searching employers for User ID: {}, Query: {}", userId, search);
            List<Employer> list = employerService.searchEmployers(search, userId);
            model.addAttribute("employers", list);
            model.addAttribute("searchQuery", search);
            model.addAttribute("employer", new Employer());
            model.addAttribute("showForm", false);
            return "employer/edit";
        } catch (Exception e) {
            logger.error("[EMPLOYER LIST ERROR] Error listing employers for User ID: {}", userId, e);
            throw e;
        }
    }

    @GetMapping("/edit")
    public String editEmployer(@RequestParam(value = "id", required = false) Long id, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        try {
            logger.info("[EMPLOYER EDIT] Editing employer ID: {} for User ID: {}", id, userId);
            List<Employer> list = employerService.getAllEmployers(userId);
            model.addAttribute("employers", list);

            if (id != null && id > 0) {
                Optional<Employer> opt = employerService.getEmployerByIdAndUserId(id, userId);
                if (opt.isPresent()) {
                    model.addAttribute("employer", opt.get());
                    model.addAttribute("showForm", true);
                } else {
                    logger.warn("[EMPLOYER EDIT WARN] Employer ID {} not found for User ID: {}", id, userId);
                    model.addAttribute("employer", new Employer());
                    model.addAttribute("showForm", true);
                }
            } else {
                model.addAttribute("employer", new Employer());
                model.addAttribute("showForm", true);
            }
            return "employer/edit";
        } catch (Exception e) {
            logger.error("[EMPLOYER EDIT ERROR] Error opening employer edit form for Employer ID: {}, User ID: {}", id, userId, e);
            throw e;
        }
    }

    @PostMapping("/save")
    public String saveEmployer(@ModelAttribute Employer employer, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        try {
            logger.info("[EMPLOYER SAVE] Saving employer Business Name: {}, EIN: {} for User ID: {}", 
                    employer.getBusinessName(), employer.getEin(), userId);

            employer.setCreatedBy(userId);
            Map<String, Object> valResult = employerService.validateEmployer(employer);
            List<?> errors = (List<?>) valResult.get("errors");

            if (errors != null && !errors.isEmpty()) {
                logger.warn("[EMPLOYER SAVE VALIDATION] Employer validation failed with {} errors for Business: {}", 
                        errors.size(), employer.getBusinessName());
                model.addAttribute("employers", employerService.getAllEmployers(userId));
                model.addAttribute("employer", employer);
                model.addAttribute("errors", errors);
                model.addAttribute("fieldErrors", valResult.get("fieldErrors"));
                model.addAttribute("showForm", true);
                return "employer/edit";
            }

            employerService.saveEmployer(employer, userId);
            logger.info("[EMPLOYER SAVE SUCCESS] Employer ID: {} saved successfully.", employer.getEmployerId());
            return "redirect:/employer/list";
        } catch (Exception e) {
            logger.error("[EMPLOYER SAVE ERROR] Error saving employer Business: {} for User ID: {}", employer.getBusinessName(), userId, e);
            throw e;
        }
    }

    @GetMapping("/delete")
    public String deleteEmployer(@RequestParam("id") Long id, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        try {
            logger.info("[EMPLOYER DELETE] Deleting employer ID: {} for User ID: {}", id, userId);
            employerService.deleteEmployer(id, userId);
            return "redirect:/employer/list";
        } catch (Exception e) {
            logger.error("[EMPLOYER DELETE ERROR] Error deleting employer ID: {} for User ID: {}", id, userId, e);
            throw e;
        }
    }
}
