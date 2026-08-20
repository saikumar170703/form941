package com.company.irs941.dao;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.company.irs941.dto.Form941DTO;
import com.company.irs941.model.Form941;

@Repository
public class Form941Dao {

    private static final Logger logger = LogManager.getLogger(Form941Dao.class);

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final RowMapper<Form941> FORM941_ROW_MAPPER = new RowMapper<Form941>() {
        @Override
        public Form941 mapRow(ResultSet rs, int rowNum) throws SQLException {
            Form941 f = new Form941();
            f.setForm941Id(rs.getLong("form941_id"));
            f.setEmployerId(rs.getLong("employer_id"));
            f.setTaxYearId(rs.getObject("tax_year_id") != null ? rs.getInt("tax_year_id") : null);
            f.setQuarter(rs.getObject("quarter") != null ? rs.getInt("quarter") : null);
            f.setFilingPeriodStart(rs.getDate("filing_period_start"));
            f.setFilingPeriodEnd(rs.getDate("filing_period_end"));
            f.setStatus(rs.getString("status"));
            f.setCreatedBy(rs.getObject("created_by") != null ? rs.getLong("created_by") : null);
            f.setCreatedAt(rs.getTimestamp("created_at"));
            f.setUpdatedAt(rs.getTimestamp("updated_at"));
            f.setIsAmended(rs.getBoolean("is_amended"));

            try {
                int yr = rs.getInt("year");
                if (!rs.wasNull()) {
                    f.setTaxYear(yr);
                } else if (f.getTaxYearId() != null) {
                    f.setTaxYear(f.getTaxYearId());
                }
            } catch (SQLException ignored) {
                if (f.getTaxYearId() != null) {
                    f.setTaxYear(f.getTaxYearId());
                }
            }

            return f;
        }
    };

