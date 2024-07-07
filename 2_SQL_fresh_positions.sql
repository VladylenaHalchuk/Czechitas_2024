-- Filtering fresh positions from jobscz
-- filter_jobscz_trimmed_table

-- Set the skills timestamp from the All_Skills_List table. This timestamp reflects the last update to the skills list in Google Sheets.
SET skills_timestamp = (
    SELECT to_date(to_timestamp("Timestamp", 'DD.MM.YYYY HH24:MI:SS'))
    FROM "All_Skills_List"
    LIMIT 1
);

-- Create or replace the jobs_raw_scrape_new_positions table.
-- This table filters out only the new or updated job ads by comparing the job ad timestamp in jobs_raw_scrape_trimmed
-- with the skills_timestamp. Only ads newer or at the time of the last skills list update are included.
CREATE OR REPLACE TABLE "jobs_raw_scrape_new_positions" AS
SELECT 
    "bodyHtml", 
    "company", 
    "date", 
    "id", 
    "name", 
    "place", 
    "salary", 
    "url"
FROM "jobs_raw_scrape_trimmed"
WHERE to_date("_timestamp") <= $skills_timestamp
ORDER BY "_timestamp" DESC;

