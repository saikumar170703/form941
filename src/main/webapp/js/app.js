/* ============================================================
   eFile941 — Application JavaScript
   ============================================================ */

/* ---- Announcement Bar close ---- */
(function () {
  var closeBtn = document.getElementById('ann-close');
  if (closeBtn) {
    closeBtn.addEventListener('click', function () {
      var bar = document.getElementById('announcement-bar');
      if (bar) {
        bar.style.maxHeight = bar.scrollHeight + 'px';
        bar.style.overflow  = 'hidden';
        bar.style.transition = 'max-height .4s ease, padding .4s ease, opacity .3s ease';
        requestAnimationFrame(function () {
          bar.style.maxHeight = '0';
          bar.style.padding   = '0';
          bar.style.opacity   = '0';
        });
        setTimeout(function () { bar.style.display = 'none'; }, 420);
      }
    });
  }
})();

/* ---- Password Show/Hide Toggle ---- */
document.querySelectorAll('.toggle-pw').forEach(function (btn) {
  btn.addEventListener('click', function () {
    var input = this.previousElementSibling;
    if (!input) return;
    if (input.type === 'password') {
      input.type = 'text';
      this.textContent = '🙈';
      this.title = 'Hide password';
    } else {
      input.type = 'password';
      this.textContent = '👁';
      this.title = 'Show password';
    }
  });
});

/* ---- Login Form ---- */
(function () {
  var loginForm = document.getElementById('login-form');
  if (!loginForm) return;

  var DEMO_EMAIL    = 'admin@efile941.com';
  var DEMO_PASSWORD = 'password123';

  loginForm.addEventListener('submit', function (e) {
    e.preventDefault();
    clearErrors();

    var email = document.getElementById('email').value.trim();
    var pass  = document.getElementById('password').value;
    var btn   = document.getElementById('login-btn');
    var alert = document.getElementById('login-alert');
    var valid = true;

    if (!email) {
      showFieldError('email-error', 'Email address is required.');
      valid = false;
    } else if (!isValidEmail(email)) {
      showFieldError('email-error', 'Please enter a valid email address.');
      valid = false;
    }
    if (!pass) {
      showFieldError('pass-error', 'Password is required.');
      valid = false;
    }
    if (!valid) return;

    // Simulate loading
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner"></span>&nbsp;Logging in…';

    setTimeout(function () {
      if (email === DEMO_EMAIL && pass === DEMO_PASSWORD) {
        // Store session
        sessionStorage.setItem('ef941_user', JSON.stringify({ name: 'Admin User', email: email }));
        window.location.href = 'dashboard.jsp';
      } else {
        btn.disabled = false;
        btn.textContent = 'Login';
        if (alert) {
          alert.className = 'alert-msg error';
          alert.textContent = 'Invalid email or password. Use admin@efile941.com / password123 to demo.';
        }
      }
    }, 1000);
  });
})();

/* ---- Register Form ---- */
(function () {
  var regForm = document.getElementById('register-form');
  if (!regForm) return;

  regForm.addEventListener('submit', function (e) {
    e.preventDefault();
    clearErrors();

    var name     = document.getElementById('reg-name').value.trim();
    var email    = document.getElementById('reg-email').value.trim();
    var pass     = document.getElementById('reg-password').value;
    var confirm  = document.getElementById('reg-confirm').value;
    var btn      = document.getElementById('reg-btn');
    var alert    = document.getElementById('reg-alert');
    var valid    = true;

    if (!name)  { showFieldError('name-error', 'Full name is required.'); valid = false; }
    if (!email) { showFieldError('reg-email-error', 'Email is required.'); valid = false; }
    else if (!isValidEmail(email)) { showFieldError('reg-email-error', 'Enter a valid email.'); valid = false; }
    if (pass.length < 8) { showFieldError('reg-pass-error', 'Password must be at least 8 characters.'); valid = false; }
    if (pass !== confirm) { showFieldError('reg-confirm-error', 'Passwords do not match.'); valid = false; }
    if (!valid) return;

    btn.disabled = true;
    btn.innerHTML = '<span class="spinner"></span>&nbsp;Creating Account…';

    setTimeout(function () {
      // Simulate success — store and redirect
      sessionStorage.setItem('ef941_user', JSON.stringify({ name: name, email: email }));
      if (alert) {
        alert.className = 'alert-msg success';
        alert.textContent = '🎉 Account created successfully! Redirecting to your dashboard…';
      }
      setTimeout(function () { window.location.href = 'dashboard.jsp'; }, 1200);
    }, 1200);
  });
})();

