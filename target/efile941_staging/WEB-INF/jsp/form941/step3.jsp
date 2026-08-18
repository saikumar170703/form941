<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form 941 - Step 3: Part 2 Deposit Schedule</title>
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
            <% request.setAttribute("pageTitle", "Form 941 - Part 2: Deposit Schedule" ); %>
            <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

            <!-- Wizard Content -->
            <div class="content-area">
                <div class="tm-card p-3 p-md-4 rounded-4 bg-white shadow-sm">
                    <% request.setAttribute("currentStep", 3); %>
                    <jsp:include page="/WEB-INF/jsp/layout/progress.jsp" />

                    <!-- Read-Only Banner for Submitted Returns -->
                    <c:if test="${formDTO.status == 'SUBMITTED'}">
                        <div class="alert alert-info border-info border-2 rounded-3 shadow-sm mb-4">
                            <div class="d-flex align-items-center">
                                <span class="fs-4 me-2">🔒</span>
                                <div>
                                    <h6 class="fw-bold m-0">Submitted Return #${formDTO.form941Id} (Read-Only Mode)</h6>
                                    <small>This return has already been submitted to the IRS and cannot be edited.</small>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <h4 class="fw-bold mb-4" style="color: var(--primary-blue);">Part 2: Tell us about your deposit schedule and tax liability for this quarter.</h4>

                    <!-- Dynamic Error Alert Banner -->
                    <div id="mismatchBanner" class="alert alert-danger shadow-sm mb-4 border-danger border-2 d-none" role="alert">
                        <div class="d-flex align-items-center">
                            <span class="fs-4 me-2">🛑</span>
                            <div>
                                <h6 class="fw-bold mb-1">IRS Rule 941-DEP-01 Validation Error</h6>
                                <p class="mb-0 small" id="mismatchBannerText">Total quarterly deposit liability must equal Line 12. Proceed button is disabled until values match.</p>
                            </div>
                        </div>
                    </div>

                    <form action="<%= request.getContextPath() %>/form941/step4" method="POST" id="step3Form">
                        <div class="mb-4">
                            <div class="row mb-3 align-items-start g-3">
                                <div class="col-12 col-md-2 fw-bold text-dark fs-6">16. Check one:</div>
                                <div class="col-12 col-md-10">

                                    <!-- Option 1: Less than $2500 -->
                                    <div class="form-check mb-4 p-3 border rounded-3 bg-white shadow-sm">
                                        <input class="form-check-input ms-0 me-3" type="radio" name="16" id="line16a" value="lessThan2500"
                                            ${formDTO.getLineValue('16')=='lessThan2500' || formDTO.getLineValue('16')=='1' || empty formDTO.getLineValue('16') ? 'checked' : '' }>
                                        <label class="form-check-label text-dark cursor-pointer" for="line16a" style="line-height: 1.6;">
                                            <strong>Line 12 on this return is less than $2,500 or line 12 on the return for the prior quarter was less than $2,500, and you didn’t incur a $100,000 next-day deposit obligation during the current quarter.</strong>
                                            <span class="text-muted d-block mt-1">Go to Part 3.</span>
                                        </label>
                                    </div>

                                    <!-- Option 2: Monthly Schedule Depositor -->
                                    <div class="form-check mb-4 p-3 border rounded-3 bg-white shadow-sm">
                                        <input class="form-check-input ms-0 me-3" type="radio" name="16" id="line16b" value="monthly"
                                            ${formDTO.getLineValue('16')=='monthly' || formDTO.getLineValue('16')=='2' ? 'checked' : '' }>
                                        <label class="form-check-label text-dark mb-3 cursor-pointer" for="line16b" style="line-height: 1.6;">
                                            <strong>You were a monthly schedule depositor for the entire quarter.</strong> Enter your tax liability for each month and total liability for the quarter, then go to Part 3.
                                        </label>

                                        <!-- Monthly Inputs Section -->
                                        <div class="mt-2 p-3 bg-light rounded-3 border d-none" id="monthlySection">
                                            <div class="row align-items-center mb-2 g-2">
                                                <div class="col-12 col-sm-3 text-secondary text-sm-end">Tax liability:</div>
                                                <div class="col-12 col-sm-2 text-secondary text-sm-end">Month 1</div>
                                                <div class="col-12 col-sm-6 col-md-4">
                                                    <input type="text" class="form-control text-end m-liability amount-input" name="16_m1" id="m1"
                                                        value="${formDTO.getLineValue('16_m1') != null ? formDTO.getLineValue('16_m1') : '0.00'}" placeholder="0.00">
                                                </div>
                                            </div>

                                            <div class="row align-items-center mb-2 g-2">
                                                <div class="col-12 col-sm-3"></div>
                                                <div class="col-12 col-sm-2 text-secondary text-sm-end">Month 2</div>
                                                <div class="col-12 col-sm-6 col-md-4">
                                                    <input type="text" class="form-control text-end m-liability amount-input" name="16_m2" id="m2"
                                                        value="${formDTO.getLineValue('16_m2') != null ? formDTO.getLineValue('16_m2') : '0.00'}" placeholder="0.00">
                                                </div>
                                            </div>

                                            <div class="row align-items-center mb-3 g-2">
                                                <div class="col-12 col-sm-3"></div>
                                                <div class="col-12 col-sm-2 text-secondary text-sm-end">Month 3</div>
                                                <div class="col-12 col-sm-6 col-md-4">
                                                    <input type="text" class="form-control text-end m-liability amount-input" name="16_m3" id="m3"
                                                        value="${formDTO.getLineValue('16_m3') != null ? formDTO.getLineValue('16_m3') : '0.00'}" placeholder="0.00">
                                                </div>
                                            </div>

                                            <div class="row align-items-center mt-3 pt-3 border-top g-2">
                                                <div class="col-12 col-sm-5 text-secondary text-sm-end fw-bold">Total liability for quarter :</div>
                                                <div class="col-12 col-sm-4">
                                                    <input type="text" class="form-control text-end bg-white fw-bold text-primary amount-input" name="16_total" id="mtotal"
                                                        value="${formDTO.getLineValue('16_total') != null ? formDTO.getLineValue('16_total') : '0.00'}" readonly>
                                                </div>
                                                <div class="col-12 col-sm-3 text-muted small" id="statusMsg">
                                                    Total must equal line 12. <strong class="text-primary" id="line12MonthlyTarget">$${formDTO.getLineValue('12') != null ? formDTO.getLineValue('12') : '0.00'}</strong>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Option 3: Semiweekly Schedule Depositor -->
                                    <div class="form-check mb-4 p-3 border rounded-3 bg-white shadow-sm">
                                        <input class="form-check-input ms-0 me-3" type="radio" name="16" id="line16c" value="semiweekly"
                                            ${formDTO.getLineValue('16')=='semiweekly' || formDTO.getLineValue('16')=='3' ? 'checked' : '' }>
                                        <label class="form-check-label text-dark cursor-pointer" for="line16c" style="line-height: 1.6;">
                                            <strong>You were a semiweekly schedule depositor for any part of this quarter.</strong> Complete Schedule B (Form 941), Report of Tax Liability for Semiweekly Schedule Depositors below.
                                        </label>

                                        <!-- Container for Option 3 Schedule B Fields -->
                                        <div id="option3_container" class="mt-3"></div>
                                    </div>

                                    <!-- SCHEDULE B (FORM 941) DAILY TAX LIABILITY GRID SECTION (ONLY FOR OPTION 3) -->
                                    <div class="p-3 p-md-4 border border-2 border-primary-subtle rounded-4 bg-white shadow-sm d-none" id="scheduleBSection">
                                        <div class="d-flex justify-content-between align-items-center mb-3 pb-3 border-bottom flex-wrap gap-2">
                                            <div>
                                                <h5 class="fw-bold text-primary m-0">Schedule B (Form 941)</h5>
                                                <small class="text-muted">Report of Tax Liability for Semiweekly Schedule Depositors (Daily Breakdown)</small>
                                            </div>
                                            <span class="badge bg-primary-subtle text-primary fw-bold px-3 py-2 rounded-pill">IRS Form 941 Schedule B</span>
                                        </div>

                                        <p class="text-muted small mb-4">
                                            Use this schedule to show your <strong>TAX LIABILITY</strong> for each day of the quarter. Enter your daily tax liability on the space that corresponds to the date wages were paid.
                                        </p>

                                        <!-- MONTH 1 BLOCK -->
                                        <div class="card mb-4 border-0 bg-light shadow-sm p-3 rounded-3">
                                            <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom flex-wrap gap-2">
                                                <h6 class="fw-bold m-0 text-dark">Month 1 Tax Liability Record</h6>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="fw-bold small text-secondary">Tax liability for Month 1:</span>
                                                    <input type="text" class="form-control form-control-sm text-end fw-bold text-primary bg-white amount-input" 
                                                           style="width: 140px;" name="sb_m1_total" id="sb_m1_total" 
                                                           value="${formDTO.getLineValue('sb_m1_total') != null ? formDTO.getLineValue('sb_m1_total') : '0.00'}" readonly>
                                                </div>
                                            </div>

                                            <div class="row g-2">
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="1" end="8">
                                                        <c:set var="fn" value="sb_m1_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m1-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="9" end="16">
                                                        <c:set var="fn" value="sb_m1_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m1-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="17" end="24">
                                                        <c:set var="fn" value="sb_m1_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m1-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="25" end="31">
                                                        <c:set var="fn" value="sb_m1_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m1-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- MONTH 2 BLOCK -->
                                        <div class="card mb-4 border-0 bg-light shadow-sm p-3 rounded-3">
                                            <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom flex-wrap gap-2">
                                                <h6 class="fw-bold m-0 text-dark">Month 2 Tax Liability Record</h6>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="fw-bold small text-secondary">Tax liability for Month 2:</span>
                                                    <input type="text" class="form-control form-control-sm text-end fw-bold text-primary bg-white amount-input" 
                                                           style="width: 140px;" name="sb_m2_total" id="sb_m2_total" 
                                                           value="${formDTO.getLineValue('sb_m2_total') != null ? formDTO.getLineValue('sb_m2_total') : '0.00'}" readonly>
                                                </div>
                                            </div>

                                            <div class="row g-2">
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="1" end="8">
                                                        <c:set var="fn" value="sb_m2_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m2-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="9" end="16">
                                                        <c:set var="fn" value="sb_m2_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m2-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="17" end="24">
                                                        <c:set var="fn" value="sb_m2_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m2-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="25" end="31">
                                                        <c:set var="fn" value="sb_m2_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m2-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- MONTH 3 BLOCK -->
                                        <div class="card mb-4 border-0 bg-light shadow-sm p-3 rounded-3">
                                            <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom flex-wrap gap-2">
                                                <h6 class="fw-bold m-0 text-dark">Month 3 Tax Liability Record</h6>
                                                <div class="d-flex align-items-center gap-2">
                                                    <span class="fw-bold small text-secondary">Tax liability for Month 3:</span>
                                                    <input type="text" class="form-control form-control-sm text-end fw-bold text-primary bg-white amount-input" 
                                                           style="width: 140px;" name="sb_m3_total" id="sb_m3_total" 
                                                           value="${formDTO.getLineValue('sb_m3_total') != null ? formDTO.getLineValue('sb_m3_total') : '0.00'}" readonly>
                                                </div>
                                            </div>

                                            <div class="row g-2">
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="1" end="8">
                                                        <c:set var="fn" value="sb_m3_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m3-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="9" end="16">
                                                        <c:set var="fn" value="sb_m3_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m3-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="17" end="24">
                                                        <c:set var="fn" value="sb_m3_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m3-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <div class="col-12 col-sm-6 col-md-3">
                                                    <c:forEach var="d" begin="25" end="31">
                                                        <c:set var="fn" value="sb_m3_d${d}" />
                                                        <div class="input-group input-group-sm mb-1">
                                                            <span class="input-group-text bg-white text-muted font-monospace" style="width: 32px; justify-content: center;">${d}</span>
                                                            <input type="text" class="form-control text-end sb-input sb-m3-input amount-input" name="${fn}" id="${fn}" value="${formDTO.getLineValue(fn) != null ? formDTO.getLineValue(fn) : ''}" placeholder="0.00">
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- TOTAL LIABILITY FOR QUARTER BLOCK -->
                                        <div class="card p-3 bg-white border-2 border-primary shadow-sm rounded-3 mt-3">
                                            <div class="row align-items-center g-2">
                                                <div class="col-12 col-md-7">
                                                    <h6 class="fw-bold mb-1 text-dark">Total liability for the quarter (Month 1 + Month 2 + Month 3)</h6>
                                                    <small class="text-muted">Must equal Line 12 on Form 941 ($<span id="targetLine12Display">${formDTO.getLineValue('12') != null ? formDTO.getLineValue('12') : '0.00'}</span>)</small>
                                                </div>
                                                <div class="col-12 col-md-5">
                                                    <input type="text" class="form-control form-control-lg text-end bg-light fw-bold text-primary amount-input" 
                                                           name="sb_quarter_total" id="sb_quarter_total" 
                                                           value="${formDTO.getLineValue('sb_quarter_total') != null ? formDTO.getLineValue('sb_quarter_total') : '0.00'}" readonly>
                                                </div>
                                            </div>
                                            <div class="mt-2 text-end" id="sbStatusMsg"></div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <hr class="my-4">

                        <div class="d-flex justify-content-between flex-wrap gap-2">
                            <a href="<%= request.getContextPath() %>/form941/step2" class="btn btn-outline-secondary px-4">Back</a>
                            <c:choose>
                                <c:when test="${formDTO.status == 'SUBMITTED'}">
                                    <a href="<%= request.getContextPath() %>/form941/step4" class="btn btn-primary px-5">View Step 4 &raquo;</a>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" id="btnProceed" class="btn btn-primary px-5" style="background-color: #2563EB; border: none;">Proceed</button>
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
            document.addEventListener('DOMContentLoaded', function() {
                document.querySelectorAll('#step3Form input, #step3Form select, #step3Form textarea').forEach(function(el) {
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

        // Real-time comma formatting as user types digits
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
            } catch (e) {}
        }

        document.addEventListener('DOMContentLoaded', function () {
            const m1 = document.getElementById('m1');
            const m2 = document.getElementById('m2');
            const m3 = document.getElementById('m3');
            const mtotal = document.getElementById('mtotal');
            const btnProceed = document.getElementById('btnProceed');
            const statusMsg = document.getElementById('statusMsg');
            const sbStatusMsg = document.getElementById('sbStatusMsg');
            const mismatchBanner = document.getElementById('mismatchBanner');
            const mismatchBannerText = document.getElementById('mismatchBannerText');
            const targetLine12 = parseRawNumber("${formDTO.getLineValue('12') != null ? formDTO.getLineValue('12') : '0.00'}");

            // Display target line 12 with formatting
            const targetDisplayEl = document.getElementById('targetLine12Display');
            if (targetDisplayEl) targetDisplayEl.innerText = formatAmount(targetLine12);
            const line12MonthlyTargetEl = document.getElementById('line12MonthlyTarget');
            if (line12MonthlyTargetEl) line12MonthlyTargetEl.innerText = '$' + formatAmount(targetLine12);

            function validateAndCalculate() {
                const selectedEl = document.querySelector('input[name="16"]:checked');
                const selectedOption = selectedEl ? selectedEl.value : 'lessThan2500';
                
                const monthlySec = document.getElementById('monthlySection');
                const schedBSec = document.getElementById('scheduleBSection');
                const option3Container = document.getElementById('option3_container');

                if (selectedOption === 'monthly' || selectedOption === '2') {
                    if (monthlySec) monthlySec.classList.remove('d-none');
                    if (schedBSec) schedBSec.classList.add('d-none');
                } else if (selectedOption === 'semiweekly' || selectedOption === '3') {
                    if (monthlySec) monthlySec.classList.add('d-none');
                    if (schedBSec && option3Container) {
                        if (schedBSec.parentElement !== option3Container) {
                            option3Container.appendChild(schedBSec);
                        }
                        schedBSec.classList.remove('d-none');
                    }
                } else {
                    // Option 1: lessThan2500 - Schedule B is NOT shown
                    if (monthlySec) monthlySec.classList.add('d-none');
                    if (schedBSec) schedBSec.classList.add('d-none');
                }

                // 1. Option 1 selected -> proceed immediately enabled
                if (selectedOption === 'lessThan2500' || selectedOption === '1') {
                    btnProceed.disabled = false;
                    btnProceed.style.pointerEvents = 'auto';
                    btnProceed.style.opacity = '1';
                    btnProceed.classList.remove('disabled');
                    if (mismatchBanner) mismatchBanner.classList.add('d-none');
                    return;
                }

                // 2. Calculate Monthly Section
                const v1 = parseRawNumber(m1.value);
                const v2 = parseRawNumber(m2.value);
                const v3 = parseRawNumber(m3.value);
                const totalMonthly = v1 + v2 + v3;
                if (mtotal) mtotal.value = formatAmount(totalMonthly);

                // 3. Calculate Schedule B Totals (Days 1..31 for Month 1, 2, 3)
                let sbTotalM1 = 0, sbTotalM2 = 0, sbTotalM3 = 0;
                document.querySelectorAll('.sb-m1-input').forEach(el => { sbTotalM1 += parseRawNumber(el.value); });
                document.querySelectorAll('.sb-m2-input').forEach(el => { sbTotalM2 += parseRawNumber(el.value); });
                document.querySelectorAll('.sb-m3-input').forEach(el => { sbTotalM3 += parseRawNumber(el.value); });

                const sbM1El = document.getElementById('sb_m1_total');
                const sbM2El = document.getElementById('sb_m2_total');
                const sbM3El = document.getElementById('sb_m3_total');
                const sbQEl = document.getElementById('sb_quarter_total');

                if (sbM1El) sbM1El.value = formatAmount(sbTotalM1);
                if (sbM2El) sbM2El.value = formatAmount(sbTotalM2);
                if (sbM3El) sbM3El.value = formatAmount(sbTotalM3);

                const sbQuarterTotal = sbTotalM1 + sbTotalM2 + sbTotalM3;
                if (sbQEl) sbQEl.value = formatAmount(sbQuarterTotal);

                // 4. Validation matching active section total against Line 12
                const isMonthly = (selectedOption === 'monthly' || selectedOption === '2');
                const activeTotal = isMonthly ? totalMonthly : sbQuarterTotal;
                const diff = Math.abs(activeTotal - targetLine12);

                if (diff > 0.001) {
                    btnProceed.disabled = true;
                    btnProceed.style.pointerEvents = 'none';
                    btnProceed.style.opacity = '0.5';
                    btnProceed.classList.add('disabled');

                    const errHtml = '<span class="text-danger fw-bold">⚠️ Total ($' + formatAmount(activeTotal) + ') != Line 12 ($' + formatAmount(targetLine12) + ')</span>';
                    if (statusMsg) statusMsg.innerHTML = errHtml;
                    if (sbStatusMsg) sbStatusMsg.innerHTML = errHtml;

                    if (mismatchBannerText) mismatchBannerText.innerText = 'Total quarterly deposit liability ($' + formatAmount(activeTotal) + ') does NOT equal Line 12 ($' + formatAmount(targetLine12) + '). Please adjust your tax liability values before proceeding.';
                    if (mismatchBanner) mismatchBanner.classList.remove('d-none');
                } else {
                    btnProceed.disabled = false;
                    btnProceed.style.pointerEvents = 'auto';
                    btnProceed.style.opacity = '1';
                    btnProceed.classList.remove('disabled');

                    const successHtml = '<span class="text-success fw-bold">✓ Total matches Line 12 ($' + formatAmount(targetLine12) + ').</span>';
                    if (statusMsg) statusMsg.innerHTML = successHtml;
                    if (sbStatusMsg) sbStatusMsg.innerHTML = successHtml;

                    if (mismatchBanner) mismatchBanner.classList.add('d-none');
                }
            }

            // Bind REAL-TIME amount formatting to all inputs
            document.querySelectorAll('.amount-input').forEach(el => {
                if (el.value) {
                    el.value = formatAmount(el.value);
                }

                // Real-time comma insertion as user types
                el.addEventListener('input', function () {
                    applyRealTimeFormatting(this);
                });

                // Pad decimals on blur
                el.addEventListener('blur', function () {
                    if (this.value) {
                        this.value = formatAmount(this.value);
                    }
                });
            });

            // Input listeners for Monthly section
            document.querySelectorAll('.m-liability').forEach(el => {
                el.addEventListener('input', validateAndCalculate);
            });

            // Input listeners for Schedule B daily inputs
            document.querySelectorAll('.sb-input').forEach(el => {
                el.addEventListener('input', validateAndCalculate);
            });

            // Radio button selection listeners
            document.querySelectorAll('input[name="16"]').forEach(el => {
                el.addEventListener('change', validateAndCalculate);
            });

            // Form submit validation
            document.getElementById('step3Form').addEventListener('submit', function (e) {
                const selectedEl = document.querySelector('input[name="16"]:checked');
                const selectedOption = selectedEl ? selectedEl.value : 'lessThan2500';
                
                if (selectedOption === 'lessThan2500' || selectedOption === '1') {
                    return true;
                }

                let activeTotal = 0;
                if (selectedOption === 'monthly' || selectedOption === '2') {
                    activeTotal = parseRawNumber(m1.value) + parseRawNumber(m2.value) + parseRawNumber(m3.value);
                } else {
                    let sbTotal = 0;
                    document.querySelectorAll('.sb-input').forEach(el => { sbTotal += parseRawNumber(el.value); });
                    activeTotal = sbTotal;
                }

                if (Math.abs(activeTotal - targetLine12) > 0.001) {
                    e.preventDefault();
                    alert('IRS Rule 941-DEP-01: Total liability ($' + formatAmount(activeTotal) + ') must equal Line 12 ($' + formatAmount(targetLine12) + '). Cannot proceed.');
                    return false;
                }
            });

            validateAndCalculate();
        });
    </script>
</body>

</html>