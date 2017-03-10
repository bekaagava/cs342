@drop.sql
@schema.sql
@data.sql

-- Exercise 5.3a
SELECT p.lastName|| ', ' || p.firstName||' and '||p1.firstName || ' - ' || h.phoneNumber || ' - ' || h.street FAMILY_ENTRIES
FROM Person p JOIN Person p1 ON p.householdId = p1.householdId AND p.id < p1.id
JOIN Household h ON p1.householdID = h.id AND p1.householdRole <> 'child';

-- Exercise 5.3b
SELECT p.lastName|| ', ' || p.firstName||' and '||p1.firstName || ' ' || p1.lastName || ' - ' || h.phoneNumber || ' - ' || h.street FAMILY_ENTRIES
FROM Person p JOIN Person p1 ON p.householdId = p1.householdId AND p.id < p1.id
JOIN Household h ON p1.householdID = h.id AND p1.householdRole <> 'child';

--Exercise 5.3c
SELECT p.lastName|| ', ' || p.firstName||' and '||p1.firstName || ' ' || p1.lastName || ' - ' || h.phoneNumber || ' - ' || h.street FAMILY_ENTRIES
FROM Person p JOIN Person p1 ON p.householdId = p1.householdId AND p.id < p1.id
JOIN Household h ON p1.householdID = h.id AND p1.householdRole <> 'child'
UNION 
SELECT p.lastName|| ', ' || p.firstName||' - ' || h.phoneNumber || ' - ' || h.street ENTRIES 
FROM Person p
JOIN Household h ON p.householdId = h.id AND p.householdRole = 'single';







