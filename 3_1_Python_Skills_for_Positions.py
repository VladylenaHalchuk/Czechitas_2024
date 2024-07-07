# Create list of skills and list of positions
# Skills_for_Positions

import csv
import re

# Set the limit for processing job ads to a very high number (near-infinite for practical purposes)
LIMIT = 10**9

# Increase the maximum field size allowed in CSV to accommodate large fields
csv.field_size_limit(10**6)

# Initialize a dictionary to hold skills and their associated regex patterns
skills = {}

# Open and read skills from a CSV file, storing them in the skills dictionary
with open("in/tables/All_Skills_List.csv", newline="", encoding="utf8") as csvfile:
    reader = csv.reader(csvfile)
    next(reader)  # Skip header
    for row in reader:
        skills[row[0]] = row[1]

# Open the input job ads CSV and an output file to write extracted skills
with open(
    "in/tables/jobs_raw_scrape_new_positions.csv", newline="", encoding="utf8"
) as csvfile, open(
    "out/tables/table_skills_positions.csv", mode="w", encoding="utf-8", newline=""
) as output_file:
    fieldnames = ["id", "name", "skills"]
    writer = csv.writer(output_file)
    writer.writerow(fieldnames)  # Write header to output file

    reader_jobs = csv.DictReader(csvfile)
    i = 0
    for row in reader_jobs:
        if i > LIMIT:
            break
        i += 1

        current_job_skills = []  # List to store skills found in the current job ad

        # Check each skill against the job ad's HTML content
        for skill_en, skill_regex in skills.items():
            # Direct match with skill name or regex search
            if skill_en in row["bodyHtml"]:
                current_job_skills.append(skill_en)
            elif re.search(skill_regex, row["bodyHtml"]):
                current_job_skills.append(skill_en)

        # Write the job id, name, and extracted skills to the output file
        writer.writerow([row["id"], row["name"], current_job_skills])
