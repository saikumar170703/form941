package com.company.irs941.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.company.irs941.model.Employer;
import com.company.irs941.model.Form941;
import com.company.irs941.service.EmployerService;
import com.company.irs941.service.Form941Service;

@Controller
public class DashboardController {

    @Autowired
    private Form941Service form941Service;

    @Autowired
    private EmployerService employerService;

    @GetMapping({"/", "/dashboard"})
    public String showDashboard(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        model.addAttribute("totalFilingsCount", form941Service.getTotalFilingsCount(userId));
        model.addAttribute("inProgressCount", form941Service.getDraftsCount(userId));
        model.addAttribute("employersCount", employerService.getEmployersCount(userId));
        model.addAttribute("completedCount", form941Service.getSubmittedCount(userId));

        List<Form941> filings = form941Service.getFilingsByUserId(userId);
        model.addAttribute("recentFilings", filings);

        List<Employer> employers = employerService.getAllEmployers(userId);
        model.addAttribute("employers", employers);

        Map<Long, Employer> employerMap = new HashMap<>();
        for (Employer emp : employers) {
            employerMap.put(emp.getEmployerId(), emp);
        }
        model.addAttribute("employerMap", employerMap);

        return "dashboard";
    }
}
