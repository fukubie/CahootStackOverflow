using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Dapper;
using CahootStackOverflow.Models;
using System.Diagnostics;

namespace CahootStackOverflow.Controllers
{
    public class HomeController : Controller
    {
        private readonly IConfiguration _config;
        private readonly ILogger<HomeController> _logger;

        // We inject both the configuration (for the DB connection) and the default logger
        public HomeController(IConfiguration config, ILogger<HomeController> logger)
        {
            _config = config;
            _logger = logger;
        }

        public async Task<IActionResult> Index(string searchTerm = "", int page = 1)
        {
            int pageSize = 10;
            int offset = (page - 1) * pageSize;

            // If no search term, return an empty view
            if (string.IsNullOrWhiteSpace(searchTerm))
            {
                ViewBag.SearchTerm = "";
                ViewBag.Page = page;
                return View(new List<SearchResult>());
            }

            string connectionString = _config.GetConnectionString("DefaultConnection");

            string sql = @"
                WITH PagedPosts AS (
                    SELECT Id
                    FROM Posts WITH (NOLOCK)
                    WHERE PostTypeId = 1 
                      AND Title LIKE @Search
                    ORDER BY Id
                    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY
                )
                SELECT 
                    ISNULL(p.Title, 'Question Post') AS Title,
                    SUBSTRING(ISNULL(p.Body, ''), 1, 140) AS Description,
                    ISNULL(p.Score, 0) AS TotalVotes,
                    ISNULL(p.AnswerCount, 0) AS TotalAnswers,
                    ISNULL(u.DisplayName, 'Unknown User') AS UserName,
                    ISNULL(u.Reputation, 0) AS UserReputation,
                    (SELECT COUNT(*) FROM Badges b WITH (NOLOCK) WHERE b.UserId = u.Id) AS BadgeCount
                FROM PagedPosts pp
                INNER JOIN Posts p WITH (NOLOCK) ON pp.Id = p.Id
                LEFT JOIN Users u WITH (NOLOCK) ON p.OwnerUserId = u.Id;";

            using (var connection = new SqlConnection(connectionString))
            {
                var results = await connection.QueryAsync<SearchResult>(sql, new
                {
                    Search = $"%{searchTerm}%",
                    Offset = offset,
                    PageSize = pageSize
                }, commandTimeout: 180);

                ViewBag.SearchTerm = searchTerm;
                ViewBag.Page = page;

                return View(results.ToList());
            }
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}