package com.company.irs941.dao;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.company.irs941.model.TaxYear;

@Repository
public class TaxYearDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public List<TaxYear> findAllActive() {
        String sql = "SELECT tax_year_id, year, status FROM tax_year WHERE status = 'ACTIVE' ORDER BY year DESC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new TaxYear(
                rs.getInt("tax_year_id"),
                rs.getInt("year"),
                rs.getString("status")
        ));
    }

    public Optional<Integer> findTaxYearIdByYear(int year) {
        String sql = "SELECT tax_year_id FROM tax_year WHERE year = ?";
        List<Integer> list = jdbcTemplate.query(sql, (rs, rowNum) -> rs.getInt("tax_year_id"), year);
        return list.stream().findFirst();
    }
}
