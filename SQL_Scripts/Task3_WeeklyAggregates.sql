WITH Weeks AS (
    -- Get a master list of all weeks that exist
    SELECT DISTINCT DATEADD(wk, DATEDIFF(wk, 0, CreationDate), 0) AS WeekStart
    FROM Posts
),
PostStats AS (
    -- Count Q's, A's, and Accepted A's per week
    SELECT 
        DATEADD(wk, DATEDIFF(wk, 0, CreationDate), 0) AS WeekStart,
        SUM(CASE WHEN PostTypeId = 1 THEN 1 ELSE 0 END) AS QuestionCount,
        SUM(CASE WHEN PostTypeId = 2 THEN 1 ELSE 0 END) AS AnswerCount,
        SUM(CASE WHEN PostTypeId = 1 AND AcceptedAnswerId IS NOT NULL THEN 1 ELSE 0 END) AS AcceptedAnswerCount
    FROM Posts
    GROUP BY DATEADD(wk, DATEDIFF(wk, 0, CreationDate), 0)
),
VoteStats AS (
    -- Count total votes per week
    SELECT 
        DATEADD(wk, DATEDIFF(wk, 0, CreationDate), 0) AS WeekStart,
        COUNT(*) AS VoteCount
    FROM Votes
    GROUP BY DATEADD(wk, DATEDIFF(wk, 0, CreationDate), 0)
),
UserStats AS (
    -- Count new users per week
    SELECT 
        DATEADD(wk, DATEDIFF(wk, 0, CreationDate), 0) AS WeekStart,
        COUNT(*) AS NewUserCount
    FROM Users
    GROUP BY DATEADD(wk, DATEDIFF(wk, 0, CreationDate), 0)
),
ActiveUserStats AS (
    -- Count active users per week based on LastAccessDate
    SELECT 
        DATEADD(wk, DATEDIFF(wk, 0, LastAccessDate), 0) AS WeekStart,
        COUNT(*) AS ActiveUserCount
    FROM Users
    GROUP BY DATEADD(wk, DATEDIFF(wk, 0, LastAccessDate), 0)
)
-- Join all the separate aggregations together
SELECT 
    w.WeekStart AS [First Date of the Week],
    ISNULL(p.QuestionCount, 0) AS [Count of Questions],
    ISNULL(p.AnswerCount, 0) AS [Count of Answers],
    ISNULL(p.AcceptedAnswerCount, 0) AS [Count of Accepted Answers],
    ISNULL(v.VoteCount, 0) AS [Count of Votes],
    ISNULL(u.NewUserCount, 0) AS [New Users],
    ISNULL(a.ActiveUserCount, 0) AS [Active Users]
FROM Weeks w
LEFT JOIN PostStats p ON w.WeekStart = p.WeekStart
LEFT JOIN VoteStats v ON w.WeekStart = v.WeekStart
LEFT JOIN UserStats u ON w.WeekStart = u.WeekStart
LEFT JOIN ActiveUserStats a ON w.WeekStart = a.WeekStart
ORDER BY w.WeekStart DESC;