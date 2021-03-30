using Microsoft.Office.Tools.Ribbon;
using System.Windows.Forms;

namespace VSTOSAP {
    public partial class Ribbon1
    {
        private Form sapTableForm = null;

        private void Ribbon1_Load(object sender, RibbonUIEventArgs e)
        {
        }

        private void btnTableExplorer_Click(object sender, RibbonControlEventArgs e)
        {
            if (sapTableForm == null) {
                sapTableForm = new SAPTableForm();
            }
            sapTableForm.ShowDialog();
        }

        private void btnBsItems_Click(object sender, RibbonControlEventArgs e)
        {
            var selectionForm = new ReportSelectionForm();
            selectionForm.Tag = "BS";
            selectionForm.ShowDialog();
        }

        private void btnTB_Click(object sender, RibbonControlEventArgs e)
        {
            var selectionForm = new ReportSelectionForm();
            selectionForm.Tag = "TB";
            selectionForm.ShowDialog();
        }

        private void button1_Click(object sender, RibbonControlEventArgs e) {
            var bsService = new BalanceSheetService();
            string cellAddr = ExcelUtils.GetRelativeAddress(ThisAddIn.ExcelApp.ActiveCell);

            string fsItem = bsService.FindFsItem(cellAddr);

            if (fsItem != null) {
                string cocd = BalanceSheetService.GlobalInstance.CompanyCode;
                string year = BalanceSheetService.GlobalInstance.ReportYear;
                string period = BalanceSheetService.GlobalInstance.ReportPeriod;

                System.Data.DataTable tbItems = bsService.GetBsItemsDetail(cocd, year, period);
                System.Data.DataView tbView = new System.Data.DataView(tbItems);
                tbView.RowFilter = $"FSItem = '{fsItem}' ";
                System.Data.DataTable rv = tbView.ToTable();

                // Copy Template                
                string fullPath = ExcelUtils.TemplatePath + "B000_Trial_Balance_v1.xltx";
                ExcelUtils.CopyTemplate(fullPath, "TB", ThisAddIn.ExcelApp.ActiveSheet);

                ExcelUtils.CopyFromDataTable(rv, ThisAddIn.ExcelApp.ActiveSheet, false);
            }           
        }
    }
}
