-- 1. Index to speed up grouping Posts by Week and filtering by Type
CREATE NONCLUSTERED INDEX IX_Posts_CreationDate_PostType 
ON Posts(CreationDate, PostTypeId) 
INCLUDE (AcceptedAnswerId);

-- 2. Index to speed up grouping Votes by Week
CREATE NONCLUSTERED INDEX IX_Votes_CreationDate 
ON Votes(CreationDate);

-- 3. Indexes to speed up User activity aggregations
CREATE NONCLUSTERED INDEX IX_Users_CreationDate 
ON Users(CreationDate);

CREATE NONCLUSTERED INDEX IX_Users_LastAccessDate 
ON Users(LastAccessDate);