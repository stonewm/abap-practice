using System;
using System.Data;

namespace VSTOSAP
{
    public class DataTableUtils
    {
        /// <summary>
        /// Print DataTable
        /// </summary>
        /// <param name="dataTable"></param>
        public static void PrintValues(DataTable dataTable)
        {
            foreach (DataRow row in dataTable.Rows) {
                foreach (DataColumn col in dataTable.Columns) {
                    Console.Write(row[col].ToString() + "\t");
                }
                Console.WriteLine();
            }
        }

        /// <summary>
        /// Combine two datatables
        /// </summary>
        /// <param name="dt1"></param>
        /// <param name="dt2"></param>
        /// <returns></returns>
        public static DataTable CombineDataTable(DataTable dt1, DataTable dt2)
        {
            DataTable dtNew = new DataTable();
            if (dt1.Columns.Count == 0) {
                dtNew = dt2;
            }
            else {
                foreach (DataColumn col in dt1.Columns) {
                    dtNew.Columns.Add(col.ColumnName);
                }
                foreach (DataColumn col in dt2.Columns) {
                    dtNew.Columns.Add(col.ColumnName);
                }

                for (int i = 0; i < dt1.Rows.Count; i++) {
                    DataRow item = dtNew.NewRow();
                    foreach (DataColumn col in dt1.Columns) {
                        item[col.ColumnName] = dt1.Rows[i][col.ColumnName];
                    }
                    foreach (DataColumn col in dt2.Columns) {
                        item[col.ColumnName] = dt2.Rows[i][col.ColumnName];
                    }
                    dtNew.Rows.Add(item);
                    dtNew.AcceptChanges();
                }
            }

            return dtNew;
        }
    }
}
