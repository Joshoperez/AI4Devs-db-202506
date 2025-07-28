-- =====================================================
-- PERFORMANCE OPTIMIZATION: Additional Indexes and Constraints
-- =====================================================

-- Add CHECK constraint for interview score (0-100 range)
ALTER TABLE interview ADD CONSTRAINT interview_score_check CHECK (score >= 0 AND score <= 100);

-- Add CHECK constraint for salary range (min <= max)
ALTER TABLE position ADD CONSTRAINT position_salary_check CHECK (salary_min IS NULL OR salary_max IS NULL OR salary_min <= salary_max);

-- Add CHECK constraint for application date (not in future)
ALTER TABLE application ADD CONSTRAINT application_date_check CHECK (application_date <= CURRENT_DATE);

-- Add CHECK constraint for interview date (not in future)
ALTER TABLE interview ADD CONSTRAINT interview_date_check CHECK (interview_date <= CURRENT_DATE);

-- Add CHECK constraint for education dates (start <= end)
ALTER TABLE education ADD CONSTRAINT education_date_check CHECK (end_date IS NULL OR start_date <= end_date);

-- Add CHECK constraint for work experience dates (start <= end)
ALTER TABLE work_experience ADD CONSTRAINT work_experience_date_check CHECK (end_date IS NULL OR start_date <= end_date);

-- =====================================================
-- PERFORMANCE INDEXES FOR FREQUENT QUERIES
-- =====================================================

-- Indexes for candidate searches
CREATE INDEX idx_candidate_email ON candidate(email);
CREATE INDEX idx_candidate_name ON candidate(first_name, last_name);
CREATE INDEX idx_candidate_created ON candidate(created_at);

-- Indexes for position searches
CREATE INDEX idx_position_title ON position(title);
CREATE INDEX idx_position_company_status ON position(company_id, position_status_id);
CREATE INDEX idx_position_location ON position(location_id);
CREATE INDEX idx_position_employment_type ON position(employment_type_id);
CREATE INDEX idx_position_visible_deadline ON position(is_visible, application_deadline);
CREATE INDEX idx_position_created ON position(created_at);

-- Indexes for application searches
CREATE INDEX idx_application_status ON application(application_status_id);
CREATE INDEX idx_application_date ON application(application_date);
CREATE INDEX idx_application_candidate_status ON application(candidate_id, application_status_id);
CREATE INDEX idx_application_position_status ON application(position_id, application_status_id);
CREATE INDEX idx_application_created ON application(created_at);

-- Indexes for interview searches
CREATE INDEX idx_interview_date ON interview(interview_date);
CREATE INDEX idx_interview_result ON interview(interview_result_id);
CREATE INDEX idx_interview_employee ON interview(employee_id);
CREATE INDEX idx_interview_step ON interview(interview_step_id);
CREATE INDEX idx_interview_application_date ON interview(application_id, interview_date);
CREATE INDEX idx_interview_created ON interview(created_at);

-- Indexes for employee searches
CREATE INDEX idx_employee_email ON employee(email);
CREATE INDEX idx_employee_company_role ON employee(company_id, role);
CREATE INDEX idx_employee_active ON employee(is_active);
CREATE INDEX idx_employee_created ON employee(created_at);

-- Indexes for company searches
CREATE INDEX idx_company_name ON company(name);
CREATE INDEX idx_company_active ON company(is_active);
CREATE INDEX idx_company_created ON company(created_at);

-- Indexes for lookup tables
CREATE INDEX idx_employment_type_active ON employment_type(is_active);
CREATE INDEX idx_location_active ON location(is_active);
CREATE INDEX idx_application_status_active ON application_status(is_active);
CREATE INDEX idx_interview_result_active ON interview_result(is_active);
CREATE INDEX idx_position_status_active ON position_status(is_active);
CREATE INDEX idx_interview_type_active ON interview_type(is_active);
CREATE INDEX idx_interview_flow_active ON interview_flow(is_active);

-- Composite indexes for common query patterns
CREATE INDEX idx_position_company_visible ON position(company_id, is_visible, application_deadline);
CREATE INDEX idx_application_candidate_date ON application(candidate_id, application_date DESC);
CREATE INDEX idx_interview_application_step ON interview(application_id, interview_step_id);
CREATE INDEX idx_employee_company_active ON employee(company_id, is_active);

-- Indexes for audit fields (useful for reporting)
CREATE INDEX idx_candidate_updated ON candidate(updated_at);
CREATE INDEX idx_position_updated ON position(updated_at);
CREATE INDEX idx_application_updated ON application(updated_at);
CREATE INDEX idx_interview_updated ON interview(updated_at);
CREATE INDEX idx_employee_updated ON employee(updated_at); 