/**
 * 记录运行中的报表，以便从Worksheet中可以drill down到明细或者原始数据
 */

using System.Collections.Generic;

namespace VSTOSAP {

    public class RuntimeReports {
        public static IList<RuntimeReport> Reports = new List<RuntimeReport>();

        public static void Add(RuntimeReport report)
        {
            Reports.Add(report);
        }

        public static void RemoveBy(string sheetName)
        {
            foreach(RuntimeReport item in Reports) {
                if (item.WorksheetName.Equals(sheetName)) {
                    Reports.Remove(item);
                }
            }
        }
        

        public static object FindReportByWorksheet(string sheetName)
        {
            object instance = null;
            foreach(RuntimeReport item in Reports) {
                if (item.WorksheetName.Equals(sheetName)) {
                    instance = item.ReportInstance;
                }
            }
            return instance;
        }
    }

    public class RuntimeReport {
        public object ReportInstance { get; set; }
        public string WorksheetName { get; set; }
    }
}
