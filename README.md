# Czechitas_2024
## Do you have what it takes? The skillset for IT jobs on the Czech labor market
 The project was created by Vladylena Halchuk and Olena Marchuk, students of the Czechitas Digital Academy Data program. With guidance from our mentors, Martina Gelnerova and Zuzka Pelechova from APIFY, we developed this practical solution for Czechitas, showcasing the application of our data analysis skills in a real-world context.

### Methodology
Our project was executed using a streamlined process that integrated both data collection and analysis:
    Data Collection: We used Apify to scrape job listing data from the web.
    Data Processing: Keboola served as our central platform for data integration, where we applied transformations using SQL and Python to refine and structure the data.
    Visualization: We created interactive dashboards and reports in Tableau and Power BI to visualize the data and extract meaningful insights.
Here's a visual representation of our data workflow in Keboola, illustrating how each part of the process is interconnected:
![Czechitas - flow](https://github.com/VladylenaHalchuk/Czechitas_2024/assets/112247563/0177f864-98fb-47db-a433-92e89cc02234)

## 1. Uploading basic tables
This step involves importing essential datasets into Keboola, such as job listings and skills inventories, setting the foundation for subsequent data processing and analysis tasks.
### 1.1 All_Skills_List
Downloading the All_Skills_List table into Keboola, setting it up as a primary data source that will be used to match and categorize skills across various job listings.
## 2. Filtering fresh positions from jobscz
This process involves selecting only the most recent and relevant job postings from the jobscz dataset, ensuring that the data used for analysis is up-to-date and reflects current market conditions.
### 2.1 filter_jobscz_trimmed_table
Setting the Skills Timestamp
    Purpose: Fetch the latest skills update time.
    Operation: Select and set the latest timestamp from "All_Skills_List".

Creating or Replacing jobs_raw_scrape_new_positions Table
    Purpose: Keep only fresh job ads relevant to the latest skills list.
    Operation:
        Table Management: Create or replace the table to ensure freshness.
        Data Handling: Select relevant job details and filter based on the skills_timestamp.
Check the code here:
(https://github.com/VladylenaHalchuk/Czechitas_2024/blob/main/2_SQL_fresh_positions.sql)

## 3. Create list of skills and list of positions
In this stage of the workflow, job listings are processed to extract, categorize, and assign relevant attributes for deeper analysis and visualization. This includes:

3.1 Skills_for_Positions: Extracting specific skills from job descriptions. This part involves parsing job ads to identify and list distinct skills mentioned, using a predefined list of skills to standardize and optimize the matching process.

3.2 Jobs_Categorization: Categorizing jobs into specific roles based on keywords in the job titles. This helps in classifying jobs into roles such as Fullstack Developer, Backend Developer, etc., based on the presence of key terms that align with job responsibilities and required expertise.

3.3 Seniority: Assigning seniority levels based on the experience required as indicated in job titles and descriptions. This categorization differentiates between senior, medior, and junior roles, aiding in the segmentation of job market data based on career level.
### 3.1 Skills_for_Positions
Purpose: Extract and match skills from job ads to a predefined skills list.
Operation:
    Preparation: Set processing limits and increase CSV field size to handle large data volumes.
    Skill Extraction: Load skills and their regex patterns from a CSV file.
    Data Processing: Read job ads, match against skills, and compile results into a new CSV for further use.
Check the code here:
(https://github.com/VladylenaHalchuk/Czechitas_2024/blob/main/3_1_Python_Skills_for_Positions.py)

### 3.2 jobs_categorization
Purpose: Categorize job listings based on specific keywords found in job titles to identify the role's nature and required skill set.
Operation:
    Table Management: Creates or replaces the "jobs_categorization" table to ensure updated categorization based on current data.
    Categorization Logic: Utilizes a series of CASE statements to assign Boolean values indicating whether each job ad matches criteria for various job roles like Fullstack Developer, Backend Developer, Frontend Developer, and other specialized roles based on specific keywords and phrases in the job title.
    Data Source: Pulls data from the "jobs_raw_scrape_trimmed" table, ensuring that only the latest and relevant job ads are categorized for further analysis.
Check the code here:
(https://github.com/VladylenaHalchuk/Czechitas_2024/blob/main/3_2_SQL_jobs_categorization.sql)

### 3.3 Seniority
Purpose: Assign seniority levels to job listings based on keywords in job titles and descriptions, distinguishing between senior, medior, and junior roles.
Operation:
    Table Update: Creates or refreshes the "seniority" table to reflect the latest job data.
    Categorization Process: Applies CASE statements to classify jobs into senior, medior, or junior categories by identifying specific keywords that indicate the required experience level.
    Data Source: Extracts data from "jobs_raw_scrape_trimmed", ensuring categorization is based on current and relevant job listings.
Check the code here:
(https://github.com/VladylenaHalchuk/Czechitas_2024/blob/main/3_3_SQL_Seniority.sql)

## 4. Separate skills from the lists
This step involves extracting and categorizing individual skills from job listings into 'hard' or 'soft' skills, ensuring data is ready for detailed analysis and reporting in subsequent stages.
### 4.1 Separating_skills
Purpose: Differentiate skills listed in job postings into 'hard' or 'soft' categories.
Operation:
    Table Creation: Generates or updates the "separated_skills" table to include categorized skills.
    Data Processing: Uses a Common Table Expression (flattened_skills) to break down JSON arrays of skills into individual entries, making them easier to process.
    Skill Classification: Joins the flattened skills with "All_Skills_List" to assign 'hard' or 'soft' labels based on predefined criteria.
    Data Integration: Merges results with the 'JG_separating' table for a comprehensive dataset.
Check the code here:
(https://github.com/VladylenaHalchuk/Czechitas_2024/blob/main/4_SQL_Separating_skills.sql)

## 5. Add trimmed jobscz table for visualization
This stage focuses on refining and organizing job data from the jobscz table to ensure it's optimized for effective visualization, helping to highlight key employment trends and insights.
### 5.1 jobs_trimmed_for_visualisation
Purpose: Aggregate and prepare job data for effective visualization, focusing on key attributes relevant to analysis.
Operation:
    Table Update: Refreshes the "jobs_information_for_vis" table to ensure it contains the latest, most relevant job data.
    Data Selection: Gathers distinct job details such as job ID, title, company, location, salary range, date information, and multiple categorizations (seniority, job category) from various linked tables.
    Data Integration: Joins with multiple tables to enrich job records with comprehensive attributes like regional data, category, and seniority, only including jobs with listed skills.
    Union Operation: Combines the curated job data with additional processed visualization data from 'JG_for_visualization' to form a unified set for tools like Tableau or Power BI.
Check the code here:
(https://github.com/VladylenaHalchuk/Czechitas_2024/blob/main/5_SQL_jobs_trimmed_for_visualisation.sql)

## 6. Send tables to Tableau and Power BI
This step involves exporting the jobs_information_for_vis and separated_skills tables from Keboola to visualization platforms.
### 6.1 Czechitasskillsproject:
The tables jobs_information_for_vis and separated_skills are exported from Keboola to Google Sheets. This setup facilitates their visualization in Tableau, allowing for interactive exploration and analysis of job data and skill categorizations.
### 6.2 Skill analysis DA jaro 2024
These same tables, jobs_information_for_vis and separated_skills, are also sent to a PostgreSQL database within Keboola. This arrangement supports their use in Power BI, enabling detailed data analysis and reporting for the Spring 2024 skill analysis project.

## 7. Visualizations
Both Tableau and Power BI are used to display the datasets jobs_information_for_vis and separated_skills through two main dashboards: "Demand for Specific Skills" and "The Most In-Demand Skills in IT Job Roles." These visualizations provide a clear view of skill prevalence and requirements across the IT job market, enabling detailed comparative analysis and strategic planning.
### 7.1 Tableau
Utilizes the data from jobs_information_for_vis and separated_skills to create two key dashboards. "Demand for Specific Skills" provides insights into the frequency and distribution of skills across job postings, while "The Most In-Demand Skills in IT Job Roles" focuses on identifying top skills required across various IT roles. These interactive dashboards facilitate a dynamic exploration of job market trends.

![Tableau - 1](https://github.com/VladylenaHalchuk/Czechitas_2024/assets/112247563/dde153bb-6ba8-4715-974a-a21b40b3d77a)

![Tableau - 2](https://github.com/VladylenaHalchuk/Czechitas_2024/assets/112247563/17ebbaff-f898-4991-b247-b81d61f79bce)

https://public.tableau.com/app/profile/czechitas.skillsproject/viz/Final_Dashboard2_In-Demand_Skills/SkillOriented?publish=yes

or

(https://github.com/VladylenaHalchuk/Czechitas_2024/blob/main/Czechitas_DA_Data.twbx)

### 7.2 Power BI
Mirrors the Tableau setup with two similar dashboards. "Demand for Specific Skills" examines the prevalence of different skills in the job market, and "The Most In-Demand Skills in IT Job Roles" breaks down essential skills for IT positions. Power BI offers robust data manipulation capabilities to delve deeper into these employment trends and skill demands.

![Power BI - 1](https://github.com/VladylenaHalchuk/Czechitas_2024/assets/112247563/5ce64f12-0dc2-43a7-b608-08a759fe5b8f)

![Power BI - 2](https://github.com/VladylenaHalchuk/Czechitas_2024/assets/112247563/e9da17aa-afb2-4793-b785-9da584772616)

(https://github.com/VladylenaHalchuk/Czechitas_2024/blob/main/Czechitas_DA_Data.pbix)

## Blog post
For a more detailed explanation of our project and deeper insights into our findings, please visit our blog post linked below:
https://medium.com/@czechitasskillsproject/do-you-have-what-it-takes-the-skillset-for-it-jobs-on-the-czech-labor-market-e627e7f37e8c

## Thank you!
Thank you to everyone who has supported us throughout this project. Your guidance and insights have been invaluable, and we are grateful for the opportunity to apply our learning in such a practical and impactful way. We hope our work will inspire and assist others in their data analysis endeavors.













