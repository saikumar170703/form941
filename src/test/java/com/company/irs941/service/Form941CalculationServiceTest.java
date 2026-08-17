package com.company.irs941.service;

import com.company.irs941.dto.Form941DTO;

public class Form941CalculationServiceTest {

    public static void main(String[] args) {
        Form941CalculationService service = new Form941CalculationService();

        Form941DTO dto = new Form941DTO();
        dto.setLineValue("3", "1000.00");
        dto.setLineValue("5a_wages", "10000.00"); // 10,000 * 0.124 = 1,240.00
        dto.setLineValue("5c_wages", "10000.00"); // 10,000 * 0.029 = 290.00

        service.calculateAndValidate(dto);

        System.out.println("Form941CalculationServiceTest Line 5a Tax : " + dto.getLineValue("5a_tax"));
        System.out.println("Form941CalculationServiceTest Line 5c Tax : " + dto.getLineValue("5c_tax"));
        System.out.println("Form941CalculationServiceTest Line 5e Tax : " + dto.getLineValue("5e"));
        System.out.println("Form941CalculationServiceTest Line 6 Tax  : " + dto.getLineValue("6"));
        System.out.println("Form941CalculationServiceTest Line 10 Tax : " + dto.getLineValue("10"));
        System.out.println("Form941CalculationServiceTest Line 12 Tax : " + dto.getLineValue("12"));
    }
}
