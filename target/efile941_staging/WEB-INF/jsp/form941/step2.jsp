<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Form 941 - Step 2: Part 1</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="<%= request.getContextPath() %>/css/style.css?v=2" rel="stylesheet">
        </head>

        <body>
            <div class="d-flex">
                <!-- Sidebar -->
                <jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

                <!-- Main Content Wrapper -->
                <div class="main-wrapper bg-light">
                    <!-- Header -->
                    <% request.setAttribute("pageTitle", "Form 941 - Part 1" ); %>
                        <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

                        <!-- Wizard Content -->
                        <div class="content-area">
                            <div class="tm-card p-3 p-md-4 rounded-4 bg-white shadow-sm">
                                <% request.setAttribute("currentStep", 2); %>
                                    <jsp:include page="/WEB-INF/jsp/layout/progress.jsp" />

                                    <!-- Read-Only Banner for Submitted Returns -->
                                    <c:if test="${formDTO.status == 'SUBMITTED'}">
                                        <div class="alert alert-info border-info border-2 rounded-3 shadow-sm mb-4">
                                            <div class="d-flex align-items-center">
                                                <span class="fs-4 me-2">🔒</span>
                                                <div>
                                                    <h6 class="fw-bold m-0">Submitted Return #${formDTO.form941Id}
                                                        (Read-Only Mode)</h6>
                                                    <small>This return has already been submitted to the IRS and cannot
                                                        be edited.</small>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
                                        <h4 class="fw-bold m-0" style="color: var(--primary-blue);">Part 1: Answer these
                                            questions for this quarter.</h4>
                                    </div>

                                    <form action="<%= request.getContextPath() %>/form941/step3" method="POST"
                                        id="form941Step2">

                                        <!-- 1 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">1. Number of employees who
                                                received wages, tips, or other compensation</div>
                                            <div class="col-12 col-md-4">
                                                <input type="number" class="form-control text-end" name="1"
                                                    value="${formDTO.getLineValue('1') != null ? formDTO.getLineValue('1') : '0'}"
                                                    required min="0">
                                            </div>
                                        </div>

                                        <!-- 2 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">2. Wages, tips, and other
                                                compensation</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger" name="2"
                                                    id="line2"
                                                    value="${formDTO.getLineValue('2') != null ? formDTO.getLineValue('2') : '0.00'}"
                                                    required>
                                            </div>
                                        </div>

                                        <!-- 3 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">3. Federal income tax
                                                withheld from wages, tips, and other compensation</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger" name="3"
                                                    id="line3"
                                                    value="${formDTO.getLineValue('3') != null ? formDTO.getLineValue('3') : '0.00'}"
                                                    required>
                                            </div>
                                        </div>

                                        <!-- 4 -->
                                        <div class="row mb-3 g-2">
                                            <div class="col-12 text-start">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" name="4" id="line4"
                                                        ${formDTO.getLineValue('4')=='true' ? 'checked' : '' }>
                                                    <label class="form-check-label fw-bold cursor-pointer"
                                                        for="line4">4. If no wages, tips, and other compensation are
                                                        subject to social security or Medicare tax, check here and go to
                                                        line 6.</label>
                                                </div>
                                            </div>
                                        </div>

                                        <hr class="my-4">
                                        <h5 class="fw-bold mb-3 text-start" style="color: var(--primary-blue);">Taxable
                                            Wages, Tips & Taxes</h5>

                                        <!-- 5a -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-5 fw-bold text-start">5a. Taxable social security
                                                wages</div>
                                            <div class="col-7 col-sm-4 col-md-3">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger"
                                                    name="5a_wages" id="line5a_wages"
                                                    value="${formDTO.getLineValue('5a_wages') != null ? formDTO.getLineValue('5a_wages') : '0.00'}">
                                            </div>
                                            <div class="col-5 col-sm-2 col-md-1 text-center font-monospace small">x
                                                ${ssRateCombined != null ? ssRateCombined : '0.124'} =</div>
                                            <div class="col-12 col-sm-6 col-md-3">
                                                <input type="text"
                                                    class="form-control text-end bg-light fw-bold text-primary amount-input"
                                                    name="5a_tax" id="line5a_tax"
                                                    value="${formDTO.getLineValue('5a_tax') != null ? formDTO.getLineValue('5a_tax') : '0.00'}"
                                                    readonly>
                                            </div>
                                        </div>

                                        <!-- 5b -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-5 fw-bold text-start">5b. Taxable social security
                                                tips</div>
                                            <div class="col-7 col-sm-4 col-md-3">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger"
                                                    name="5b_tips" id="line5b_tips"
                                                    value="${formDTO.getLineValue('5b_tips') != null ? formDTO.getLineValue('5b_tips') : '0.00'}">
                                            </div>
                                            <div class="col-5 col-sm-2 col-md-1 text-center font-monospace small">x
                                                ${ssRateCombined != null ? ssRateCombined : '0.124'} =</div>
                                            <div class="col-12 col-sm-6 col-md-3">
                                                <input type="text"
                                                    class="form-control text-end bg-light fw-bold text-primary amount-input"
                                                    name="5b_tax" id="line5b_tax"
                                                    value="${formDTO.getLineValue('5b_tax') != null ? formDTO.getLineValue('5b_tax') : '0.00'}"
                                                    readonly>
                                            </div>
                                        </div>

                                        <!-- 5c -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-5 fw-bold text-start">5c. Taxable Medicare wages &
                                                tips</div>
                                            <div class="col-7 col-sm-4 col-md-3">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger"
                                                    name="5c_wages" id="line5c_wages"
                                                    value="${formDTO.getLineValue('5c_wages') != null ? formDTO.getLineValue('5c_wages') : '0.00'}">
                                            </div>
                                            <div class="col-5 col-sm-2 col-md-1 text-center font-monospace small">x
                                                ${medicareRateCombined != null ? medicareRateCombined : '0.029'} =</div>
                                            <div class="col-12 col-sm-6 col-md-3">
                                                <input type="text"
                                                    class="form-control text-end bg-light fw-bold text-primary amount-input"
                                                    name="5c_tax" id="line5c_tax"
                                                    value="${formDTO.getLineValue('5c_tax') != null ? formDTO.getLineValue('5c_tax') : '0.00'}"
                                                    readonly>
                                            </div>
                                        </div>

                                        <!-- 5d -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-5 fw-bold text-start">5d. Taxable wages & tips
                                                subject to Additional Medicare Tax</div>
                                            <div class="col-7 col-sm-4 col-md-3">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger"
                                                    name="5d_wages" id="line5d_wages"
                                                    value="${formDTO.getLineValue('5d_wages') != null ? formDTO.getLineValue('5d_wages') : '0.00'}">
                                            </div>
                                            <div class="col-5 col-sm-2 col-md-1 text-center font-monospace small">x
                                                ${addlMedicareRate != null ? addlMedicareRate : '0.009'} =</div>
                                            <div class="col-12 col-sm-6 col-md-3">
                                                <input type="text"
                                                    class="form-control text-end bg-light fw-bold text-primary amount-input"
                                                    name="5d_tax" id="line5d_tax"
                                                    value="${formDTO.getLineValue('5d_tax') != null ? formDTO.getLineValue('5d_tax') : '0.00'}"
                                                    readonly>
                                            </div>
                                        </div>

                                        <!-- 5e -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">5e. Total social security
                                                and Medicare taxes. Add Column 2 from lines 5a, 5b, 5c, and 5d</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end bg-light fw-bold text-primary amount-input"
                                                    name="5e" id="line5e"
                                                    value="${formDTO.getLineValue('5e') != null ? formDTO.getLineValue('5e') : '0.00'}"
                                                    readonly>
                                            </div>
                                        </div>

                                        <!-- 5f -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">5f. Section 3121(q) Notice
                                                and Demand—Tax due on unreported tips</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger" name="5f"
                                                    id="line5f"
                                                    value="${formDTO.getLineValue('5f') != null ? formDTO.getLineValue('5f') : '0.00'}">
                                            </div>
                                        </div>

                                        <!-- 6 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">06. Total taxes before
                                                adjustments (add lines 3, 5e, and 5f)</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end bg-light fw-bold text-primary amount-input"
                                                    name="6" id="line6"
                                                    value="${formDTO.getLineValue('6') != null ? formDTO.getLineValue('6') : '0.00'}"
                                                    readonly>
                                            </div>
                                        </div>

                                        <hr class="my-4">
                                        <h5 class="fw-bold mb-3 text-start" style="color: var(--primary-blue);">
                                            Adjustments & Tax Liability</h5>

                                        <!-- 7 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">07. Current quarter's
                                                adjustment for fractions of cents</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger" name="7"
                                                    id="line7"
                                                    value="${formDTO.getLineValue('7') != null ? formDTO.getLineValue('7') : '0.00'}">
                                            </div>
                                        </div>

                                        <!-- 8 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">08. Current quarter's
                                                adjustment for sick pay</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger" name="8"
                                                    id="line8"
                                                    value="${formDTO.getLineValue('8') != null ? formDTO.getLineValue('8') : '0.00'}">
                                            </div>
                                        </div>

                                        <!-- 9 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">09. Current quarter's
                                                adjustment for tips and group-term life insurance</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger" name="9"
                                                    id="line9"
                                                    value="${formDTO.getLineValue('9') != null ? formDTO.getLineValue('9') : '0.00'}">
                                            </div>
                                        </div>

                                        <!-- 10 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">10. Total taxes after
                                                adjustments. Combine lines 6 through 9</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end bg-light fw-bold text-primary amount-input"
                                                    name="10" id="line10"
                                                    value="${formDTO.getLineValue('10') != null ? formDTO.getLineValue('10') : '0.00'}"
                                                    readonly>
                                            </div>
                                        </div>

                                        <!-- 11 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">11. Qualified small business
                                                payroll tax credit for increasing research activities. Attach Form 8974
                                            </div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger" name="11"
                                                    id="line11"
                                                    value="${formDTO.getLineValue('11') != null ? formDTO.getLineValue('11') : (formDTO.getLineValue('11a') != null ? formDTO.getLineValue('11a') : '0.00')}">
                                            </div>
                                        </div>

                                        <!-- 12 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start text-primary fs-6">12. Total
                                                taxes after adjustments and nonrefundable credits. Subtract line 11 from
                                                line 10</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end bg-light fw-bold text-primary fs-6 amount-input"
                                                    name="12" id="line12"
                                                    value="${formDTO.getLineValue('12') != null ? formDTO.getLineValue('12') : '0.00'}"
                                                    readonly>
                                            </div>
                                        </div>

                                        <!-- 13 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start">13. Total deposits for this
                                                quarter, including overpayment applied from a prior quarter and
                                                overpayments applied from Form 941-X, 941-X (PR), or 944-X filed in the
                                                current quarter</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end amount-input calc-trigger" name="13"
                                                    id="line13"
                                                    value="${formDTO.getLineValue('13') != null ? formDTO.getLineValue('13') : (formDTO.getLineValue('13a') != null ? formDTO.getLineValue('13a') : '0.00')}">
                                            </div>
                                        </div>

                                        <!-- 14 -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start text-danger">14. Balance due.
                                                If line 12 is more than line 13, enter the difference and see
                                                instructions</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end bg-light fw-bold text-danger amount-input"
                                                    name="14" id="line14"
                                                    value="${formDTO.getLineValue('14') != null ? formDTO.getLineValue('14') : '0.00'}"
                                                    readonly>
                                            </div>
                                        </div>

                                        <!-- 15a Overpayment -->
                                        <div class="row align-items-center mb-3 g-2">
                                            <div class="col-12 col-md-8 fw-bold text-start text-success">15a.
                                                Overpayment. If line 13 is more than line 12, enter the difference</div>
                                            <div class="col-12 col-md-4">
                                                <input type="text"
                                                    class="form-control text-end bg-light fw-bold text-success amount-input"
                                                    name="15" id="line15"
                                                    value="${formDTO.getLineValue('15') != null ? formDTO.getLineValue('15') : '0.00'}"
                                                    readonly>
                                            </div>
                                        </div>

                                        <!-- 15b Overpayment Choice & Direct Deposit Section -->
                                        <div class="mb-3" id="line15b_row">
                                            <div class="p-3 border rounded-3 bg-light shadow-sm">
                                                <div class="row align-items-center mb-3 g-2">
                                                    <div class="col-12 col-md-4 fw-bold text-start">15b. Check one:
                                                    </div>
                                                    <div class="col-12 col-md-8">
                                                        <div class="d-flex gap-4 flex-wrap">
                                                            <div class="form-check">
                                                                <input class="form-check-input" type="radio" name="15b"
                                                                    id="line15b_next" value="APPLY_TO_NEXT_RETURN"
                                                                    ${formDTO.getLineValue('15b')=='APPLY_TO_NEXT_RETURN'
                                                                    || empty formDTO.getLineValue('15b') ? 'checked'
                                                                    : '' }>
                                                                <label
                                                                    class="form-check-label fw-bold text-primary cursor-pointer"
                                                                    for="line15b_next">
                                                                    Apply to next return.
                                                                </label>
                                                            </div>
                                                            <div class="form-check">
                                                                <input class="form-check-input" type="radio" name="15b"
                                                                    id="line15b_refund" value="SEND_REFUND"
                                                                    ${formDTO.getLineValue('15b')=='SEND_REFUND'
                                                                    ? 'checked' : '' }>
                                                                <label
                                                                    class="form-check-label fw-bold text-success cursor-pointer"
                                                                    for="line15b_refund">
                                                                    Send a refund.
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Direct Deposit Fields (Lines 15c, 15d, 15e) -->
                                                <div class="p-3 bg-white border rounded-3 mt-3"
                                                    id="directDepositSection" style="display: none;">
                                                    <h6 class="fw-bold text-primary border-bottom pb-2 mb-3">Direct
                                                        Deposit Information for Refund</h6>

                                                    <div class="row g-3 align-items-start mb-3">
                                                        <div class="col-12 col-md-4 fw-semibold text-start pt-2">15c.
                                                            Routing number <span class="text-danger">*</span></div>
                                                        <div class="col-12 col-md-8">
                                                            <input type="text" class="form-control font-monospace"
                                                                name="15c" id="line15c"
                                                                value="${formDTO.getLineValue('15c')}" maxlength="9"
                                                                placeholder="9-digit Routing Number">
                                                            <div id="err_15c"
                                                                style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                                ⚠️ Routing number must be exactly 9 digits (numbers
                                                                only).</div>
                                                        </div>
                                                    </div>

                                                    <div class="row g-3 align-items-center mb-3">
                                                        <div class="col-12 col-md-4 fw-semibold text-start">15d. Type:
                                                            <span class="text-danger">*</span></div>
                                                        <div class="col-12 col-md-8">
                                                            <div class="d-flex gap-4">
                                                                <div class="form-check">
                                                                    <input class="form-check-input" type="radio"
                                                                        name="15d" id="line15d_checking"
                                                                        value="CHECKING"
                                                                        ${formDTO.getLineValue('15d')=='CHECKING' ||
                                                                        empty formDTO.getLineValue('15d') ? 'checked'
                                                                        : '' }>
                                                                    <label class="form-check-label cursor-pointer"
                                                                        for="line15d_checking">Checking</label>
                                                                </div>
                                                                <div class="form-check">
                                                                    <input class="form-check-input" type="radio"
                                                                        name="15d" id="line15d_savings" value="SAVINGS"
                                                                        ${formDTO.getLineValue('15d')=='SAVINGS'
                                                                        ? 'checked' : '' }>
                                                                    <label class="form-check-label cursor-pointer"
                                                                        for="line15d_savings">Savings</label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="row g-3 align-items-start">
                                                        <div class="col-12 col-md-4 fw-semibold text-start pt-2">15e.
                                                            Account number <span class="text-danger">*</span></div>
                                                        <div class="col-12 col-md-8">
                                                            <input type="text" class="form-control font-monospace"
                                                                name="15e" id="line15e"
                                                                value="${formDTO.getLineValue('15e')}" maxlength="17"
                                                                placeholder="17-digit Account Number">
                                                            <div id="err_15e"
                                                                style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                                ⚠️ Account number must be exactly 17 digits (numbers
                                                                only).</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <hr class="my-4">

                                        <div class="d-flex justify-content-between flex-wrap gap-2">
                                            <a href="<%= request.getContextPath() %>/form941/step1"
                                                class="btn btn-outline-secondary px-4">Back</a>
                                            <c:choose>
                                                <c:when test="${formDTO.status == 'SUBMITTED'}">
                                                    <a href="<%= request.getContextPath() %>/form941/step3"
                                                        class="btn btn-primary px-5">View Step 3 &raquo;</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="submit" id="btnStep2Submit"
                                                        class="btn btn-primary px-5"
                                                        style="background-color: #2563EB; border: none;">Proceed</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </form>
                            </div>
                        </div>
                </div>
            </div>

            <c:if test="${formDTO.status == 'SUBMITTED'}">
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        document.querySelectorAll('#form941Step2 input, #form941Step2 select, #form941Step2 textarea').forEach(function (el) {
                            el.disabled = true;
                            el.readOnly = true;
                        });
                    });
                </script>
            </c:if>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                function parseRawNumber(val) {
                    if (!val) return 0;
                    const clean = val.toString().replace(/,/g, '').trim();
                    return parseFloat(clean) || 0;
                }

                function formatAmount(val) {
                    if (val === null || val === undefined || val === '') return '0.00';
                    let clean = val.toString().replace(/,/g, '').replace(/\$/g, '').trim();
                    let num = parseFloat(clean);
                    if (isNaN(num)) return '0.00';
                    let parts = num.toFixed(2).split('.');
                    let intPart = parts[0];
                    let decPart = '.' + parts[1];

                    let isNegative = false;
                    if (intPart.startsWith('-')) {
                        isNegative = true;
                        intPart = intPart.substring(1);
                    }

                    let formattedInt = intPart.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
                    return (isNegative ? '-' : '') + formattedInt + decPart;
                }

                function applyRealTimeFormatting(el) {
                    if (!el || el.readOnly) return;
                    let val = el.value;
                    if (val === '') return;

                    let cursorPos = el.selectionStart;
                    let oldLen = val.length;

                    let isNegative = val.startsWith('-');
                    let clean = val.replace(/[^0-9.]/g, '');
                    let parts = clean.split('.');
                    let intPart = parts[0];
                    let decPart = parts.length > 1 ? '.' + parts[1].substring(0, 2) : '';

                    let formattedInt = intPart !== '' ? intPart.replace(/\B(?=(\d{3})+(?!\d))/g, ',') : '0';

                    let result = (isNegative ? '-' : '') + formattedInt + decPart;
                    el.value = result;

                    let newLen = result.length;
                    let diff = newLen - oldLen;
                    let newPos = Math.max(0, cursorPos + diff);
                    try {
                        el.setSelectionRange(newPos, newPos);
                    } catch (e) { }
                }

                document.addEventListener('DOMContentLoaded', function () {
                    const getVal = (id) => parseRawNumber(document.getElementById(id)?.value);
                    const setVal = (id, numVal) => {
                        const el = document.getElementById(id);
                        if (el) el.value = formatAmount(Math.max(0, numVal));
                    };

                    const directDepositSection = document.getElementById('directDepositSection');
                    const refundRadio = document.getElementById('line15b_refund');
                    const nextRadio = document.getElementById('line15b_next');
                    const line15c = document.getElementById('line15c');
                    const line15e = document.getElementById('line15e');
                    const err15c = document.getElementById('err_15c');
                    const err15e = document.getElementById('err_15e');

                    function setRedBorder(el, isError, errDiv) {
                        if (!el) return;
                        if (isError) {
                            el.style.border = '2px solid #dc3545';
                            el.style.boxShadow = '0 0 0 0.25rem rgba(220, 53, 69, 0.25)';
                            if (errDiv) errDiv.style.display = 'block';
                        } else {
                            el.style.border = '';
                            el.style.boxShadow = '';
                            if (errDiv) errDiv.style.display = 'none';
                        }
                    }

                    function validate15c() {
                        if (!refundRadio || !refundRadio.checked) {
                            setRedBorder(line15c, false, err15c);
                            return true;
                        }
                        if (!line15c) return true;
                        line15c.value = line15c.value.replace(/\D/g, '').substring(0, 9);
                        const isInvalid = (line15c.value.length !== 9);
                        setRedBorder(line15c, isInvalid, err15c);
                        return !isInvalid;
                    }

                    function validate15e() {
                        if (!refundRadio || !refundRadio.checked) {
                            setRedBorder(line15e, false, err15e);
                            return true;
                        }
                        if (!line15e) return true;
                        line15e.value = line15e.value.replace(/\D/g, '').substring(0, 17);
                        const isInvalid = (line15e.value.length !== 17);
                        setRedBorder(line15e, isInvalid, err15e);
                        return !isInvalid;
                    }

                    function toggleDirectDeposit() {
                        if (refundRadio && refundRadio.checked) {
                            if (directDepositSection) directDepositSection.style.display = 'block';
                            validate15c();
                            validate15e();
                        } else {
                            if (directDepositSection) directDepositSection.style.display = 'none';
                            setRedBorder(line15c, false, err15c);
                            setRedBorder(line15e, false, err15e);
                        }
                    }

                    if (refundRadio) refundRadio.addEventListener('change', toggleDirectDeposit);
                    if (nextRadio) nextRadio.addEventListener('change', toggleDirectDeposit);

                    if (line15c) line15c.addEventListener('input', validate15c);
                    if (line15e) line15e.addEventListener('input', validate15e);

                    document.getElementById('form941Step2').addEventListener('submit', function (e) {
                        if (refundRadio && refundRadio.checked) {
                            const validC = validate15c();
                            const validE = validate15e();
                            if (!validC || !validE) {
                                e.preventDefault();
                                if (!validC) line15c.focus();
                                else if (!validE) line15e.focus();
                                return false;
                            }
                        }
                    });

                    function updateCalculations() {
                        const line3 = getVal('line3');
                        const l5a_wages = getVal('line5a_wages');
                        const l5b_tips = getVal('line5b_tips');
                        const l5c_wages = getVal('line5c_wages');
                        const l5d_wages = getVal('line5d_wages');

                        const SS_RATE_COMBINED = parseFloat('${ssRateCombined != null ? ssRateCombined : "0.124"}') || 0.124;
                        const MEDICARE_RATE_COMBINED = parseFloat('${medicareRateCombined != null ? medicareRateCombined : "0.029"}') || 0.029;
                        const ADDL_MEDICARE_RATE = parseFloat('${addlMedicareRate != null ? addlMedicareRate : "0.009"}') || 0.009;

                        const l5a_tax = l5a_wages * SS_RATE_COMBINED;
                        const l5b_tax = l5b_tips * SS_RATE_COMBINED;
                        const l5c_tax = l5c_wages * MEDICARE_RATE_COMBINED;
                        const l5d_tax = l5d_wages * ADDL_MEDICARE_RATE;

                        setVal('line5a_tax', l5a_tax);
                        setVal('line5b_tax', l5b_tax);
                        setVal('line5c_tax', l5c_tax);
                        setVal('line5d_tax', l5d_tax);

                        const line5e = l5a_tax + l5b_tax + l5c_tax + l5d_tax;
                        setVal('line5e', line5e);

                        const line5f = getVal('line5f');
                        const line6 = line3 + line5e + line5f;
                        setVal('line6', line6);

                        const line7 = getVal('line7');
                        const line8 = getVal('line8');
                        const line9 = getVal('line9');
                        const line10 = line6 + line7 + line8 + line9;
                        setVal('line10', line10);

                        const line11 = getVal('line11');
                        const line12 = Math.max(0, line10 - line11);
                        setVal('line12', line12);

                        const line13 = getVal('line13');

                        const line15bRow = document.getElementById('line15b_row');

                        if (line12 > line13) {
                            const balanceDue = line12 - line13;
                            setVal('line14', balanceDue);
                            setVal('line15', 0);
                            if (line15bRow) line15bRow.style.display = 'none';
                        } else if (line13 > line12) {
                            const overpayment = line13 - line12;
                            setVal('line14', 0);
                            setVal('line15', overpayment);
                            if (line15bRow) line15bRow.style.display = 'block';
                            toggleDirectDeposit();
                        } else {
                            setVal('line14', 0);
                            setVal('line15', 0);
                            if (line15bRow) line15bRow.style.display = 'none';
                        }
                    }

                    document.querySelectorAll('.amount-input').forEach(el => {
                        if (el.value) {
                            el.value = formatAmount(el.value);
                        }

                        el.addEventListener('input', function () {
                            applyRealTimeFormatting(this);
                            if (this.classList.contains('calc-trigger')) {
                                updateCalculations();
                            }
                        });

                        el.addEventListener('blur', function () {
                            if (this.value) {
                                this.value = formatAmount(this.value);
                            }
                        });
                    });

                    updateCalculations();
                });
            </script>
        </body>

        </html>