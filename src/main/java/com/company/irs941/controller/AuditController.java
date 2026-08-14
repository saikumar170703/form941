package com.company.irs941.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.company.irs941.model.AuditLog;
import com.company.irs941.service.AuditLogService;

@Controller
public class AuditController {

    @Autowired
    private AuditLogService auditLogService;

    @GetMapping("/audit/list")
    public String listAuditLogs(Model model) {
        List<AuditLog> logs = auditLogService.getAllAuditLogs();
        model.addAttribute("logs", logs);
        return "audit/list";
    }
}
