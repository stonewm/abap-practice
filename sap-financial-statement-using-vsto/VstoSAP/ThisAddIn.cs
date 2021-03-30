using Microsoft.Office.Core;
using Excel = Microsoft.Office.Interop.Excel;

namespace VSTOSAP {
    public partial class ThisAddIn
    {
        public static Excel.Application ExcelApp;
        public static CommandBar cellCommandBar;

        private void ThisAddIn_Startup(object sender, System.EventArgs e)
        {
            ExcelApp = Globals.ThisAddIn.Application;
            AddDrillDownButton();
        }

        public void DrillDownButton_Click(CommandBarButton Ctrl, ref bool CancelDefault) {
            Excel.Range currentCell = (Excel.Range) ExcelApp.ActiveCell;
            currentCell.Value = ExcelUtils.GetRelativeAddress(currentCell);
            CancelDefault = true;
        }

        private void ThisAddIn_Shutdown(object sender, System.EventArgs e)
        {
            DelDrillDownButton("DRILLDOWN");
        }

        private void AddDrillDownButton() {
            cellCommandBar = ExcelApp.CommandBars["Cell"];
            cellCommandBar.Reset();

            CommandBarButton drillDownButton = (CommandBarButton)cellCommandBar.Controls.Add(
                MsoControlType.msoControlButton, Before: 1);
            drillDownButton.Tag = "DRILLDOWN";
            drillDownButton.Caption = "Drill Down";
            drillDownButton.FaceId = 49;

            drillDownButton.Click += DrillDownButton_Click;
        }

        private void DelDrillDownButton(string tagName) {
            CommandBarControls controls = ExcelApp.CommandBars["Cell"].Controls;
            foreach(CommandBarControl item in controls) {
                if (item.Tag.ToString().Equals(tagName)) {
                    item.Delete();
                }
            }
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
