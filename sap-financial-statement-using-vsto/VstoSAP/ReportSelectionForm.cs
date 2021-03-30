using System;
using System.Data;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;

namespace VSTOSAP
{
    public partial class ReportSelectionForm : Form
    {
        private string templateFile = "B001_Balance_Sheet.xltx";
        private string templateSheet = "Balance Sheet";

        public ReportSelectionForm()
        {
            InitializeComponent();
        } 

        private void btnConfirm_Click(object sender, EventArgs e)
        {
            string year = txtYear.Text.Trim();
            string month = txtMonth.Text.Trim();
            string companyCode = txtCompany.Text.ToUpper().Trim();

            if (this.Tag.ToString().Equals("BS")) {
                // 将公司代码、年度和期间数据写入GlobalInstance
                var bsService = new BalanceSheetService();
                BalanceSheetService.GlobalInstance.CompanyCode = companyCode;
                BalanceSheetService.GlobalInstance.ReportYear = year;
                BalanceSheetService.GlobalInstance.ReportPeriod = month;

                DataTable bsItems = bsService.GetBsItems(companyCode, year, month);

                // Copy Template
                string fullPath = ExcelUtils.TemplatePath + templateFile;
                ExcelUtils.CopyTemplate(fullPath, templateSheet, ThisAddIn.ExcelApp.ActiveSheet);

                Excel.Worksheet bsSheet = ThisAddIn.ExcelApp.ActiveSheet;

                // period
                bsSheet.Range["D2"].Value = $"'{year}年{month}月";

                foreach (DataRow row in bsItems.Rows) {
                    string bsItem = row["FSITEM"].ToString();
                    string cell1 = bsService.FindCell(bsItem, 1);
                    string cell2 = bsService.FindCell(bsItem, 6);                    

                    if (cell1 != null) {
                        int sign = bsService.Sign(bsItem, 1);
                        bsSheet.Range[cell1].Value = sign * Convert.ToDouble(row["YR_OPENBAL"]);
                    }
                    if (cell2 != null) {
                        int sign = bsService.Sign(bsItem, 6);
                        bsSheet.Range[cell2].Value = sign * Convert.ToDouble(row["BALANCE"]);
                    }                   
                }
            }

            if (this.Tag.ToString().Equals("TB")) {
                var bsService = new BalanceSheetService();
                DataTable bsItems = bsService.GetBsItemsDetail(companyCode, year, month);

                // Copy Template                
                string fullPath = ExcelUtils.TemplatePath + "B000_Trial_Balance_v1.xltx";
                ExcelUtils.CopyTemplate(fullPath, "TB", ThisAddIn.ExcelApp.ActiveSheet);

                ExcelUtils.CopyFromDataTable(bsItems, ThisAddIn.ExcelApp.ActiveSheet, false); 
            }

            this.Close();
        }

        private void txtCompany_KeyPress(object sender, KeyPressEventArgs e)
        {
            e.KeyChar = Convert.ToChar(e.KeyChar.ToString().ToUpper());
        }
    }
}