    public List<Form941> findAllFilings() {
        try {
            String sql = "SELECT f.*, ty.year FROM form_941 f LEFT JOIN tax_year ty ON f.tax_year_id = ty.tax_year_id ORDER BY f.updated_at DESC";
            List<Form941> list = jdbcTemplate.query(sql, FORM941_ROW_MAPPER);
            for (Form941 f : list) {
                populateLineValuesForForm(f);
            }
            return list;
        } catch (Exception e) {
            System.err.println("Form941Dao findAllFilings exception: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    public List<Form941> findFilingsByUserId(Long userId) {
        try {
            if (userId == null) return Collections.emptyList();
            String sql = "SELECT f.*, ty.year FROM form_941 f LEFT JOIN tax_year ty ON f.tax_year_id = ty.tax_year_id WHERE f.created_by = ? ORDER BY f.updated_at DESC";
            List<Form941> list = jdbcTemplate.query(sql, FORM941_ROW_MAPPER, userId);
            for (Form941 f : list) {
                populateLineValuesForForm(f);
            }
            return list;
        } catch (Exception e) {
            System.err.println("Form941Dao findFilingsByUserId exception: " + e.getMessage());
            return Collections.emptyList();
        }
    }

    public Optional<Form941> findById(Long form941Id) {
        try {
            String sql = "SELECT f.*, ty.year FROM form_941 f LEFT JOIN tax_year ty ON f.tax_year_id = ty.tax_year_id WHERE f.form941_id = ?";
            List<Form941> list = jdbcTemplate.query(sql, FORM941_ROW_MAPPER, form941Id);
            Optional<Form941> opt = list.stream().findFirst();
            opt.ifPresent(this::populateLineValuesForForm);
            return opt;
        } catch (Exception e) {
            System.err.println("Form941Dao findById exception: " + e.getMessage());
            return Optional.empty();
        }
    }

    public Form941DTO findDtoById(Long form941Id) {
        try {
            Optional<Form941> opt = findById(form941Id);
            if (!opt.isPresent()) return null;
            Form941 f = opt.get();
            Form941DTO dto = new Form941DTO();
            dto.setForm941Id(f.getForm941Id());
            dto.setEmployerId(f.getEmployerId());
            dto.setTaxYear(f.getTaxYear() != null ? f.getTaxYear() : (f.getTaxYearId() != null ? f.getTaxYearId() : 2026));
            dto.setQuarter(f.getQuarter());
            dto.setStatus(f.getStatus());
            populateLineValuesFromDetail(dto, f.getForm941Id());
            return dto;
        } catch (Exception e) {
            System.err.println("Form941Dao findDtoById exception: " + e.getMessage());
            return null;
        }
    }

    public Form941DTO findDtoByIdAndUserId(Long form941Id, Long userId) {
        try {
            if (userId == null || form941Id == null) return null;
            String sql = "SELECT f.*, ty.year FROM form_941 f LEFT JOIN tax_year ty ON f.tax_year_id = ty.tax_year_id WHERE f.form941_id = ? AND f.created_by = ?";
            List<Form941> list = jdbcTemplate.query(sql, FORM941_ROW_MAPPER, form941Id, userId);
            Optional<Form941> opt = list.stream().findFirst();
            if (!opt.isPresent()) return null;
            Form941 f = opt.get();

            Form941DTO dto = new Form941DTO();
            dto.setForm941Id(f.getForm941Id());
            dto.setEmployerId(f.getEmployerId());
            dto.setTaxYear(f.getTaxYear() != null ? f.getTaxYear() : (f.getTaxYearId() != null ? f.getTaxYearId() : 2026));
            dto.setQuarter(f.getQuarter());
            dto.setStatus(f.getStatus());
            populateLineValuesFromDetail(dto, f.getForm941Id());
            return dto;
        } catch (Exception e) {
            System.err.println("Form941Dao findDtoByIdAndUserId exception: " + e.getMessage());
            return null;
        }
    }

    public Long saveForm941(Form941DTO dto, Long userId) {
        try {
            Long formId = dto.getForm941Id();

            Long empId = dto.getEmployerId();
            if (empId == null || empId <= 0) {
                List<Long> empIds = jdbcTemplate.query("SELECT employer_id FROM employers WHERE created_by = ? LIMIT 1", (rs, r) -> rs.getLong(1), userId);
                if (empIds.isEmpty()) {
                    empIds = jdbcTemplate.query("SELECT employer_id FROM employers LIMIT 1", (rs, r) -> rs.getLong(1));
                }
                empId = !empIds.isEmpty() ? empIds.get(0) : 1L;
                dto.setEmployerId(empId);
            }

            int yr = dto.getTaxYear() != null ? dto.getTaxYear() : 2026;
            int qtr = dto.getQuarter() != null ? dto.getQuarter() : 1;

            Date startDate = calculatePeriodStart(yr, qtr);
            Date endDate = calculatePeriodEnd(yr, qtr);

            if (formId == null || formId <= 0) {
                String sql = "INSERT INTO form_941 (employer_id, tax_year_id, quarter, filing_period_start, filing_period_end, status, created_by, created_at, updated_at) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING form941_id";
                formId = jdbcTemplate.queryForObject(sql, Long.class,
                        empId, yr, qtr, startDate, endDate,
                        dto.getStatus() != null ? dto.getStatus() : "DRAFT",
                        userId != null ? userId : 1L);
                dto.setForm941Id(formId);
            } else {
                String sql = "UPDATE form_941 SET employer_id = ?, tax_year_id = ?, quarter = ?, filing_period_start = ?, filing_period_end = ?, status = ?, updated_at = CURRENT_TIMESTAMP WHERE form941_id = ?";
                jdbcTemplate.update(sql, empId, yr, qtr, startDate, endDate, dto.getStatus(), formId);
            }

            // form_941_line table removed; all data goes to form_941_detail
            saveDetail(formId, dto);
            saveScheduleB(formId, dto);
            saveTaxLiabilityBreakdown(formId, dto);

            return formId;
        } catch (Exception e) {
            System.err.println("Form941Dao saveForm941 exception: " + e.getMessage());
            e.printStackTrace();
            return dto.getForm941Id() != null ? dto.getForm941Id() : 1L;
        }
    }

    private void populateLineValuesForForm(Form941 f) {
        if (f == null || f.getForm941Id() == null) return;
        try {
            String sql = "SELECT * FROM form_941_detail WHERE form941_id = ?";
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, f.getForm941Id());
            if (!rows.isEmpty()) {
                Map<String, Object> r = rows.get(0);
                setLineFromRow(f, r, "line1_num_employees", "1");
                setLineFromRow(f, r, "line2_wages_tips_compensation", "2");
                setLineFromRow(f, r, "line3_fed_income_tax_withheld", "3");
                setLineFromRow(f, r, "line4_no_wages_subject_ss_med", "4");
                setLineFromRow(f, r, "line5a_taxable_ss_wages", "5a_wages");
                setLineFromRow(f, r, "line5a_ss_wages_tax", "5a_tax");
                setLineFromRow(f, r, "line5b_taxable_ss_tips", "5b_tips");
                setLineFromRow(f, r, "line5b_ss_tips_tax", "5b_tax");
                setLineFromRow(f, r, "line5c_taxable_med_wages", "5c_wages");
                setLineFromRow(f, r, "line5c_med_wages_tax", "5c_tax");
                setLineFromRow(f, r, "line5d_addl_med_wages", "5d_wages");
                setLineFromRow(f, r, "line5d_addl_med_tax", "5d_tax");
                setLineFromRow(f, r, "line5e_total_ss_med_tax", "5e");
                setLineFromRow(f, r, "line5f_sec_3121q_tax", "5f");
                setLineFromRow(f, r, "line6_total_tax_before_adj", "6");
                setLineFromRow(f, r, "line7_cents_adj", "7");
                setLineFromRow(f, r, "line8_sick_pay_adj", "8");
                setLineFromRow(f, r, "line9_tips_life_insurance_adj", "9");
                setLineFromRow(f, r, "line10_total_tax_after_adj", "10");
                setLineFromRow(f, r, "line11_payroll_tax_credit", "11");
                setLineFromRow(f, r, "line12_total_tax_after_credits", "12");
                setLineFromRow(f, r, "line13_total_deposits", "13");
                setLineFromRow(f, r, "line14_balance_due", "14");
                setLineFromRow(f, r, "line15a_overpayment", "15a");
                setLineFromRow(f, r, "line15b_overpayment_choice", "15b");
                setLineFromRow(f, r, "line15c_routing_number", "15c");
                setLineFromRow(f, r, "line15d_account_type", "15d");
                setLineFromRow(f, r, "line15e_account_number", "15e");

                // Lines 16-19
                setLineFromRow(f, r, "line16_deposit_schedule", "16");
                setLineFromRow(f, r, "line17_business_closed", "line17");
                setLineFromRow(f, r, "line17_final_wages_date", "17_date");
                setLineFromRow(f, r, "line17_final_wages_date", "finalDateWages");
                setLineFromRow(f, r, "line18_seasonal_employer", "line18");
                setLineFromRow(f, r, "line19_payroll_tax_credit", "19");

                // Part 4 Third-Party Designee
                setLineFromRow(f, r, "part4_designee_choice", "designeeChoice");
                setLineFromRow(f, r, "part4_designee_name", "designeeName");
                setLineFromRow(f, r, "part4_designee_phone", "designeePhone");
                setLineFromRow(f, r, "part4_designee_pin", "designeePin");

                // Part 5 Signatures & Paid Preparer
                setLineFromRow(f, r, "part5_signature_name", "signatureName");
                setLineFromRow(f, r, "part5_signature_title", "signatureTitle");
                setLineFromRow(f, r, "part5_signature_date", "signatureDate");
                setLineFromRow(f, r, "part5_signature_phone", "signaturePhone");
                setLineFromRow(f, r, "part5_paid_preparer_used", "paidPreparerCheck");
                setLineFromRow(f, r, "part5_preparer_self_employed", "preparerSelfEmployed");
                setLineFromRow(f, r, "part5_preparer_name", "preparerName");
                setLineFromRow(f, r, "part5_preparer_ptin", "preparerPtin");
                setLineFromRow(f, r, "part5_preparer_signature", "preparerSignature");
                setLineFromRow(f, r, "part5_preparer_date", "preparerDate");
                setLineFromRow(f, r, "part5_preparer_firm_name", "preparerFirmName");
                setLineFromRow(f, r, "part5_preparer_ein", "preparerEin");
                setLineFromRow(f, r, "part5_preparer_address", "preparerAddress");
                setLineFromRow(f, r, "part5_preparer_phone", "preparerPhone");
                setLineFromRow(f, r, "part5_preparer_city", "preparerCity");
                setLineFromRow(f, r, "part5_preparer_state", "preparerState");
                setLineFromRow(f, r, "part5_preparer_zip", "preparerZip");
            }
            // Load Schedule B summary
            String sbSql = "SELECT * FROM form_941_schedule_b WHERE form941_id = ?";
            List<Map<String, Object>> sbRows = jdbcTemplate.queryForList(sbSql, f.getForm941Id());
            if (!sbRows.isEmpty()) {
                Map<String, Object> sb = sbRows.get(0);
                setLineFromRow(f, sb, "month1_tax_liability", "16_m1");
                setLineFromRow(f, sb, "month1_tax_liability", "sb_m1_total");
                setLineFromRow(f, sb, "month2_tax_liability", "16_m2");
                setLineFromRow(f, sb, "month2_tax_liability", "sb_m2_total");
                setLineFromRow(f, sb, "month3_tax_liability", "16_m3");
                setLineFromRow(f, sb, "month3_tax_liability", "sb_m3_total");
                setLineFromRow(f, sb, "total_quarter_liability", "16_total");
                setLineFromRow(f, sb, "total_quarter_liability", "sb_quarter_total");
            }
            // Load Schedule B daily details
            String sbDetailSql = "SELECT * FROM form_941_schedule_b_detail WHERE form941_id = ?";
            List<Map<String, Object>> sbDetailRows = jdbcTemplate.queryForList(sbDetailSql, f.getForm941Id());
            for (Map<String, Object> r : sbDetailRows) {
                Object mObj = r.get("month_number");
                Object dObj = r.get("day_number");
                Object amtObj = r.get("amount");
                if (mObj != null && dObj != null && amtObj != null) {
                    String key = "sb_m" + mObj.toString() + "_d" + dObj.toString();
                    f.setLineValue(key, amtObj.toString());
                }
            }
        } catch (Exception e) {
            System.err.println("populateLineValuesForForm exception: " + e.getMessage());
        }
    }

    private void populateLineValuesFromDetail(Form941DTO dto, Long formId) {
        try {
            String sql = "SELECT * FROM form_941_detail WHERE form941_id = ?";
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, formId);
            if (!rows.isEmpty()) {
                Map<String, Object> r = rows.get(0);
                setDtoLineFromRow(dto, r, "line1_num_employees", "1");
                setDtoLineFromRow(dto, r, "line2_wages_tips_compensation", "2");
                setDtoLineFromRow(dto, r, "line3_fed_income_tax_withheld", "3");
                setDtoLineFromRow(dto, r, "line4_no_wages_subject_ss_med", "4");
                setDtoLineFromRow(dto, r, "line5a_taxable_ss_wages", "5a_wages");
                setDtoLineFromRow(dto, r, "line5a_ss_wages_tax", "5a_tax");
                setDtoLineFromRow(dto, r, "line5b_taxable_ss_tips", "5b_tips");
                setDtoLineFromRow(dto, r, "line5b_ss_tips_tax", "5b_tax");
                setDtoLineFromRow(dto, r, "line5c_taxable_med_wages", "5c_wages");
                setDtoLineFromRow(dto, r, "line5c_med_wages_tax", "5c_tax");
                setDtoLineFromRow(dto, r, "line5d_addl_med_wages", "5d_wages");
                setDtoLineFromRow(dto, r, "line5d_addl_med_tax", "5d_tax");
                setDtoLineFromRow(dto, r, "line5e_total_ss_med_tax", "5e");
                setDtoLineFromRow(dto, r, "line5f_sec_3121q_tax", "5f");
                setDtoLineFromRow(dto, r, "line6_total_tax_before_adj", "6");
                setDtoLineFromRow(dto, r, "line7_cents_adj", "7");
                setDtoLineFromRow(dto, r, "line8_sick_pay_adj", "8");
                setDtoLineFromRow(dto, r, "line9_tips_life_insurance_adj", "9");
                setDtoLineFromRow(dto, r, "line10_total_tax_after_adj", "10");
                setDtoLineFromRow(dto, r, "line11_payroll_tax_credit", "11");
                setDtoLineFromRow(dto, r, "line12_total_tax_after_credits", "12");
                setDtoLineFromRow(dto, r, "line13_total_deposits", "13");
                setDtoLineFromRow(dto, r, "line14_balance_due", "14");
                setDtoLineFromRow(dto, r, "line15a_overpayment", "15a");
                setDtoLineFromRow(dto, r, "line15b_overpayment_choice", "15b");
                setDtoLineFromRow(dto, r, "line15c_routing_number", "15c");
                setDtoLineFromRow(dto, r, "line15d_account_type", "15d");
                setDtoLineFromRow(dto, r, "line15e_account_number", "15e");

                // Lines 16-19
                setDtoLineFromRow(dto, r, "line16_deposit_schedule", "16");
                setDtoLineFromRow(dto, r, "line17_business_closed", "line17");
                setDtoLineFromRow(dto, r, "line17_final_wages_date", "17_date");
                setDtoLineFromRow(dto, r, "line17_final_wages_date", "finalDateWages");
                setDtoLineFromRow(dto, r, "line18_seasonal_employer", "line18");
                setDtoLineFromRow(dto, r, "line19_payroll_tax_credit", "19");

                // Part 4 Third-Party Designee
                setDtoLineFromRow(dto, r, "part4_designee_choice", "designeeChoice");
                setDtoLineFromRow(dto, r, "part4_designee_name", "designeeName");
                setDtoLineFromRow(dto, r, "part4_designee_phone", "designeePhone");
                setDtoLineFromRow(dto, r, "part4_designee_pin", "designeePin");

                // Part 5 Signatures & Paid Preparer
                setDtoLineFromRow(dto, r, "part5_signature_name", "signatureName");
                setDtoLineFromRow(dto, r, "part5_signature_title", "signatureTitle");
                setDtoLineFromRow(dto, r, "part5_signature_date", "signatureDate");
                setDtoLineFromRow(dto, r, "part5_signature_phone", "signaturePhone");
                setDtoLineFromRow(dto, r, "part5_paid_preparer_used", "paidPreparerCheck");
                setDtoLineFromRow(dto, r, "part5_preparer_self_employed", "preparerSelfEmployed");
                setDtoLineFromRow(dto, r, "part5_preparer_name", "preparerName");
                setDtoLineFromRow(dto, r, "part5_preparer_ptin", "preparerPtin");
                setDtoLineFromRow(dto, r, "part5_preparer_signature", "preparerSignature");
                setDtoLineFromRow(dto, r, "part5_preparer_date", "preparerDate");
                setDtoLineFromRow(dto, r, "part5_preparer_firm_name", "preparerFirmName");
                setDtoLineFromRow(dto, r, "part5_preparer_ein", "preparerEin");
                setDtoLineFromRow(dto, r, "part5_preparer_address", "preparerAddress");
                setDtoLineFromRow(dto, r, "part5_preparer_phone", "preparerPhone");
                setDtoLineFromRow(dto, r, "part5_preparer_city", "preparerCity");
                setDtoLineFromRow(dto, r, "part5_preparer_state", "preparerState");
                setDtoLineFromRow(dto, r, "part5_preparer_zip", "preparerZip");
            }
            // Also load schedule B summary data
            String sbSql = "SELECT * FROM form_941_schedule_b WHERE form941_id = ?";
            List<Map<String, Object>> sbRows = jdbcTemplate.queryForList(sbSql, formId);
            if (!sbRows.isEmpty()) {
                Map<String, Object> sb = sbRows.get(0);
                setDtoLineFromRow(dto, sb, "month1_tax_liability", "16_m1");
                setDtoLineFromRow(dto, sb, "month1_tax_liability", "sb_m1_total");
                setDtoLineFromRow(dto, sb, "month2_tax_liability", "16_m2");
                setDtoLineFromRow(dto, sb, "month2_tax_liability", "sb_m2_total");
                setDtoLineFromRow(dto, sb, "month3_tax_liability", "16_m3");
                setDtoLineFromRow(dto, sb, "month3_tax_liability", "sb_m3_total");
                setDtoLineFromRow(dto, sb, "total_quarter_liability", "16_total");
                setDtoLineFromRow(dto, sb, "total_quarter_liability", "sb_quarter_total");
            }
            // Load Schedule B daily details
            String sbDetailSql = "SELECT * FROM form_941_schedule_b_detail WHERE form941_id = ?";
            List<Map<String, Object>> sbDetailRows = jdbcTemplate.queryForList(sbDetailSql, formId);
            for (Map<String, Object> r : sbDetailRows) {
                Object mObj = r.get("month_number");
                Object dObj = r.get("day_number");
                Object amtObj = r.get("amount");
                if (mObj != null && dObj != null && amtObj != null) {
                    String key = "sb_m" + mObj.toString() + "_d" + dObj.toString();
                    dto.setLineValue(key, amtObj.toString());
                }
            }
        } catch (Exception e) {
            System.err.println("populateLineValuesFromDetail exception: " + e.getMessage());
        }
    }

