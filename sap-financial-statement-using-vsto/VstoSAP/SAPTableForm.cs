using Microsoft.Office.Interop.Excel;
using System;
using System.Windows.Forms;

namespace VSTOSAP {
    public partial class SAPTableForm : Form {
        public SAPTableForm() {
            InitializeComponent();
        }

        private void btnConfirm_Click(object sender, EventArgs e) {
            var sapService = new SAPTableServiceNCo();

            if (tableFieldsCheckBox.Checked) {
                var tableFields = sapService.GetTableFields(txtTableName.Text.Trim().ToUpper());
                Worksheet sheet = ThisAddIn.ExcelApp.Worksheets.Add();
                sheet.Name = $"{txtTableName.Text.ToUpper()}_strucutre_{sheet.Name}";
                ExcelUtils.CopyFromDataTable(tableFields, sheet);
            }

            if (tableContentCheckBox.Checked) {
                var tableContent = sapService.GetTableContent(txtTableName.Text.ToUpper().Trim(), 
                    Convert.ToInt32(txtRows.Text),
                    txtCriteria.Text);
                Worksheet sheet = ThisAddIn.ExcelApp.Worksheets.Add();
                sheet.Name = $"{txtTableName.Text.ToUpper()}_{sheet.Name}";
                ExcelUtils.CopyFromDataTable(tableContent, sheet);
            }

            this.Close();
        }
    }
}
