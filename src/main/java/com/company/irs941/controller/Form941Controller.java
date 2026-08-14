package com.company.irs941.controller;

import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.util.Optional;
import java.util.stream.Collectors;

import com.company.irs941.dao.TaxRateDao;
import com.company.irs941.dao.TaxYearDao;
import com.company.irs941.dto.Form941DTO;
import com.company.irs941.dto.ValidationErrorDTO;
import com.company.irs941.model.Employer;
import com.company.irs941.model.Form941;
import com.company.irs941.model.TaxRate;
import com.company.irs941.model.TaxYear;
import com.company.irs941.service.EmployerService;
import com.company.irs941.service.Form941Service;

@Controller
public class Form941Controller {

    @Autowired
    private Form941Service form941Service;

    @Autowired
    private EmployerService employerService;

    @Autowired
    private TaxYearDao taxYearDao;

    @Autowired
    private TaxRateDao taxRateDao;

    @GetMapping("/form941/interactive")
    public String showInteractiveForm(@RequestParam(value = "id", required = false) Long id,
                                      @RequestParam(value = "new", required = false) Boolean isNew,
                                      HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        if (Boolean.TRUE.equals(isNew)) {
            session.removeAttribute("formDTO");
        }
        if (id != null && id > 0) {
            Form941DTO dto = form941Service.getFilingDtoByIdAndUserId(id, userId);
            if (dto != null) {
                session.setAttribute("formDTO", dto);
            }
        }
        Form941DTO dto = getOrCreateDTO(session);

        if (dto.getEmployerId() == null || dto.getEmployerId() <= 0) {
            List<Employer> employers = employerService.getAllEmployers(userId);
            if (!employers.isEmpty()) {
                dto.setEmployerId(employers.get(0).getEmployerId());
            }
        }

        if (dto.getEmployerId() != null && dto.getEmployerId() > 0) {
            employerService.getEmployerByIdAndUserId(dto.getEmployerId(), userId).ifPresent(emp -> {
                if (dto.getLineValue("ein") == null) dto.setLineValue("ein", emp.getEin());
                if (dto.getLineValue("businessName") == null) dto.setLineValue("businessName", emp.getBusinessName());
                if (dto.getLineValue("tradeName") == null) dto.setLineValue("tradeName", emp.getTradeName());
                if (dto.getLineValue("address") == null) dto.setLineValue("address", emp.getAddressLine1());
                if (dto.getLineValue("city") == null) dto.setLineValue("city", emp.getCity());
                if (dto.getLineValue("state") == null) dto.setLineValue("state", emp.getState());
                if (dto.getLineValue("zip") == null) dto.setLineValue("zip", emp.getZip());
            });
        }

        model.addAttribute("formDTO", dto);
        return "form941/interactive";
    }

    @GetMapping("/form941/view")
    public String viewFiling(@RequestParam("id") Long id, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        if (id != null && id > 0) {
            Form941DTO dto = form941Service.getFilingDtoByIdAndUserId(id, userId);
            if (dto != null) {
                session.setAttribute("formDTO", dto);
            }
        }
        return "redirect:/form941/step1";
    }

    @GetMapping("/form941/new")
    public String startNewFiling(HttpSession session) {
        session.removeAttribute("formDTO");
        return "redirect:/form941/step1?new=true";
    }

    @GetMapping("/form941/step1")
    public String showStep1(@RequestParam(value = "new", required = false) Boolean isNew, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Form941DTO dto = (Form941DTO) session.getAttribute("formDTO");
        if (Boolean.TRUE.equals(isNew) || dto == null) {
            dto = new Form941DTO();
            session.setAttribute("formDTO", dto);
        }
        populateStep1Dropdowns(model, userId);
        model.addAttribute("formDTO", dto);
        return "form941/step1";
    }

    @PostMapping("/form941/step2")
    public String processStep1AndShowStep2(@RequestParam(value = "employerId", required = false) Long employerId,
                                           @RequestParam(value = "taxYear", required = false) Integer taxYear,
                                           @RequestParam(value = "quarter", required = false) Integer quarter,
                                           HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Form941DTO dto = getOrCreateDTO(session);
        if (employerId != null) dto.setEmployerId(employerId);
        if (taxYear != null) dto.setTaxYear(taxYear);
        if (quarter != null) dto.setQuarter(quarter);

        if (!"SUBMITTED".equals(dto.getStatus())) {
            form941Service.saveDraft(dto, userId);
        }

        populateTaxRateModel(model, dto);
        model.addAttribute("formDTO", dto);
        return "form941/step2";
    }

    @GetMapping("/form941/step2")
    public String showStep2(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Form941DTO dto = getOrCreateDTO(session);
        populateTaxRateModel(model, dto);
        model.addAttribute("formDTO", dto);
        return "form941/step2";
    }

