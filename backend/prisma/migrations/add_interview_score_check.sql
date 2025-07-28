-- Add CHECK constraint for interview score (0-100 range)
-- This constraint ensures interview scores are within valid range
ALTER TABLE interview ADD CONSTRAINT interview_score_check CHECK (score >= 0 AND score <= 100); 