/* ---- Dashboard Auth Guard ---- */
(function () {
  if (document.body.classList.contains('dash-page')) {
    var user = sessionStorage.getItem('ef941_user');
    if (!user) {
      window.location.href = 'login.jsp';
      return;
    }
    var parsed = JSON.parse(user);
    // Populate user info
    var avatarEl = document.getElementById('user-avatar-initials');
    var nameEl   = document.getElementById('dash-user-name');
    if (parsed && parsed.name) {
      var initials = parsed.name.split(' ').map(function (w) { return w[0]; }).join('').toUpperCase().slice(0,2);
      if (avatarEl) avatarEl.textContent = initials;
      if (nameEl)   nameEl.textContent   = parsed.name;
    }
  }
})();

/* ---- Sidebar Collapse ---- */
/* ---- Sidebar Collapse ---- */
(function () {
  var sidebarToggle = document.getElementById('sidebar-toggle');
  var sidebar       = document.getElementById('sidebar');
  var body          = document.body;

  if (!sidebarToggle || !sidebar) return;

  sidebarToggle.addEventListener('click', function () {
    sidebar.classList.toggle('collapsed');
    body.classList.toggle('sidebar-collapsed');

    var icon = this.querySelector('.toggle-icon');
    if (icon) {
      icon.textContent = sidebar.classList.contains('collapsed') ? '→' : '←';
    }
  });
})();

/* ---- Form 941-X Wizard ---- */
(function () {
  var currentStep = 1;
  var totalSteps = 5;

  var nextBtns = document.querySelectorAll('.btn-next');
  var prevBtns = document.querySelectorAll('.btn-prev');
  var submitBtn = document.getElementById('wizard-submit');

  function showStep(step) {
    document.querySelectorAll('.wizard-step').forEach(function(el) {
      el.classList.remove('active');
    });
    var stepEl = document.getElementById('step-' + step);
    if (stepEl) {
      stepEl.classList.add('active');
    }

    // Update progress bar
    document.querySelectorAll('.progress-step').forEach(function(el, index) {
      el.classList.remove('active', 'completed');
      if (index + 1 === step) {
        el.classList.add('active');
      } else if (index + 1 < step) {
        el.classList.add('completed');
        var circle = el.querySelector('.step-circle');
        if (circle) circle.innerHTML = '✓';
      } else {
        var circle = el.querySelector('.step-circle');
        if (circle) circle.innerHTML = (index + 1);
      }
    });
  }

  nextBtns.forEach(function(btn) {
    btn.addEventListener('click', function() {
      // Validate current step
      var currentStepEl = document.getElementById('step-' + currentStep);
      if (currentStepEl) {
        var requiredFields = currentStepEl.querySelectorAll('[required]');
        var allValid = true;
        
        requiredFields.forEach(function(field) {
          if (!field.value.trim()) {
            allValid = false;
            field.style.borderColor = 'var(--danger)';
          } else {
            field.style.borderColor = ''; // reset
          }
        });

        if (!allValid) {
          alert('Please fill in all mandatory fields before proceeding.');
          return; // Stop here
        }
      }

      if (currentStep < totalSteps) {
        currentStep++;
        showStep(currentStep);
        window.scrollTo(0, 0);
      }
    });
  });

  prevBtns.forEach(function(btn) {
    btn.addEventListener('click', function() {
      if (currentStep > 1) {
        currentStep--;
        showStep(currentStep);
        window.scrollTo(0, 0);
      }
    });
  });

  if (submitBtn) {
    submitBtn.addEventListener('click', function(e) {
      e.preventDefault();
      alert('Form 941-X has been submitted successfully! Redirecting to dashboard...');
      setTimeout(function() {
        window.location.href = 'dashboard.jsp';
      }, 1500);
    });
  }

  // Handle Part 1 Selection showing/hiding Part 2 options
  var part1Radios = document.querySelectorAll('input[name="process"]');
  var certAdjusted = document.getElementById('cert-adjusted');
  var certClaim = document.getElementById('cert-claim');

  part1Radios.forEach(function(radio) {
    radio.addEventListener('change', function() {
      if (this.value === 'adjusted') {
        if (certAdjusted) certAdjusted.style.display = 'block';
        if (certClaim) certClaim.style.display = 'none';
      } else if (this.value === 'claim') {
        if (certAdjusted) certAdjusted.style.display = 'none';
        if (certClaim) certClaim.style.display = 'block';
      }
    });
  });
})();

/* ---- Sidebar Accordion ---- */
document.querySelectorAll('.nav-item.expandable > button').forEach(function (btn) {
  btn.addEventListener('click', function () {
    var item = this.closest('.nav-item');
    var isOpen = item.classList.contains('open');
    // Close all
    document.querySelectorAll('.nav-item.expandable').forEach(function (el) {
      el.classList.remove('open');
    });
    if (!isOpen) item.classList.add('open');
  });
});

