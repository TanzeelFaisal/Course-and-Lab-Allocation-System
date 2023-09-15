using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ProjectApplication
{
    public class DataAccess
    {
        public int temp;

        public void func(int instructorID, string courseID, string timeSlot, string venueID)
        {
            string sql = ConfigurationManager.ConnectionStrings["course_databaseConnectionString"].ConnectionString;
            DataSet ds = new DataSet();
            string str = "Data Source=DESKTOP-7NMR6P9;Initial Catalog=SE_TEAM2_db;Integrated Security=True";
            SqlConnection n = new SqlConnection(str);
            n.Open();
            SqlCommand m;
            try
            {
                m = new SqlCommand("check_clash", n);   //name of procedure
                m.CommandType = CommandType.StoredProcedure;
                m.Parameters.Add("@teacher_name", SqlDbType.Int);
                m.Parameters["@teacher_name"].Value = TNAME;
                m.Parameters.Add("@start_time", SqlDbType.VarChar);
                m.Parameters["@start_time"].Value = STIME;
                m.Parameters.Add("@end_time", SqlDbType.VarChar);
                m.Parameters["@end_time"].Value = ETIME;
                m.Parameters.Add("@venue_id", SqlDbType.VarChar);
                m.Parameters["@venue_id"].Value = VID;
                //m.Parameters.Add("@clash_details", SqlDbType.VarChar);
                //m.Parameters["@clash_details"].Value = TNAME;
                m.Parameters.Add("@clash_details", SqlDbType.VarChar).Direction = ParameterDirection.Output;
                string output = Convert.ToString(m.Parameters["@clash_details"].Value);
                m.ExecuteNonQuery();
                n.Close();
            }
            catch (SqlExceptione ex)
            {
                Console.WriteLine("SQL Error" + ex.Message.ToString());
            }
            finally
            {
                n.close;
            }
        }
    }
}