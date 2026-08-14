package com.company.irs941.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpSession;

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

    @Autowired
    private EmployerService employerService;

    @GetMapping("/list")
    public String listEmployers(@RequestParam(value = "search", required = false) String search, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        List<Employer> list = employerService.searchEmployers(search, userId);
        model.addAttribute("employers", list);
        model.addAttribute("searchQuery", search);
        model.addAttribute("employer", new Employer());
        model.addAttribute("showForm", false);
        return "employer/edit";
    }

    @GetMapping("/edit")
    public String editEmployer(@RequestParam(value = "id", required = false) Long id, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        List<Employer> list = employerService.getAllEmployers(userId);
        model.addAttribute("employers", list);

        if (id != null && id > 0) {
            Optional<Employer> opt = employerService.getEmployerByIdAndUserId(id, userId);
            if (opt.isPresent()) {
                model.addAttribute("employer", opt.get());
                model.addAttribute("showForm", true);
            } else {
                model.addAttribute("employer", new Employer());
                model.addAttribute("showForm", true);
            }
        } else {
            model.addAttribute("employer", new Employer());
            model.addAttribute("showForm", true);
        }
        return "employer/edit";
    }

    @PostMapping("/save")
    public String saveEmployer(@ModelAttribute Employer employer, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        employer.setCreatedBy(userId);
        Map<String, Object> valResult = employerService.validateEmployer(employer);
        List<?> errors = (List<?>) valResult.get("errors");

        if (errors != null && !errors.isEmpty()) {
            model.addAttribute("employers", employerService.getAllEmployers(userId));
            model.addAttribute("employer", employer);
            model.addAttribute("errors", errors);
            model.addAttribute("fieldErrors", valResult.get("fieldErrors"));
            model.addAttribute("showForm", true);
            return "employer/edit";
        }

        employerService.saveEmployer(employer, userId);
        return "redirect:/employer/list";
    }

    @GetMapping("/delete")
    public String deleteEmployer(@RequestParam("id") Long id, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        employerService.deleteEmployer(id, userId);
        return "redirect:/employer/list";
    }
}
