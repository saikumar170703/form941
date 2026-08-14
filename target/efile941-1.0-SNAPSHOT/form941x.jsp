<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Form 941-X | eFile941</title>
  <meta name="description" content="File Form 941-X Wizard">
  <link rel="stylesheet" href="css/style.css">
</head>
<body class="dash-page">

  <!-- ===================================================
       SIDEBAR (Simplified for wizard view)
  ==================================================== -->
  <aside id="sidebar" class="sidebar collapsed">
    <div class="sidebar-header">
      <a href="dashboard.jsp" class="sidebar-logo">
        <div class="logo-badge" style="font-size:.9rem;padding:.28rem .5rem;"><span>e</span>F941</div>
        <div class="sidebar-logo-text">
          <span class="logo-name">eFile941</span>
        </div>
      </a>
    </div>
    <nav class="sidebar-nav">
      <div class="nav-item">
        <a href="dashboard.jsp" title="Back to Dashboard">
          <span class="nav-icon">←</span>
          <span class="nav-label">Exit Wizard</span>
        </a>
      </div>
    </nav>
  </aside>

  <!-- ===================================================
       MAIN AREA
  ==================================================== -->
  <div class="main-area" style="margin-left: 64px;">
    
    <header class="dash-topbar" style="justify-content: center; background: var(--bg); border-bottom: none;">
      <div class="dash-title" style="font-size: 1.25rem;">Form 941 Filing Wizard</div>
    </header>

    <main class="dash-content" style="padding-top: 1rem;">
      
      <div class="wizard-container anim-fade-up">
        
        <!-- Wizard Header -->
        <div class="wizard-header">
          <h1>Adjusted Employer's QUARTERLY Federal Tax Return or Claim for Refund</h1>
          <p>OMB No. 1545-0029</p>
        </div>

        <!-- Progress Tracker -->
        <div class="wizard-progress">
          <div class="progress-step active" id="prog-1">
            <div class="step-circle">1</div>
            <div class="step-label">Basic Info</div>
          </div>
          <div class="progress-step" id="prog-2">
            <div class="step-circle">2</div>
            <div class="step-label">Process</div>
          </div>
          <div class="progress-step" id="prog-3">
            <div class="step-circle">3</div>
            <div class="step-label">Certifications</div>
          </div>
          <div class="progress-step" id="prog-4">
            <div class="step-circle">4</div>
            <div class="step-label">Corrections</div>
          </div>
          <div class="progress-step" id="prog-5">
            <div class="step-circle">5</div>
            <div class="step-label">Sign</div>
          </div>
        </div>

        <div class="wizard-body">
          <form id="wizard-form" autocomplete="off">
            
            <!-- ================= STEP 1: BASIC INFO ================= -->
            <div class="wizard-step active" id="step-1">
              <h2>Employer Identification &amp; Return Info</h2>
              
              <div class="grid-2">
                <div class="form-group">
                  <label>Employer identification number (EIN) <span class="req">*</span></label>
                  <input type="text" id="ein-input" class="form-control" placeholder="XX-XXXXXXX" maxlength="10" required>
                </div>
                <div class="form-group">
                  <label>Name (not your trade name) <span class="req">*</span></label>
                  <input type="text" id="name-input" class="form-control" value="" maxlength="75" required>
                </div>
              </div>

              <div class="grid-2">
                <div class="form-group">
                  <label>Trade name (if any)</label>
                  <input type="text" class="form-control" placeholder="Optional">
                </div>
                <div class="form-group">
                  <label>Return You're Correcting <span class="req">*</span></label>
                  <select class="form-control" required>
                    <option value="941">Form 941</option>
                    <option value="941-SS">Form 941-SS</option>
                  </select>
                </div>
              </div>

              <div class="grid-3" style="margin-top: 1rem;">
                <div class="form-group">
                  <label>Quarter You're Correcting <span class="req">*</span></label>
                  <select class="form-control" required>
                    <option value="">Select Quarter</option>
                    <option value="1">1: January, February, March</option>
                    <option value="2">2: April, May, June</option>
                    <option value="3">3: July, August, September</option>
                    <option value="4">4: October, November, December</option>
                  </select>
                </div>
                <div class="form-group">
                  <label>Calendar Year (YYYY) <span class="req">*</span></label>
                  <input type="number" class="form-control" placeholder="2025" min="2000" max="2026" required>
                </div>
                <div class="form-group">
                  <label>Date discovered errors (MM/DD/YYYY) <span class="req">*</span></label>
                  <input type="date" class="form-control" required>
                </div>
              </div>

              <div class="wizard-footer" style="padding: 1.5rem 0 0; background: transparent; border: none; justify-content: flex-end;">
                <button type="button" class="btn btn-accent btn-lg btn-next">Next Step →</button>
              </div>
            </div>

            <!-- ================= STEP 2: PART 1 (PROCESS) ================= -->
            <div class="wizard-step" id="step-2">
              <h2>Part 1: Select ONLY one process</h2>
              <p class="text-muted" style="margin-bottom: 1.5rem;">See page 6 for additional guidance, including information on how to treat employment tax credits.</p>
              
              <div class="radio-group">
                <label class="radio-card">
                  <input type="radio" name="process" value="adjusted">
                  <div class="radio-content">
                    <h4>1. Adjusted employment tax return.</h4>
                    <p>Check this box if you underreported tax amounts. Also check this box if you overreported tax amounts and you would like to use the adjustment process to correct the errors. You must check this box if you're correcting both underreported and overreported tax amounts on this form.</p>
                  </div>
                </label>

                <label class="radio-card">
                  <input type="radio" name="process" value="claim">
                  <div class="radio-content">
                    <h4>2. Claim.</h4>
                    <p>Check this box if you overreported tax amounts only and you would like to use the claim process to ask for a refund or abatement of the amount shown on line 27. Don't check this box if you're correcting ANY underreported tax amounts on this form.</p>
                  </div>
                </label>
              </div>

              <div class="wizard-footer" style="padding: 1.5rem 0 0; background: transparent; border: none;">
                <button type="button" class="btn btn-outline btn-lg btn-prev">← Back</button>
                <button type="button" class="btn btn-accent btn-lg btn-next">Next Step →</button>
              </div>
            </div>

            <!-- ================= STEP 3: PART 2 (CERTIFICATIONS) ================= -->
            <div class="wizard-step" id="step-3">
              <h2>Part 2: Complete the certifications</h2>
              
              <div class="checkbox-group" style="margin-bottom: 2rem;">
                <label style="display:flex; gap:1rem; align-items:flex-start;">
                  <input type="checkbox" style="margin-top:0.3rem;">
                  <div>
                    <strong>3. I certify that I've filed or will file Forms W-2, Wage and Tax Statement, or Forms W-2c, Corrected Wage and Tax Statement, as required.</strong>
                  </div>
                </label>
              </div>

              <!-- Certifications for Adjusted Return -->
              <div id="cert-adjusted" style="display:none; padding:1.5rem; background:var(--primary-light); border-radius:var(--radius); margin-bottom:1.5rem;">
                <p style="font-weight:600; margin-bottom:1rem; color:var(--primary-dark);">4. If you checked line 1 because you're adjusting overreported federal income tax, social security tax, Medicare tax, or Additional Medicare Tax, check all that apply. You must check at least one box.</p>
                <div class="checkbox-group">
                  <label style="display:flex; gap:0.75rem;"><input type="checkbox"><span><strong>a.</strong> I repaid or reimbursed each affected employee...</span></label>
                  <label style="display:flex; gap:0.75rem;"><input type="checkbox"><span><strong>b.</strong> The adjustments of social security tax and Medicare tax are for the employer's share only...</span></label>
                  <label style="display:flex; gap:0.75rem;"><input type="checkbox"><span><strong>c.</strong> The adjustment is for federal income tax, social security tax... that I didn't withhold from employee wages.</span></label>
                </div>
              </div>

              <!-- Certifications for Claim -->
              <div id="cert-claim" style="display:none; padding:1.5rem; background:#fff7ed; border-radius:var(--radius); margin-bottom:1.5rem;">
                <p style="font-weight:600; margin-bottom:1rem; color:#9a3412;">5. If you checked line 2 because you're claiming a refund or abatement of overreported federal income tax, social security tax, Medicare tax, or Additional Medicare Tax, check all that apply.</p>
                <div class="checkbox-group">
                  <label style="display:flex; gap:0.75rem;"><input type="checkbox"><span><strong>a.</strong> I repaid or reimbursed each affected employee...</span></label>
                  <label style="display:flex; gap:0.75rem;"><input type="checkbox"><span><strong>b.</strong> I have a written consent from each affected employee...</span></label>
                  <label style="display:flex; gap:0.75rem;"><input type="checkbox"><span><strong>c.</strong> The claim for social security tax and Medicare tax is for the employer's share only...</span></label>
                  <label style="display:flex; gap:0.75rem;"><input type="checkbox"><span><strong>d.</strong> The claim is for federal income tax... that I didn't withhold from employee wages.</span></label>
                </div>
              </div>

              <div class="wizard-footer" style="padding: 1.5rem 0 0; background: transparent; border: none;">
                <button type="button" class="btn btn-outline btn-lg btn-prev">← Back</button>
                <button type="button" class="btn btn-accent btn-lg btn-next">Next Step →</button>
              </div>
            </div>

            <!-- ================= STEP 4: PART 3 (CORRECTIONS) ================= -->
            <div class="wizard-step" id="step-4">
              <h2>Part 3: Enter the corrections for this quarter</h2>
              <p class="text-muted" style="margin-bottom: 1rem;">If any line doesn't apply, leave it blank.</p>

              <div class="table-responsive">
                <table class="pdf-table">
                  <thead>
                    <tr>
                      <th style="width: 35%;">Item</th>
                      <th style="width: 15%;">Col 1: Total Corrected Amount</th>
                      <th style="width: 15%;">Col 2: Amount Originally Reported</th>
                      <th style="width: 15%;">Col 3: Difference</th>
                      <th style="width: 20%;">Col 4: Tax Correction</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><strong>6.</strong> Wages, tips, and other compensation</td>
                      <td><input type="number" step="0.01"></td>
                      <td><input type="number" step="0.01"></td>
                      <td><input type="number" step="0.01" readonly style="background:#f1f5f9;"></td>
                      <td>(Use Col 1 on W-2)</td>
                    </tr>
                    <tr>
                      <td><strong>7.</strong> Federal income tax withheld</td>
                      <td><input type="number" step="0.01"></td>
                      <td><input type="number" step="0.01"></td>
                      <td><input type="number" step="0.01" readonly style="background:#f1f5f9;"></td>
                      <td><input type="number" step="0.01" placeholder="Copy Col 3"></td>
                    </tr>
                    <tr>
                      <td><strong>8.</strong> Taxable social security wages</td>
                      <td><input type="number" step="0.01"></td>
                      <td><input type="number" step="0.01"></td>
                      <td><input type="number" step="0.01" readonly style="background:#f1f5f9;"></td>
                      <td><input type="number" step="0.01" placeholder="x 0.124"></td>
                    </tr>
                    <tr>
                      <td><strong>12.</strong> Taxable Medicare wages &amp; tips</td>
                      <td><input type="number" step="0.01"></td>
                      <td><input type="number" step="0.01"></td>
                      <td><input type="number" step="0.01" readonly style="background:#f1f5f9;"></td>
                      <td><input type="number" step="0.01" placeholder="x 0.029"></td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <div class="wizard-footer" style="padding: 1.5rem 0 0; background: transparent; border: none;">
                <button type="button" class="btn btn-outline btn-lg btn-prev">← Back</button>
                <button type="button" class="btn btn-accent btn-lg btn-next">Next Step →</button>
              </div>
            </div>

            <!-- ================= STEP 5: PART 4 & 5 (SIGNATURE) ================= -->
            <div class="wizard-step" id="step-5">
              <h2>Part 4: Explain your corrections</h2>
              <div class="form-group" style="margin-bottom: 2rem;">
                <label>43. You must give us a detailed explanation of how you determined your corrections.</label>
                <textarea class="form-control" rows="5" placeholder="Enter detailed explanation here..."></textarea>
              </div>

              <h2>Part 5: Sign here</h2>
              <p class="text-muted" style="margin-bottom: 1.5rem; font-size: 0.85rem;">Under penalties of perjury, I declare that I have filed an original Form 941 or Form 941-SS and that I have examined this adjusted return or claim...</p>
              
              <div class="grid-2">
                <div class="form-group">
                  <label>Sign your name here <span class="req">*</span></label>
                  <input type="text" class="form-control" placeholder="Type your full legal name to sign" required>
                </div>
                <div class="form-group">
                  <label>Date <span class="req">*</span></label>
                  <input type="date" class="form-control" required>
                </div>
              </div>
              
              <div class="grid-2">
                <div class="form-group">
                  <label>Print your title here <span class="req">*</span></label>
                  <input type="text" class="form-control" placeholder="e.g., President, Owner" required>
                </div>
                <div class="form-group">
                  <label>Best daytime phone <span class="req">*</span></label>
                  <input type="text" class="form-control" placeholder="(XXX) XXX-XXXX" required>
                </div>
              </div>

              <div class="wizard-footer" style="padding: 1.5rem 0 0; background: transparent; border: none;">
                <button type="button" class="btn btn-outline btn-lg btn-prev">← Back</button>
                <button type="submit" class="btn btn-primary btn-lg" id="wizard-submit">Submit Form 941-X</button>
              </div>
            </div>

          </form>
        </div>
      </div>
    </main>
  </div>

  <script src="js/app.js"></script>
</body>
</html>