    private void populateTaxRateModel(Model model, Form941DTO dto) {
        int taxYear = dto.getTaxYear() != null ? dto.getTaxYear() : 2026;
        Optional<TaxRate> taxRateOpt = taxRateDao.findByYear(taxYear);

        BigDecimal ssRateCombined = new BigDecimal("0.124");
        BigDecimal medicareRateCombined = new BigDecimal("0.029");
        BigDecimal addlMedicareRate = new BigDecimal("0.009");

        if (taxRateOpt.isPresent()) {
            TaxRate tr = taxRateOpt.get();
            if (tr.getSsRate() != null) {
                ssRateCombined = tr.getSsRate().multiply(new BigDecimal("2"));
            }
            if (tr.getMedicareRate() != null) {
                medicareRateCombined = tr.getMedicareRate().multiply(new BigDecimal("2"));
            }
            if (tr.getAddlMedicareRate() != null) {
                addlMedicareRate = tr.getAddlMedicareRate();
            }
        }

        model.addAttribute("ssRateCombined", ssRateCombined.stripTrailingZeros().toPlainString());
        model.addAttribute("medicareRateCombined", medicareRateCombined.stripTrailingZeros().toPlainString());
        model.addAttribute("addlMedicareRate", addlMedicareRate.stripTrailingZeros().toPlainString());
    }

    @PostMapping("/form941/step3")
    public String processStep2AndShowStep3(HttpServletRequest request, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Form941DTO dto = getOrCreateDTO(session);
        if (!"SUBMITTED".equals(dto.getStatus())) {
            copyRequestParamsToDto(request, dto, Arrays.asList(
                "1", "2", "3", "4", "5a_wages", "5a_tax", "5b_tips", "5b_tax",
                "5c_wages", "5c_tax", "5d_wages", "5d_tax", "5e", "5f", "6",
                "7", "8", "9", "10", "11", "12", "13", "14", "15", "15b", "15c", "15d", "15e"
            ));

            form941Service.saveDraft(dto, userId);
        }

        form941Service.validateForm(dto);
        model.addAttribute("formDTO", dto);
        return "form941/step3";
    }

    @GetMapping("/form941/step3")
    public String showStep3(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Form941DTO dto = getOrCreateDTO(session);
        form941Service.validateForm(dto);
        model.addAttribute("formDTO", dto);
        return "form941/step3";
    }

    @PostMapping("/form941/step4")
    public String processStep3AndShowStep4(HttpServletRequest request, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Form941DTO dto = getOrCreateDTO(session);
        if (!"SUBMITTED".equals(dto.getStatus())) {
            copyRequestParamsToDto(request, dto, Arrays.asList("16", "16_m1", "16_m2", "16_m3", "16_total", "sb_m1_total", "sb_m2_total", "sb_m3_total", "sb_quarter_total"));

            for (int m = 1; m <= 3; m++) {
                for (int d = 1; d <= 31; d++) {
                    String key = "sb_m" + m + "_d" + d;
                    String val = request.getParameter(key);
                    if (val != null) dto.setLineValue(key, val);
                }
            }

            form941Service.saveDraft(dto, userId);
        }

        form941Service.validateForm(dto);
        model.addAttribute("formDTO", dto);
        return "form941/step4";
    }

    @GetMapping("/form941/step4")
    public String showStep4(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        model.addAttribute("formDTO", getOrCreateDTO(session));
        return "form941/step4";
    }

    @PostMapping("/form941/step5")
    public String processStep4AndShowStep5(HttpServletRequest request, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Form941DTO dto = getOrCreateDTO(session);
        if (!"SUBMITTED".equals(dto.getStatus())) {
            copyRequestParamsToDto(request, dto, Arrays.asList(
                "line17", "finalDateWages", "17_date", "line18", "19",
                "designeeChoice", "designeeName", "designeePhone", "designeePin"
            ));

            form941Service.saveDraft(dto, userId);
        }

        model.addAttribute("formDTO", dto);
        return "form941/step5";
    }

    @GetMapping("/form941/step5")
    public String showStep5(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        model.addAttribute("formDTO", getOrCreateDTO(session));
        return "form941/step5";
    }

    @PostMapping("/form941/step6")
    public String processStep5AndShowStep6(HttpServletRequest request, HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Form941DTO dto = getOrCreateDTO(session);
        if (!"SUBMITTED".equals(dto.getStatus())) {
            copyRequestParamsToDto(request, dto, Arrays.asList(
                "signatureName", "signatureTitle", "signatureDate", "signaturePhone",
                "paidPreparerCheck", "preparerSelfEmployed", "preparerName", "preparerPtin",
                "preparerSignature", "preparerDate", "preparerFirmName", "preparerEin",
                "preparerAddress", "preparerPhone", "preparerCity", "preparerState", "preparerZip"
            ));

            form941Service.saveDraft(dto, userId);
        }

        List<ValidationErrorDTO> validationErrors = form941Service.validateForm(dto);
        populateTaxRateModel(model, dto);
        model.addAttribute("formDTO", dto);
        model.addAttribute("validationErrors", validationErrors);
        return "form941/step6";
    }

