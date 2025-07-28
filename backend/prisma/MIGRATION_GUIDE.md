# LTI Database Migration Guide - Optimized Schema

This guide documents the complete database migration process for the LTI Talent Tracking System with optimized schema including normalization, indexes, constraints, and audit fields.

## 🎯 Overview

The database has been optimized with the following improvements:

### ✅ **Normalization Applied**
- **Employment Types**: Normalized employment types (Full-time, Part-time, Contract, Internship)
- **Locations**: Normalized locations with city, state, and country
- **Application Statuses**: Normalized application statuses with color coding
- **Interview Results**: Normalized interview results
- **Position Statuses**: Normalized position statuses

### ✅ **Performance Optimizations**
- **Indexes**: 40+ strategic indexes for common query patterns
- **Composite Indexes**: Multi-column indexes for complex queries
- **Audit Indexes**: Indexes on created_at/updated_at for reporting

### ✅ **Data Integrity**
- **CHECK Constraints**: Validation rules for scores, dates, and ranges
- **Unique Constraints**: Prevent duplicate applications and ensure data uniqueness
- **Foreign Key Constraints**: Proper referential integrity

### ✅ **Audit Trail**
- **Timestamps**: created_at and updated_at on all tables
- **Soft Deletes**: is_active flags for logical deletion
- **Change Tracking**: Automatic timestamp updates

## 📊 Database Schema Summary

### Core Business Tables
| Table | Purpose | Key Features |
|-------|---------|--------------|
| `company` | Company information | Audit fields, active status |
| `employee` | Employee data | Company relationship, role tracking |
| `position` | Job positions | Normalized status, location, employment type |
| `candidate` | Candidate information | Email uniqueness, audit trail |
| `application` | Job applications | Status tracking, unique candidate-position |
| `interview` | Interview records | Result tracking, score validation |

### Normalized Lookup Tables
| Table | Purpose | Normalized Fields |
|-------|---------|-------------------|
| `employment_type` | Employment types | Full-time, Part-time, Contract, Internship |
| `location` | Geographic locations | City, State, Country combinations |
| `application_status` | Application states | Pending, Reviewing, Accepted, Rejected, Withdrawn |
| `interview_result` | Interview outcomes | Passed, Failed, Pending, Rescheduled |
| `position_status` | Position states | Active, Closed, Draft, Paused |

### Interview Process Tables
| Table | Purpose | Features |
|-------|---------|----------|
| `interview_type` | Interview formats | Phone, Technical, Behavioral, Final |
| `interview_flow` | Interview processes | Standard, Senior, Entry-level flows |
| `interview_step` | Process steps | Ordered steps within flows |

### Historical Data Tables
| Table | Purpose | Audit Features |
|-------|---------|----------------|
| `education` | Candidate education | Date validation, audit trail |
| `work_experience` | Work history | Date validation, audit trail |
| `resume` | Resume files | Upload tracking, audit trail |

## 🔧 Migration History

### 1. Initial Schema (20250728040103_add_lti_talent_tracking_system)
- Created basic tables from ER diagram
- Established foreign key relationships
- Basic indexes for foreign keys

### 2. Optimization Migration (20250728041158_optimize_database_with_normalization_and_indexes)
- **Added normalized lookup tables**
- **Implemented audit fields** (created_at, updated_at)
- **Added soft delete flags** (is_active)
- **Enhanced relationships** with proper constraints
- **Added unique constraints** for data integrity

### 3. Performance Migration (20250728041232_add_performance_indexes_and_constraints)
- **Added 40+ strategic indexes**
- **Implemented CHECK constraints** for data validation
- **Added composite indexes** for complex queries
- **Enhanced query performance** for common operations

## 📈 Performance Indexes

### Candidate Search Indexes
```sql
CREATE INDEX idx_candidate_email ON candidate(email);
CREATE INDEX idx_candidate_name ON candidate("firstName", "lastName");
CREATE INDEX idx_candidate_created ON candidate(created_at);
```

### Position Search Indexes
```sql
CREATE INDEX idx_position_title ON position(title);
CREATE INDEX idx_position_company_status ON position(company_id, position_status_id);
CREATE INDEX idx_position_location ON position(location_id);
CREATE INDEX idx_position_employment_type ON position(employment_type_id);
CREATE INDEX idx_position_visible_deadline ON position(is_visible, application_deadline);
```

### Application Search Indexes
```sql
CREATE INDEX idx_application_status ON application(application_status_id);
CREATE INDEX idx_application_date ON application(application_date);
CREATE INDEX idx_application_candidate_status ON application(candidate_id, application_status_id);
CREATE INDEX idx_application_position_status ON application(position_id, application_status_id);
```

### Interview Search Indexes
```sql
CREATE INDEX idx_interview_date ON interview(interview_date);
CREATE INDEX idx_interview_result ON interview(interview_result_id);
CREATE INDEX idx_interview_employee ON interview(employee_id);
CREATE INDEX idx_interview_step ON interview(interview_step_id);
```

