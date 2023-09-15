using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ProjectApplication.Controllers
{
    public class HomeController : Controller
    {

        private string connectionString = "Data Source=DESKTOP-7NMR6P9;Initial Catalog=SE_TEAM2_db;Integrated Security=True;MultipleActiveResultSets=True";
        //string connectionString = ConfigurationManager.ConnectionStrings["MyConnectionString"].ConnectionString;

        public ActionResult CheckClash(int instructorID, string courseID, string timeSlot, string venueID)
        {
            bool courseClashOutput, timingClashOutput, venueClashOutput;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand("check_clash", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.Add("@instructor_id", SqlDbType.Int).Value = instructorID;
                    command.Parameters.Add("@course_id", SqlDbType.VarChar, 20).Value = courseID;
                    command.Parameters.Add("@time_slot", SqlDbType.VarChar, 20).Value = timeSlot;
                    command.Parameters.Add("@venue_id", SqlDbType.VarChar, 20).Value = venueID;

                    command.Parameters.Add("@course_clash_output", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    command.Parameters.Add("@timing_clash_output", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    command.Parameters.Add("@venue_clash_output", SqlDbType.Bit).Direction = ParameterDirection.Output;

                    connection.Open();
                    command.ExecuteNonQuery();

                    courseClashOutput = (bool)command.Parameters["@course_clash_output"].Value;
                    timingClashOutput = (bool)command.Parameters["@timing_clash_output"].Value;
                    venueClashOutput = (bool)command.Parameters["@venue_clash_output"].Value;
                }
            }

            return Json(new
            {
                CourseClash = courseClashOutput,
                TimingClash = timingClashOutput,
                VenueClash = venueClashOutput
            });
        }

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}