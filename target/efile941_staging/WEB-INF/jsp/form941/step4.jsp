<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form 941 - Step 4: Business Info & Designee</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<%= request.getContextPath() %>/css/style.css?v=2" rel="stylesheet">
    <!-- Modern Flatpickr Calendar CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/themes/material_blue.css">
</head>

<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

        <!-- Main Content Wrapper -->
        <div class="main-wrapper bg-light">
            <!-- Header -->
            <% request.setAttribute("pageTitle", "Form 941 - Step 4: Business Info" ); %>
            <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

            <!-- Wizard Content -->
            <div class="content-area">
                <div class="tm-card p-3 p-md-4 rounded-4 bg-white shadow-sm">
                    <% request.setAttribute("currentStep", 4); %>
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

                    <h4 class="fw-bold mb-4" style="color: var(--primary-blue);">Part 3: Tell us about your business</h4>

                    <form action="<%= request.getContextPath() %>/form941/step5" method="POST" id="step4Form">

                        <!-- Line 17 -->
                        <div class="p-3 border rounded-3 bg-light mb-4 shadow-sm">
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="checkbox" name="line17" id="line17" value="true"
                                    ${formDTO.getLineValue('line17') == 'true' || formDTO.getLineValue('17') == 'true' ? 'checked' : ''}>
                                <label class="form-check-label fw-bold cursor-pointer" for="line17">
                                    17. If your business has closed or you stopped paying wages, check here.
                                </label>
                            </div>
                            <div class="ms-4 row align-items-center g-2 mt-1">
                                <div class="col-auto text-secondary fw-semibold">Enter the final date you paid wages:</div>
                                <div class="col-auto">
                                    <div class="input-group">
                                        <span class="input-group-text bg-white border-end-0">📅</span>
                                        <input type="text" class="form-control border-start-0 modern-datepicker bg-white" name="finalDateWages" id="finalDateWages"
                                            value="${formDTO.getLineValue('finalDateWages') != null ? formDTO.getLineValue('finalDateWages') : formDTO.getLineValue('17_date')}"
                                            placeholder="mm/dd/yyyy">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Line 18 -->
                        <div class="p-3 border rounded-3 bg-light mb-4 shadow-sm">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="line18" id="line18" value="true"
                                    ${formDTO.getLineValue('line18') == 'true' || formDTO.getLineValue('18') == 'true' ? 'checked' : ''}>
                                <label class="form-check-label fw-bold cursor-pointer" for="line18">
                                    18. If you're a seasonal employer and you don't have to file a return for every quarter of the year, check here.
                                </label>
                            </div>
                        </div>

                        <!-- Line 19 (Others / Tax Plan Notes) -->
                        <div class="p-3 border rounded-3 bg-light mb-4 shadow-sm">
                            <label for="line19" class="form-label fw-bold text-dark fs-6 mb-2">
                                19. Others (The more you want to tell about your business tax plan)
                            </label>
                            <textarea class="form-control rounded-3 bg-white" name="19" id="line19" rows="3"
                                placeholder="Enter additional details or notes about your business tax plan (Optional)">${formDTO.getLineValue('19')}</textarea>
                            <small class="text-muted d-block mt-1">Optional: Provide any supplementary comments or details regarding your business tax planning for this quarter.</small>
                        </div>

                        <hr class="my-4">

                        <h4 class="fw-bold mb-3" style="color: var(--primary-blue);">Part 4: May we speak with your third-party designee?</h4>
                        <p class="text-secondary mb-4">Do you want to allow an employee, a paid tax preparer, or another person to discuss this return with the IRS?</p>

                        <div class="form-check mb-3 p-3 border rounded-3 bg-white shadow-sm">
                            <input class="form-check-input ms-0 me-3" type="radio" name="designeeChoice" id="designeeYes" value="yes"
                                ${formDTO.getLineValue('designeeChoice') == 'yes' ? 'checked' : ''}>
                            <label class="form-check-label fw-bold cursor-pointer" for="designeeYes">Yes</label>

                            <div class="mt-3 p-3 border rounded-3 bg-light" id="designeeSection" style="display: none;">
                                <div class="row g-3 mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Designee's name <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="designeeName" id="designeeName" value="${formDTO.getLineValue('designeeName')}">
                                        <div id="err_designeeName" style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">⚠️ Designee name is required.</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">Phone number <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control font-monospace" name="designeePhone" id="designeePhone" value="${formDTO.getLineValue('designeePhone')}" maxlength="14" placeholder="(111) 111-1111">
                                        <div id="err_designeePhone" style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">⚠️ Phone number must be 10 digits in (111) 111-1111 format.</div>
                                    </div>
                                </div>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold">5-digit PIN <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control font-monospace" name="designeePin" id="designeePin" maxlength="5" placeholder="5-digit PIN"
                                            value="${formDTO.getLineValue('designeePin')}">
                                        <div id="err_designeePin" style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">⚠️ PIN must be exactly 5 digits (numbers only).</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-check mb-4 p-3 border rounded-3 bg-white shadow-sm">
                            <input class="form-check-input ms-0 me-3" type="radio" name="designeeChoice" id="designeeNo" value="no"
                                ${formDTO.getLineValue('designeeChoice') != 'yes' ? 'checked' : ''}>
                            <label class="form-check-label fw-bold cursor-pointer" for="designeeNo">No</label>
                        </div>

                        <hr class="my-4">

                        <div class="d-flex justify-content-between flex-wrap gap-2">
                            <a href="<%= request.getContextPath() %>/form941/step3" class="btn btn-outline-secondary px-4">Back</a>
                            <c:choose>
                                <c:when test="${formDTO.status == 'SUBMITTED'}">
                                    <a href="<%= request.getContextPath() %>/form941/step5" class="btn btn-primary px-5">View Step 5 &raquo;</a>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" class="btn btn-primary px-5" style="background-color: #2563EB; border: none;">Proceed</button>
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
                document.querySelectorAll('#step4Form input, #step4Form select, #step4Form textarea').forEach(function(el) {
                    el.disabled = true;
                    el.readOnly = true;
                });
            });
        </script>
    </c:if>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Modern Flatpickr Calendar JS -->
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize Modern Flatpickr Date Picker
            flatpickr("#finalDateWages", {
                dateFormat: "m/d/Y",
                allowInput: true,
                animate: true
            });

            const yesRadio = document.getElementById('designeeYes');
            const noRadio = document.getElementById('designeeNo');
            const designeeSection = document.getElementById('designeeSection');

            const designeeName = document.getElementById('designeeName');
            const designeePhone = document.getElementById('designeePhone');
            const designeePin = document.getElementById('designeePin');

            function setRedBorder(el, isError, errId) {
                const errDiv = document.getElementById(errId);
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

            function formatPhoneNumber(val) {
                let digits = val.replace(/\D/g, '').substring(0, 10);
                if (digits.length === 0) return '';
                if (digits.length <= 3) return '(' + digits;
                if (digits.length <= 6) return '(' + digits.substring(0, 3) + ') ' + digits.substring(3);
                return '(' + digits.substring(0, 3) + ') ' + digits.substring(3, 6) + '-' + digits.substring(6);
            }

            function validateName() {
                if (!yesRadio.checked) return true;
                const isInvalid = !designeeName.value.trim();
                setRedBorder(designeeName, isInvalid, 'err_designeeName');
                return !isInvalid;
            }

            function validatePhone() {
                if (!yesRadio.checked) return true;
                let rawDigits = designeePhone.value.replace(/\D/g, '').substring(0, 10);
                designeePhone.value = formatPhoneNumber(designeePhone.value);
                const isInvalid = (rawDigits.length !== 10);
                setRedBorder(designeePhone, isInvalid, 'err_designeePhone');
                return !isInvalid;
            }

            function validatePin() {
                if (!yesRadio.checked) return true;
                designeePin.value = designeePin.value.replace(/\D/g, '').substring(0, 5);
                const isInvalid = (designeePin.value.length !== 5);
                setRedBorder(designeePin, isInvalid, 'err_designeePin');
                return !isInvalid;
            }

            function toggleDesignee() {
                if (yesRadio && yesRadio.checked) {
                    if (designeeSection) designeeSection.style.display = 'block';
                    validateName();
                    validatePhone();
                    validatePin();
                } else {
                    if (designeeSection) designeeSection.style.display = 'none';
                    setRedBorder(designeeName, false, 'err_designeeName');
                    setRedBorder(designeePhone, false, 'err_designeePhone');
                    setRedBorder(designeePin, false, 'err_designeePin');
                }
            }

            if (yesRadio) yesRadio.addEventListener('change', toggleDesignee);
            if (noRadio) noRadio.addEventListener('change', toggleDesignee);

            if (designeeName) designeeName.addEventListener('input', validateName);
            if (designeePhone) {
                designeePhone.addEventListener('input', validatePhone);
                if (designeePhone.value) validatePhone();
            }
            if (designeePin) designeePin.addEventListener('input', validatePin);

            document.getElementById('step4Form').addEventListener('submit', function (e) {
                if (yesRadio.checked) {
                    const vN = validateName();
                    const vP = validatePhone();
                    const vPin = validatePin();
                    if (!vN || !vP || !vPin) {
                        e.preventDefault();
                        if (!vN) designeeName.focus();
                        else if (!vP) designeePhone.focus();
                        else if (!vPin) designeePin.focus();
                        return false;
                    }
                }
            });

            toggleDesignee();
        });
    </script>
</body>

</html>