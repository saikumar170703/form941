<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Employer - Form 941 E-File Portal</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">
    </head>

    <body>
        <div class="d-flex">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/jsp/layout/sidebar.jsp" />

            <!-- Main Content Wrapper -->
            <div class="main-wrapper bg-light">
                <!-- Header -->
                <% request.setAttribute("pageTitle", "Manage Employer" ); %>
                    <jsp:include page="/WEB-INF/jsp/layout/header.jsp" />

                    <!-- Content -->
                    <div class="content-area">
                        <div class="tm-card">
                            <h4 class="fw-bold mb-4" style="color: var(--primary-blue);">Employer Details</h4>

                            <form action="<%= request.getContextPath() %>/dashboard.jsp" method="POST">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Employer Identification Number (EIN) <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="ein" placeholder="NN-NNNNNNN"
                                            required pattern="\d{2}-\d{7}">
                                        <div class="form-text">Format: 12-3456789</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Business Name <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="businessName"
                                            placeholder="Enter Business Name" required>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-12">
                                        <label class="form-label fw-bold">Trade Name (if any)</label>
                                        <input type="text" class="form-control" name="tradeName"
                                            placeholder="Doing Business As">
                                    </div>
                                </div>

                                <h5 class="fw-bold mt-4 mb-3" style="color: var(--primary-blue);">Address</h5>

                                <div class="row mb-3">
                                    <div class="col-md-8">
                                        <label class="form-label fw-bold">Street Address <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="address" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">Suite or Room Number</label>
                                        <input type="text" class="form-control" name="suite">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">City <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="city" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">State <span
                                                class="text-danger">*</span></label>
                                        <select class="form-select" name="state" required>
                                            <option value="" selected disabled>Select State</option>
                                            <option value="CA">California</option>
                                            <option value="TX">Texas</option>
                                            <option value="NY">New York</option>
                                            <!-- Add other states -->
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label fw-bold">ZIP Code <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="zip" required
                                            pattern="\d{5}(-\d{4})?">
                                    </div>
                                </div>

                                <hr class="my-4">

                                <div class="d-flex justify-content-between">
                                    <a href="<%= request.getContextPath() %>/dashboard.jsp"
                                        class="btn btn-outline-secondary px-4">Cancel</a>
                                    <button type="submit" class="btn btn-tmBlue px-5">Save Business</button>
                                </div>
                            </form>
                        </div>
                    </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>