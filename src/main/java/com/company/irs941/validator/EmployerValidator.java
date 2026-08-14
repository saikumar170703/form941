package com.company.irs941.validator;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import org.springframework.stereotype.Component;

import com.company.irs941.dto.ValidationErrorDTO;
import com.company.irs941.model.Employer;

@Component
public class EmployerValidator {

    private static final Pattern EIN_PATTERN = Pattern.compile("^\\d{2}-\\d{7}$");
    private static final Pattern RAW_EIN_PATTERN = Pattern.compile("^\\d{9}$");
    private static final Pattern ZIP_PATTERN = Pattern.compile("^\\d{5}(-\\d{4})?$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");

    public Map<String, Object> validateEmployer(Employer emp) {
        List<ValidationErrorDTO> errors = new ArrayList<>();
        Map<String, String> fieldErrors = new HashMap<>();

        if (emp == null) {
            errors.add(new ValidationErrorDTO("ALL", "Employer object is null"));
            Map<String, Object> result = new HashMap<>();
            result.put("errors", errors);
            result.put("fieldErrors", fieldErrors);
            return result;
        }

        // EIN
        if (emp.getEin() == null || emp.getEin().trim().isEmpty()) {
            addError("ein", "Employer Identification Number (EIN) is required.", errors, fieldErrors);
        } else {
            String cleanEin = emp.getEin().trim();
            if (RAW_EIN_PATTERN.matcher(cleanEin).matches()) {
                cleanEin = cleanEin.substring(0, 2) + "-" + cleanEin.substring(2);
                emp.setEin(cleanEin);
            }
            if (!EIN_PATTERN.matcher(cleanEin).matches()) {
                addError("ein", "EIN must be a 9-digit number format XX-XXXXXXX (e.g. 12-3456789).", errors, fieldErrors);
            }
        }

        // Legal Business Name
        if (emp.getBusinessName() == null || emp.getBusinessName().trim().isEmpty()) {
            addError("businessName", "Legal Business Name is required.", errors, fieldErrors);
        }

        // Street Address
        if (emp.getAddressLine1() == null || emp.getAddressLine1().trim().isEmpty()) {
            addError("address", "Street Address is required.", errors, fieldErrors);
        }

        // City
        if (emp.getCity() == null || emp.getCity().trim().isEmpty()) {
            addError("city", "City is required.", errors, fieldErrors);
        }

        // State
        if (emp.getState() == null || emp.getState().trim().isEmpty()) {
            addError("state", "US State selection is required.", errors, fieldErrors);
        }

        // ZIP
        if (emp.getZip() == null || emp.getZip().trim().isEmpty()) {
            addError("zip", "ZIP Code is required.", errors, fieldErrors);
        } else if (!ZIP_PATTERN.matcher(emp.getZip().trim()).matches()) {
            addError("zip", "ZIP Code must be 5 digits (e.g. 78701) or ZIP+4 (e.g. 78701-1234).", errors, fieldErrors);
        }

        // Contact Name (Optional fallback)
        if (emp.getContactName() == null || emp.getContactName().trim().isEmpty()) {
            emp.setContactName("Primary Contact");
        }

        // Contact Title (Optional fallback)
        if (emp.getContactTitle() == null || emp.getContactTitle().trim().isEmpty()) {
            emp.setContactTitle("Officer");
        }

        // Phone
        if (emp.getPhone() == null || emp.getPhone().trim().isEmpty()) {
            addError("phone", "Mobile / Phone Number is required.", errors, fieldErrors);
        }

        // Email
        if (emp.getEmail() == null || emp.getEmail().trim().isEmpty()) {
            addError("email", "Email Address is required.", errors, fieldErrors);
        } else if (!EMAIL_PATTERN.matcher(emp.getEmail().trim()).matches()) {
            addError("email", "Email Address must be a valid email format (e.g. contact@domain.com).", errors, fieldErrors);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("errors", errors);
        result.put("fieldErrors", fieldErrors);
        return result;
    }

    private void addError(String field, String msg, List<ValidationErrorDTO> list, Map<String, String> map) {
        list.add(new ValidationErrorDTO(field, msg));
        map.put(field, msg);
    }
}
