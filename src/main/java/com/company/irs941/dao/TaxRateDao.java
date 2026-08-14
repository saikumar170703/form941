package com.company.irs941.dao;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.company.irs941.model.TaxRate;

@Repository
public class TaxRateDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public Optional<TaxRate> findByYear(int year) {
        try {
            String sql = "SELECT tr.* FROM tax_rates tr JOIN tax_year ty ON tr.tax_year_id = ty.tax_year_id WHERE ty.year = ?";
            List<TaxRate> list = jdbcTemplate.query(sql, (rs, rowNum) -> {
                TaxRate tr = new TaxRate();
                tr.setTaxRateId(rs.getInt("tax_rate_id"));
                tr.setTaxYearId(rs.getInt("tax_year_id"));
                tr.setSsRate(rs.getBigDecimal("ss_rate"));
                tr.setSsWageBase(rs.getBigDecimal("ss_wage_base"));
                tr.setMedicareRate(rs.getBigDecimal("medicare_rate"));
                tr.setAddlMedicareRate(rs.getBigDecimal("addl_medicare_rate"));
                tr.setEffectiveFrom(rs.getDate("effective_from"));
                tr.setEffectiveTo(rs.getDate("effective_to"));
                return tr;
            }, year);
            return list.stream().findFirst();
        } catch (Exception e) {
            System.err.println("TaxRateDao findByYear exception: " + e.getMessage());
            return Optional.empty();
        }
    }
}
