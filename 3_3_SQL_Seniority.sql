-- Create list of skills and list of positions
-- Seniority

-- Create or replace the seniority table to categorize job listings based on seniority level using keywords found in job titles or descriptions.
CREATE OR REPLACE TABLE "seniority" AS
SELECT
    "id",
    "name",

    -- Categorize as Senior if the job title or description contains keywords indicating a senior level or significant experience (5+ years).
    CASE
        WHEN "name" ILIKE '%senior%' OR 
             "bodyHtml" ILIKE '%senior%' OR
             "name" ILIKE '%Lead%' OR 
             "name" ILIKE '%Teamlead%' OR
             "bodyHtml" ILIKE '%5 years%' OR 
             "bodyHtml" ILIKE '%5+ years%' OR
             "bodyHtml" ILIKE '%5 let%' OR 
             "bodyHtml" ILIKE '%5+ let%' OR
             "name" ILIKE '%vedoucí%' OR 
             "bodyHtml" ILIKE '%odborník%' THEN TRUE
        ELSE FALSE
    END AS "Senior",

    -- Categorize as Medior if the job title or description contains keywords indicating a mid-level experience (typically 2-3 years).
    CASE
        WHEN "name" ILIKE '%medior%' OR 
             "bodyHtml" ILIKE '%medior%' OR
             "name" ILIKE '%middle%' OR 
             "name" ILIKE '%zkušený%' OR 
             "name" ILIKE '%zkušeného%' OR
             "bodyHtml" ILIKE '%middle%' OR 
             "bodyHtml" ILIKE '%3 years%' OR
             "bodyHtml" ILIKE '%3+ years%' OR 
             "bodyHtml" ILIKE '%2 years%' OR
             "bodyHtml" ILIKE '%2+ years%' OR 
             "bodyHtml" ILIKE '%3 roky%' OR
             "bodyHtml" ILIKE '%3+ roky%' OR 
             "bodyHtml" ILIKE '%2 roky%' OR
             "bodyHtml" ILIKE '%2+ roky%' THEN TRUE
        ELSE FALSE
    END AS "Medior",

    -- Categorize as Junior if the job title or description indicates an entry-level position, explicitly excluding any senior or medior indications.
    CASE
        WHEN "name" ILIKE '%junior%' OR 
             "bodyHtml" ILIKE '%začátečn%' OR
             "bodyHtml" ILIKE '%absolvent%' AND 
             ("name" NOT ILIKE '%senior%' AND
             "name" NOT ILIKE '%medior%' AND 
             "name" NOT ILIKE '%middle%') OR
             NOT ("Senior" = TRUE OR "Medior" = TRUE) THEN TRUE
        ELSE FALSE
    END AS "Junior"
FROM "jobs_raw_scrape_trimmed"; -- Source table containing raw job ad data.
