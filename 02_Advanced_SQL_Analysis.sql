/*
===============================================================================
                    CAMPUS PLACEMENT ANALYTICS PROJECT
                     02 - ADVANCED SQL ANALYSIS
===============================================================================

Objective:
Perform advanced SQL analysis using CTEs, Window Functions,
Ranking Functions, CASE statements, and Subqueries to derive
deeper insights from the engineering placement dataset.

Dataset:
Engineering Placement Dataset

Tool Used:
MySQL Workbench

===============================================================================
*/


-- =============================================================================
-- 1. Rank Engineering Branches by Average Package
-- Concept: RANK()
-- =============================================================================

SELECT
    Branch,
    ROUND(AVG(Package_LPA),2) AS Average_Package,
    RANK() OVER(ORDER BY AVG(Package_LPA) DESC) AS Branch_Rank
FROM placement_data
WHERE Placement_Status='Placed'
GROUP BY Branch;


-- =============================================================================
-- 2. Rank Companies by Number of Students Hired
-- Concept: DENSE_RANK()
-- =============================================================================

SELECT
    Company,
    COUNT(*) AS Students_Hired,
    DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS Company_Rank
FROM placement_data
WHERE Placement_Status='Placed'
GROUP BY Company;


-- =============================================================================
-- 3. Highest Package Offered in Each Branch
-- Concept: ROW_NUMBER()
-- =============================================================================

WITH BranchPackage AS
(
SELECT
    Branch,
    Student_ID,
    Package_LPA,
    ROW_NUMBER() OVER(PARTITION BY Branch ORDER BY Package_LPA DESC) AS rn
FROM placement_data
WHERE Placement_Status='Placed'
)

SELECT *
FROM BranchPackage
WHERE rn=1;


-- =============================================================================
-- 4. Students Earning Above Overall Average Package
-- Concept: Subquery
-- =============================================================================

SELECT
    Student_ID,
    Branch,
    Company,
    Package_LPA
FROM placement_data
WHERE Package_LPA >
(
SELECT AVG(Package_LPA)
FROM placement_data
WHERE Placement_Status='Placed'
);


-- =============================================================================
-- 5. Students Having CGPA Above Branch Average
-- Concept: Correlated Subquery
-- =============================================================================

SELECT
    Student_ID,
    Branch,
    CGPA
FROM placement_data p1
WHERE CGPA >
(
SELECT AVG(CGPA)
FROM placement_data p2
WHERE p1.Branch=p2.Branch
);


-- =============================================================================
-- 6. Categorize Salary Packages
-- Concept: CASE
-- =============================================================================

SELECT
    Student_ID,
    Company,
    Package_LPA,

CASE

WHEN Package_LPA>=20 THEN 'Excellent'

WHEN Package_LPA>=15 THEN 'High'

WHEN Package_LPA>=10 THEN 'Good'

WHEN Package_LPA>0 THEN 'Average'

ELSE 'Not Placed'

END AS Package_Category

FROM placement_data;


-- =============================================================================
-- 7. Branch Contribution to Total Placements
-- Concept: CTE
-- =============================================================================

WITH TotalPlaced AS
(
SELECT COUNT(*) AS Total
FROM placement_data
WHERE Placement_Status='Placed'
)

SELECT
    Branch,
    COUNT(*) AS Students_Placed,
    ROUND(COUNT(*)*100.0/Total,2) AS Contribution_Percentage
FROM placement_data
CROSS JOIN TotalPlaced
WHERE Placement_Status='Placed'
GROUP BY Branch;


-- =============================================================================
-- 8. Company-wise Average Package
-- =============================================================================

SELECT
    Company,
    ROUND(AVG(Package_LPA),2) AS Average_Package
FROM placement_data
WHERE Placement_Status='Placed'
GROUP BY Company
ORDER BY Average_Package DESC;


-- =============================================================================
-- 9. Top 5 Highest Paying Companies
-- =============================================================================

SELECT
    Company,
    ROUND(AVG(Package_LPA),2) AS Average_Package
FROM placement_data
WHERE Placement_Status='Placed'
GROUP BY Company
ORDER BY Average_Package DESC
LIMIT 5;


-- =============================================================================
-- 10. Placement Percentage by Graduation Year
-- =============================================================================

SELECT
    Graduation_Year,
    ROUND(
    SUM(CASE WHEN Placement_Status='Placed' THEN 1 ELSE 0 END)
    *100.0/COUNT(*),2) AS Placement_Percentage
FROM placement_data
GROUP BY Graduation_Year;


-- =============================================================================
-- 11. Internship Impact on Average Package
-- =============================================================================

SELECT
    Internship,
    ROUND(AVG(Package_LPA),2) AS Average_Package
FROM placement_data
WHERE Placement_Status='Placed'
GROUP BY Internship;


-- =============================================================================
-- 12. Active Backlogs vs Placement Percentage
-- =============================================================================

SELECT
    Active_Backlogs,
    COUNT(*) AS Total_Students,
    SUM(CASE WHEN Placement_Status='Placed' THEN 1 ELSE 0 END) AS Placed_Students,
    ROUND(
    SUM(CASE WHEN Placement_Status='Placed' THEN 1 ELSE 0 END)
    *100.0/COUNT(*),2) AS Placement_Percentage
FROM placement_data
GROUP BY Active_Backlogs
ORDER BY Active_Backlogs;


-- =============================================================================
-- 13. Top 3 Highest Paid Students in Each Branch
-- Concept: ROW_NUMBER() with PARTITION BY
-- Purpose:
-- Identify the top three highest package holders in every branch.
-- =============================================================================

WITH RankedStudents AS
(
    SELECT
        Branch,
        Student_ID,
        Company,
        Package_LPA,
        ROW_NUMBER() OVER(
            PARTITION BY Branch
            ORDER BY Package_LPA DESC
        ) AS Rank_In_Branch
    FROM placement_data
    WHERE Placement_Status = 'Placed'
)

SELECT
    Branch,
    Student_ID,
    Company,
    Package_LPA,
    Rank_In_Branch
FROM RankedStudents
WHERE Rank_In_Branch <= 3
ORDER BY Branch, Rank_In_Branch;


/*
===============================================================================
End of File : 02_Advanced_SQL_Analysis.sql
===============================================================================
*/