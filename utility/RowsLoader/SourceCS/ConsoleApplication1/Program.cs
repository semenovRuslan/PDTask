using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace ConsoleApplication1
{
    class Program
    {
        static SqlConnection conn2 = new SqlConnection();
        static void Main(string[] args)
        {
            List<string> err = new List<string>();
            conn2.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DBServer"].ConnectionString; 
            int rowcnt = 0;
            
            conn2.Open();

            string path = args[0];
            using (StreamReader sr = new StreamReader(path, System.Text.Encoding.Default))
            {
                string line;
                
                while ((line = sr.ReadLine()) != null)
                {
                    try
                    {
                        ExecuteQuery(line);
                        rowcnt++;

                    }
                    catch (Exception exc)
                    {
                        err.Add(string.Format("Error in row # {0}:{1}", rowcnt + 1, exc.Message));
                        rowcnt++;
                    }
                }
            }

            conn2.Close();

            foreach (string rErr in err)
            {
                Console.WriteLine(rErr);
            }
            Console.WriteLine(String.Format("{0} rows processed", rowcnt));
            Console.WriteLine("...Press button ....");
            Console.ReadKey();

        }

        private static void ExecuteQuery(string s)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn2;
            cmd.CommandText = s;

            cmd.ExecuteNonQuery();

        }
    }
}
