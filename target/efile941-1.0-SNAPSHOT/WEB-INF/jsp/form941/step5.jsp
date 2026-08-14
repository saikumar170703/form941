<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Form 941 - Step 5: Signature & Paid Preparer</title>
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
                    <% request.setAttribute("pageTitle", "Form 941 - Step 5: Signature & Paid Preparer" ); %>
                        <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

                        <!-- Wizard Content -->
                        <div class="content-area">
                            <div class="tm-card p-3 p-md-4 rounded-4 bg-white shadow-sm">
                                <% request.setAttribute("currentStep", 5); %>
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

                                    <h4 class="fw-bold mb-3" style="color: var(--primary-blue);">Part 5: Sign here</h4>
                                    <p class="text-muted mb-4">Under penalties of perjury, I declare that I have
                                        examined this return, including accompanying schedules and statements, and to
                                        the best of my knowledge and belief, it is true, correct, and complete.</p>

                                    <form action="<%= request.getContextPath() %>/form941/step6" method="POST"
                                        id="step5Form">

                                        <!-- Authorized Signatory Box -->
                                        <div
                                            class="p-3 p-md-4 border rounded-4 bg-white mb-4 shadow-sm border-secondary-subtle">
                                            <h5 class="fw-bold mb-3 border-bottom pb-2 text-dark">Authorized Signatory
                                            </h5>
                                            <div class="row g-3 mb-3">
                                                <div class="col-12 col-md-6">
                                                    <label class="form-label fw-bold">Sign your name here </label>
                                                    <input type="text" class="form-control" name="signatureName"
                                                        id="signatureName"
                                                        value="${formDTO.getLineValue('signatureName')}"
                                                        placeholder="Type your full name as signature">
                                                </div>
                                                <div class="col-12 col-md-6">
                                                    <label class="form-label fw-bold">Print your title here </label>
                                                    <input type="text" class="form-control" name="signatureTitle"
                                                        id="signatureTitle"
                                                        value="${formDTO.getLineValue('signatureTitle')}"
                                                        placeholder="e.g. Owner, President, Director">
                                                </div>
                                            </div>
                                            <div class="row g-3">
                                                <div class="col-12 col-md-6">
                                                    <label class="form-label fw-bold">Date </label>
                                                    <div class="input-group">
                                                        <span class="input-group-text bg-white border-end-0">📅</span>
                                                        <input type="text"
                                                            class="form-control border-start-0 modern-datepicker bg-white"
                                                            name="signatureDate" id="signatureDate"
                                                            value="${formDTO.getLineValue('signatureDate')}"
                                                            placeholder="mm/dd/yyyy">
                                                    </div>
                                                </div>
                                                <div class="col-12 col-md-6">
                                                    <label class="form-label fw-bold">Best daytime phone </label>
                                                    <input type="text" class="form-control font-monospace"
                                                        name="signaturePhone" id="signaturePhone"
                                                        value="${formDTO.getLineValue('signaturePhone')}"
                                                        placeholder="(111) 111-1111" maxlength="14">
                                                    <div id="err_signaturePhone"
                                                        style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                        ⚠️ Best daytime phone must be 10 digits in (111) 111-1111
                                                        format.</div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Paid Preparer Trigger Box -->
                                        <div class="p-3 p-md-4 border rounded-4 bg-light mb-4 shadow-sm">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" name="paidPreparerCheck"
                                                    id="paidPreparerCheck"
                                                    ${formDTO.getLineValue('paidPreparerCheck')=='true' ||
                                                    formDTO.getLineValue('paidPreparerCheck')=='on' ? 'checked' : '' }>
                                                <label class="form-check-label fw-bold text-dark fs-6 cursor-pointer"
                                                    for="paidPreparerCheck">
                                                    Check if Paid Preparer Used
                                                </label>
                                            </div>

                                            <!-- PAID PREPARER USE ONLY FORM SECTION -->
                                            <div class="mt-4 p-3 p-md-4 border border-2 border-primary-subtle rounded-3 bg-white"
                                                id="paidPreparerSection" style="display: none;">
                                                <div
                                                    class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom flex-wrap gap-2">
                                                    <h5 class="fw-bold text-primary m-0">Paid Preparer Use Only</h5>
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="checkbox"
                                                            name="preparerSelfEmployed" id="preparerSelfEmployed"
                                                            ${formDTO.getLineValue('preparerSelfEmployed')=='true' ||
                                                            formDTO.getLineValue('preparerSelfEmployed')=='on'
                                                            ? 'checked' : '' }>
                                                        <label
                                                            class="form-check-label fw-bold text-secondary small cursor-pointer"
                                                            for="preparerSelfEmployed">
                                                            Check if you're self-employed . . .
                                                        </label>
                                                    </div>
                                                </div>

                                                <div class="row g-3 mb-2">
                                                    <div class="col-12 col-md-8">
                                                        <label class="form-label fw-semibold text-dark">Preparer's name
                                                            <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="preparerName"
                                                            id="preparerName"
                                                            value="${formDTO.getLineValue('preparerName')}"
                                                            placeholder="Full Name">
                                                        <div id="err_preparerName"
                                                            style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                            ⚠️ Preparer name is required.</div>
                                                    </div>
                                                    <div class="col-12 col-md-4">
                                                        <label class="form-label fw-semibold text-dark">PTIN <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control font-monospace"
                                                            name="preparerPtin" id="preparerPtin"
                                                            value="${formDTO.getLineValue('preparerPtin')}"
                                                            placeholder="P00000000" maxlength="9">
                                                        <div id="err_preparerPtin"
                                                            style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                            ⚠️ PTIN must start with 'P' followed by 8 digits (e.g.
                                                            P12345678).</div>
                                                    </div>
                                                </div>

                                                <div class="row g-3 mb-2">
                                                    <div class="col-12 col-md-8">
                                                        <label class="form-label fw-semibold text-dark">Preparer's
                                                            signature <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="preparerSignature"
                                                            id="preparerSignature"
                                                            value="${formDTO.getLineValue('preparerSignature')}"
                                                            placeholder="Type full name as signature">
                                                        <div id="err_preparerSignature"
                                                            style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                            ⚠️ Preparer signature is required.</div>
                                                    </div>
                                                    <div class="col-12 col-md-4">
                                                        <label class="form-label fw-semibold text-dark">Date <span
                                                                class="text-danger">*</span></label>
                                                        <div class="input-group">
                                                            <span
                                                                class="input-group-text bg-white border-end-0">📅</span>
                                                            <input type="text"
                                                                class="form-control border-start-0 modern-datepicker bg-white"
                                                                name="preparerDate" id="preparerDate"
                                                                value="${formDTO.getLineValue('preparerDate')}"
                                                                placeholder="mm/dd/yyyy">
                                                        </div>
                                                        <div id="err_preparerDate"
                                                            style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                            ⚠️ Date is required.</div>
                                                    </div>
                                                </div>

                                                <div class="row g-3 mb-2">
                                                    <div class="col-12 col-md-8">
                                                        <label class="form-label fw-semibold text-dark">Firm's name (or
                                                            yours if self-employed) <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="preparerFirmName"
                                                            id="preparerFirmName"
                                                            value="${formDTO.getLineValue('preparerFirmName')}"
                                                            placeholder="Firm or Business Name">
                                                        <div id="err_preparerFirmName"
                                                            style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                            ⚠️ Firm name is required.</div>
                                                    </div>
                                                    <div class="col-12 col-md-4">
                                                        <label class="form-label fw-semibold text-dark">EIN <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control font-monospace"
                                                            name="preparerEin" id="preparerEin"
                                                            value="${formDTO.getLineValue('preparerEin')}"
                                                            placeholder="11-1111111" maxlength="10">
                                                        <div id="err_preparerEin"
                                                            style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                            ⚠️ EIN must be 9 digits in XX-XXXXXXX format.</div>
                                                    </div>
                                                </div>

                                                <div class="row g-3 mb-2">
                                                    <div class="col-12 col-md-8">
                                                        <label class="form-label fw-semibold text-dark">Address <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="preparerAddress"
                                                            id="preparerAddress"
                                                            value="${formDTO.getLineValue('preparerAddress')}"
                                                            placeholder="Street Address">
                                                        <div id="err_preparerAddress"
                                                            style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                            ⚠️ Address is required.</div>
                                                    </div>
                                                    <div class="col-12 col-md-4">
                                                        <label class="form-label fw-semibold text-dark">Phone <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control font-monospace"
                                                            name="preparerPhone" id="preparerPhone"
                                                            value="${formDTO.getLineValue('preparerPhone')}"
                                                            placeholder="(111) 111-1111" maxlength="14">
                                                        <div id="err_preparerPhone"
                                                            style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                            ⚠️ Phone number must be 10 digits in (111) 111-1111 format.
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row g-3">
                                                    <div class="col-12 col-md-5">
                                                        <label class="form-label fw-semibold text-dark">City <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="preparerCity"
                                                            id="preparerCity"
                                                            value="${formDTO.getLineValue('preparerCity')}"
                                                            placeholder="City">
                                                        <div id="err_preparerCity"
                                                            style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                            ⚠️ City is required.</div>
                                                    </div>
                                                    <div class="col-6 col-md-3">
                                                        <label class="form-label fw-semibold text-dark">State <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control text-uppercase"
                                                            name="preparerState" id="preparerState"
                                                            value="${formDTO.getLineValue('preparerState')}"
                                                            maxlength="2" placeholder="ST">
                                                        <div id="err_preparerState"
                                                            style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                            ⚠️ State is required.</div>
                                                    </div>
                                                    <div class="col-6 col-md-4">
                                                        <label class="form-label fw-semibold text-dark">ZIP code <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control font-monospace"
                                                            name="preparerZip" id="preparerZip"
                                                            value="${formDTO.getLineValue('preparerZip')}"
                                                            placeholder="12345" maxlength="5">
                                                        <div id="err_preparerZip"
                                                            style="display: none; color: #dc3545; font-weight: bold; font-size: 0.85rem; margin-top: 4px;">
                                                            ⚠️ ZIP code must be 5 digits (numbers only).</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <hr class="my-4">

                                        <div class="d-flex justify-content-between flex-wrap gap-2">
                                            <a href="<%= request.getContextPath() %>/form941/step4"
                                                class="btn btn-outline-secondary px-4">&laquo; Back</a>
                                            <c:choose>
                                                <c:when test="${formDTO.status == 'SUBMITTED'}">
                                                    <a href="<%= request.getContextPath() %>/form941/step6"
                                                        class="btn btn-primary px-5">View Summary &raquo;</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="submit" class="btn btn-primary px-5"
                                                        style="background-color: #2563EB; border: none;">Review Return
                                                        &raquo;</button>
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
                        document.querySelectorAll('#step5Form input, #step5Form select, #step5Form textarea').forEach(function (el) {
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
                    // Initialize Modern Flatpickr Date Pickers
                    flatpickr(".modern-datepicker", {
                        dateFormat: "m/d/Y",
                        allowInput: true,
                        animate: true
                    });

                    const sigPhoneEl = document.getElementById('signaturePhone');
                    const paidPreparerCheck = document.getElementById('paidPreparerCheck');
                    const paidPreparerSection = document.getElementById('paidPreparerSection');

                    const ptinEl = document.getElementById('preparerPtin');
                    const einEl = document.getElementById('preparerEin');
                    const phoneEl = document.getElementById('preparerPhone');
                    const zipEl = document.getElementById('preparerZip');

                    const nameEl = document.getElementById('preparerName');
                    const sigEl = document.getElementById('preparerSignature');
                    const dateEl = document.getElementById('preparerDate');
                    const firmEl = document.getElementById('preparerFirmName');
                    const addrEl = document.getElementById('preparerAddress');
                    const cityEl = document.getElementById('preparerCity');
                    const stateEl = document.getElementById('preparerState');

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

                    function validateSignaturePhone() {
                        if (!sigPhoneEl) return true;
                        let rawDigits = sigPhoneEl.value.replace(/\D/g, '').substring(0, 10);
                        if (rawDigits.length === 0) {
                            setRedBorder(sigPhoneEl, false, 'err_signaturePhone');
                            return true;
                        }
                        sigPhoneEl.value = formatPhoneNumber(sigPhoneEl.value);
                        const isInvalid = (rawDigits.length !== 10);
                        setRedBorder(sigPhoneEl, isInvalid, 'err_signaturePhone');
                        return !isInvalid;
                    }

                    if (sigPhoneEl) {
                        sigPhoneEl.addEventListener('input', validateSignaturePhone);
                        if (sigPhoneEl.value) validateSignaturePhone();
                    }

                    function validatePtin() {
                        if (!paidPreparerCheck || !paidPreparerCheck.checked) return true;
                        let val = ptinEl.value.trim().toUpperCase();
                        if (val === '') {
                            val = 'P';
                        } else if (!val.startsWith('P')) {
                            val = 'P' + val.replace(/\D/g, '');
                        }
                        const digits = val.substring(1).replace(/\D/g, '').substring(0, 8);
                        ptinEl.value = 'P' + digits;

                        const isInvalid = (digits.length !== 8);
                        setRedBorder(ptinEl, isInvalid, 'err_preparerPtin');
                        return !isInvalid;
                    }

                    function validateEin() {
                        if (!paidPreparerCheck || !paidPreparerCheck.checked) return true;
                        let digits = einEl.value.replace(/\D/g, '').substring(0, 9);
                        if (digits.length > 2) {
                            einEl.value = digits.substring(0, 2) + '-' + digits.substring(2);
                        } else {
                            einEl.value = digits;
                        }
                        const isInvalid = (digits.length !== 9);
                        setRedBorder(einEl, isInvalid, 'err_preparerEin');
                        return !isInvalid;
                    }

                    function validatePhone() {
                        if (!paidPreparerCheck || !paidPreparerCheck.checked) return true;
                        let rawDigits = phoneEl.value.replace(/\D/g, '').substring(0, 10);
                        phoneEl.value = formatPhoneNumber(phoneEl.value);
                        const isInvalid = (rawDigits.length !== 10);
                        setRedBorder(phoneEl, isInvalid, 'err_preparerPhone');
                        return !isInvalid;
                    }

                    function validateZip() {
                        if (!paidPreparerCheck || !paidPreparerCheck.checked) return true;
                        zipEl.value = zipEl.value.replace(/\D/g, '').substring(0, 5);
                        const isInvalid = (zipEl.value.length !== 5);
                        setRedBorder(zipEl, isInvalid, 'err_preparerZip');
                        return !isInvalid;
                    }

                    function validateRequiredText(el, errId) {
                        if (!paidPreparerCheck || !paidPreparerCheck.checked) return true;
                        const isInvalid = !el.value.trim();
                        setRedBorder(el, isInvalid, errId);
                        return !isInvalid;
                    }

                    function togglePreparerSection() {
                        if (paidPreparerCheck && paidPreparerSection) {
                            if (paidPreparerCheck.checked) {
                                paidPreparerSection.style.display = 'block';
                                validatePtin();
                                validateEin();
                                validatePhone();
                                validateZip();
                                validateRequiredText(nameEl, 'err_preparerName');
                                validateRequiredText(sigEl, 'err_preparerSignature');
                                validateRequiredText(dateEl, 'err_preparerDate');
                                validateRequiredText(firmEl, 'err_preparerFirmName');
                                validateRequiredText(addrEl, 'err_preparerAddress');
                                validateRequiredText(cityEl, 'err_preparerCity');
                                validateRequiredText(stateEl, 'err_preparerState');
                            } else {
                                paidPreparerSection.style.display = 'none';
                                const ids = ['preparerName', 'preparerPtin', 'preparerSignature', 'preparerDate', 'preparerFirmName', 'preparerEin', 'preparerAddress', 'preparerPhone', 'preparerCity', 'preparerState', 'preparerZip'];
                                ids.forEach(id => setRedBorder(document.getElementById(id), false, 'err_' + id));
                            }
                        }
                    }

                    if (paidPreparerCheck) {
                        paidPreparerCheck.addEventListener('change', togglePreparerSection);
                    }

                    if (ptinEl) ptinEl.addEventListener('input', validatePtin);
                    if (einEl) einEl.addEventListener('input', validateEin);
                    if (phoneEl) {
                        phoneEl.addEventListener('input', validatePhone);
                        if (phoneEl.value) validatePhone();
                    }
                    if (zipEl) zipEl.addEventListener('input', validateZip);

                    if (nameEl) nameEl.addEventListener('input', () => validateRequiredText(nameEl, 'err_preparerName'));
                    if (sigEl) sigEl.addEventListener('input', () => validateRequiredText(sigEl, 'err_preparerSignature'));
                    if (dateEl) dateEl.addEventListener('change', () => validateRequiredText(dateEl, 'err_preparerDate'));
                    if (firmEl) firmEl.addEventListener('input', () => validateRequiredText(firmEl, 'err_preparerFirmName'));
                    if (addrEl) addrEl.addEventListener('input', () => validateRequiredText(addrEl, 'err_preparerAddress'));
                    if (cityEl) cityEl.addEventListener('input', () => validateRequiredText(cityEl, 'err_preparerCity'));
                    if (stateEl) stateEl.addEventListener('input', () => validateRequiredText(stateEl, 'err_preparerState'));

                    document.getElementById('step5Form').addEventListener('submit', function (e) {
                        const vSigPhone = validateSignaturePhone();
                        if (!vSigPhone) {
                            e.preventDefault();
                            sigPhoneEl.focus();
                            return false;
                        }

                        if (paidPreparerCheck && paidPreparerCheck.checked) {
                            const vPtin = validatePtin();
                            const vEin = validateEin();
                            const vPhone = validatePhone();
                            const vZip = validateZip();
                            const vName = validateRequiredText(nameEl, 'err_preparerName');
                            const vSig = validateRequiredText(sigEl, 'err_preparerSignature');
                            const vDate = validateRequiredText(dateEl, 'err_preparerDate');
                            const vFirm = validateRequiredText(firmEl, 'err_preparerFirmName');
                            const vAddr = validateRequiredText(addrEl, 'err_preparerAddress');
                            const vCity = validateRequiredText(cityEl, 'err_preparerCity');
                            const vState = validateRequiredText(stateEl, 'err_preparerState');

                            if (!vPtin || !vEin || !vPhone || !vZip || !vName || !vSig || !vDate || !vFirm || !vAddr || !vCity || !vState) {
                                e.preventDefault();
                                if (!vName) nameEl.focus();
                                else if (!vPtin) ptinEl.focus();
                                else if (!vSig) sigEl.focus();
                                else if (!vDate) dateEl.focus();
                                else if (!vFirm) firmEl.focus();
                                else if (!vEin) einEl.focus();
                                else if (!vAddr) addrEl.focus();
                                else if (!vPhone) phoneEl.focus();
                                else if (!vCity) cityEl.focus();
                                else if (!vState) stateEl.focus();
                                else if (!vZip) zipEl.focus();
                                return false;
                            }
                        }
                    });

                    togglePreparerSection();
                });
            </script>
        </body>

        </html>