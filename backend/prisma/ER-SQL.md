# SQL Script for LTI Talent Tracking System Database

This script creates the database schema for the LTI Talent Tracking System based on the ER diagram.

## Database Schema Creation

```sql
-- =====================================================
-- LTI TALENT TRACKING SYSTEM - DATABASE SCHEMA
-- =====================================================
-- This script creates the complete database schema for the LTI system
-- Based on the ER diagram from ER.md
-- 
-- Tables created:
-- 1. company - Stores company information
-- 2. employee - Stores employee data linked to companies
-- 3. position - Stores job positions offered by companies
-- 4. interview_flow - Defines interview processes
-- 5. interview_step - Individual steps within interview flows
-- 6. interview_type - Types of interviews (phone, technical, etc.)
-- 7. candidate - Stores candidate information
-- 8. application - Links candidates to positions
-- 9. interview - Stores interview results and feedback
-- =====================================================

-- Create database (uncomment if needed)
-- CREATE DATABASE lti_talent_tracking;
-- USE lti_talent_tracking;

-- =====================================================
-- CLEANUP: Drop existing tables in correct order
-- =====================================================
-- Tables are dropped in reverse dependency order to avoid foreign key conflicts
DROP TABLE IF EXISTS interview CASCADE;
DROP TABLE IF EXISTS application CASCADE;
DROP TABLE IF EXISTS interview_step CASCADE;
DROP TABLE IF EXISTS position CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS candidate CASCADE;
DROP TABLE IF EXISTS interview_flow CASCADE;
DROP TABLE IF EXISTS interview_type CASCADE;
DROP TABLE IF EXISTS company CASCADE;

-- =====================================================
-- TABLE CREATION: Independent tables (no foreign keys)
-- =====================================================

-- COMPANY table
-- Purpose: Stores basic company information
-- Relationships: Referenced by employee and position tables
CREATE TABLE company (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing primary key
    name VARCHAR(255) NOT NULL               -- Company name (required)
);

-- INTERVIEW_TYPE table
-- Purpose: Defines different types of interviews (phone, technical, behavioral, etc.)
-- Relationships: Referenced by interview_step table
CREATE TABLE interview_type (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing primary key
    name VARCHAR(100) NOT NULL,              -- Interview type name (e.g., "Phone Screening")
    description TEXT                         -- Detailed description of the interview type
);

-- INTERVIEW_FLOW table
-- Purpose: Defines complete interview processes for different job types
-- Relationships: Referenced by position and interview_step tables
CREATE TABLE interview_flow (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing primary key
    description TEXT                         -- Description of the interview flow process
);

-- =====================================================
-- TABLE CREATION: Dependent tables (with foreign keys)
-- =====================================================

-- EMPLOYEE table
-- Purpose: Stores employee information linked to companies
-- Relationships: 
--   - Belongs to a company (company_id FK)
--   - Conducts interviews (referenced by interview table)
CREATE TABLE employee (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing primary key
    company_id INTEGER NOT NULL,              -- Foreign key to company table
    name VARCHAR(255) NOT NULL,               -- Employee full name
    email VARCHAR(255) NOT NULL UNIQUE,       -- Employee email (unique across all employees)
    role VARCHAR(100) NOT NULL,               -- Employee role/title (e.g., "HR Manager", "Technical Lead")
    is_active BOOLEAN DEFAULT true,           -- Whether the employee is currently active
    FOREIGN KEY (company_id) REFERENCES company(id) ON DELETE CASCADE  -- Delete employee if company is deleted
);

-- POSITION table
-- Purpose: Stores job positions offered by companies
-- Relationships:
--   - Belongs to a company (company_id FK)
--   - Uses an interview flow (interview_flow_id FK)
--   - Receives applications (referenced by application table)
CREATE TABLE position (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing primary key
    company_id INTEGER NOT NULL,              -- Foreign key to company table
    interview_flow_id INTEGER NOT NULL,       -- Foreign key to interview_flow table
    title VARCHAR(255) NOT NULL,              -- Job title (e.g., "Senior Software Engineer")
    description TEXT,                         -- Brief position description
    status VARCHAR(50) DEFAULT 'active',      -- Position status (active, closed, draft, etc.)
    is_visible BOOLEAN DEFAULT true,          -- Whether the position is visible to candidates
    location VARCHAR(255),                    -- Job location (city, country, remote, etc.)
    job_description TEXT,                     -- Detailed job description
    requirements TEXT,                        -- Job requirements and qualifications
    responsibilities TEXT,                    -- Job responsibilities
    salary_min DECIMAL(10,2),                 -- Minimum salary (optional)
    salary_max DECIMAL(10,2),                 -- Maximum salary (optional)
    employment_type VARCHAR(50),              -- Employment type (full-time, part-time, contract, etc.)
    benefits TEXT,                            -- Benefits and perks
    company_description TEXT,                 -- Company description for the position
    application_deadline DATE,                -- Application deadline
    contact_info TEXT,                        -- Contact information for questions
    FOREIGN KEY (company_id) REFERENCES company(id) ON DELETE CASCADE,      -- Delete position if company is deleted
    FOREIGN KEY (interview_flow_id) REFERENCES interview_flow(id) ON DELETE RESTRICT  -- Prevent deletion if position uses this flow
);

-- INTERVIEW_STEP table
-- Purpose: Defines individual steps within interview flows
-- Relationships:
--   - Belongs to an interview flow (interview_flow_id FK)
--   - Uses an interview type (interview_type_id FK)
--   - Referenced by interview table
CREATE TABLE interview_step (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing primary key
    interview_flow_id INTEGER NOT NULL,       -- Foreign key to interview_flow table
    interview_type_id INTEGER NOT NULL,       -- Foreign key to interview_type table
    name VARCHAR(255) NOT NULL,               -- Step name (e.g., "Initial Phone Screening")
    order_index INTEGER NOT NULL,             -- Order of this step in the flow (1, 2, 3, etc.)
    FOREIGN KEY (interview_flow_id) REFERENCES interview_flow(id) ON DELETE CASCADE,    -- Delete steps if flow is deleted
    FOREIGN KEY (interview_type_id) REFERENCES interview_type(id) ON DELETE RESTRICT,   -- Prevent deletion if step uses this type
    UNIQUE(interview_flow_id, order_index)    -- Ensure unique order within each flow
);

-- CANDIDATE table
-- Purpose: Stores candidate information
-- Relationships:
--   - Submits applications (referenced by application table)
CREATE TABLE candidate (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing primary key
    first_name VARCHAR(255) NOT NULL,         -- Candidate's first name
    last_name VARCHAR(255) NOT NULL,          -- Candidate's last name
    email VARCHAR(255) NOT NULL UNIQUE,       -- Candidate's email (unique across all candidates)
    phone VARCHAR(50),                        -- Candidate's phone number (optional)
    address TEXT                              -- Candidate's address (optional)
);

-- APPLICATION table
-- Purpose: Links candidates to positions (many-to-many relationship)
-- Relationships:
--   - Links to a position (position_id FK)
--   - Links to a candidate (candidate_id FK)
--   - Has interviews (referenced by interview table)
CREATE TABLE application (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing primary key
    position_id INTEGER NOT NULL,             -- Foreign key to position table
    candidate_id INTEGER NOT NULL,            -- Foreign key to candidate table
    application_date DATE DEFAULT CURRENT_DATE, -- Date when application was submitted
    status VARCHAR(50) DEFAULT 'pending',     -- Application status (pending, reviewing, accepted, rejected, etc.)
    notes TEXT,                               -- Additional notes about the application
    FOREIGN KEY (position_id) REFERENCES position(id) ON DELETE CASCADE,    -- Delete application if position is deleted
    FOREIGN KEY (candidate_id) REFERENCES candidate(id) ON DELETE CASCADE   -- Delete application if candidate is deleted
);

-- INTERVIEW table
-- Purpose: Stores interview results and feedback
-- Relationships:
--   - Belongs to an application (application_id FK)
--   - Uses an interview step (interview_step_id FK)
--   - Conducted by an employee (employee_id FK)
CREATE TABLE interview (
    id SERIAL PRIMARY KEY,                    -- Auto-incrementing primary key
    application_id INTEGER NOT NULL,          -- Foreign key to application table
    interview_step_id INTEGER NOT NULL,       -- Foreign key to interview_step table
    employee_id INTEGER NOT NULL,             -- Foreign key to employee table (who conducted the interview)
    interview_date DATE NOT NULL,             -- Date when the interview took place
    result VARCHAR(50),                       -- Interview result (passed, failed, pending, etc.)
    score INTEGER CHECK (score >= 0 AND score <= 100), -- Interview score (0-100 scale)
    notes TEXT,                               -- Interview notes and feedback
    FOREIGN KEY (application_id) REFERENCES application(id) ON DELETE CASCADE,      -- Delete interview if application is deleted
    FOREIGN KEY (interview_step_id) REFERENCES interview_step(id) ON DELETE RESTRICT, -- Prevent deletion if interview uses this step
    FOREIGN KEY (employee_id) REFERENCES employee(id) ON DELETE RESTRICT            -- Prevent deletion if interview was conducted by this employee
);

-- =====================================================
-- PERFORMANCE OPTIMIZATION: Create indexes
-- =====================================================
-- Indexes are created on foreign key columns to improve query performance
-- These indexes will speed up JOIN operations and WHERE clauses on these columns

CREATE INDEX idx_employee_company ON employee(company_id);           -- Speed up queries filtering employees by company
CREATE INDEX idx_position_company ON position(company_id);           -- Speed up queries filtering positions by company
CREATE INDEX idx_position_flow ON position(interview_flow_id);       -- Speed up queries filtering positions by interview flow
CREATE INDEX idx_interview_step_flow ON interview_step(interview_flow_id); -- Speed up queries filtering steps by flow
CREATE INDEX idx_application_position ON application(position_id);   -- Speed up queries filtering applications by position
CREATE INDEX idx_application_candidate ON application(candidate_id); -- Speed up queries filtering applications by candidate
CREATE INDEX idx_interview_application ON interview(application_id); -- Speed up queries filtering interviews by application
CREATE INDEX idx_interview_step ON interview(interview_step_id);     -- Speed up queries filtering interviews by step
CREATE INDEX idx_interview_employee ON interview(employee_id);       -- Speed up queries filtering interviews by employee

-- =====================================================
-- SAMPLE DATA: Insert test data for development
-- =====================================================
-- This section inserts sample data to help with testing and development
-- You can comment out or remove this section in production

-- Sample companies
INSERT INTO company (name) VALUES 
('TechCorp'),           -- Technology company
('InnovateSoft'),       -- Software development company
('Digital Solutions');  -- Digital consulting company

-- Sample interview types (common interview formats)
INSERT INTO interview_type (name, description) VALUES 
('Phone Screening', 'Initial phone interview to assess basic qualifications and interest'),
('Technical Interview', 'Technical skills assessment and problem-solving evaluation'),
('Behavioral Interview', 'Assessment of soft skills, cultural fit, and past experiences'),
('Final Interview', 'Final round with senior management or hiring manager');

-- Sample interview flows (different processes for different job types)
INSERT INTO interview_flow (description) VALUES 
('Standard Engineering Position'),    -- Typical process for software engineers
('Senior Management Position'),       -- Process for senior/management roles
('Entry Level Position');             -- Simplified process for junior positions

-- Sample interview steps for Standard Engineering Position
-- This creates a complete interview process with 4 steps
INSERT INTO interview_step (interview_flow_id, interview_type_id, name, order_index) VALUES 
(1, 1, 'Initial Phone Screening', 1),    -- Step 1: Phone screening
(1, 2, 'Technical Assessment', 2),       -- Step 2: Technical evaluation
(1, 3, 'Behavioral Interview', 3),       -- Step 3: Cultural fit assessment
(1, 4, 'Final Interview', 4);            -- Step 4: Final decision

-- Sample employees (HR and technical staff)
INSERT INTO employee (company_id, name, email, role) VALUES 
(1, 'John Doe', 'john.doe@techcorp.com', 'HR Manager'),        -- HR representative
(1, 'Jane Smith', 'jane.smith@techcorp.com', 'Technical Lead'); -- Technical interviewer

-- Sample position (example job posting)
INSERT INTO position (company_id, interview_flow_id, title, description, location, employment_type) VALUES 
(1, 1, 'Senior Software Engineer', 'Looking for an experienced software engineer to join our team', 'Barcelona', 'Full-time');
```

