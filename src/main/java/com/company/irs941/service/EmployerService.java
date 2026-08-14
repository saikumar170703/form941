package com.company.irs941.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.irs941.dao.EmployerDao;
import com.company.irs941.model.Employer;
import com.company.irs941.validator.EmployerValidator;

@Service
public class EmployerService {

    @Autowired
    private EmployerDao employerDao;

    @Autowired
    private EmployerValidator employerValidator;

    @Autowired
    private AuditLogService auditLogService;

    public List<Employer> getAllEmployers() {
        return employerDao.findAll();
    }

    public List<Employer> getAllEmployers(Long userId) {
        if (userId == null) return employerDao.findAll();
        return employerDao.findByUserId(userId);
    }

    public List<Employer> searchEmployers(String term) {
        return employerDao.search(term);
    }

    public List<Employer> searchEmployers(String term, Long userId) {
        if (userId == null) return employerDao.search(term);
        return employerDao.searchByUserId(term, userId);
    }

    public Optional<Employer> getEmployerById(Long id) {
        return employerDao.findById(id);
    }

    public Optional<Employer> getEmployerByIdAndUserId(Long id, Long userId) {
        if (userId == null) return employerDao.findById(id);
        return employerDao.findByIdAndUserId(id, userId);
    }

    public Map<String, Object> validateEmployer(Employer emp) {
        return employerValidator.validateEmployer(emp);
    }

    public Employer saveEmployer(Employer emp, Long userId) {
        if (emp.getCreatedBy() == null && userId != null) {
            emp.setCreatedBy(userId);
        }
        boolean isNew = (emp.getEmployerId() == null || emp.getEmployerId() <= 0);
        Employer saved = employerDao.save(emp);
        String action = isNew ? "CREATE_EMPLOYER" : "UPDATE_EMPLOYER";
        auditLogService.log("employers", saved.getEmployerId(), action, userId != null ? userId : 1L, "Employer saved: " + saved.getBusinessName());
        return saved;
    }

    public boolean deleteEmployer(Long id, Long userId) {
        boolean deleted = employerDao.delete(id, userId);
        if (deleted) {
            auditLogService.log("employers", id, "DELETE_EMPLOYER", userId != null ? userId : 1L, "Employer deleted with ID: " + id);
        }
        return deleted;
    }

    public int getEmployersCount() {
        return employerDao.count();
    }

    public int getEmployersCount(Long userId) {
        if (userId == null) return employerDao.count();
        return employerDao.countByUserId(userId);
    }
}
