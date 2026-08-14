-- Create Schema if not exists
CREATE SCHEMA IF NOT EXISTS irs941;

-- 1. Roles
CREATE TABLE IF NOT EXISTS irs941.roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- 2. Users
CREATE TABLE IF NOT EXISTS irs941.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role_id INT REFERENCES irs941.roles(id),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Employer
CREATE TABLE IF NOT EXISTS irs941.employer (
    id SERIAL PRIMARY KEY,
    ein VARCHAR(10) NOT NULL UNIQUE, -- Format: NN-NNNNNNN
    business_name VARCHAR(150) NOT NULL,
    trade_name VARCHAR(150),
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Employer Contact
CREATE TABLE IF NOT EXISTS irs941.employer_contact (
    id SERIAL PRIMARY KEY,
    employer_id INT NOT NULL REFERENCES irs941.employer(id) ON DELETE CASCADE,
    contact_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    title VARCHAR(100)
);

-- 5. Form 941 Header
CREATE TABLE IF NOT EXISTS irs941.form_941_header (
    id SERIAL PRIMARY KEY,
    employer_id INT NOT NULL REFERENCES irs941.employer(id),
    tax_year INT NOT NULL,
    quarter INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT', -- DRAFT, SUBMITTED
    created_by INT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_employer_year_quarter UNIQUE (employer_id, tax_year, quarter)
);

-- 6. Form 941 Line (EAV pattern for form lines)
CREATE TABLE IF NOT EXISTS irs941.form_941_line (
    id SERIAL PRIMARY KEY,
    return_id INT NOT NULL REFERENCES irs941.form_941_header(id) ON DELETE CASCADE,
    line_number VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    value TEXT,
    calculated BOOLEAN DEFAULT FALSE,
    editable BOOLEAN DEFAULT TRUE,
    CONSTRAINT uk_return_line UNIQUE (return_id, line_number)
);

-- 7. Field Metadata
CREATE TABLE IF NOT EXISTS irs941.field_metadata (
    id SERIAL PRIMARY KEY,
    form_code VARCHAR(10) NOT NULL DEFAULT '941',
    line_number VARCHAR(10) NOT NULL,
    field_name VARCHAR(100) NOT NULL,
    label VARCHAR(255) NOT NULL,
    data_type VARCHAR(20) NOT NULL DEFAULT 'STRING', -- STRING, NUMBER, DECIMAL, BOOLEAN, DATE
    required BOOLEAN DEFAULT FALSE,
    editable BOOLEAN DEFAULT TRUE,
    regex VARCHAR(255),
    display_order INT DEFAULT 0,
    help_text TEXT
);

-- 8. Validation Error
CREATE TABLE IF NOT EXISTS irs941.validation_error (
    id SERIAL PRIMARY KEY,
    return_id INT REFERENCES irs941.form_941_header(id) ON DELETE CASCADE,
    field_name VARCHAR(100) NOT NULL,
    error_code VARCHAR(50) NOT NULL,
    error_message TEXT NOT NULL,
    severity VARCHAR(20) DEFAULT 'ERROR', -- ERROR, WARNING
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Audit Log
CREATE TABLE IF NOT EXISTS irs941.audit_log (
    id SERIAL PRIMARY KEY,
    action VARCHAR(50) NOT NULL, -- CREATE, UPDATE, SUBMIT, DELETE
    entity_name VARCHAR(50) NOT NULL,
    entity_id INT NOT NULL,
    performed_by VARCHAR(100),
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Initial Roles Data
INSERT INTO irs941.roles (id, name, description) VALUES (1, 'ADMIN', 'Administrator') ON CONFLICT DO NOTHING;
INSERT INTO irs941.roles (id, name, description) VALUES (2, 'USER', 'Standard User') ON CONFLICT DO NOTHING;

-- Initial User Data (admin / password123)
INSERT INTO irs941.users (username, email, password, role_id) 
VALUES ('admin', 'admin@efile941.com', 'password123', 1) 
ON CONFLICT DO NOTHING;

-- Initial Employer Data
INSERT INTO irs941.employer (id, ein, business_name, trade_name, address, city, state, zip) 
VALUES (1, '12-3456789', 'SAMPLE BUSINESS INC', 'Sample Biz', '123 Main St', 'Austin', 'TX', '78701') 
ON CONFLICT DO NOTHING;

INSERT INTO irs941.employer_contact (id, employer_id, contact_name, phone, email, title)
VALUES (1, 1, 'John Doe', '512-555-0199', 'contact@sample.com', 'CEO')
ON CONFLICT DO NOTHING;

-- Synchronize sequences with MAX(id)
SELECT setval('irs941.employer_id_seq', COALESCE((SELECT MAX(id) FROM irs941.employer), 1));
SELECT setval('irs941.employer_contact_id_seq', COALESCE((SELECT MAX(id) FROM irs941.employer_contact), 1));
SELECT setval('irs941.users_id_seq', COALESCE((SELECT MAX(id) FROM irs941.users), 1));
SELECT setval('irs941.roles_id_seq', COALESCE((SELECT MAX(id) FROM irs941.roles), 1));
SELECT setval('irs941.form_941_header_id_seq', COALESCE((SELECT MAX(id) FROM irs941.form_941_header), 1));
SELECT setval('irs941.form_941_line_id_seq', COALESCE((SELECT MAX(id) FROM irs941.form_941_line), 1));

