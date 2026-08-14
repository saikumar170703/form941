package com.company.irs941.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.company.irs941.dao.TaxRateDao;
import com.company.irs941.dto.Form941DTO;
import com.company.irs941.dto.ValidationErrorDTO;
import com.company.irs941.model.TaxRate;

@Service
public class Form941CalculationService {

    private static final DecimalFormat FMT = new DecimalFormat("#,##0.00");

    @Autowired
    private TaxRateDao taxRateDao;

    public List<ValidationErrorDTO> calculateAndValidate(Form941DTO dto) {
        List<ValidationErrorDTO> errors = new ArrayList<>();
        if (dto == null) return errors;

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

        // Line 3: Federal Income Tax Withheld
        BigDecimal line3 = parseRaw(dto.getLineValue("3"));

        // Line 5a: Social Security Wages (2 * ss_rate)
        BigDecimal l5aWages = parseRaw(dto.getLineValue("5a_wages"));
        BigDecimal l5aTax = l5aWages.multiply(ssRateCombined).setScale(2, RoundingMode.HALF_UP);
        dto.setLineValue("5a_tax", formatDecimal(l5aTax));

        // Line 5b: Social Security Tips (2 * ss_rate)
        BigDecimal l5bTips = parseRaw(dto.getLineValue("5b_tips"));
        BigDecimal l5bTax = l5bTips.multiply(ssRateCombined).setScale(2, RoundingMode.HALF_UP);
        dto.setLineValue("5b_tax", formatDecimal(l5bTax));

        // Line 5c: Medicare Wages & Tips (2 * medicare_rate)
        BigDecimal l5cWages = parseRaw(dto.getLineValue("5c_wages"));
        BigDecimal l5cTax = l5cWages.multiply(medicareRateCombined).setScale(2, RoundingMode.HALF_UP);
        dto.setLineValue("5c_tax", formatDecimal(l5cTax));

        // Line 5d: Additional Medicare Tax (addl_medicare_rate)
        BigDecimal l5dWages = parseRaw(dto.getLineValue("5d_wages"));
        BigDecimal l5dTax = l5dWages.multiply(addlMedicareRate).setScale(2, RoundingMode.HALF_UP);
        dto.setLineValue("5d_tax", formatDecimal(l5dTax));

        // Line 5e: Total Social Security and Medicare taxes
        BigDecimal line5e = l5aTax.add(l5bTax).add(l5cTax).add(l5dTax);
        dto.setLineValue("5e", formatDecimal(line5e));

        // Line 5f: Section 3121(q)
        BigDecimal line5f = parseRaw(dto.getLineValue("5f"));

        // Line 6: Total taxes before adjustments (3 + 5e + 5f)
        BigDecimal line6 = line3.add(line5e).add(line5f);
        dto.setLineValue("6", formatDecimal(line6));

        // Line 7, 8, 9 adjustments
        BigDecimal line7 = parseRaw(dto.getLineValue("7"));
        BigDecimal line8 = parseRaw(dto.getLineValue("8"));
        BigDecimal line9 = parseRaw(dto.getLineValue("9"));

        // Line 10: Total taxes after adjustments (6 + 7 + 8 + 9)
        BigDecimal line10 = line6.add(line7).add(line8).add(line9);
        dto.setLineValue("10", formatDecimal(line10));

        // Line 11: Payroll tax credit
        BigDecimal line11 = parseRaw(dto.getLineValue("11"));

        // Line 12: Total taxes after adjustments and credits (max(0, 10 - 11))
        BigDecimal line12 = line10.subtract(line11);
        if (line12.compareTo(BigDecimal.ZERO) < 0) {
            line12 = BigDecimal.ZERO;
        }
        dto.setLineValue("12", formatDecimal(line12));

        // Line 13: Total deposits
        BigDecimal line13 = parseRaw(dto.getLineValue("13"));

        // Line 14: Balance due & Line 15: Overpayment
        if (line12.compareTo(line13) > 0) {
            BigDecimal balanceDue = line12.subtract(line13);
            dto.setLineValue("14", formatDecimal(balanceDue));
            dto.setLineValue("15", "0.00");
        } else if (line13.compareTo(line12) > 0) {
            BigDecimal overpayment = line13.subtract(line12);
            dto.setLineValue("14", "0.00");
            dto.setLineValue("15", formatDecimal(overpayment));
        } else {
            dto.setLineValue("14", "0.00");
            dto.setLineValue("15", "0.00");
        }

        // Schedule B / Line 16 validation
        String opt16 = dto.getLineValue("16");
        if ("monthly".equals(opt16) || "2".equals(opt16)) {
            BigDecimal m1 = parseRaw(dto.getLineValue("16_m1"));
            BigDecimal m2 = parseRaw(dto.getLineValue("16_m2"));
            BigDecimal m3 = parseRaw(dto.getLineValue("16_m3"));
            BigDecimal totalM = m1.add(m2).add(m3);
            dto.setLineValue("16_total", formatDecimal(totalM));
            if (totalM.compareTo(line12) != 0) {
                errors.add(new ValidationErrorDTO("941-DEP-01", "16",
                        "Total monthly deposit liability ($" + formatDecimal(totalM) + ") must equal Line 12 ($" + formatDecimal(line12) + ").", "ERROR"));
            }
        } else if ("semiweekly".equals(opt16) || "3".equals(opt16)) {
            BigDecimal sbTotal = parseRaw(dto.getLineValue("sb_quarter_total"));
            if (sbTotal.compareTo(BigDecimal.ZERO) == 0) {
                BigDecimal m1 = parseRaw(dto.getLineValue("sb_m1_total"));
                BigDecimal m2 = parseRaw(dto.getLineValue("sb_m2_total"));
                BigDecimal m3 = parseRaw(dto.getLineValue("sb_m3_total"));
                sbTotal = m1.add(m2).add(m3);
                dto.setLineValue("sb_quarter_total", formatDecimal(sbTotal));
            }
            if (sbTotal.compareTo(line12) != 0) {
                errors.add(new ValidationErrorDTO("941-DEP-01", "16 (Schedule B)",
                        "Total Schedule B quarterly liability ($" + formatDecimal(sbTotal) + ") must equal Line 12 ($" + formatDecimal(line12) + ").", "ERROR"));
            }
        }

        return errors;
    }

    private BigDecimal parseRaw(String val) {
        if (val == null) return BigDecimal.ZERO;
        String clean = val.replace(",", "").replace("$", "").trim();
        if (clean.isEmpty()) return BigDecimal.ZERO;
        try {
            return new BigDecimal(clean);
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private String formatDecimal(BigDecimal bd) {
        if (bd == null) return "0.00";
        return FMT.format(bd);
    }
}
