SELECT 
    CASE p.PostTypeId 
        WHEN 1 THEN 'Question' 
        WHEN 2 THEN 'Answer' 
    END AS [Post Type],
    DATENAME(weekday, p.CreationDate) AS [Day of the week],
    COUNT(DISTINCT p.Id) AS [Total Posts],
    SUM(CASE WHEN v.VoteTypeId = 2 THEN 1 ELSE 0 END) AS [Total Upvotes],
    SUM(CASE WHEN v.VoteTypeId = 3 THEN 1 ELSE 0 END) AS [Total Downvotes],
    CAST(SUM(CASE WHEN v.VoteTypeId = 2 THEN 1 ELSE 0 END) AS FLOAT) / 
        NULLIF(SUM(CASE WHEN v.VoteTypeId = 3 THEN 1 ELSE 0 END), 0) AS [Upvotes to Downvotes ratio]
FROM 
    Posts p
LEFT JOIN 
    Votes v ON p.Id = v.PostId AND v.VoteTypeId IN (2, 3)
WHERE 
    p.PostTypeId IN (1, 2)
GROUP BY 
    p.PostTypeId,
    DATENAME(weekday, p.CreationDate)
ORDER BY 
    [Upvotes to Downvotes ratio] DESC;
SELECT 
    CASE p.PostTypeId 
        WHEN 1 THEN 'Question' 
        WHEN 2 THEN 'Answer' 
    END AS [Post Type],
    DATENAME(weekday, p.CreationDate) AS [Day of the week],
    COUNT(DISTINCT p.Id) AS [Total Posts],
    SUM(CASE WHEN v.VoteTypeId = 2 THEN 1 ELSE 0 END) AS [Total Upvotes],
    SUM(CASE WHEN v.VoteTypeId = 3 THEN 1 ELSE 0 END) AS [Total Downvotes],
    -- Calculate ratio. CAST to FLOAT for decimals, NULLIF to prevent divide-by-zero crashes
    CAST(SUM(CASE WHEN v.VoteTypeId = 2 THEN 1 ELSE 0 END) AS FLOAT) / 
        NULLIF(SUM(CASE WHEN v.VoteTypeId = 3 THEN 1 ELSE 0 END), 0) AS [Upvotes to Downvotes ratio]
FROM 
    Posts p
LEFT JOIN 
    Votes v ON p.Id = v.PostId AND v.VoteTypeId IN (2, 3)
WHERE 
    p.PostTypeId IN (1, 2)
GROUP BY 
    p.PostTypeId,
    DATENAME(weekday, p.CreationDate)
ORDER BY 
    [Upvotes to Downvotes ratio] DESC;