## Database Design Notes

### Foreign Key Constraints
- **CASCADE**: Used when deleting the parent should delete all related records (e.g., deleting a company deletes all its employees and positions)
- **RESTRICT**: Used when deleting the parent should be prevented if child records exist (e.g., preventing deletion of interview types that are still being used)

### Performance Optimizations
- **Indexes**: Created on all foreign key columns to speed up JOIN operations
- **Unique constraints**: Applied where business logic requires uniqueness (e.g., email addresses, step order within flows)

### Data Validation
- **CHECK constraints**: Applied to ensure data integrity (e.g., interview scores between 0-100)
- **NOT NULL**: Applied to required fields
- **UNIQUE**: Applied to fields that must be unique across the system

### Sample Data
- Includes realistic test data for development and testing
- Can be safely removed in production environments
- Provides examples of how to structure data in the system

## Usage Instructions

### Prerequisites
1. PostgreSQL database server running
2. Database connection established
3. Appropriate permissions to create tables and indexes

### Execution Steps
1. **Connect to your database** using your preferred PostgreSQL client
2. **Run the complete script** to create all tables, indexes, and sample data
3. **Verify the schema** by checking that all tables were created successfully
4. **Test with sample data** to ensure relationships work correctly

### Verification Queries
After running the script, you can verify the setup with these queries:

