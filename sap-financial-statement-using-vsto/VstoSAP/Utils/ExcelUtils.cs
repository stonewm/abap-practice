using Microsoft.Office.Interop.Excel;
using System;
using System.IO;

namespace VSTOSAP {
    public class ExcelUtils {
        private static string templatePath = AppDomain.CurrentDomain.BaseDirectory + $@"templates\";

        public static String TemplatePath {
            get { return templatePath; }           
        }

        public static void CopyFromDataTable(System.Data.DataTable dt, Worksheet sht, bool withHeader = true) {
            if (dt == null) return;

            int colCount = dt.Columns.Count; // 列数量
            int rowCount = dt.Rows.Count;    // 行数量
            if (colCount == 0 || rowCount == 0) {
                throw new Exception("Empty table!");
            }

            // Header array
            object[] headerArray = new object[colCount];
            for (int col = 0; col < colCount; col++) {
                headerArray[col] = dt.Columns[col].ColumnName;
            }

            Range startCell = (Range)sht.Cells[1, 1]; // 从第二行第一列开始

            if (withHeader) {
                // Write header from header array
                Range headerRange = sht.get_Range(startCell, (Range)sht.Cells[startCell.Row, colCount]);
                headerRange.Value = headerArray;
            }

            // Value for line item Cells
            object[,] valueArray = new object[rowCount, colCount];

            for (int row = 0; row < rowCount; row++) {
                for (int col = 0; col < colCount; col++) {
                    valueArray[row, col] = dt.Rows[row][col];
                }
            }
            
            // 数据整体从array拷贝到工作表(从表头的下一行开始)
            sht.get_Range(startCell.Offset[1, 0], (Range)(sht.Cells[rowCount + 1, colCount])).Value = valueArray;
        }

        public static void CopyTemplate(String templateExcelFile, String sourceSheetName, Worksheet targetSheet) {
            Application excelApp = ThisAddIn.ExcelApp;
 
            excelApp.ScreenUpdating = false;
            Workbook templateWorkbook = excelApp.Workbooks.Open(templateExcelFile);

            if (templateWorkbook == null) {
                throw new FileNotFoundException("Template file does not exist.");
            }

            Worksheet templateSheet = templateWorkbook.Worksheets[sourceSheetName];
            if (templateSheet == null) {
                throw new Exception("Template worksheet does not exist.");
            }

            templateSheet.Copy(targetSheet); 
            templateWorkbook.Close();
            excelApp.ScreenUpdating = true;
        }

        public static string GetRelativeAddress(Range cell) {
            return cell.get_AddressLocal(false, false, XlReferenceStyle.xlA1);
        }
    }
}