    private void setLineFromRow(Form941 f, Map<String, Object> row, String colName, String lineKey) {
        Object val = row.get(colName);
        if (val != null) {
            String strVal;
            if (val instanceof Date) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/dd/yyyy");
                strVal = sdf.format((Date) val);
            } else if (val instanceof java.util.Date) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/dd/yyyy");
                strVal = sdf.format((java.util.Date) val);
            } else {
                strVal = val.toString();
            }
            f.setLineValue(lineKey, strVal);
        }
    }

    private void setDtoLineFromRow(Form941DTO dto, Map<String, Object> row, String colName, String lineKey) {
        Object val = row.get(colName);
        if (val != null) {
            String strVal;
            if (val instanceof Date) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/dd/yyyy");
                strVal = sdf.format((Date) val);
            } else if (val instanceof java.util.Date) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/dd/yyyy");
                strVal = sdf.format((java.util.Date) val);
            } else {
                strVal = val.toString();
            }
            dto.setLineValue(lineKey, strVal);
        }
    }

    private boolean parseBool(String val) {
        if (val == null) return false;
        String clean = val.trim().toLowerCase();
        return "true".equals(clean) || "yes".equals(clean) || "1".equals(clean) || "on".equals(clean);
    }

    private Date parseDate(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        String clean = val.trim();

        // 1. Try ISO YYYY-MM-DD
        try {
            return Date.valueOf(clean);
        } catch (Exception ignored) {}

        // 2. Try MM/dd/yyyy or M/d/yyyy
        try {
            java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("M/d/yyyy");
            java.time.LocalDate ld = java.time.LocalDate.parse(clean, dtf);
            return Date.valueOf(ld);
        } catch (Exception ignored) {}

        // 3. Try MM-dd-yyyy or M-d-yyyy
        try {
            java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("M-d-yyyy");
            java.time.LocalDate ld = java.time.LocalDate.parse(clean, dtf);
            return Date.valueOf(ld);
        } catch (Exception ignored) {}

        // 4. Try yyyy/M/d
        try {
            java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("yyyy/M/d");
            java.time.LocalDate ld = java.time.LocalDate.parse(clean, dtf);
            return Date.valueOf(ld);
        } catch (Exception ignored) {}

        return null;
    }

    private void saveDetail(Long formId, Form941DTO dto) {
        try {
            int l1 = parseInt(dto.getLineValue("1"));
            BigDecimal l2 = parseDecimal(dto.getLineValue("2"));
            BigDecimal l3 = parseDecimal(dto.getLineValue("3"));
            boolean l4 = parseBool(dto.getLineValue("4"));
            BigDecimal l5aWages = parseDecimal(dto.getLineValue("5a_wages"));
            BigDecimal l5aTax = parseDecimal(dto.getLineValue("5a_tax"));
            BigDecimal l5bTips = parseDecimal(dto.getLineValue("5b_tips"));
            BigDecimal l5bTax = parseDecimal(dto.getLineValue("5b_tax"));
            BigDecimal l5cWages = parseDecimal(dto.getLineValue("5c_wages"));
            BigDecimal l5cTax = parseDecimal(dto.getLineValue("5c_tax"));
            BigDecimal l5dWages = parseDecimal(dto.getLineValue("5d_wages"));
            BigDecimal l5dTax = parseDecimal(dto.getLineValue("5d_tax"));
            BigDecimal l5e = parseDecimal(dto.getLineValue("5e"));
            BigDecimal l5f = parseDecimal(dto.getLineValue("5f"));
            BigDecimal l6 = parseDecimal(dto.getLineValue("6"));
            BigDecimal l7 = parseDecimal(dto.getLineValue("7"));
            BigDecimal l8 = parseDecimal(dto.getLineValue("8"));
            BigDecimal l9 = parseDecimal(dto.getLineValue("9"));
            BigDecimal l10 = parseDecimal(dto.getLineValue("10"));
            BigDecimal l11 = parseDecimal(dto.getLineValue("11"));
            BigDecimal l12 = parseDecimal(dto.getLineValue("12"));
            BigDecimal l13 = parseDecimal(dto.getLineValue("13"));
            BigDecimal l14 = parseDecimal(dto.getLineValue("14"));
            BigDecimal l15a = parseDecimal(dto.getLineValue("15a"));
            if (l15a.compareTo(BigDecimal.ZERO) == 0 && dto.getLineValue("15") != null) {
                l15a = parseDecimal(dto.getLineValue("15"));
            }
            String l15b = dto.getLineValue("15b");
            String l15c = dto.getLineValue("15c");
            String l15d = dto.getLineValue("15d");
            String l15e = dto.getLineValue("15e");

            // Lines 16-19
            String l16 = dto.getLineValue("16");
            boolean l17 = parseBool(dto.getLineValue("line17")) || parseBool(dto.getLineValue("17"));
            
            String d17Str = dto.getLineValue("17_date");
            if (d17Str == null || d17Str.trim().isEmpty()) {
                d17Str = dto.getLineValue("finalDateWages");
            }
            if (d17Str == null || d17Str.trim().isEmpty()) {
                d17Str = dto.getLineValue("line17Date");
            }
            Date l17Date = parseDate(d17Str);

            boolean l18 = parseBool(dto.getLineValue("line18")) || parseBool(dto.getLineValue("18"));
            BigDecimal l19 = parseDecimal(dto.getLineValue("19") != null ? dto.getLineValue("19") : dto.getLineValue("line19"));

            // Part 4 Third-Party Designee
            String p4Choice = dto.getLineValue("designeeChoice");
            String p4Name = dto.getLineValue("designeeName");
            String p4Phone = dto.getLineValue("designeePhone");
            String p4Pin = dto.getLineValue("designeePin");

            // Part 5 Signatures & Paid Preparer
            String p5SigName = dto.getLineValue("signatureName");
            String p5SigTitle = dto.getLineValue("signatureTitle");
            Date p5SigDate = parseDate(dto.getLineValue("signatureDate"));
            String p5SigPhone = dto.getLineValue("signaturePhone");

            boolean p5PrepUsed = parseBool(dto.getLineValue("paidPreparerCheck")) || parseBool(dto.getLineValue("preparerCheck"));
            boolean p5PrepSelfEmployed = parseBool(dto.getLineValue("preparerSelfEmployed"));
            String p5PrepName = dto.getLineValue("preparerName");
            String p5PrepPtin = dto.getLineValue("preparerPtin");
            String p5PrepSignature = dto.getLineValue("preparerSignature");
            Date p5PrepDate = parseDate(dto.getLineValue("preparerDate"));
            String p5PrepFirmName = dto.getLineValue("preparerFirmName");
            String p5PrepEin = dto.getLineValue("preparerEin");
            String p5PrepAddress = dto.getLineValue("preparerAddress");
            String p5PrepPhone = dto.getLineValue("preparerPhone");
            String p5PrepCity = dto.getLineValue("preparerCity");
            String p5PrepState = dto.getLineValue("preparerState");
            String p5PrepZip = dto.getLineValue("preparerZip");

            String checkSql = "SELECT COUNT(*) FROM form_941_detail WHERE form941_id = ?";
            Integer count = jdbcTemplate.queryForObject(checkSql, Integer.class, formId);

            if (count != null && count > 0) {
                String sql = "UPDATE form_941_detail SET " +
                             "line1_num_employees = ?, line2_wages_tips_compensation = ?, line3_fed_income_tax_withheld = ?, line4_no_wages_subject_ss_med = ?, " +
                             "line5a_taxable_ss_wages = ?, line5a_ss_wages_tax = ?, line5b_taxable_ss_tips = ?, line5b_ss_tips_tax = ?, " +
                             "line5c_taxable_med_wages = ?, line5c_med_wages_tax = ?, line5d_addl_med_wages = ?, line5d_addl_med_tax = ?, " +
                             "line5e_total_ss_med_tax = ?, line5f_sec_3121q_tax = ?, line6_total_tax_before_adj = ?, " +
                             "line7_cents_adj = ?, line8_sick_pay_adj = ?, line9_tips_life_insurance_adj = ?, " +
                             "line10_total_tax_after_adj = ?, line11_payroll_tax_credit = ?, line12_total_tax_after_credits = ?, " +
                             "line13_total_deposits = ?, line14_balance_due = ?, line15a_overpayment = ?, " +
                             "line15b_overpayment_choice = ?, line15c_routing_number = ?, line15d_account_type = ?, line15e_account_number = ?, " +
                             "line16_deposit_schedule = ?, line17_business_closed = ?, line17_final_wages_date = ?, line18_seasonal_employer = ?, line19_payroll_tax_credit = ?, " +
                             "part4_designee_choice = ?, part4_designee_name = ?, part4_designee_phone = ?, part4_designee_pin = ?, " +
                             "part5_signature_name = ?, part5_signature_title = ?, part5_signature_date = ?, part5_signature_phone = ?, " +
                             "part5_paid_preparer_used = ?, part5_preparer_self_employed = ?, part5_preparer_name = ?, part5_preparer_ptin = ?, " +
                             "part5_preparer_signature = ?, part5_preparer_date = ?, part5_preparer_firm_name = ?, part5_preparer_ein = ?, " +
                             "part5_preparer_address = ?, part5_preparer_phone = ?, part5_preparer_city = ?, part5_preparer_state = ?, part5_preparer_zip = ?, " +
                             "updated_at = CURRENT_TIMESTAMP WHERE form941_id = ?";
                jdbcTemplate.update(sql, l1, l2, l3, l4, l5aWages, l5aTax, l5bTips, l5bTax, l5cWages, l5cTax, l5dWages, l5dTax,
                        l5e, l5f, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15a, l15b, l15c, l15d, l15e,
                        l16, l17, l17Date, l18, l19,
                        p4Choice, p4Name, p4Phone, p4Pin,
                        p5SigName, p5SigTitle, p5SigDate, p5SigPhone,
                        p5PrepUsed, p5PrepSelfEmployed, p5PrepName, p5PrepPtin,
                        p5PrepSignature, p5PrepDate, p5PrepFirmName, p5PrepEin,
                        p5PrepAddress, p5PrepPhone, p5PrepCity, p5PrepState, p5PrepZip, formId);
            } else {
                String sql = "INSERT INTO form_941_detail (form941_id, line1_num_employees, line2_wages_tips_compensation, line3_fed_income_tax_withheld, line4_no_wages_subject_ss_med, " +
                             "line5a_taxable_ss_wages, line5a_ss_wages_tax, line5b_taxable_ss_tips, line5b_ss_tips_tax, line5c_taxable_med_wages, line5c_med_wages_tax, line5d_addl_med_wages, line5d_addl_med_tax, " +
                             "line5e_total_ss_med_tax, line5f_sec_3121q_tax, line6_total_tax_before_adj, line7_cents_adj, line8_sick_pay_adj, line9_tips_life_insurance_adj, " +
                             "line10_total_tax_after_adj, line11_payroll_tax_credit, line12_total_tax_after_credits, line13_total_deposits, line14_balance_due, line15a_overpayment, " +
                             "line15b_overpayment_choice, line15c_routing_number, line15d_account_type, line15e_account_number, " +
                             "line16_deposit_schedule, line17_business_closed, line17_final_wages_date, line18_seasonal_employer, line19_payroll_tax_credit, " +
                             "part4_designee_choice, part4_designee_name, part4_designee_phone, part4_designee_pin, " +
                             "part5_signature_name, part5_signature_title, part5_signature_date, part5_signature_phone, " +
                             "part5_paid_preparer_used, part5_preparer_self_employed, part5_preparer_name, part5_preparer_ptin, " +
                             "part5_preparer_signature, part5_preparer_date, part5_preparer_firm_name, part5_preparer_ein, " +
                             "part5_preparer_address, part5_preparer_phone, part5_preparer_city, part5_preparer_state, part5_preparer_zip) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                jdbcTemplate.update(sql, formId, l1, l2, l3, l4, l5aWages, l5aTax, l5bTips, l5bTax, l5cWages, l5cTax, l5dWages, l5dTax,
                        l5e, l5f, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15a, l15b, l15c, l15d, l15e,
                        l16, l17, l17Date, l18, l19,
                        p4Choice, p4Name, p4Phone, p4Pin,
                        p5SigName, p5SigTitle, p5SigDate, p5SigPhone,
                        p5PrepUsed, p5PrepSelfEmployed, p5PrepName, p5PrepPtin,
                        p5PrepSignature, p5PrepDate, p5PrepFirmName, p5PrepEin,
                        p5PrepAddress, p5PrepPhone, p5PrepCity, p5PrepState, p5PrepZip);
            }
        } catch (Exception e) {
            System.err.println("saveDetail exception: " + e.getMessage());
        }
    }

    private void saveScheduleB(Long formId, Form941DTO dto) {
        try {
            BigDecimal m1Sum = BigDecimal.ZERO;
            BigDecimal m2Sum = BigDecimal.ZERO;
            BigDecimal m3Sum = BigDecimal.ZERO;

            for (int d = 1; d <= 31; d++) {
                m1Sum = m1Sum.add(parseDecimal(dto.getLineValue("sb_m1_d" + d)));
                m2Sum = m2Sum.add(parseDecimal(dto.getLineValue("sb_m2_d" + d)));
                m3Sum = m3Sum.add(parseDecimal(dto.getLineValue("sb_m3_d" + d)));
            }

            BigDecimal m1 = m1Sum.compareTo(BigDecimal.ZERO) != 0 ? m1Sum : parseDecimal(dto.getLineValue("16_m1") != null ? dto.getLineValue("16_m1") : dto.getLineValue("sb_m1_total"));
            BigDecimal m2 = m2Sum.compareTo(BigDecimal.ZERO) != 0 ? m2Sum : parseDecimal(dto.getLineValue("16_m2") != null ? dto.getLineValue("16_m2") : dto.getLineValue("sb_m2_total"));
            BigDecimal m3 = m3Sum.compareTo(BigDecimal.ZERO) != 0 ? m3Sum : parseDecimal(dto.getLineValue("16_m3") != null ? dto.getLineValue("16_m3") : dto.getLineValue("sb_m3_total"));
            BigDecimal total = m1.add(m2).add(m3);

            dto.setLineValue("16_m1", m1.toString());
            dto.setLineValue("sb_m1_total", m1.toString());
            dto.setLineValue("16_m2", m2.toString());
            dto.setLineValue("sb_m2_total", m2.toString());
            dto.setLineValue("16_m3", m3.toString());
            dto.setLineValue("sb_m3_total", m3.toString());
            dto.setLineValue("16_total", total.toString());
            dto.setLineValue("sb_quarter_total", total.toString());

            String checkSql = "SELECT COUNT(*) FROM form_941_schedule_b WHERE form941_id = ?";
            Integer count = jdbcTemplate.queryForObject(checkSql, Integer.class, formId);

            if (count != null && count > 0) {
                String sql = "UPDATE form_941_schedule_b SET month1_tax_liability = ?, month2_tax_liability = ?, month3_tax_liability = ?, total_quarter_liability = ? WHERE form941_id = ?";
                jdbcTemplate.update(sql, m1, m2, m3, total, formId);
            } else {
                String sql = "INSERT INTO form_941_schedule_b (form941_id, month1_tax_liability, month2_tax_liability, month3_tax_liability, total_quarter_liability) VALUES (?, ?, ?, ?, ?)";
                jdbcTemplate.update(sql, formId, m1, m2, m3, total);
            }

            saveScheduleBDetail(formId, dto);
        } catch (Exception e) {
            System.err.println("saveScheduleB exception: " + e.getMessage());
        }
    }

    private void saveScheduleBDetail(Long formId, Form941DTO dto) {
        try {
            Integer yr = dto.getTaxYear() != null ? dto.getTaxYear() : 2026;
            Integer qtr = dto.getQuarter() != null ? dto.getQuarter() : 1;

            String deleteSql = "DELETE FROM form_941_schedule_b_detail WHERE form941_id = ?";
            jdbcTemplate.update(deleteSql, formId);

            String insertSql = "INSERT INTO form_941_schedule_b_detail (form941_id, month_number, day_number, deposit_date, amount, created_at, updated_at) " +
                               "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

            for (int m = 1; m <= 3; m++) {
                for (int d = 1; d <= 31; d++) {
                    String key = "sb_m" + m + "_d" + d;
                    String val = dto.getLineValue(key);
                    if (val != null && !val.trim().isEmpty()) {
                        BigDecimal amt = parseDecimal(val);
                        if (amt.compareTo(BigDecimal.ZERO) != 0) {
                            Date depositDate = calculateDepositDate(yr, qtr, m, d);
                            jdbcTemplate.update(insertSql, formId, m, d, depositDate, amt);
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("saveScheduleBDetail exception: " + e.getMessage());
        }
    }

    private Date calculateDepositDate(Integer taxYear, Integer quarter, int monthNumber, int dayNumber) {
        if (taxYear == null) taxYear = 2026;
        if (quarter == null) quarter = 1;
        int startMonth = (quarter - 1) * 3 + 1;
        int actualMonth = startMonth + (monthNumber - 1);
        try {
            java.time.LocalDate ld = java.time.LocalDate.of(taxYear, actualMonth, dayNumber);
            return Date.valueOf(ld);
        } catch (Exception e) {
            return null;
        }
    }

    private void saveTaxLiabilityBreakdown(Long formId, Form941DTO dto) {
        try {
            String checkSql = "SELECT COUNT(*) FROM form_941_tax_liability_breakdown WHERE form941_id = ?";
            Integer count = jdbcTemplate.queryForObject(checkSql, Integer.class, formId);

            BigDecimal ssWages = parseDecimal(dto.getLineValue("5a_wages"));
            BigDecimal ssTax = parseDecimal(dto.getLineValue("5a_tax"));
            BigDecimal medWages = parseDecimal(dto.getLineValue("5c_wages"));
            BigDecimal medTax = parseDecimal(dto.getLineValue("5c_tax"));
            BigDecimal addlMedWages = parseDecimal(dto.getLineValue("5d_wages"));
            BigDecimal addlMedTax = parseDecimal(dto.getLineValue("5d_tax"));

            if (count != null && count > 0) {
                String sql = "UPDATE form_941_tax_liability_breakdown SET ss_wages = ?, ss_tax = ?, med_wages = ?, med_tax = ?, addl_med_wages = ?, addl_med_tax = ? WHERE form941_id = ?";
                jdbcTemplate.update(sql, ssWages, ssTax, medWages, medTax, addlMedWages, addlMedTax, formId);
            } else {
                String sql = "INSERT INTO form_941_tax_liability_breakdown (form941_id, ss_wages, ss_tax, med_wages, med_tax, addl_med_wages, addl_med_tax) VALUES (?, ?, ?, ?, ?, ?, ?)";
                jdbcTemplate.update(sql, formId, ssWages, ssTax, medWages, medTax, addlMedWages, addlMedTax);
            }
        } catch (Exception e) {
            System.err.println("saveTaxLiabilityBreakdown exception: " + e.getMessage());
        }
    }

    private BigDecimal parseDecimal(String val) {
        if (val == null || val.trim().isEmpty()) return BigDecimal.ZERO;
        try {
            String clean = val.replace(",", "").replace("$", "").trim();
            return new BigDecimal(clean);
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private int parseInt(String val) {
        if (val == null || val.trim().isEmpty()) return 0;
        try {
            return Integer.parseInt(val.trim());
        } catch (Exception e) {
            return 0;
        }
    }

    public static Date calculatePeriodStart(int year, int quarter) {
        switch (quarter) {
            case 1: return Date.valueOf(year + "-01-01");
            case 2: return Date.valueOf(year + "-04-01");
            case 3: return Date.valueOf(year + "-07-01");
            case 4: return Date.valueOf(year + "-10-01");
            default: return Date.valueOf(year + "-01-01");
        }
    }

    public static Date calculatePeriodEnd(int year, int quarter) {
        switch (quarter) {
            case 1: return Date.valueOf(year + "-03-31");
            case 2: return Date.valueOf(year + "-06-30");
            case 3: return Date.valueOf(year + "-09-30");
            case 4: return Date.valueOf(year + "-12-31");
            default: return Date.valueOf(year + "-03-31");
        }
    }

    public int countByUserId(Long userId) {
        try {
            String sql = "SELECT COUNT(*) FROM form_941 WHERE created_by = ?";
            Integer c = jdbcTemplate.queryForObject(sql, Integer.class, userId);
            return c != null ? c : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    public int countByUserIdAndStatus(Long userId, String status) {
        try {
            String sql = "SELECT COUNT(*) FROM form_941 WHERE created_by = ? AND status = ?";
            Integer c = jdbcTemplate.queryForObject(sql, Integer.class, userId, status);
            return c != null ? c : 0;
        } catch (Exception e) {
            return 0;
        }
    }
}
