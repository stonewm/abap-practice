using SAP.Middleware.Connector;
using System;
using System.Collections;
using System.Data;

namespace VSTOSAP
{
    public class SAPUtils
    {
        public static ArrayList ToArrayList(IRfcStructure stru)
        {
            var list = new ArrayList();

            for (int i = 0; i < stru.ElementCount; i++) {
                // get column name from position
                RfcElementMetadata colMeta = stru.GetElementMetadata(i);
                list.Add(String.Format("{0}: {1}",
                    colMeta.Name,                     // column name
                    stru.GetString(colMeta.Name)));   // get value from column name
            }

            return list;
        }

        public static DataTable ToDataTable(IRfcTable itab)
        {
            DataTable dataTable = new DataTable();

            // dataTable columns definition
            for (int i = 0; i < itab.ElementCount; i++) {
                RfcElementMetadata metadata = itab.GetElementMetadata(i);
                dataTable.Columns.Add(metadata.Name);
            }

            // line items
            for (int rowIdx = 0; rowIdx < itab.RowCount; rowIdx++) {
                DataRow dRow = dataTable.NewRow();

                // every line is of type structure                
                for (int idx = 0; idx < itab.ElementCount; idx++) {
                    dRow[idx] = itab[rowIdx].GetString(idx);
                }

                dataTable.Rows.Add(dRow);
            }

            return dataTable;
        }
    }
}
