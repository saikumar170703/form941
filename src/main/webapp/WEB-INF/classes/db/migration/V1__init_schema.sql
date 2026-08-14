/*
===============================================================================
IRS eFile Portal - Form 941 Database Architecture
Target Database: 941_newdb (PostgreSQL 14+) - PUBLIC SCHEMA ONLY
===============================================================================
*/

SET search_path TO public;

DROP SCHEMA IF EXISTS irs_efile CASCADE;
DROP SCHEMA IF EXISTS irs941 CASCADE;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. user_roles (Constant Table - READ ONLY from Java)
CREATE TABLE IF NOT EXISTS user_roles (
    role_id     INT PRIMARY KEY,
    role_name   VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- 2. users
CREATE TABLE IF NOT EXISTS users (
    user_id       BIGSERIAL PRIMARY KEY,
    full_name     VARCHAR(150) NOT NULL,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT,
    role_id       INT REFERENCES user_roles(role_id),
    status        VARCHAR(20) DEFAULT 'ACTIVE',
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. employers
CREATE TABLE IF NOT EXISTS employers (
    employer_id   BIGSERIAL PRIMARY KEY,
    ein           VARCHAR(20) NOT NULL UNIQUE,
    business_name VARCHAR(255) NOT NULL,
    trade_name    VARCHAR(255),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city          VARCHAR(100),
    state         CHAR(2),
    zip           VARCHAR(10),
    phone         VARCHAR(30),
    industry_code VARCHAR(100),
    contact_name  VARCHAR(150),
    contact_title VARCHAR(100),
    email         VARCHAR(255),
    created_by    BIGINT REFERENCES users(user_id) DEFAULT 1,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. tax_year (Constant Table - tax_year_id = year e.g. 2026, 2025, 2024)
CREATE TABLE IF NOT EXISTS tax_year (
    tax_year_id INT PRIMARY KEY,
    year        SMALLINT NOT NULL UNIQUE,
    status      VARCHAR(20) DEFAULT 'ACTIVE'
);

-- 5. tax_rates (Constant Table - linked with tax_year)
CREATE TABLE IF NOT EXISTS tax_rates (
    tax_rate_id        SERIAL PRIMARY KEY,
    tax_year_id        INT REFERENCES tax_year(tax_year_id),
    ss_rate            NUMERIC(5,4),
    ss_wage_base       NUMERIC(12,2),
    medicare_rate      NUMERIC(5,4),
    addl_medicare_rate NUMERIC(5,4),
    effective_from     DATE,
    effective_to       DATE
);

-- 6. form_941
CREATE TABLE IF NOT EXISTS form_941 (
    form941_id          BIGSERIAL PRIMARY KEY,
    employer_id         BIGINT REFERENCES employers(employer_id),
    tax_year_id         INT REFERENCES tax_year(tax_year_id),
    quarter             SMALLINT,
    filing_period_start DATE,
    filing_period_end   DATE,
    status              VARCHAR(20) DEFAULT 'DRAFT',
    created_by          BIGINT REFERENCES users(user_id),
    created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_amended          BOOLEAN DEFAULT FALSE
);

-- 7. form_941_detail (Comprehensive Form 941 data storage: Lines 1-19, Part 4 & Part 5)
CREATE TABLE IF NOT EXISTS form_941_detail (
    detail_id                      BIGSERIAL PRIMARY KEY,
    form941_id                     BIGINT REFERENCES form_941(form941_id) ON DELETE CASCADE,
    line1_num_employees            INT DEFAULT 0,
    line2_wages_tips_compensation  NUMERIC(15,2) DEFAULT 0,
    line3_fed_income_tax_withheld  NUMERIC(15,2) DEFAULT 0,
    line4_no_wages_subject_ss_med  BOOLEAN DEFAULT FALSE,
    line5a_taxable_ss_wages        NUMERIC(15,2) DEFAULT 0,
    line5a_ss_wages_tax            NUMERIC(15,2) DEFAULT 0,
    line5b_taxable_ss_tips         NUMERIC(15,2) DEFAULT 0,
    line5b_ss_tips_tax             NUMERIC(15,2) DEFAULT 0,
    line5c_taxable_med_wages       NUMERIC(15,2) DEFAULT 0,
    line5c_med_wages_tax           NUMERIC(15,2) DEFAULT 0,
    line5d_addl_med_wages          NUMERIC(15,2) DEFAULT 0,
    line5d_addl_med_tax            NUMERIC(15,2) DEFAULT 0,
    line5e_total_ss_med_tax        NUMERIC(15,2) DEFAULT 0,
    line5f_sec_3121q_tax           NUMERIC(15,2) DEFAULT 0,
    line6_total_tax_before_adj     NUMERIC(15,2) DEFAULT 0,
    line7_cents_adj                NUMERIC(15,2) DEFAULT 0,
    line8_sick_pay_adj             NUMERIC(15,2) DEFAULT 0,
    line9_tips_life_insurance_adj  NUMERIC(15,2) DEFAULT 0,
    line10_total_tax_after_adj     NUMERIC(15,2) DEFAULT 0,
    line11_payroll_tax_credit      NUMERIC(15,2) DEFAULT 0,
    line12_total_tax_after_credits NUMERIC(15,2) DEFAULT 0,
    line13_total_deposits          NUMERIC(15,2) DEFAULT 0,
    line14_balance_due             NUMERIC(15,2) DEFAULT 0,
    line15a_overpayment            NUMERIC(15,2) DEFAULT 0,
    line15b_overpayment_choice     VARCHAR(20),
    line15c_routing_number         VARCHAR(20),
    line15d_account_type           VARCHAR(20),
    line15e_account_number         VARCHAR(30),
    -- Lines 16-19
    line16_deposit_schedule        VARCHAR(30),
    line17_business_closed         BOOLEAN DEFAULT FALSE,
    line17_final_wages_date        DATE,
    line18_seasonal_employer       BOOLEAN DEFAULT FALSE,
    line19_payroll_tax_credit      NUMERIC(15,2) DEFAULT 0,
    -- Part 4: Third-Party Designee
    part4_designee_choice          VARCHAR(10),
    part4_designee_name            VARCHAR(150),
    part4_designee_phone           VARCHAR(30),
    part4_designee_pin             VARCHAR(10),
    -- Part 5: Signatures & Paid Preparer
    part5_signature_name           VARCHAR(150),
    part5_signature_title          VARCHAR(100),
    part5_signature_date           DATE,
    part5_signature_phone          VARCHAR(30),
    part5_paid_preparer_used       BOOLEAN DEFAULT FALSE,
    part5_preparer_self_employed   BOOLEAN DEFAULT FALSE,
    part5_preparer_name            VARCHAR(150),
    part5_preparer_ptin            VARCHAR(20),
    part5_preparer_signature       VARCHAR(150),
    part5_preparer_date            DATE,
    part5_preparer_firm_name       VARCHAR(255),
    part5_preparer_ein             VARCHAR(20),
    part5_preparer_address          VARCHAR(255),
    part5_preparer_phone           VARCHAR(30),
    part5_preparer_city            VARCHAR(100),
    part5_preparer_state           CHAR(2),
    part5_preparer_zip             VARCHAR(10),
    created_at                     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 8. form_941_schedule_b
CREATE TABLE IF NOT EXISTS form_941_schedule_b (
    scheduleb_id            BIGSERIAL PRIMARY KEY,
    form941_id              BIGINT REFERENCES form_941(form941_id) ON DELETE CASCADE,
    month1_tax_liability    NUMERIC(15,2) DEFAULT 0,
    month2_tax_liability    NUMERIC(15,2) DEFAULT 0,
    month3_tax_liability    NUMERIC(15,2) DEFAULT 0,
    total_quarter_liability NUMERIC(15,2) DEFAULT 0,
    created_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 8b. form_941_schedule_b_detail (Daily semiweekly tax liabilities per month)
CREATE TABLE IF NOT EXISTS form_941_schedule_b_detail (
    detail_id     BIGSERIAL PRIMARY KEY,
    form941_id    BIGINT REFERENCES form_941(form941_id) ON DELETE CASCADE,
    month_number  SMALLINT NOT NULL,
    day_number    SMALLINT NOT NULL,
    deposit_date  DATE,
    amount        NUMERIC(15,2) DEFAULT 0,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_scheduleb_form_month_day UNIQUE (form941_id, month_number, day_number)
);

-- 9. form_941_tax_liability_breakdown
CREATE TABLE IF NOT EXISTS form_941_tax_liability_breakdown (
    breakdown_id   BIGSERIAL PRIMARY KEY,
    form941_id     BIGINT REFERENCES form_941(form941_id) ON DELETE CASCADE,
    ss_wages       NUMERIC(15,2) DEFAULT 0,
    ss_tax         NUMERIC(15,2) DEFAULT 0,
    med_wages      NUMERIC(15,2) DEFAULT 0,
    med_tax        NUMERIC(15,2) DEFAULT 0,
    addl_med_wages NUMERIC(15,2) DEFAULT 0,
    addl_med_tax   NUMERIC(15,2) DEFAULT 0
);

-- 10. payments
CREATE TABLE IF NOT EXISTS payments (
    payment_id            BIGSERIAL PRIMARY KEY,
    form941_id            BIGINT REFERENCES form_941(form941_id),
    payment_date          DATE,
    payment_type          VARCHAR(30),
    amount                NUMERIC(15,2) DEFAULT 0,
    payment_method        VARCHAR(30),
    transaction_reference VARCHAR(100),
    created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 11. efile_submissions
CREATE TABLE IF NOT EXISTS efile_submissions (
    submission_id           BIGSERIAL PRIMARY KEY,
    form941_id              BIGINT REFERENCES form_941(form941_id),
    submission_type         VARCHAR(20) DEFAULT 'ORIGINAL',
    submitted_by_user_id    BIGINT REFERENCES users(user_id),
    submission_timestamp    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    irs_acknowledgment_code VARCHAR(10),
    irs_acknowledgment_date TIMESTAMP,
    status                  VARCHAR(20) DEFAULT 'SUBMITTED',
    rejection_reason        TEXT,
    transmission_id         VARCHAR(100),
    created_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 12. efile_attachments
CREATE TABLE IF NOT EXISTS efile_attachments (
    attachment_id       BIGSERIAL PRIMARY KEY,
    submission_id       BIGINT REFERENCES efile_submissions(submission_id) ON DELETE CASCADE,
    file_name           VARCHAR(255),
    file_path           TEXT,
    file_type           VARCHAR(50),
    file_size           BIGINT,
    uploaded_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    uploaded_by_user_id BIGINT REFERENCES users(user_id)
);

-- 13. audit_logs
CREATE TABLE IF NOT EXISTS audit_logs (
    audit_id           BIGSERIAL PRIMARY KEY,
    table_name         VARCHAR(100),
    record_id          BIGINT,
    action             VARCHAR(20),
    old_values         JSONB,
    new_values         JSONB,
    changed_by_user_id BIGINT REFERENCES users(user_id),
    changed_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_address         VARCHAR(45)
);

-- Seed Constant Reference Data
INSERT INTO user_roles (role_id, role_name, description) VALUES
(1, 'DBA_ADMIN', 'Full Database Access'),
(2, 'APP_ADMIN', 'Application Admin'),
(3, 'TAX_PREPARER', 'Prepare & File Returns'),
(4, 'AUDITOR', 'Read Only (Audit)'),
(5, 'VIEWER', 'Read Only (Reports)')
ON CONFLICT (role_id) DO NOTHING;

INSERT INTO users (full_name, email, password_hash, role_id, status) VALUES
('System Admin', 'admin@efile941.com', 'password123', 1, 'ACTIVE')
ON CONFLICT (email) DO NOTHING;

INSERT INTO tax_year (tax_year_id, year, status) VALUES
(2026, 2026, 'ACTIVE'),
(2025, 2025, 'ACTIVE'),
(2024, 2024, 'ACTIVE')
ON CONFLICT (tax_year_id) DO NOTHING;

INSERT INTO tax_rates (tax_year_id, ss_rate, ss_wage_base, medicare_rate, addl_medicare_rate, effective_from) VALUES
(2026, 0.0620, 184500.00, 0.0145, 0.0090, '2026-01-01'),
(2025, 0.0620, 176100.00, 0.0145, 0.0090, '2025-01-01'),
(2024, 0.0620, 168600.00, 0.0145, 0.0090, '2024-01-01')
ON CONFLICT DO NOTHING;
