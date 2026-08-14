<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Registered Businesses- Form 941 E-File Portal</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="<%= request.getContextPath() %>/css/style.css?v=2" rel="stylesheet">
            <style>
                .field-error-msg {
                    color: #DC2626 !important;
                    font-size: 0.85rem;
                    font-weight: 600;
                    margin-top: 0.35rem;
                    display: flex;
                    align-items: center;
                    gap: 0.3rem;
                }

                .form-control.is-invalid,
                .form-select.is-invalid {
                    border-color: #DC2626 !important;
                    background-image: none !important;
                    box-shadow: 0 0 0 0.2rem rgba(220, 38, 38, 0.15) !important;
                }
            </style>
        </head>

        <body>
            <div class="d-flex">
                <!-- Sidebar -->
                <jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

                <!-- Main Content Wrapper -->
                <div class="main-wrapper bg-light">
                    <!-- Header -->
                    <% request.setAttribute("pageTitle", "Registered Business" ); %>
                        <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

                        <!-- Content -->
                        <div class="content-area">

                            <!-- 1. Registered Employers List Section (Top Card) -->
                            <div class="tm-card glass-panel p-4 rounded-4 bg-white shadow-sm mb-4">
                                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">
                                    <div>
                                        <h4 class="fw-bold m-0" style="color: var(--text-dark);">Registered Businesses
                                        </h4>
                                        <small class="text-muted">Showing registered companies (5 per page)</small>
                                    </div>
                                    <div class="d-flex align-items-center gap-3">
                                        <form action="<%= request.getContextPath() %>/employer/list" method="GET"
                                            class="d-flex gap-2">
                                            <input type="text" name="search" class="form-control form-control-sm"
                                                placeholder="Search EIN or Name..." value="${searchQuery}"
                                                style="width: 220px;">
                                            <button type="submit"
                                                class="btn btn-outline-primary btn-sm rounded-pill px-3">Search</button>
                                        </form>
                                        <button type="button" class="btn btn-primary btn-sm rounded-pill px-4"
                                            style="background-color: #2563EB; border: none;"
                                            onclick="toggleAddEmployerForm()">
                                            ➕ Add New Business
                                        </button>
                                    </div>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0" id="registeredEmployersTable">
                                        <thead class="table-light">
                                            <tr>
                                                <th>EIN</th>
                                                <th>Business Name</th>
                                                <th>Trade Name (DBA)</th>
                                                <th>City, State</th>
                                                <th>Contact Email</th>
                                                <th class="text-end">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty employers}">
                                                    <c:forEach var="emp" items="${employers}">
                                                        <tr>
                                                            <td><strong class="font-monospace">${emp.ein}</strong></td>
                                                            <td style="color: #2563EB; font-weight: 600;">
                                                                ${emp.businessName}</td>
                                                            <td class="text-muted small">${not empty emp.tradeName ?
                                                                emp.tradeName : '-'}</td>
                                                            <td>${emp.city}, ${emp.state}</td>
                                                            <td>${emp.email}</td>
                                                            <td class="text-end">
                                                                <a href="<%= request.getContextPath() %>/employer/edit?id=${emp.id}"
                                                                    class="btn btn-sm btn-outline-primary rounded-pill px-3 me-1">Edit</a>
                                                                <button type="button" class="btn btn-sm btn-outline-danger rounded-pill px-3 delete-btn"
                                                                    data-id="${emp.id}"
                                                                    data-name="<c:out value='${emp.businessName}'/>"
                                                                    data-ein="<c:out value='${emp.ein}'/>">
                                                                    Delete
                                                                </button>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="6" class="text-center py-4 text-muted">
                                                            No registered Business found. Click <strong>➕ Add New
                                                                Business</strong> above to add one.
                                                        </td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                                <div
                                    class="p-3 border-top d-flex justify-content-between align-items-center bg-white rounded-bottom mt-2">
                                    <small class="text-muted" id="regEmpPageInfo">Showing entries</small>
                                    <nav>
                                        <ul class="pagination pagination-sm m-0" id="regEmpPagination"></ul>
                                    </nav>
                                </div>
                            </div>

                            <!-- 2. IRS-Style Validation Error Summary Alert Banner -->
                            <c:if test="${not empty errors}">
                                <div class="alert alert-danger mb-4 shadow-sm border-danger border-2" role="alert">
                                    <div class="d-flex align-items-center mb-2">
                                        <span class="fs-4 me-2">⚠️</span>
                                        <h5 class="fw-bold mb-0 text-danger">Validation Engine Findings
                                            (${errors.size()} Rule Error(s)):</h5>
                                    </div>
                                    <p class="text-dark small mb-2">Please correct the highlighted fields displayed in
                                        red below:</p>
                                </div>
                            </c:if>

                            <!-- 3. Add / Edit Employer Form Card -->
                            <div class="tm-card glass-panel p-4 rounded-4 bg-white shadow-sm ${showForm || not empty errors || employer.id != null ? '' : 'd-none'}"
                                id="employerFormCard">
                                <div class="d-flex justify-content-between align-items-center mb-4 border-bottom pb-3">
                                    <h4 class="fw-bold m-0" style="color: var(--primary-blue);" id="formTitle">
                                        ${employer.id != null ? 'Edit Business' : 'Add New Business'}
                                    </h4>
                                    <button type="button" class="btn-close" onclick="toggleAddEmployerForm()"
                                        aria-label="Close"></button>
                                </div>

                                <form action="<%= request.getContextPath() %>/employer/save" method="POST" novalidate>
                                    <input type="hidden" name="id" value="${employer.id}">

                                    <!-- SECTION 1: BUSINESS IDENTIFICATION -->
                                    <h5 class="fw-bold mb-3" style="color: var(--primary-blue);">1. Business
                                        Identification</h5>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Employer Identification Number (EIN) <span
                                                    class="text-danger">*</span></label>
                                            <input type="text"
                                                class="form-control ${not empty fieldErrors['ein'] ? 'is-invalid' : ''}"
                                                id="ein-input" name="ein" value="${employer.ein}"
                                                placeholder="12-3456789" required pattern="\d{2}-\d{7}">
                                            <div class="form-text">Format: 9 digits with hyphen (12-3456789)</div>
                                            <c:if test="${not empty fieldErrors['ein']}">
                                                <div class="field-error-msg">⚠️ ${fieldErrors['ein']}</div>
                                            </c:if>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Legal Business Name <span
                                                    class="text-danger">*</span></label>
                                            <input type="text"
                                                class="form-control ${not empty fieldErrors['businessName'] ? 'is-invalid' : ''}"
                                                name="businessName" value="${employer.businessName}"
                                                placeholder="Enter Business Name" required>
                                            <c:if test="${not empty fieldErrors['businessName']}">
                                                <div class="field-error-msg">⚠️ ${fieldErrors['businessName']}</div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-12">
                                            <label class="form-label fw-bold">Trade Name (DBA)</label>
                                            <input type="text"
                                                class="form-control ${not empty fieldErrors['tradeName'] ? 'is-invalid' : ''}"
                                                name="tradeName" value="${employer.tradeName}"
                                                placeholder="Doing Business As (Optional)">
                                            <c:if test="${not empty fieldErrors['tradeName']}">
                                                <div class="field-error-msg">⚠️ ${fieldErrors['tradeName']}</div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <!-- SECTION 2: BUSINESS ADDRESS -->
                                    <h5 class="fw-bold mt-4 mb-3" style="color: var(--primary-blue);">2. Business
                                        Address</h5>
                                    <div class="row mb-3">
                                        <div class="col-md-12">
                                            <label class="form-label fw-bold">Street Address <span
                                                    class="text-danger">*</span></label>
                                            <input type="text"
                                                class="form-control ${not empty fieldErrors['address'] ? 'is-invalid' : ''}"
                                                name="address" value="${employer.address}"
                                                placeholder="123 Main St, Suite 100" required>
                                            <c:if test="${not empty fieldErrors['address']}">
                                                <div class="field-error-msg">⚠️ ${fieldErrors['address']}</div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-4">
                                            <label class="form-label fw-bold">City <span
                                                    class="text-danger">*</span></label>
                                            <input type="text"
                                                class="form-control ${not empty fieldErrors['city'] ? 'is-invalid' : ''}"
                                                name="city" value="${employer.city}" placeholder="Austin" required>
                                            <c:if test="${not empty fieldErrors['city']}">
                                                <div class="field-error-msg">⚠️ ${fieldErrors['city']}</div>
                                            </c:if>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label fw-bold">State <span
                                                    class="text-danger">*</span></label>
                                            <select
                                                class="form-select ${not empty fieldErrors['state'] ? 'is-invalid' : ''}"
                                                name="state" required>
                                                <option value="" disabled ${empty employer.state ? 'selected' : '' }>
                                                    Select US State...</option>
                                                <c:set var="states"
                                                    value="AL,AK,AZ,AR,CA,CO,CT,DE,FL,GA,HI,ID,IL,IN,IA,KS,KY,LA,ME,MD,MA,MI,MN,MS,MO,MT,NE,NV,NH,NJ,NM,NY,NC,ND,OH,OK,OR,PA,RI,SC,SD,TN,TX,UT,VT,VA,WA,WV,WI,WY,DC,PR,VI,GU,AS,MP" />
                                                <c:forEach var="st" items="${states.split(',')}">
                                                    <option value="${st}" ${employer.state==st ? 'selected' : '' }>${st}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div class="form-text">Must be a valid 2-letter US State code</div>
                                            <c:if test="${not empty fieldErrors['state']}">
                                                <div class="field-error-msg">⚠️ ${fieldErrors['state']}</div>
                                            </c:if>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label fw-bold">ZIP Code <span
                                                    class="text-danger">*</span></label>
                                            <input type="text"
                                                class="form-control ${not empty fieldErrors['zip'] ? 'is-invalid' : ''}"
                                                id="zip-input" name="zip" value="${employer.zip}"
                                                placeholder="78701 or 78701-1234" required maxlength="10"
                                                pattern="\d{5}(-\d{4})?"
                                                title="5-digit US ZIP Code (e.g. 78701) or ZIP+4 (e.g. 78701-1234)">
                                            <div class="form-text">5 digits (78701) or ZIP+4 (78701-1234)</div>
                                            <c:if test="${not empty fieldErrors['zip']}">
                                                <div class="field-error-msg">⚠️ ${fieldErrors['zip']}</div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <!-- SECTION 3: PRIMARY CONTACT PERSON -->
                                    <h5 class="fw-bold mt-4 mb-3" style="color: var(--primary-blue);">3. Primary Contact
                                        Person</h5>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Contact Name <span
                                                    class="text-danger">*</span></label>
                                            <input type="text"
                                                class="form-control ${not empty fieldErrors['contactName'] ? 'is-invalid' : ''}"
                                                name="contactName" value="${employer.contactName}"
                                                placeholder="John Doe" required>
                                            <c:if test="${not empty fieldErrors['contactName']}">
                                                <div class="field-error-msg">⚠️ ${fieldErrors['contactName']}</div>
                                            </c:if>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Title <span
                                                    class="text-danger">*</span></label>
                                            <input type="text"
                                                class="form-control ${not empty fieldErrors['contactTitle'] ? 'is-invalid' : ''}"
                                                name="contactTitle" value="${employer.contactTitle}"
                                                placeholder="CEO / Officer" required>
                                            <c:if test="${not empty fieldErrors['contactTitle']}">
                                                <div class="field-error-msg">⚠️ ${fieldErrors['contactTitle']}</div>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Mobile / Phone Number <span
                                                    class="text-danger">*</span></label>
                                            <input type="text"
                                                class="form-control ${not empty fieldErrors['phone'] ? 'is-invalid' : ''}"
                                                id="phone-input" name="phone" value="${employer.phone}"
                                                placeholder="(111) 111-1111" required maxlength="14"
                                                title="10-digit US Mobile / Phone Number (e.g. (111) 111-1111)">
                                            <div class="form-text">Format: 10-digit US phone (e.g. (111) 111-1111)</div>
                                            <c:if test="${not empty fieldErrors['phone']}">
                                                <div class="field-error-msg">⚠️ ${fieldErrors['phone']}</div>
                                            </c:if>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Email Address <span
                                                    class="text-danger">*</span></label>
                                            <input type="email"
                                                class="form-control ${not empty fieldErrors['email'] ? 'is-invalid' : ''}"
                                                name="email" value="${employer.email}" placeholder="contact@domain.com"
                                                required pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$">
                                            <div class="form-text">Format: valid email (e.g. user@domain.com)</div>
                                            <c:if test="${not empty fieldErrors['email']}">
                                                <div class="field-error-msg">⚠️ ${fieldErrors['email']}</div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <hr class="my-4">

                                    <div class="d-flex justify-content-between">
                                        <button type="button" class="btn btn-outline-secondary px-4 rounded-pill"
                                            onclick="toggleAddEmployerForm()">Cancel</button>
                                        <button type="submit" class="btn btn-primary px-5 rounded-pill"
                                            style="background-color: #2563EB; border: none;">Save Business</button>
                                    </div>
                                </form>
                            </div>

                        </div>

                </div>
            </div>

            <!-- Custom App Delete Confirmation Modal -->
            <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content rounded-4 border-0 shadow-lg">
                        <div class="modal-header border-0 pb-0 pt-4 px-4">
                            <div class="d-flex align-items-center gap-3">
                                <div class="rounded-circle bg-danger-subtle p-3 d-flex align-items-center justify-content-center text-danger" style="width: 52px; height: 52px;">
                                    <svg width="28" height="28" fill="currentColor" viewBox="0 0 16 16">
                                        <path d="M11 1.5v1h3.5a.5.5 0 0 1 0 1h-.538l-.853 10.66A2 2 0 0 1 11.115 16h-6.23a2 2 0 0 1-1.994-1.84L2.038 3.5H1.5a.5.5 0 0 1 0-1H5v-1A1.5 1.5 0 0 1 6.5 0h3A1.5 1.5 0 0 1 11 1.5Zm-5 0v1h4v-1a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5ZM4.5 5.029l.5 8.5a.5.5 0 1 0 .998-.06l-.5-8.5a.5.5 0 1 0-.998.06Zm6.53-.06a.5.5 0 0 0-.998.06l.5 8.5a.5.5 0 1 0 .998-.06l-.5-8.5Zm-3.47.06a.5.5 0 0 0-1 0v8.5a.5.5 0 0 0 1 0v-8.5Z"/>
                                    </svg>
                                </div>
                                <div>
                                    <h5 class="modal-title fw-bold text-dark" id="deleteModalLabel">Delete Business</h5>
                                    <small class="text-muted">Form 941 E-File Portal</small>
                                </div>
                            </div>
                            <button type="button" class="btn-close align-self-start" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body p-4">
                            <p class="text-secondary mb-3 fs-6" style="line-height: 1.5;">
                                Are you sure you want to delete <strong class="text-dark" id="deleteBusinessNameText"></strong> (EIN: <span class="font-monospace fw-bold text-dark" id="deleteEinText"></span>)?
                            </p>
                            <div class="alert alert-warning border-0 rounded-3 p-3 mb-0 small text-warning-emphasis bg-warning-subtle d-flex align-items-center gap-2">
                                <span>⚠️</span>
                                <div>This action cannot be undone. All tax filing records linked to this business will be deleted.</div>
                            </div>
                        </div>
                        <div class="modal-footer border-0 pt-0 pb-4 px-4 gap-2">
                            <button type="button" class="btn btn-light rounded-pill px-4 fw-semibold text-secondary" data-bs-dismiss="modal">Cancel</button>
                            <a href="#" id="confirmDeleteLink" class="btn btn-danger rounded-pill px-4 fw-semibold shadow-sm">Yes, Delete Business</a>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="<%= request.getContextPath() %>/js/app.js"></script>
            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    setupTablePagination('registeredEmployersTable', 'regEmpPageInfo', 'regEmpPagination', 5);

                    // Delete modal event handler
                    document.addEventListener('click', function(e) {
                        var btn = e.target.closest('.delete-btn');
                        if (btn) {
                            var id = btn.getAttribute('data-id');
                            var name = btn.getAttribute('data-name');
                            var ein = btn.getAttribute('data-ein');
                            
                            document.getElementById('deleteBusinessNameText').innerText = name;
                            document.getElementById('deleteEinText').innerText = ein;
                            document.getElementById('confirmDeleteLink').href = '<%= request.getContextPath() %>/employer/delete?id=' + encodeURIComponent(id);
                            
                            var modalEl = document.getElementById('deleteConfirmModal');
                            var modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                            modal.show();
                        }
                    });

                    var einInput = document.getElementById('ein-input');
                    if (einInput) {
                        einInput.addEventListener('input', function (e) {
                            var x = e.target.value.replace(/\D/g, '').match(/(\d{0,2})(\d{0,7})/);
                            e.target.value = !x[2] ? x[1] : x[1] + '-' + x[2];
                        });
                    }

                    var phoneInput = document.getElementById('phone-input');
                    if (phoneInput) {
                        phoneInput.addEventListener('input', function (e) {
                            var digits = e.target.value.replace(/\D/g, '').substring(0, 10);
                            if (digits.length === 0) {
                                e.target.value = '';
                            } else if (digits.length <= 3) {
                                e.target.value = '(' + digits;
                            } else if (digits.length <= 6) {
                                e.target.value = '(' + digits.substring(0, 3) + ') ' + digits.substring(3);
                            } else {
                                e.target.value = '(' + digits.substring(0, 3) + ') ' + digits.substring(3, 6) + '-' + digits.substring(6);
                            }
                        });
                    }

                    var zipInput = document.getElementById('zip-input');
                    if (zipInput) {
                        zipInput.addEventListener('input', function (e) {
                            var val = e.target.value.replace(/[^\d-]/g, '');
                            if (val.length > 5 && val.indexOf('-') === -1) {
                                val = val.substring(0, 5) + '-' + val.substring(5, 9);
                            }
                            e.target.value = val;
                        });
                    }

                    // Real-time instant field validation on input, blur, change
                    var employerForm = document.querySelector('#employerFormCard form');
                    if (employerForm) {
                        var formInputs = employerForm.querySelectorAll('input:not([type="hidden"]), select');

                        function validateSingleField(input) {
                            var name = input.name;
                            var val = input.value ? input.value.trim() : '';
                            var errorMsg = null;

                            if (name === 'ein') {
                                if (!val) errorMsg = 'Employer Identification Number (EIN) is required.';
                                else if (!/^\d{2}-\d{7}$/.test(val)) errorMsg = 'EIN must be in 9-digit format XX-XXXXXXX (e.g. 12-3456789).';
                            } else if (name === 'businessName') {
                                if (!val) errorMsg = 'Legal Business Name is required.';
                            } else if (name === 'tradeName') {
                                if (val.length > 150) errorMsg = 'Trade Name must not exceed 150 characters.';
                            } else if (name === 'address') {
                                if (!val) errorMsg = 'Street Address is required.';
                            } else if (name === 'city') {
                                if (!val) errorMsg = 'City is required.';
                            } else if (name === 'state') {
                                if (!val) errorMsg = 'US State selection is required.';
                            } else if (name === 'zip') {
                                if (!val) errorMsg = 'ZIP Code is required.';
                                else if (!/^\d{5}(-\d{4})?$/.test(val)) errorMsg = 'ZIP Code must be 5 digits (e.g. 78701) or ZIP+4 (e.g. 78701-1234).';
                            } else if (name === 'contactName') {
                                if (!val) errorMsg = 'Contact Person Name is required.';
                            } else if (name === 'contactTitle') {
                                if (!val) errorMsg = 'Contact Title / Role is required.';
                            } else if (name === 'phone') {
                                if (!val) errorMsg = 'Mobile / Phone Number is required.';
                                else if (!/^(\+?1[-.\s]?)?(\(?\d{3}\)?)[-.\s]?\d{3}[-.\s]?\d{4}$/.test(val)) errorMsg = 'Mobile Number must be a valid 10-digit US format (e.g. 512-555-0199).';
                            } else if (name === 'email') {
                                if (!val) errorMsg = 'Email Address is required.';
                                else if (!/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(val)) errorMsg = 'Email Address must be a valid email format (e.g. contact@domain.com).';
                            }

                            var parent = input.parentElement;
                            var existingErr = parent.querySelector('.field-error-msg');

                            if (errorMsg) {
                                input.classList.add('is-invalid');
                                if (!existingErr) {
                                    existingErr = document.createElement('div');
                                    existingErr.className = 'field-error-msg';
                                    parent.appendChild(existingErr);
                                }
                                existingErr.innerHTML = '⚠️ ' + errorMsg;
                            } else {
                                input.classList.remove('is-invalid');
                                if (existingErr) {
                                    existingErr.remove();
                                }
                            }
                            return !errorMsg;
                        }

                        formInputs.forEach(function (input) {
                            ['input', 'blur', 'change'].forEach(function (evt) {
                                input.addEventListener(evt, function () {
                                    validateSingleField(input);
                                });
                            });
                        });

                        employerForm.addEventListener('submit', function (e) {
                            var isValid = true;
                            formInputs.forEach(function (input) {
                                if (!validateSingleField(input)) {
                                    isValid = false;
                                }
                            });
                            if (!isValid) {
                                e.preventDefault();
                            }
                        });
                    }
                });

                function toggleAddEmployerForm() {
                    var card = document.getElementById('employerFormCard');
                    if (card) {
                        if (card.classList.contains('d-none')) {
                            card.classList.remove('d-none');
                            card.scrollIntoView({ behavior: 'smooth' });
                        } else {
                            card.classList.add('d-none');
                        }
                    }
                }
            </script>
        </body>

        </html>