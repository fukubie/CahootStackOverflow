namespace CahootStackOverflow.Models
{
    public class SearchResult
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public int TotalVotes { get; set; }
        public int TotalAnswers { get; set; }
        public string UserName { get; set; }
        public int UserReputation { get; set; }
        public int BadgeCount { get; set; }
    }
}