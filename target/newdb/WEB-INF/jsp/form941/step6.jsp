<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form 941 - Step 6: Review & Submit</title>
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
            <% request.setAttribute("pageTitle", "Form 941 - Step 6: Review" ); %>
            <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

            <!-- Wizard Content -->
            <div class="content-area p-4" style="max-width: 1100px; margin: 0 auto;">
                <div class="tm-card border-success border-2 shadow p-4 rounded-4 bg-white">
                    <% request.setAttribute("currentStep", 6); %>
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

                    <div class="text-center mb-4">
                        <h2 class="fw-bold" style="color: var(--primary-blue);">Review Form 941</h2>
                        <p class="text-muted">Review all lines below. IRS-style validations and calculations have been processed by the Calculation & Validation Engine.</p>
                    </div>

                    <!-- IRS Validation Engine Message Banner -->
                    <c:if test="${not empty validationErrors}">
                        <div class="alert alert-warning mb-4 shadow-sm" role="alert">
                            <h6 class="fw-bold mb-2">📋 IRS Validation Engine Findings (${validationErrors.size()} finding(s)):</h6>
                            <ul class="mb-0 ps-3">
                                <c:forEach var="err" items="${validationErrors}">
                                    <li>
                                        <span class="badge ${err.severity == 'ERROR' ? 'bg-danger' : 'bg-warning text-dark'} me-1">${err.severity}</span>
                                        <strong>Line ${err.fieldName}</strong> (${err.errorCode}): ${err.errorMessage}
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                    <form action="<%= request.getContextPath() %>/form941/submitInternal" method="POST">
                        <input type="hidden" name="form941Id" value="${formDTO.form941Id}">
                        <input type="hidden" name="employerId" value="${formDTO.employerId}">
                        <div class="accordion" id="reviewAccordion">
                            <!-- Return Header -->
                            <div class="accordion-item mb-3 border rounded-3 overflow-hidden">
                                <h2 class="accordion-header">
                                    <button class="accordion-button fw-bold text-primary" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne">
                                        Step 1: Return Header & Tax Period
                                    </button>
                                </h2>
                                <div id="collapseOne" class="accordion-collapse collapse show">
                                    <div class="accordion-body bg-light">
                                        <div class="row py-1">
                                            <div class="col-md-4 fw-bold">Return Status:</div>
                                            <div class="col-md-8">
                                                <span class="badge bg-primary px-3 py-2">${formDTO.status != null ? formDTO.status : 'DRAFT'}</span>
                                            </div>
                                        </div>
                                        <div class="row py-1">
                                            <div class="col-md-4 fw-bold">Tax Year / Quarter:</div>
                                            <div class="col-md-8">${formDTO.taxYear} / Quarter ${formDTO.quarter}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Part 1 Breakdown -->
                            <div class="accordion-item mb-3 border rounded-3 overflow-hidden">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed fw-bold text-primary" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo">
                                        Part 1: Detailed Tax Calculation Summary (Lines 1 - 15e)
                                    </button>
                                </h2>
                                <div id="collapseTwo" class="accordion-collapse collapse show">
                                    <div class="accordion-body bg-light">
                                        <div class="row py-1 border-bottom">
                                            <div class="col-md-8">1. Number of employees who received compensation</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold">${formDTO.getLineValue('1') != null ? formDTO.getLineValue('1') : '0'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom">
                                            <div class="col-md-8">2. Wages, tips, and other compensation</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('2') != null ? formDTO.getLineValue('2') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom">
                                            <div class="col-md-8">3. Federal income tax withheld</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('3') != null ? formDTO.getLineValue('3') : '0.00'}</div>
                                        </div>

                                        <div class="row py-1 border-bottom bg-white">
                                            <div class="col-md-8">5a. Taxable social security wages tax (x ${ssRateCombined != null ? ssRateCombined : '0.124'})</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('5a_tax') != null ? formDTO.getLineValue('5a_tax') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom bg-white">
                                            <div class="col-md-8">5b. Taxable social security tips tax (x ${ssRateCombined != null ? ssRateCombined : '0.124'})</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('5b_tax') != null ? formDTO.getLineValue('5b_tax') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom bg-white">
                                            <div class="col-md-8">5c. Taxable Medicare wages tax (x ${medicareRateCombined != null ? medicareRateCombined : '0.029'})</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('5c_tax') != null ? formDTO.getLineValue('5c_tax') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom bg-white">
                                            <div class="col-md-8">5d. Additional Medicare tax (x ${addlMedicareRate != null ? addlMedicareRate : '0.009'})</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('5d_tax') != null ? formDTO.getLineValue('5d_tax') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom text-primary bg-white">
                                            <div class="col-md-8 fw-bold">5e. Total social security and Medicare taxes</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('5e') != null ? formDTO.getLineValue('5e') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom">
                                            <div class="col-md-8">5f. Section 3121(q) Notice and Demand—Tax due on unreported tips</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('5f') != null ? formDTO.getLineValue('5f') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom text-primary">
                                            <div class="col-md-8 fw-bold">06. Total taxes before adjustments (Add lines 3, 5e, and 5f)</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('6') != null ? formDTO.getLineValue('6') : '0.00'}</div>
                                        </div>

                                        <div class="row py-1 border-bottom bg-white">
                                            <div class="col-md-8">07. Current quarter’s adjustment for fractions of cents</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('7') != null ? formDTO.getLineValue('7') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom bg-white">
                                            <div class="col-md-8">08. Current quarter’s adjustment for sick pay</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('8') != null ? formDTO.getLineValue('8') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom bg-white">
                                            <div class="col-md-8">09. Current quarter’s adjustments for tips and group-term life insurance</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('9') != null ? formDTO.getLineValue('9') : '0.00'}</div>
                                        </div>

                                        <div class="row py-1 border-bottom text-primary">
                                            <div class="col-md-8 fw-bold">10. Total taxes after adjustments (Combine lines 6 through 9)</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('10') != null ? formDTO.getLineValue('10') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom">
                                            <div class="col-md-8">11. Qualified small business payroll tax credit for increasing research activities (Form 8974)</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('11') != null ? formDTO.getLineValue('11') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom text-success bg-white">
                                            <div class="col-md-8 fw-bold">12. Total taxes after adjustments and nonrefundable credits (Subtract line 11 from line 10)</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('12') != null ? formDTO.getLineValue('12') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom">
                                            <div class="col-md-8">13. Total deposits for this quarter, including overpayments</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('13') != null ? formDTO.getLineValue('13') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom text-danger bg-white">
                                            <div class="col-md-8 fw-bold">14. Balance due (If line 12 is more than line 13)</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('14') != null ? formDTO.getLineValue('14') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 border-bottom text-success bg-white">
                                            <div class="col-md-8 fw-bold">15a. Overpayment (If line 13 is more than line 12)</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('15') != null ? formDTO.getLineValue('15') : '0.00'}</div>
                                        </div>
                                        <div class="row py-1 text-primary bg-white">
                                            <div class="col-md-8 fw-bold">15b. Overpayment Election</div>
                                            <div class="col-md-4 text-end font-monospace fw-bold">
                                                <span class="badge ${formDTO.getLineValue('15b') == 'SEND_REFUND' ? 'bg-success' : 'bg-primary'} px-3 py-2">
                                                    ${formDTO.getLineValue('15b') == 'SEND_REFUND' ? 'Send a refund' : 'Apply to next return'}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Lines 15c, 15d, 15e: Direct Deposit Refund Details - COLLAPSED BY DEFAULT -->
                            <c:if test="${formDTO.getLineValue('15b') == 'SEND_REFUND'}">
                                <div class="accordion-item mb-3 border rounded-3 overflow-hidden">
                                    <h2 class="accordion-header">
                                        <button class="accordion-button collapsed fw-bold text-success" type="button" data-bs-toggle="collapse" data-bs-target="#collapseDirectDeposit" aria-expanded="false" aria-controls="collapseDirectDeposit">
                                            Lines 15c, 15d, 15e: Direct Deposit Information for Refund
                                        </button>
                                    </h2>
                                    <div id="collapseDirectDeposit" class="accordion-collapse collapse">
                                        <div class="accordion-body bg-light">
                                            <div class="p-3 bg-white border rounded-3 shadow-sm">
                                                <div class="row py-2 border-bottom">
                                                    <div class="col-md-6 fw-bold">15c. Routing Number:</div>
                                                    <div class="col-md-6 font-monospace fw-bold text-primary">${formDTO.getLineValue('15c')}</div>
                                                </div>
                                                <div class="row py-2 border-bottom">
                                                    <div class="col-md-6 fw-bold">15d. Account Type:</div>
                                                    <div class="col-md-6 fw-bold">
                                                        <span class="badge bg-secondary px-3 py-2">${formDTO.getLineValue('15d') != null ? formDTO.getLineValue('15d') : 'CHECKING'}</span>
                                                    </div>
                                                </div>
                                                <div class="row py-2">
                                                    <div class="col-md-6 fw-bold">15e. Account Number:</div>
                                                    <div class="col-md-6 font-monospace fw-bold text-primary">${formDTO.getLineValue('15e')}</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Part 2 Breakdown (Line 16 Deposit Schedule) - COLLAPSED BY DEFAULT -->
                            <c:set var="opt16" value="${formDTO.getLineValue('16')}" />
                            <div class="accordion-item mb-3 border rounded-3 overflow-hidden">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed fw-bold text-primary" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                        Part 2: Deposit Schedule & Tax Liability (Line 16)
                                    </button>
                                </h2>
                                <div id="collapseThree" class="accordion-collapse collapse">
                                    <div class="accordion-body bg-light">
                                        <div class="row py-2 border-bottom align-items-center bg-white p-3 rounded-3 mb-3 shadow-sm">
                                            <div class="col-md-6 fw-bold fs-6">16. Deposit Schedule & Tax Liability Status:</div>
                                            <div class="col-md-6 text-md-end">
                                                <c:choose>
                                                    <c:when test="${opt16 == 'lessThan2500' || opt16 == '1'}">
                                                        <span class="badge bg-secondary px-3 py-2 fs-6">Option 1: Line 12 is less than $2,500</span>
                                                    </c:when>
                                                    <c:when test="${opt16 == 'monthly' || opt16 == '2'}">
                                                        <span class="badge bg-primary px-3 py-2 fs-6">Option 2: Monthly Schedule Depositor</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-success px-3 py-2 fs-6">Option 3: Semiweekly Schedule Depositor</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <!-- Option 1 Details -->
                                        <c:if test="${opt16 == 'lessThan2500' || opt16 == '1'}">
                                            <div class="p-3 bg-white border rounded-3 mt-3 shadow-sm">
                                                <p class="mb-0 text-muted">Line 12 on this return is less than $2,500 or line 12 on the return for the prior quarter was less than $2,500. No separate tax liability schedule (Schedule B) is required for Option 1.</p>
                                            </div>
                                        </c:if>

                                        <!-- Option 2 Monthly Details -->
                                        <c:if test="${opt16 == 'monthly' || opt16 == '2'}">
                                            <div class="p-3 bg-white border rounded-3 mt-3 shadow-sm">
                                                <h6 class="fw-bold text-primary mb-3">Monthly Tax Liability Record</h6>
                                                <div class="row py-1 border-bottom">
                                                    <div class="col-md-8">Month 1 Tax Liability:</div>
                                                    <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('16_m1')}</div>
                                                </div>
                                                <div class="row py-1 border-bottom">
                                                    <div class="col-md-8">Month 2 Tax Liability:</div>
                                                    <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('16_m2')}</div>
                                                </div>
                                                <div class="row py-1 border-bottom">
                                                    <div class="col-md-8">Month 3 Tax Liability:</div>
                                                    <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('16_m3')}</div>
                                                </div>
                                                <div class="row py-1 text-primary fw-bold">
                                                    <div class="col-md-8">Total Quarter Liability:</div>
                                                    <div class="col-md-4 text-end font-monospace fs-6 format-amt">${formDTO.getLineValue('16_total')}</div>
                                                </div>
                                            </div>
                                        </c:if>

                                        <!-- Option 3 Semiweekly Schedule B Summary & View Schedule B Button -->
                                        <c:if test="${opt16 == 'semiweekly' || opt16 == '3' || empty opt16}">
                                            <div class="p-3 bg-white border rounded-3 mt-3 shadow-sm">
                                                <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3 border-bottom pb-3">
                                                    <div>
                                                        <h6 class="fw-bold text-primary m-0 fs-6">Schedule B (Form 941) Report of Tax Liability</h6>
                                                        <small class="text-muted">Daily Tax Liability Breakdown for Semiweekly Schedule Depositor</small>
                                                    </div>
                                                    <button type="button" class="btn btn-primary fw-bold px-4 py-2 rounded-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#scheduleBModal">
                                                        🔍 View Schedule B
                                                    </button>
                                                </div>

                                                <div class="row py-1 border-bottom">
                                                    <div class="col-md-8">Month 1 Liability Total:</div>
                                                    <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('sb_m1_total')}</div>
                                                </div>
                                                <div class="row py-1 border-bottom">
                                                    <div class="col-md-8">Month 2 Liability Total:</div>
                                                    <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('sb_m2_total')}</div>
                                                </div>
                                                <div class="row py-1 border-bottom">
                                                    <div class="col-md-8">Month 3 Liability Total:</div>
                                                    <div class="col-md-4 text-end font-monospace fw-bold format-amt">${formDTO.getLineValue('sb_m3_total')}</div>
                                                </div>
                                                <div class="row py-1 text-primary fw-bold">
                                                    <div class="col-md-8">Total Liability for Quarter (Schedule B):</div>
                                                    <div class="col-md-4 text-end font-monospace fs-6 format-amt">${formDTO.getLineValue('sb_quarter_total')}</div>
                                                </div>
                                            </div>
                                        </c:if>

                                    </div>
                                </div>
                            </div>
                        </div>

                        <hr class="my-4">

                        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                            <c:choose>
                                <c:when test="${formDTO.status == 'SUBMITTED'}">
                                    <a href="<%= request.getContextPath() %>/filings" class="btn btn-outline-secondary px-4">&lt;&lt; Back to Filings</a>
                                    <div>
                                        <a href="<%= request.getContextPath() %>/form941/viewXml?id=${formDTO.form941Id}" target="_blank" class="btn btn-outline-info px-3 me-2">📄 View IRS XML</a>
                                        <a href="<%= request.getContextPath() %>/form941/exportXml?id=${formDTO.form941Id}" class="btn btn-outline-secondary px-3 me-2">💾 Download IRS XML</a>
                                        <span class="badge bg-success-subtle text-success px-4 py-2 fs-6 rounded-pill fw-bold border border-success">✓ Return Submitted & Saved</span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <a href="<%= request.getContextPath() %>/form941/step5" class="btn btn-outline-secondary px-4">&lt;&lt; Edit Form</a>
                                    <div>
                                        <a href="<%= request.getContextPath() %>/form941/viewXml" target="_blank" class="btn btn-outline-info px-3 me-2">📄 Preview XML</a>
                                        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline-primary px-4 me-2">Save Draft & Exit</a>
                                        <button type="submit" class="btn btn-success px-5 py-2 fw-bold" style="font-size: 1.05rem;">Submit Return to IRS</button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- SCHEDULE B POPUP MODAL DIALOG -->
    <div class="modal fade" id="scheduleBModal" tabindex="-1" aria-labelledby="scheduleBModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold" id="scheduleBModalLabel">Schedule B (Form 941) Report of Tax Liability for Semiweekly Schedule Depositors</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4 bg-light">
                    <!-- Month 1 Grid -->
                    <div class="card mb-4 border-0 bg-white shadow-sm p-3 rounded-3">
                        <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                            <h6 class="fw-bold m-0 text-dark">Month 1 Daily Tax Liability</h6>
                            <span class="fw-bold text-primary">Month 1 Total: $<span class="format-amt">${formDTO.getLineValue('sb_m1_total')}</span></span>
                        </div>
                        <div class="row g-2">
                            <c:forEach var="d" begin="1" end="31">
                                <c:set var="fn1" value="sb_m1_d${d}" />
                                <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                                    <div class="p-2 border rounded bg-light text-center">
                                        <small class="text-muted d-block fw-bold">Day ${d}</small>
                                        <span class="font-monospace fw-bold small format-amt">${formDTO.getLineValue(fn1) != null ? formDTO.getLineValue(fn1) : '0.00'}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Month 2 Grid -->
                    <div class="card mb-4 border-0 bg-white shadow-sm p-3 rounded-3">
                        <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                            <h6 class="fw-bold m-0 text-dark">Month 2 Daily Tax Liability</h6>
                            <span class="fw-bold text-primary">Month 2 Total: $<span class="format-amt">${formDTO.getLineValue('sb_m2_total')}</span></span>
                        </div>
                        <div class="row g-2">
                            <c:forEach var="d" begin="1" end="31">
                                <c:set var="fn2" value="sb_m2_d${d}" />
                                <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                                    <div class="p-2 border rounded bg-light text-center">
                                        <small class="text-muted d-block fw-bold">Day ${d}</small>
                                        <span class="font-monospace fw-bold small format-amt">${formDTO.getLineValue(fn2) != null ? formDTO.getLineValue(fn2) : '0.00'}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Month 3 Grid -->
                    <div class="card mb-4 border-0 bg-white shadow-sm p-3 rounded-3">
                        <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                            <h6 class="fw-bold m-0 text-dark">Month 3 Daily Tax Liability</h6>
                            <span class="fw-bold text-primary">Month 3 Total: $<span class="format-amt">${formDTO.getLineValue('sb_m3_total')}</span></span>
                        </div>
                        <div class="row g-2">
                            <c:forEach var="d" begin="1" end="31">
                                <c:set var="fn3" value="sb_m3_d${d}" />
                                <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                                    <div class="p-2 border rounded bg-light text-center">
                                        <small class="text-muted d-block fw-bold">Day ${d}</small>
                                        <span class="font-monospace fw-bold small format-amt">${formDTO.getLineValue(fn3) != null ? formDTO.getLineValue(fn3) : '0.00'}</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="card p-3 bg-primary text-white rounded-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="fw-bold fs-6">Total Tax Liability for Quarter (Schedule B):</span>
                            <span class="font-monospace fs-5 fw-bold">$<span class="format-amt">${formDTO.getLineValue('sb_quarter_total')}</span></span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary px-4 rounded-3" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
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

        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.format-amt').forEach(function (el) {
                const txt = el.innerText.trim();
                if (txt) {
                    const hasDollar = txt.startsWith('$');
                    const cleanTxt = hasDollar ? txt.substring(1) : txt;
                    el.innerText = (hasDollar ? '$' : '') + formatAmount(cleanTxt);
                }
            });
        });
    </script>
</body>

</html>