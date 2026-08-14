CREATE SCHEMA IF NOT EXISTS irs941;

SET search_path TO irs941;

-- 1. users
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    enabled BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. roles
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS user_roles (
    user_id INT REFERENCES users(id),
    role_id INT REFERENCES roles(id),
    PRIMARY KEY (user_id, role_id)
);

-- 3. employer
CREATE TABLE IF NOT EXISTS employer (
    id SERIAL PRIMARY KEY,
    ein VARCHAR(10) NOT NULL UNIQUE,
    business_name VARCHAR(100) NOT NULL,
    trade_name VARCHAR(100),
    address VARCHAR(200) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    zip VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted BOOLEAN DEFAULT false
);

-- 4. employer_contact
CREATE TABLE IF NOT EXISTS employer_contact (
    id SERIAL PRIMARY KEY,
    employer_id INT NOT NULL REFERENCES employer(id),
    contact_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    is_primary BOOLEAN DEFAULT true
);

-- 5. form_941_header
CREATE TABLE IF NOT EXISTS form_941_header (
    id SERIAL PRIMARY KEY,
    employer_id INT NOT NULL REFERENCES employer(id),
    tax_year INT NOT NULL,
    quarter INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. form_941_line
CREATE TABLE IF NOT EXISTS form_941_line (
    id SERIAL PRIMARY KEY,
    return_id INT NOT NULL REFERENCES form_941_header(id),
    line_number VARCHAR(10) NOT NULL,
    description VARCHAR(255),
    value VARCHAR(255),
    calculated BOOLEAN DEFAULT false,
    editable BOOLEAN DEFAULT true,
    UNIQUE(return_id, line_number)
);

-- 7. field_metadata
CREATE TABLE IF NOT EXISTS field_metadata (
    id SERIAL PRIMARY KEY,
    form_code VARCHAR(10) NOT NULL DEFAULT '941',
    line_number VARCHAR(10) NOT NULL,
    field_name VARCHAR(100) NOT NULL,
    label VARCHAR(255) NOT NULL,
    data_type VARCHAR(20) NOT NULL,
    required BOOLEAN DEFAULT false,
    editable BOOLEAN DEFAULT true,
    regex VARCHAR(255),
    display_order INT,
    help_text TEXT
);

-- 8. validation_error
CREATE TABLE IF NOT EXISTS validation_error (
    id SERIAL PRIMARY KEY,
    return_id INT NOT NULL REFERENCES form_941_header(id),
    line_number VARCHAR(10),
    error_code VARCHAR(50) NOT NULL,
    error_message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. audit_log
CREATE TABLE IF NOT EXISTS audit_log (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    action VARCHAR(50) NOT NULL,
    entity_name VARCHAR(50),
    entity_id INT,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Initial Roles
INSERT INTO roles (name) VALUES ('ROLE_USER'), ('ROLE_ADMIN') ON CONFLICT DO NOTHING;

-- Initial User (password is 'password' for demo purposes, hash in production)
INSERT INTO users (username, password, email) VALUES ('john', 'password', 'john@example.com') ON CONFLICT DO NOTHING;
INSERT INTO user_roles (user_id, role_id) 
SELECT u.id, r.id FROM users u, roles r WHERE u.username = 'john' AND r.name = 'ROLE_USER'
ON CONFLICT DO NOTHING;
