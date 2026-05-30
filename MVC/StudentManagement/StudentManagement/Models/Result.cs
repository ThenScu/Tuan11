namespace StudentManagement.Models
{
    public class Result
    {
        public int ResultID { get; set; }
        public int UserID { get; set; }
        public User User { get; set; }
        public string SubjectName { get; set; }
        public string SubjectCode { get; set; }
        public string Semester { get; set; }
        public string AcademicYear { get; set; }
        public float ProcessScore { get; set; }
        public float ExamScore { get; set; }
        public string FinalGrade { get; set; }
    }
}
