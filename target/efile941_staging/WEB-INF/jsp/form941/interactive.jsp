<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Computerized Form 941 (Rev. March 2026) - IRS E-File Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/style.css?v=2" rel="stylesheet">
    <style>
        .irs-paper {
            background-color: #ffffff;
            border: 2px solid #000000;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            font-family: Arial, Helvetica, sans-serif;
            color: #000000;
            max-width: 950px;
            margin: 0 auto;
            padding: 25px;
        }
        .irs-header {
            border-bottom: 2px solid #000;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        .irs-box {
            border: 1px solid #000;
            padding: 8px;
            background-color: #f9fafb;
        }
        .irs-title {
            font-weight: 900;
            font-size: 1.4rem;
        }
        .irs-section-header {
            background-color: #000000;
            color: #ffffff;
            font-weight: bold;
            padding: 5px 10px;
            margin-top: 15px;
            margin-bottom: 10px;
        }
        .irs-input {
            border: 1px solid #6b7280;
            border-radius: 2px;
            font-family: monospace;
            font-weight: bold;
            padding: 2px 6px;
            background-color: #f3f4f6;
        }
        .irs-input:focus {
            background-color: #ffffff;
            border-color: #2563eb;
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.2);
        }
        @media print {
            .no-print { display: none !important; }
            .irs-paper {
                box-shadow: none;
                border: none;
                max-width: 100%;
                width: 100%;
                padding: 0;
            }
            body { background: #ffffff !important; }
            .main-wrapper { margin: 0 !important; padding: 0 !important; }
        }
    </style>
</head>
<body class="bg-secondary-subtle">
    <div class="d-flex">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

        <!-- Main Content -->
        <div class="main-wrapper">
            <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />
            
            <div class="content-area py-4">
                <!-- Action Control Bar (No Print) -->
                <div class="container-fluid no-print mb-4" style="max-width: 950px;">
                    <div class="d-flex justify-content-between align-items-center bg-white p-3 rounded-3 shadow-sm border">
                        <div>
                            <div class="d-flex align-items-center gap-2">
                                <h4 class="fw-bold m-0 text-dark">🖥️ Computerized Form 941 Engine</h4>
                                <c:choose>
                                    <c:when test="${formDTO.status == 'SUBMITTED'}">
                                        <span class="badge bg-success-subtle text-success px-3 py-1 rounded-pill fw-bold">✓ SUBMITTED RETURN #${formDTO.form941Id}</span>
                                    </c:when>
                                    <c:when test="${formDTO.form941Id != null}">
                                        <span class="badge bg-warning-subtle text-warning-emphasis px-3 py-1 rounded-pill fw-bold">⏳ DRAFT #${formDTO.form941Id}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-primary-subtle text-primary px-3 py-1 rounded-pill fw-bold">✨ NEW RETURN</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <p class="text-muted small m-0 mt-1">Computerized form input, online storage, live tax calculations & Form 941-V Payment Voucher.</p>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="<%= request.getContextPath() %>/filings" class="btn btn-outline-secondary btn-sm">📋 Return History</a>
                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="window.print();">🖨️ Print / Save PDF</button>
                            <button type="submit" form="computerizedForm" formaction="<%= request.getContextPath() %>/form941/saveDraft" class="btn btn-warning btn-sm px-3 text-dark fw-bold">💾 Save Draft</button>
                            <button type="submit" form="computerizedForm" formaction="<%= request.getContextPath() %>/form941/submitInternal" class="btn btn-primary btn-sm px-3 fw-bold">🚀 Submit Return</button>
                        </div>
                    </div>
                </div>

                <!-- Computerized IRS Form 941 Container -->
                <form id="computerizedForm" action="<%= request.getContextPath() %>/form941/submitInternal" method="POST" class="irs-paper">
                    <input type="hidden" name="form941Id" value="${formDTO.form941Id}">
                    <input type="hidden" name="employerId" value="${formDTO.employerId}">

                    <!-- HEADER -->
                    <div class="row irs-header align-items-start">
                        <div class="col-md-8">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="fs-4 fw-bold">Form 941 for 2026:</span>
                                    <span class="text-muted small ms-2">(Rev. March 2026)</span>
                                </div>
                                <span class="fw-bold font-monospace border px-2 py-1">950126</span>
                            </div>
                            <div class="irs-title">Employer’s QUARTERLY Federal Tax Return</div>
                            <div class="small text-muted mb-2">Department of the Treasury — Internal Revenue Service</div>

                            <div class="row g-2 mb-2">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold mb-0">Employer Identification Number (EIN)</label>
                                    <input type="text" class="form-control form-control-sm irs-input text-uppercase" name="ein" value="${formDTO.getLineValue('ein') != null ? formDTO.getLineValue('ein') : '12-3456789'}" placeholder="12-3456789" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold mb-0">Legal Business Name</label>
                                    <input type="text" class="form-control form-control-sm irs-input" name="businessName" value="${formDTO.getLineValue('businessName') != null ? formDTO.getLineValue('businessName') : 'SAMPLE BUSINESS INC'}" required>
                                </div>
                                <div class="col-md-12">
                                    <label class="form-label small fw-bold mb-0">Trade Name (if any)</label>
                                    <input type="text" class="form-control form-control-sm irs-input" name="tradeName" value="${formDTO.getLineValue('tradeName') != null ? formDTO.getLineValue('tradeName') : 'Sample Biz'}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold mb-0">Street Address</label>
                                    <input type="text" class="form-control form-control-sm irs-input" name="address" value="${formDTO.getLineValue('address') != null ? formDTO.getLineValue('address') : '123 Main St'}">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label small fw-bold mb-0">City</label>
                                    <input type="text" class="form-control form-control-sm irs-input" name="city" value="${formDTO.getLineValue('city') != null ? formDTO.getLineValue('city') : 'Austin'}">
                                </div>
                                <div class="col-md-1">
                                    <label class="form-label small fw-bold mb-0">State</label>
                                    <input type="text" class="form-control form-control-sm irs-input" name="state" value="${formDTO.getLineValue('state') != null ? formDTO.getLineValue('state') : 'TX'}">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label small fw-bold mb-0">ZIP Code</label>
                                    <input type="text" class="form-control form-control-sm irs-input" name="zip" value="${formDTO.getLineValue('zip') != null ? formDTO.getLineValue('zip') : '78701'}">
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="irs-box mb-2">
                                <div class="fw-bold small text-center border-bottom pb-1 mb-2">Report for this Quarter of 2026 (Check one.)</div>
                                <div class="form-check small">
                                    <input class="form-check-input" type="radio" name="quarter" id="q1" value="1" ${formDTO.quarter == 1 || formDTO.quarter == null ? 'checked' : ''}>
                                    <label class="form-check-label" for="q1">1: January, February, March</label>
                                </div>
                                <div class="form-check small">
                                    <input class="form-check-input" type="radio" name="quarter" id="q2" value="2" ${formDTO.quarter == 2 ? 'checked' : ''}>
                                    <label class="form-check-label" for="q2">2: April, May, June</label>
                                </div>
                                <div class="form-check small">
                                    <input class="form-check-input" type="radio" name="quarter" id="q3" value="3" ${formDTO.quarter == 3 ? 'checked' : ''}>
                                    <label class="form-check-label" for="q3">3: July, August, September</label>
                                </div>
                                <div class="form-check small">
                                    <input class="form-check-input" type="radio" name="quarter" id="q4" value="4" ${formDTO.quarter == 4 ? 'checked' : ''}>
                                    <label class="form-check-label" for="q4">4: October, November, December</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- PART 1 -->
                    <div class="irs-section-header">Part 1: Answer these questions for this quarter.</div>
                    
                    <div class="table-responsive">
                        <table class="table table-bordered align-middle table-sm">
                            <tbody>
                                <tr>
                                    <td style="width: 30px;" class="fw-bold text-center">1</td>
                                    <td>Number of employees who received wages, tips, or other compensation for pay period including Mar 12, June 12, Sept 12, Dec 12</td>
                                    <td style="width: 200px;">
                                        <input type="number" class="form-control form-control-sm irs-input text-end" name="1" value="${formDTO.getLineValue('1') != null ? formDTO.getLineValue('1') : '10'}">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">2</td>
                                    <td>Wages, tips, and other compensation</td>
                                    <td>
                                        <input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="2" id="line2" value="${formDTO.getLineValue('2') != null ? formDTO.getLineValue('2') : '50000.00'}">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">3</td>
                                    <td>Federal income tax withheld from wages, tips, and other compensation</td>
                                    <td>
                                        <input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="3" id="line3" value="${formDTO.getLineValue('3') != null ? formDTO.getLineValue('3') : '6000.00'}">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">5a</td>
                                    <td>Taxable social security wages ($) &times; 0.124 =</td>
                                    <td>
                                        <div class="d-flex gap-1">
                                            <input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="5a_wages" id="line5a_wages" value="${formDTO.getLineValue('5a_wages') != null ? formDTO.getLineValue('5a_wages') : '50000.00'}" placeholder="Wages">
                                            <input type="text" class="form-control form-control-sm irs-input text-end bg-light" name="5a_tax" id="line5a_tax" value="${formDTO.getLineValue('5a_tax') != null ? formDTO.getLineValue('5a_tax') : '6200.00'}" readonly>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">5b</td>
                                    <td>Taxable social security tips ($) &times; 0.124 =</td>
                                    <td>
                                        <div class="d-flex gap-1">
                                            <input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="5b_tips" id="line5b_tips" value="${formDTO.getLineValue('5b_tips') != null ? formDTO.getLineValue('5b_tips') : '0.00'}" placeholder="Tips">
                                            <input type="text" class="form-control form-control-sm irs-input text-end bg-light" name="5b_tax" id="line5b_tax" value="${formDTO.getLineValue('5b_tax') != null ? formDTO.getLineValue('5b_tax') : '0.00'}" readonly>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">5c</td>
                                    <td>Taxable Medicare wages & tips ($) &times; 0.029 =</td>
                                    <td>
                                        <div class="d-flex gap-1">
                                            <input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="5c_wages" id="line5c_wages" value="${formDTO.getLineValue('5c_wages') != null ? formDTO.getLineValue('5c_wages') : '50000.00'}" placeholder="Medicare Wages">
                                            <input type="text" class="form-control form-control-sm irs-input text-end bg-light" name="5c_tax" id="line5c_tax" value="${formDTO.getLineValue('5c_tax') != null ? formDTO.getLineValue('5c_tax') : '1450.00'}" readonly>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">5d</td>
                                    <td>Taxable wages & tips subject to Additional Medicare Tax withholding ($) &times; 0.009 =</td>
                                    <td>
                                        <div class="d-flex gap-1">
                                            <input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="5d_wages" id="line5d_wages" value="${formDTO.getLineValue('5d_wages') != null ? formDTO.getLineValue('5d_wages') : '0.00'}">
                                            <input type="text" class="form-control form-control-sm irs-input text-end bg-light" name="5d_tax" id="line5d_tax" value="${formDTO.getLineValue('5d_tax') != null ? formDTO.getLineValue('5d_tax') : '0.00'}" readonly>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="table-primary-subtle fw-bold">
                                    <td class="fw-bold text-center">5e</td>
                                    <td>Total social security and Medicare taxes. Add Column 2 from lines 5a, 5b, 5c, and 5d</td>
                                    <td>
                                        <input type="text" class="form-control form-control-sm irs-input text-end fw-bold text-primary" name="5e" id="line5e" value="${formDTO.getLineValue('5e') != null ? formDTO.getLineValue('5e') : '7650.00'}" readonly>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">5f</td>
                                    <td>Section 3121(q) Notice and Demand — Tax due on unreported tips</td>
                                    <td>
                                        <input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="5f" id="line5f" value="${formDTO.getLineValue('5f') != null ? formDTO.getLineValue('5f') : '0.00'}">
                                    </td>
                                </tr>
                                <tr class="table-warning-subtle fw-bold">
                                    <td class="fw-bold text-center">6</td>
                                    <td>Total taxes before adjustments. Add lines 3, 5e, and 5f</td>
                                    <td>
                                        <input type="text" class="form-control form-control-sm irs-input text-end fw-bold text-dark fs-6" name="6" id="line6" value="${formDTO.getLineValue('6') != null ? formDTO.getLineValue('6') : '13650.00'}" readonly>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">7</td>
                                    <td>Current quarter's adjustment for fractions of cents</td>
                                    <td><input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="7" id="line7" value="${formDTO.getLineValue('7') != null ? formDTO.getLineValue('7') : '0.00'}"></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">8</td>
                                    <td>Current quarter's adjustment for sick pay</td>
                                    <td><input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="8" id="line8" value="${formDTO.getLineValue('8') != null ? formDTO.getLineValue('8') : '0.00'}"></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">9</td>
                                    <td>Current quarter's adjustments for tips and group-term life insurance</td>
                                    <td><input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="9" id="line9" value="${formDTO.getLineValue('9') != null ? formDTO.getLineValue('9') : '0.00'}"></td>
                                </tr>
                                <tr class="table-info-subtle fw-bold">
                                    <td class="fw-bold text-center">10</td>
                                    <td>Total taxes after adjustments. Combine lines 6 through 9</td>
                                    <td><input type="text" class="form-control form-control-sm irs-input text-end fw-bold" name="10" id="line10" value="${formDTO.getLineValue('10') != null ? formDTO.getLineValue('10') : '13650.00'}" readonly></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">11</td>
                                    <td>Qualified small business payroll tax credit for increasing research activities (Form 8974)</td>
                                    <td><input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="11" id="line11" value="${formDTO.getLineValue('11') != null ? formDTO.getLineValue('11') : '0.00'}"></td>
                                </tr>
                                <tr class="table-primary fw-bold text-white">
                                    <td class="fw-bold text-center">12</td>
                                    <td>Total taxes after adjustments and nonrefundable credits (Subtract line 11 from line 10)</td>
                                    <td><input type="text" class="form-control form-control-sm irs-input text-end fw-bold text-primary fs-6" name="12" id="line12" value="${formDTO.getLineValue('12') != null ? formDTO.getLineValue('12') : '13650.00'}" readonly></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">13</td>
                                    <td>Total deposits for this quarter, including overpayments from prior quarters</td>
                                    <td><input type="text" class="form-control form-control-sm irs-input text-end calc-trigger" name="13" id="line13" value="${formDTO.getLineValue('13') != null ? formDTO.getLineValue('13') : '13650.00'}"></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">14</td>
                                    <td>Balance due. If line 12 is more than line 13, enter the difference</td>
                                    <td><input type="text" class="form-control form-control-sm irs-input text-end fw-bold text-danger" name="14" id="line14" value="${formDTO.getLineValue('14') != null ? formDTO.getLineValue('14') : '0.00'}" readonly></td>
                                </tr>
                                <tr>
                                    <td class="fw-bold text-center">15a</td>
                                    <td>Overpayment. If line 13 is more than line 12, enter the difference</td>
                                    <td><input type="text" class="form-control form-control-sm irs-input text-end fw-bold text-success" name="15" id="line15" value="${formDTO.getLineValue('15') != null ? formDTO.getLineValue('15') : '0.00'}" readonly></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- PART 2 -->
                    <div class="irs-section-header">Part 2: Tell us about your deposit schedule and tax liability for this quarter.</div>
                    <div class="irs-box mb-3">
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="16" id="opt16_1" value="less_2500" ${formDTO.getLineValue('16') == 'less_2500' ? 'checked' : ''}>
                            <label class="form-check-label small" for="opt16_1">Line 12 on this return is less than $2,500.</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="16" id="opt16_2" value="monthly" ${formDTO.getLineValue('16') == 'monthly' || formDTO.getLineValue('16') == null ? 'checked' : ''}>
                            <label class="form-check-label small fw-bold" for="opt16_2">You were a monthly schedule depositor for the entire quarter.</label>
                            <div class="row g-2 mt-1 ms-3">
                                <div class="col-md-3"><label class="small">Month 1 ($)</label><input type="text" class="form-control form-control-sm irs-input text-end" name="16_m1" id="m1" value="${formDTO.getLineValue('16_m1') != null ? formDTO.getLineValue('16_m1') : '4550.00'}"></div>
                                <div class="col-md-3"><label class="small">Month 2 ($)</label><input type="text" class="form-control form-control-sm irs-input text-end" name="16_m2" id="m2" value="${formDTO.getLineValue('16_m2') != null ? formDTO.getLineValue('16_m2') : '4550.00'}"></div>
                                <div class="col-md-3"><label class="small">Month 3 ($)</label><input type="text" class="form-control form-control-sm irs-input text-end" name="16_m3" id="m3" value="${formDTO.getLineValue('16_m3') != null ? formDTO.getLineValue('16_m3') : '4550.00'}"></div>
                                <div class="col-md-3"><label class="small fw-bold">Total Liability ($)</label><input type="text" class="form-control form-control-sm irs-input text-end fw-bold" name="16_total" id="mtotal" value="${formDTO.getLineValue('16_total') != null ? formDTO.getLineValue('16_total') : '13650.00'}" readonly></div>
                            </div>
                        </div>
                    </div>

                    <!-- PART 5: SIGNATURE -->
                    <div class="irs-section-header">Part 5: Sign here. You MUST complete both pages of Form 941 and SIGN it.</div>
                    <div class="row g-2 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Sign your name here</label>
                            <input type="text" class="form-control form-control-sm irs-input" name="signatureName" value="${formDTO.getLineValue('signatureName') != null ? formDTO.getLineValue('signatureName') : 'John Doe'}" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-bold">Print title</label>
                            <input type="text" class="form-control form-control-sm irs-input" name="signatureTitle" value="${formDTO.getLineValue('signatureTitle') != null ? formDTO.getLineValue('signatureTitle') : 'Owner'}" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-bold">Best daytime phone</label>
                            <input type="text" class="form-control form-control-sm irs-input" name="signaturePhone" value="${formDTO.getLineValue('signaturePhone') != null ? formDTO.getLineValue('signaturePhone') : '(512) 555-0199'}" required>
                        </div>
                    </div>

                    <!-- FORM 941-V PAYMENT VOUCHER -->
                    <div class="border-top border-3 border-dark pt-3 mt-4" id="voucherSection">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <div>
                                <span class="fs-4 fw-bold">Form 941-V</span>
                                <span class="fw-bold ms-2">Payment Voucher</span>
                            </div>
                            <span class="fw-bold font-monospace">2026</span>
                        </div>
                        <div class="irs-box bg-light">
                            <div class="row g-2 align-items-center">
                                <div class="col-md-4">
                                    <label class="small fw-bold">1 Enter EIN</label>
                                    <input type="text" class="form-control form-control-sm irs-input" id="v_ein" value="12-3456789" readonly>
                                </div>
                                <div class="col-md-4">
                                    <label class="small fw-bold">2 Enter Amount of Payment ($)</label>
                                    <input type="text" class="form-control form-control-sm irs-input text-end fw-bold text-danger fs-6" id="v_amount" name="voucherAmount" value="0.00" readonly>
                                </div>
                                <div class="col-md-4">
                                    <label class="small fw-bold">3 Tax Period</label>
                                    <input type="text" class="form-control form-control-sm irs-input" id="v_quarter" value="1st Quarter 2026" readonly>
                                </div>
                            </div>
                        </div>
                    </div>

                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function recalculateTaxMath() {
            var l2 = parseFloat(document.getElementById('line2').value.replace(/,/g, '')) || 0;
            var l3 = parseFloat(document.getElementById('line3').value.replace(/,/g, '')) || 0;
            
            var l5a_wages = parseFloat(document.getElementById('line5a_wages').value.replace(/,/g, '')) || 0;
            var l5a_tax = l5a_wages * 0.124;
            document.getElementById('line5a_tax').value = l5a_tax.toFixed(2);
            
            var l5b_tips = parseFloat(document.getElementById('line5b_tips').value.replace(/,/g, '')) || 0;
            var l5b_tax = l5b_tips * 0.124;
            document.getElementById('line5b_tax').value = l5b_tax.toFixed(2);

            var l5c_wages = parseFloat(document.getElementById('line5c_wages').value.replace(/,/g, '')) || 0;
            var l5c_tax = l5c_wages * 0.029;
            document.getElementById('line5c_tax').value = l5c_tax.toFixed(2);

            var l5d_wages = parseFloat(document.getElementById('line5d_wages').value.replace(/,/g, '')) || 0;
            var l5d_tax = l5d_wages * 0.009;
            document.getElementById('line5d_tax').value = l5d_tax.toFixed(2);

            var l5e = l5a_tax + l5b_tax + l5c_tax + l5d_tax;
            document.getElementById('line5e').value = l5e.toFixed(2);

            var l5f = parseFloat(document.getElementById('line5f').value.replace(/,/g, '')) || 0;
            var l6 = l3 + l5e + l5f;
            document.getElementById('line6').value = l6.toFixed(2);

            var l7 = parseFloat(document.getElementById('line7').value.replace(/,/g, '')) || 0;
            var l8 = parseFloat(document.getElementById('line8').value.replace(/,/g, '')) || 0;
            var l9 = parseFloat(document.getElementById('line9').value.replace(/,/g, '')) || 0;
            var l10 = l6 + l7 + l8 + l9;
            document.getElementById('line10').value = l10.toFixed(2);

            var l11 = parseFloat(document.getElementById('line11').value.replace(/,/g, '')) || 0;
            var l12 = Math.max(0, l10 - l11);
            document.getElementById('line12').value = l12.toFixed(2);

            var l13 = parseFloat(document.getElementById('line13').value.replace(/,/g, '')) || 0;
            if (l12 > l13) {
                var bal = l12 - l13;
                document.getElementById('line14').value = bal.toFixed(2);
                document.getElementById('line15').value = "0.00";
                document.getElementById('v_amount').value = bal.toFixed(2);
            } else if (l13 > l12) {
                var over = l13 - l12;
                document.getElementById('line14').value = "0.00";
                document.getElementById('line15').value = over.toFixed(2);
                document.getElementById('v_amount').value = "0.00";
            } else {
                document.getElementById('line14').value = "0.00";
                document.getElementById('line15').value = "0.00";
                document.getElementById('v_amount').value = "0.00";
            }

            var m1 = parseFloat(document.getElementById('m1').value.replace(/,/g, '')) || 0;
            var m2 = parseFloat(document.getElementById('m2').value.replace(/,/g, '')) || 0;
            var m3 = parseFloat(document.getElementById('m3').value.replace(/,/g, '')) || 0;
            document.getElementById('mtotal').value = (m1 + m2 + m3).toFixed(2);
        }

        document.querySelectorAll('.calc-trigger').forEach(function(el) {
            el.addEventListener('input', recalculateTaxMath);
        });

        document.addEventListener('DOMContentLoaded', recalculateTaxMath);
    </script>
</body>
</html>
