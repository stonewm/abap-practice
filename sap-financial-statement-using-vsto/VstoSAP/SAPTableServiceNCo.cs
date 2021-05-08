using SAP.Middleware.Connector;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace VSTOSAP
{
    public class SAPTableServiceNCo
    {
        public DataTable GetTableContent(string tableName,                                  
                                   int rowCount,
                                   string options = "")
        {
            String delimiter = "~";
            DataTable targetDt = new DataTable();

            int BATCH_COL_COUNT = 5;
            var fieldNames = this.GetFieldNames(tableName);
            for(int idx = 0; idx < fieldNames.Count; idx=idx+5) {
                var batchFields = fieldNames.Skip(idx).Take(BATCH_COL_COUNT);

                DataTable dt = this.ReadTableUsingFields(tableName,
                    batchFields.ToArray(),
                    delimiter,
                    rowCount,
                    options);

                DataTable newTable = DataTableUtils.CombineDataTable(targetDt, dt);
                targetDt = newTable;
            }

            return targetDt;
        }

        public DataTable ReadTableUsingFields(string tableName,
                                   String[] selectedFields,
                                   string delimeter,
                                   int rowCount,
                                   string options = "")
        {
            RfcDestination sap = DestinationProvider.GetSAPDestination();
            IRfcFunction function = sap.Repository.CreateFunction("RFC_READ_TABLE");

            function.SetValue("QUERY_TABLE", tableName.ToUpper());
            function.SetValue("DELIMITER", delimeter);
            function.SetValue("ROWCOUNT", rowCount);

            // options parameter
            if (!String.IsNullOrEmpty(options)) {
                IRfcTable optionsTable = function.GetTable("OPTIONS");
                optionsTable.Append();
                optionsTable.CurrentRow.SetValue("TEXT", options);
            }

            // fields parameter
            IRfcTable fieldsTable = function.GetTable("FIELDS");
            foreach (var item in selectedFields) {
                fieldsTable.Append();
                fieldsTable.CurrentRow.SetValue("FIELDNAME", item.ToString());
            }

            function.Invoke(sap);

            IRfcTable data = function.GetTable("DATA");
            DataTable dt = SAPUtils.ToDataTable(data);

            return this.SplittedFields(dt, selectedFields, delimeter);
        }


        public DataTable GetTableFields(string tableName)
        {
            RfcDestination sap = DestinationProvider.GetSAPDestination();
            IRfcFunction function = sap.Repository.CreateFunction("RFC_READ_TABLE");
            function.SetValue("QUERY_TABLE", tableName.ToUpper());
            function.SetValue("NO_DATA", "X");
            function.Invoke(sap);

            IRfcTable fieldsTable = function.GetTable("FIELDS");
            return SAPUtils.ToDataTable(fieldsTable);
        }

        private DataTable SplittedFields(DataTable dt, String[] fields, string delimiter)
        {
            DataTable targetDt = new DataTable();
            foreach (var item in fields) {
                targetDt.Columns.Add(new DataColumn(item.ToString()));
            }

            foreach (DataRow row in dt.Rows) {
                DataRow targetRow = targetDt.NewRow();
                for (int idx = 0; idx < targetDt.Columns.Count; idx++) {
                    String[] rowValues = row[0].ToString().Split(delimiter.ToCharArray()[0]);
                    targetRow[idx] = rowValues[idx];
                }
                targetDt.Rows.Add(targetRow);
                targetDt.AcceptChanges();
            }

            return targetDt;
        }

        private List<String> GetFieldNames(string tableName)
        {
            var fieldNames = new List<String>();

            var fields = this.GetTableFields(tableName);
            foreach (DataRow row in fields.Rows) {
                fieldNames.Add(row["FIELDNAME"].ToString());
            }

            return fieldNames;
        }
    }
}