### Composite Indexes for Complex Queries
```sql
CREATE INDEX idx_position_company_visible ON position(company_id, is_visible, application_deadline);
CREATE INDEX idx_application_candidate_date ON application(candidate_id, application_date DESC);
CREATE INDEX idx_interview_application_step ON interview(application_id, interview_step_id);
CREATE INDEX idx_employee_company_active ON employee(company_id, is_active);
```

## 🔒 Data Validation Constraints

### Score Validation
```sql
ALTER TABLE interview ADD CONSTRAINT interview_score_check 
CHECK (score >= 0 AND score <= 100);
```

### Salary Range Validation
```sql
ALTER TABLE position ADD CONSTRAINT position_salary_check 
CHECK (salary_min IS NULL OR salary_max IS NULL OR salary_min <= salary_max);
```

### Date Validation
```sql
ALTER TABLE application ADD CONSTRAINT application_date_check 
CHECK (application_date <= CURRENT_DATE);

ALTER TABLE interview ADD CONSTRAINT interview_date_check 
CHECK (interview_date <= CURRENT_DATE);
```

### Unique Constraints
```sql
-- Prevent duplicate applications
ALTER TABLE application ADD CONSTRAINT application_candidate_position_unique 
UNIQUE (candidate_id, position_id);

-- Ensure unique location combinations
ALTER TABLE location ADD CONSTRAINT location_unique 
UNIQUE (city, state, country);
```

## 🚀 Usage Instructions

### Prerequisites
1. **PostgreSQL Database**: Running and accessible
2. **Environment Variables**: DATABASE_URL configured
3. **Dependencies**: All npm packages installed

### Migration Commands
```bash
# Generate Prisma client
npm run prisma:generate

# Apply all migrations
npm run prisma:migrate

# Deploy migrations to production
npm run prisma:migrate:deploy

# Seed with sample data (optional)
npm run prisma:seed:optimized

# Open Prisma Studio for database inspection
npm run prisma:studio
```

### Verification Queries
```sql
-- Check all tables
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Check indexes
SELECT indexname, tablename FROM pg_indexes 
WHERE schemaname = 'public' 
ORDER BY tablename, indexname;

-- Check constraints
SELECT conname, conrelid::regclass, contype 
FROM pg_constraint 
WHERE connamespace = 'public'::regnamespace;
```

## 📋 Sample Data Structure

### Employment Types
- Full-time (with benefits)
- Part-time
- Contract
- Internship

### Application Statuses
- Pending (Orange)
- Reviewing (Blue)
- Accepted (Green)
- Rejected (Red)
- Withdrawn (Gray)

### Interview Results
- Passed
- Failed
- Pending
- Rescheduled

### Position Statuses
- Active
- Closed
- Draft
- Paused

## 🔍 Common Query Patterns

### Find Active Positions by Company
```sql
SELECT p.*, c.name as company_name, l.city, et.name as employment_type
FROM position p
JOIN company c ON p.company_id = c.id
LEFT JOIN location l ON p.location_id = l.id
LEFT JOIN employment_type et ON p.employment_type_id = et.id
WHERE p.is_visible = true 
AND p.application_deadline > CURRENT_DATE
AND c.is_active = true;
```

### Get Candidate Applications with Status
```sql
SELECT a.*, p.title, c.firstName, c.lastName, ast.name as status
FROM application a
JOIN position p ON a.position_id = p.id
JOIN candidate c ON a.candidate_id = c.id
JOIN application_status ast ON a.application_status_id = ast.id
WHERE c.email = 'candidate@example.com';
```

### Interview Schedule by Employee
```sql
SELECT i.*, e.name as employee_name, c.firstName, c.lastName, p.title
FROM interview i
JOIN employee e ON i.employee_id = e.id
JOIN application a ON i.application_id = a.id
JOIN candidate c ON a.candidate_id = c.id
JOIN position p ON a.position_id = p.id
WHERE i.interview_date >= CURRENT_DATE
ORDER BY i.interview_date;
```

## 🛠️ Maintenance

### Index Maintenance
```sql
-- Analyze table statistics
ANALYZE;

-- Check index usage
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

### Performance Monitoring
```sql
-- Check slow queries
SELECT query, calls, total_time, mean_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;
```

## 🔄 Future Enhancements

### Potential Improvements
1. **Partitioning**: For large tables (interviews, applications)
2. **Materialized Views**: For complex reports
3. **Full-text Search**: For candidate and position search
4. **Audit Triggers**: For detailed change tracking
5. **Data Archiving**: For old records

### Scalability Considerations
- **Read Replicas**: For heavy read workloads
- **Connection Pooling**: For high concurrency
- **Query Optimization**: Regular query analysis
- **Index Maintenance**: Periodic index rebuilding

## 📞 Support

For database-related issues:
1. Check migration status: `npx prisma migrate status`
2. Verify schema: `npx prisma db pull`
3. Reset database (development): `npx prisma migrate reset`
4. Generate client: `npx prisma generate`

## 📚 Additional Resources

- [Prisma Documentation](https://www.prisma.io/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Database Design Best Practices](https://www.postgresql.org/docs/current/ddl.html)
- [Performance Tuning Guide](https://www.postgresql.org/docs/current/performance-tips.html) 