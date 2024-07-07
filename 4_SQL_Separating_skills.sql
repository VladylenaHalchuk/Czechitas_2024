-- Separate skills from the lists
-- Separating_skills

-- Create or replace the separated_skills table to categorize skills from job listings as either hard or soft skills.
CREATE OR REPLACE TABLE "separated_skills" AS

-- First, create a CTE (Common Table Expression) named "flattened_skills" to process and flatten the JSON array of skills into a usable format.
WITH "flattened_skills" AS (
    SELECT
        t."id",
        -- Trim spaces from each skill extracted from the JSON array to ensure clean, matching keys.
        trim(f.value) AS "skill"
    FROM
        "table_skills_positions" t,
        -- Use the LATERAL FLATTEN function to expand the JSON array from the "skills" column into individual rows.
        LATERAL FLATTEN(input => PARSE_JSON(t."skills")) f
    WHERE "skills" != '[]'  -- Only process rows where "skills" are not an empty array.
)

-- Select the job id and skill from the flattened skills,
-- and join with the All_Skills_List to classify each skill as hard or soft.
SELECT
    fs."id",
    fs."skill",
    -- Join with the All_Skills_List to fetch the skill type (hard or soft) based on the skill name.
    "All_Skills_List"."Hard_or_Soft" AS "skill_type"
FROM 
    "flattened_skills" fs
LEFT JOIN "All_Skills_List"
    -- Ensure the match considers trimmed values to avoid mismatches due to extra spaces.
    ON fs."skill" = TRIM("All_Skills_List"."Skills_List")

-- Union the results with another table 'JG_separating' which might contain additional processed data.
UNION
SELECT * FROM "JG_separating";
