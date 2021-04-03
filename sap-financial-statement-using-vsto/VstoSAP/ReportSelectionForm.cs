using SAP.Middleware.Connector;
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
            string companyCode = txtCompany.Text.ToUpper().Trim();
            string year = txtYear.Text.Trim();
            string month = txtMonth.Text.Trim();

            if (this.Tag.ToString().Equals("BS")) {
                GenerateBalanceSheet(companyCode, year, month);
            }

            if (this.Tag.ToString().Equals("TB")) {
                var bsService = new BalanceSheetService(companyCode, year, month);
                DataTable bsItems = bsService.GetBsItemsDetail();

                // Copy Template                
                string fullPath = ExcelUtils.TemplatePath + "B000_Trial_Balance_v1.xltx";
                ExcelUtils.CopyTemplate(fullPath, "TB", ThisAddIn.ExcelApp.ActiveSheet);

                ExcelUtils.CopyFromDataTable(bsItems, ThisAddIn.ExcelApp.ActiveSheet, false);

                // 在RuntimeReports中记录当前的报表和worksheet对应
                RuntimeReports.Add(new RuntimeReport()
                {
                    ReportInstance = bsService,
                    WorksheetName = ThisAddIn.ExcelApp.ActiveSheet.Name
                });
            }

            this.Close();
        }

        private void GenerateBalanceSheet(string companyCode, string year, string month)
        {
            // 将公司代码、年度和期间数据写入GlobalInstance
            var bsService = new BalanceSheetService(companyCode, year, month);

            DataTable bsItems = null;
            try {
                bsItems = bsService.GetBsItems();
            }
            catch (Exception ex) {
                if (ex is RfcCommunicationException) {
                    MessageBox.Show("不能连接到SAP系统！");
                }
                else {
                    MessageBox.Show(ex.ToString());
                }
                this.Close();
                return;
            }

            // Copy Template
            string fullPath = ExcelUtils.TemplatePath + templateFile;
            ExcelUtils.CopyTemplate(fullPath, templateSheet, ThisAddIn.ExcelApp.ActiveSheet);

            Excel.Worksheet bsSheet = ThisAddIn.ExcelApp.ActiveSheet;

            // write period
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

            // 在RuntimeReports中记录当前的报表和worksheet对应
            RuntimeReports.Add(new RuntimeReport()
            {
                ReportInstance = bsService,
                WorksheetName = bsSheet.Name
            });
        }



        private void txtCompany_KeyPress(object sender, KeyPressEventArgs e)
        {
            e.KeyChar = Convert.ToChar(e.KeyChar.ToString().ToUpper());
        }
    }
}