/* ---- Logout ---- */
(function () {
  var logoutBtn = document.getElementById('logout-btn');
  if (!logoutBtn) return;
  logoutBtn.addEventListener('click', function () {
    sessionStorage.removeItem('ef941_user');
    window.location.href = 'index.jsp';
  });
})();

/* ---- Dashboard: Add New Organization modal mock ---- */
(function () {
  var btn = document.getElementById('btn-add-org');
  if (!btn) return;
  btn.addEventListener('click', function () {
    alert('Add New Organization – This feature would open a wizard to add a new organization.');
  });
})();


/* ---- Helpers ---- */
function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}
function showFieldError(id, msg) {
  var el = document.getElementById(id);
  if (el) { el.textContent = msg; el.classList.add('show'); }
  var inputId = id.replace('-error', '');
  var input   = document.getElementById(inputId);
  if (!input) {
    inputId = id.replace('-error', '').replace('reg-', 'reg-');
    input   = document.getElementById(inputId);
  }
  if (input) input.classList.add('error');
}
function clearErrors() {
  document.querySelectorAll('.form-error').forEach(function (el) { el.classList.remove('show'); el.textContent = ''; });
  document.querySelectorAll('.form-control.error').forEach(function (el) { el.classList.remove('error'); });
  var alerts = document.querySelectorAll('.alert-msg');
  alerts.forEach(function (a) { a.className = 'alert-msg'; a.textContent = ''; });
}


function formatEIN(input) {
    // Remove everything except digits
    let value = input.value.replace(/\D/g, "");

    // Limit to 9 digits
    value = value.substring(0, 9);

    // Insert hyphen after first 2 digits
    if (value.length > 2) {
        value = value.substring(0, 2) + "-" + value.substring(2);
    }

    input.value = value;
}

document.addEventListener("DOMContentLoaded", function () {
    const einInput = document.getElementById("ein-input");
    if (einInput) {
        einInput.addEventListener("input", function () {
            formatEIN(this);
        });
    }
});

/* ---- Global Reusable Table Pagination Function ---- */
window.setupTablePagination = function(tableId, infoId, paginationId, pageSize) {
    const table = document.getElementById(tableId);
    if (!table) return;
    const tbody = table.querySelector('tbody');
    if (!tbody) return;
    const rows = Array.from(tbody.querySelectorAll('tr')).filter(tr => !tr.querySelector('td[colspan]'));
    const totalRows = rows.length;

    const infoEl = document.getElementById(infoId);
    const nav = document.getElementById(paginationId);

    if (totalRows === 0) {
        if (infoEl) infoEl.innerText = "No entries to display";
        if (nav) nav.innerHTML = '';
        return;
    }

    const totalPages = Math.ceil(totalRows / pageSize);
    let currentPage = 1;

    function renderPage(page) {
        currentPage = page;
        const start = (page - 1) * pageSize;
        const end = start + pageSize;

        rows.forEach((row, idx) => {
            row.style.display = (idx >= start && idx < end) ? '' : 'none';
        });

        const showingStart = start + 1;
        const showingEnd = Math.min(end, totalRows);
        if (infoEl) {
            infoEl.innerText = 'Showing ' + showingStart + ' to ' + showingEnd + ' of ' + totalRows + ' entries';
        }

        if (!nav) return;
        nav.innerHTML = '';

        // Prev
        const prevLi = document.createElement('li');
        prevLi.className = 'page-item ' + (currentPage === 1 ? 'disabled' : '');
        prevLi.innerHTML = '<a class="page-link" href="#" aria-label="Previous">&laquo; Prev</a>';

        prevLi.onclick = function(e) {
            e.preventDefault();
            if (currentPage > 1) renderPage(currentPage - 1);
        };
        nav.appendChild(prevLi);

        // Page Numbers
        for (let i = 1; i <= totalPages; i++) {
            const li = document.createElement('li');
            li.className = 'page-item ' + (i === currentPage ? 'active' : '');
            li.innerHTML = '<a class="page-link" href="#">' + i + '</a>';
            li.onclick = (function(p) {
                return function(e) {
                    e.preventDefault();
                    renderPage(p);
                };
            })(i);
            nav.appendChild(li);
        }

        // Next
        const nextLi = document.createElement('li');
        nextLi.className = 'page-item ' + (currentPage === totalPages ? 'disabled' : '');
        nextLi.innerHTML = '<a class="page-link" href="#" aria-label="Next">Next &raquo;</a>';

        nextLi.onclick = function(e) {
            e.preventDefault();
            if (currentPage < totalPages) renderPage(currentPage + 1);
        };
        nav.appendChild(nextLi);
    }

    renderPage(1);
};




