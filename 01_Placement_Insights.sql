/*
===============================================================================
                    CAMPUS PLACEMENT ANALYTICS PROJECT
                         01 - PLACEMENT ANALYSIS
===============================================================================

Objective:
Analyze the engineering campus placement dataset to uncover
insights into placement trends, salary packages, company hiring,
and student performance.

Dataset:
Engineering Placement Dataset

Tool Used:
MySQL Workbench

===============================================================================
*/

-- =============================================================================
-- 1. Total Number of Students
-- =============================================================================

SELECT COUNT(*) AS Total_Students
FROM placement_data;


-- =============================================================================
-- 2. Placement Status Distribution
-- =============================================================================

SELECT
    Placement_Status,
    COUNT(*) AS Student_Count
FROM placement_data
GROUP BY Placement_Status;


-- =============================================================================
-- 3. Overall Placement Percentage
-- =============================================================================

SELECT
ROUND(
SUM(CASE WHEN Placement_Status='Placed' THEN 1 ELSE 0 END)*100.0
/COUNT(*),2) AS Placement_Percentage
FROM placement_data;


-- =============================================================================
-- 4. Branch-wise Student Distribution
-- =============================================================================

SELECT
    Branch,
    COUNT(*) AS Total_Students
FROM placement_data
GROUP BY Branch
ORDER BY Total_Students DESC;


-- =============================================================================
-- 5. Branch-wise Placement Rate
-- =============================================================================

SELECT
    Branch,
    COUNT(*) AS Total_Students,
    SUM(CASE WHEN Placement_Status='Placed' THEN 1 ELSE 0 END) AS Placed_Students,
    ROUND(
    SUM(CASE WHEN Placement_Status='Placed' THEN 1 ELSE 0 END)*100.0
    /COUNT(*),2) AS Placement_Percentage
FROM placement_data
GROUP BY Branch
ORDER BY Placement_Percentage DESC;


-- =============================================================================
-- 6. Gender-wise Placement Analysis
-- =============================================================================

SELECT
    Gender,
    COUNT(*) AS Total_Students,
    SUM(CASE WHEN Placement_Status='Placed' THEN 1 ELSE 0 END) AS Placed_Students,
    ROUND(
    SUM(CASE WHEN Placement_Status='Placed' THEN 1 ELSE 0 END)*100.0
    /COUNT(*),2) AS Placement_Percentage
FROM placement_data
GROUP BY Gender;


-- =============================================================================
-- 7. Internship vs Placement
-- =============================================================================

SELECT
    Internship,
    COUNT(*) AS Total_Students,
    SUM(CASE WHEN Placement_Status='Placed' THEN 1 ELSE 0 END) AS Placed_Students,
    ROUND(
    SUM(CASE WHEN Placement_Status='Placed' THEN 1 ELSE 0 END)*100.0
    /COUNT(*),2) AS Placement_Percentage
FROM placement_data
GROUP BY Internship;


-- =============================================================================
-- 8. Average Package Offered
-- =============================================================================

SELECT
    ROUND(AVG(Package_LPA),2) AS Average_Package_LPA
FROM placement_data
WHERE Placement_Status='Placed';


-- =============================================================================
-- 9. Highest Package Offered
-- =============================================================================

SELECT
    MAX(Package_LPA) AS Highest_Package_LPA
FROM placement_data
WHERE Placement_Status='Placed';


-- =============================================================================
-- 10. Lowest Package Offered
-- =============================================================================

SELECT
    MIN(Package_LPA) AS Lowest_Package_LPA
FROM placement_data
WHERE Placement_Status='Placed';


-- =============================================================================
-- 11. Branch-wise Average Package
-- =============================================================================

SELECT
    Branch,
    ROUND(AVG(Package_LPA),2) AS Average_Package_LPA
FROM placement_data
WHERE Placement_Status='Placed'
GROUP BY Branch
ORDER BY Average_Package_LPA DESC;


-- =============================================================================
-- 12. Top 10 Recruiting Companies
-- =============================================================================

SELECT
    Company,
    COUNT(*) AS Students_Hired
FROM placement_data
WHERE Placement_Status='Placed'
GROUP BY Company
ORDER BY Students_Hired DESC
LIMIT 10;


-- =============================================================================
-- 13. Job Role Distribution
-- =============================================================================

SELECT
    Job_Role,
    COUNT(*) AS Students_Placed
FROM placement_data
WHERE Placement_Status='Placed'
GROUP BY Job_Role
ORDER BY Students_Placed DESC;


-- =============================================================================
-- 14. Placement Type Analysis
-- =============================================================================

SELECT
    Placement_Type,
    COUNT(*) AS Total_Placements
FROM placement_data
WHERE Placement_Status='Placed'
GROUP BY Placement_Type;


-- =============================================================================
-- 15. Placement Season Analysis
-- =============================================================================

SELECT
    Placement_Season,
    COUNT(*) AS Students_Placed
FROM placement_data
WHERE Placement_Status='Placed'
GROUP BY Placement_Season
ORDER BY Students_Placed DESC;


-- =============================================================================
-- 16. Location-wise Placements
-- =============================================================================

SELECT
    Location,
    COUNT(*) AS Students_Placed
FROM placement_data
WHERE Placement_Status='Placed'
GROUP BY Location
ORDER BY Students_Placed DESC;


-- =============================================================================
-- 17. Average CGPA of Placed vs Not Placed Students
-- =============================================================================

SELECT
    Placement_Status,
    ROUND(AVG(CGPA),2) AS Average_CGPA
FROM placement_data
GROUP BY Placement_Status;


/*
===============================================================================
End of File : 01_Placement_Insights.sql
===============================================================================
*/