    @GetMapping("/form941/step6")
    public String showStep6(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Form941DTO dto = getOrCreateDTO(session);
        List<ValidationErrorDTO> validationErrors = form941Service.validateForm(dto);
        populateTaxRateModel(model, dto);
        model.addAttribute("formDTO", dto);
        model.addAttribute("validationErrors", validationErrors);
        return "form941/step6";
    }

    @PostMapping("/form941/saveDraft")
    public String saveDraft(HttpServletRequest request, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Form941DTO dto = getOrCreateDTO(session);
        if (!"SUBMITTED".equals(dto.getStatus())) {
            extractAllFormParameters(request, dto);
            form941Service.saveDraft(dto, userId);
        }
        return "redirect:/filings";
    }

    @PostMapping("/form941/submitInternal")
    public String submitInternal(HttpServletRequest request, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        Form941DTO dto = getOrCreateDTO(session);
        if (!"SUBMITTED".equals(dto.getStatus())) {
            extractAllFormParameters(request, dto);
            form941Service.submitReturn(dto, userId);
        }
        session.removeAttribute("formDTO");
        return "redirect:/filings";
    }

    @GetMapping("/form941/resume")
    public String resumeFiling(@RequestParam("id") Long id, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        if (id != null && id > 0) {
            Form941DTO dto = form941Service.getFilingDtoByIdAndUserId(id, userId);
            if (dto != null) {
                session.setAttribute("formDTO", dto);
            }
        }
        return "redirect:/form941/step1";
    }

    @GetMapping("/filings")
    public String listFilings(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";

        List<Form941> filings = form941Service.getFilingsByUserId(userId);
        model.addAttribute("filings", filings);

        List<Employer> employers = employerService.getAllEmployers(userId);
        Map<Long, Employer> employerMap = new HashMap<>();
        for (Employer emp : employers) {
            employerMap.put(emp.getEmployerId(), emp);
        }
        model.addAttribute("employerMap", employerMap);
        return "filings/list";
    }

    private Form941DTO getOrCreateDTO(HttpSession session) {
        Form941DTO dto = (Form941DTO) session.getAttribute("formDTO");
        if (dto == null) {
            dto = new Form941DTO();
            session.setAttribute("formDTO", dto);
        }
        return dto;
    }

    private void extractAllFormParameters(HttpServletRequest request, Form941DTO dto) {
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String name = paramNames.nextElement();
            String val = request.getParameter(name);
            if (val != null) {
                dto.setLineValue(name, val);
            }
        }
        String fId = request.getParameter("form941Id");
        if (fId != null && !fId.trim().isEmpty() && !"0".equals(fId.trim())) {
            try {
                dto.setForm941Id(Long.parseLong(fId.trim()));
            } catch (Exception ignored) {}
        }

        String q = request.getParameter("quarter");
        if (q != null && !q.isEmpty()) {
            try {
                dto.setQuarter(Integer.parseInt(q));
            } catch (Exception ignored) {}
        }
        String empId = request.getParameter("employerId");
        if (empId != null && !empId.isEmpty()) {
            try {
                dto.setEmployerId(Long.parseLong(empId));
            } catch (Exception ignored) {}
        }
    }

    private void copyRequestParamsToDto(HttpServletRequest request, Form941DTO dto, List<String> paramNames) {
        for (String param : paramNames) {
            String val = request.getParameter(param);
            if (val != null) {
                dto.setLineValue(param, val);
            }
        }
    }

    private void populateStep1Dropdowns(Model model, Long userId) {
        List<Employer> empList = employerService.getAllEmployers(userId);
        Map<Long, String> employers = new LinkedHashMap<>();
        for (Employer emp : empList) {
            employers.put(emp.getEmployerId(), emp.getBusinessName() + " (EIN: " + emp.getEin() + ")");
        }
        model.addAttribute("employers", employers);

        List<TaxYear> activeTaxYears = taxYearDao.findAllActive();
        List<Integer> yearList = activeTaxYears.stream().map(TaxYear::getYear).collect(Collectors.toList());
        if (yearList.isEmpty()) {
            yearList = Arrays.asList(2026, 2025, 2024);
        }
        model.addAttribute("taxYears", yearList);

        Map<Integer, String> quarters = new LinkedHashMap<>();
        quarters.put(1, "Q1: January, February, March");
        quarters.put(2, "Q2: April, May, June");
        quarters.put(3, "Q3: July, August, September");
        quarters.put(4, "Q4: October, November, December");
        model.addAttribute("quarters", quarters);
    }
}
