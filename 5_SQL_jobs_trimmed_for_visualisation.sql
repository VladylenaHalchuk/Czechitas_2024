-- Add trimmed jobscz table for visualization
-- jobs_trimmed_for_visualisation

-- Create or replace the jobs_information_for_vis table to aggregate essential job data for visualization purposes.
CREATE OR REPLACE TABLE "jobs_information_for_vis" AS

-- Select unique records with fields related to job identification, company details, location, salary, dates, and categorized skills.
SELECT DISTINCT
    'jobscz' AS "source",  -- Static source identifier, indicating data sourced from 'jobscz'.
    jt."id",               -- Job identifier.
    jt."name",             -- Job title.
    jt."company",          -- Company offering the job.
    jk."place",            -- Geographical place of the job.
    jk."kraj",             -- Region ('kraj') of the job.
    jk."CZK_salary_from",  -- Starting salary range in CZK.
    jk."CZK_salary_to",    -- Ending salary range in CZK.
    jk."date_start",       -- Start date of the job listing.
    jk."date_end",         -- End date of the job listing.
    sen."Senior",          -- Seniority classification: Senior.
    sen."Medior",          -- Seniority classification: Medior.
    sen."Junior",          -- Seniority classification: Junior.
    jc."Fullstack_Developer", -- Job category: Fullstack Developer.
    jc."Backend_Developer",   -- Job category: Backend Developer.
    jc."Frontend_Developer",  -- Job category: Frontend Developer.
    jc."UX_UI_Designer",      -- Job category: UX/UI Designer.
    jc."Data_Analyst",        -- Job category: Data Analyst.
    jc."Data_Scientist",      -- Job category: Data Scientist.
    jc."Data_Engineer",       -- Job category: Data Engineer.
    jc."IT_Business_Analyst", -- Job category: IT Business Analyst.
    jc."QA_Specialist_Tester",-- Job category: QA Specialist Tester.
    jc."AI_Positions_all",    -- Job category: AI Positions (all).
    jc."AI_Engineer",         -- Job category: AI Engineer.
    jc."Project_Manager",     -- Job category: Project Manager.
    jc."Product_Manager",     -- Job category: Product Manager.
    jc."Product_Owner",       -- Job category: Product Owner.
    jc."SOC_Specialist",      -- Job category: SOC Specialist.
    jc."IT_Support"           -- Job category: IT Support.
FROM 
    "jobs_raw_scrape_trimmed" jt
LEFT JOIN "jobs_dist_id_kraj" jk ON jt."id" = jk."id"      -- Join to add regional and salary data.
LEFT JOIN "jobs_categorization" jc ON jt."id" = jc."id"    -- Join to add job category data.
LEFT JOIN "seniority" sen ON jt."id" = sen."id"            -- Join to add seniority classification.
LEFT JOIN "table_skills_positions" sp ON jt."id" = sp."id" -- Join to ensure only jobs with skills listed are included.
WHERE sp."skills" != '[]'                                  -- Include only those jobs that have associated skills.

-- Union the result with another set of pre-processed visualization data, also ensuring these have skills listed.
UNION
SELECT jg.* 
FROM "JG_for_visualization" jg
LEFT JOIN "table_skills_positions" sp2 ON jg."id" = sp2."id"
WHERE sp2."skills" != '[]'; -- Ensuring again that only jobs with listed skills are included.