```sql
-- Check all tables were created
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Check sample data was inserted
SELECT 'Companies' as table_name, COUNT(*) as count FROM company
UNION ALL
SELECT 'Employees', COUNT(*) FROM employee
UNION ALL
SELECT 'Positions', COUNT(*) FROM position
UNION ALL
SELECT 'Interview Types', COUNT(*) FROM interview_type;
```

## Entity Relationships Summary

### Core Business Entities
- **Company** → **Employee** (1:N) - Companies employ multiple employees
- **Company** → **Position** (1:N) - Companies offer multiple job positions
- **Candidate** → **Application** (1:N) - Candidates can submit multiple applications

### Interview Process Flow
- **Position** → **Interview Flow** (N:1) - Positions use predefined interview processes
- **Interview Flow** → **Interview Step** (1:N) - Flows contain multiple ordered steps
- **Interview Step** → **Interview Type** (N:1) - Steps use specific interview formats

### Application and Interview Tracking
- **Position** → **Application** (1:N) - Positions receive multiple applications
- **Application** → **Interview** (1:N) - Applications go through multiple interviews
- **Interview Step** → **Interview** (1:N) - Interview steps are executed as actual interviews
- **Employee** → **Interview** (1:N) - Employees conduct multiple interviews

### Data Integrity Rules
- **Cascade deletes**: Company deletion removes all related employees and positions
- **Restrict deletes**: Interview types and steps cannot be deleted if still in use
- **Unique constraints**: Email addresses and step orders must be unique
- **Validation rules**: Interview scores must be between 0 and 100 