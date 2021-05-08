using System;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Office = Microsoft.Office.Core;


namespace VSTOSAP {
    [ComVisible(true)]
    public class Ribbon : Office.IRibbonExtensibility {
        private Office.IRibbonUI ribbon;
        private SAPTableForm sapTableForm = null;
        private ReportSelectionForm selectionForm = null;

        public Ribbon() {
        }

        /// <summary>
        /// SAP表数据查看器
        /// </summary>
        /// <param name="ctrl"></param>
        public void btnTableExplorer_Click(Office.IRibbonControl ctrl) {
            if (sapTableForm == null) {
                sapTableForm = new SAPTableForm();
            }
            sapTableForm.ShowDialog();
        }

        public void btnBalanceSheet_Click(Office.IRibbonControl ctrl) {
            if (selectionForm == null) {
                selectionForm = new ReportSelectionForm();
            }           
            selectionForm.Tag = "BS";
            selectionForm.ShowDialog();  
        }

        public void btnTB_Click(Office.IRibbonControl ctrl) {
            if (selectionForm == null) {
                selectionForm = new ReportSelectionForm();
            }
            selectionForm.Tag = "TB";
            selectionForm.ShowDialog();
        }

        public void btnTest_Click(Office.IRibbonControl control)
        {
            foreach (RuntimeReport item in RuntimeReports.Reports) {
                if (item.ReportInstance is BalanceSheetService) {
                    BalanceSheetService bs = (BalanceSheetService)item.ReportInstance;
                    MessageBox.Show(bs.ToString());
                }
            }
        }

        public void drillDownButton_Click(Office.IRibbonControl ctrl) {
            string sheetName = Globals.ThisAddIn.Application.ActiveSheet.Name;
            object reportInstance = RuntimeReports.FindReportByWorksheet(sheetName);

            if (reportInstance == null) return;
            if (!(reportInstance is BalanceSheetService)) return;

            string cellAddr = ExcelUtils.GetRelativeAddress(ThisAddIn.ExcelApp.ActiveCell);
            BalanceSheetService bsService = (BalanceSheetService)reportInstance;

            string fsItem = bsService.FindFsItem(cellAddr); // 根据单元格地址查找报表项
            if (fsItem != null) {
                System.Data.DataTable tbItems = bsService.GetBsItemsDetail();
                System.Data.DataView tbView = new System.Data.DataView(tbItems);
                tbView.RowFilter = $"FSItem = '{fsItem}' ";
                System.Data.DataTable rv = tbView.ToTable();

                // Copy Template                
                string fullPath = ExcelUtils.TemplatePath + "B000_Trial_Balance_v1.xltx";
                ExcelUtils.CopyTemplate(fullPath, "TB", ThisAddIn.ExcelApp.ActiveSheet);

                ExcelUtils.CopyFromDataTable(rv, ThisAddIn.ExcelApp.ActiveSheet, false);
            }
        }

        #region IRibbonExtensibility Members

        public string GetCustomUI(string ribbonID) {
            return GetResourceText("VSTOSAP.Ribbon.xml");
        }

        #endregion

        #region Ribbon Callbacks
        //Create callback methods here. For more information about adding callback methods, visit https://go.microsoft.com/fwlink/?LinkID=271226

        public void Ribbon_Load(Office.IRibbonUI ribbonUI) {
            this.ribbon = ribbonUI;
        }

        #endregion

        #region Helpers

        private static string GetResourceText(string resourceName) {
            Assembly asm = Assembly.GetExecutingAssembly();
            string[] resourceNames = asm.GetManifestResourceNames();
            for (int i = 0; i < resourceNames.Length; ++i) {
                if (string.Compare(resourceName, resourceNames[i], StringComparison.OrdinalIgnoreCase) == 0) {
                    using (StreamReader resourceReader = new StreamReader(asm.GetManifestResourceStream(resourceNames[i]))) {
                        if (resourceReader != null) {
                            return resourceReader.ReadToEnd();
                        }
                    }
                }
            }
            return null;
        }

        #endregion
    }
}
