using Microsoft.Office.Core;
using Microsoft.Office.Interop.Excel;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;

namespace VSTOSAP {
    public partial class ThisAddIn
    {
        public static Excel.Application ExcelApp;


        private void ThisAddIn_Startup(object sender, System.EventArgs e)
        {
            ExcelApp = Globals.ThisAddIn.Application;

            this.Application.SheetBeforeDelete += Application_SheetBeforeDelete;
        }

        /// <summary>
        /// 工作表beforeDelete事件
        /// </summary>
        /// <param name="Sh"></param>
        private void Application_SheetBeforeDelete(object Sh)
        {
            Worksheet sht = this.Application.ActiveSheet;
            RuntimeReports.RemoveBy(sht.Name);            
        }

        private void ThisAddIn_Shutdown(object sender, System.EventArgs e)
        {
        }

        protected override Microsoft.Office.Core.IRibbonExtensibility CreateRibbonExtensibilityObject() {
            return new Ribbon();
        }

        #region VSTO generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InternalStartup()
        {
            this.Startup += new System.EventHandler(ThisAddIn_Startup);
            this.Shutdown += new System.EventHandler(ThisAddIn_Shutdown);
        }
        
        #endregion
    }
}
