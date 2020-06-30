using System;
using System.Windows.Forms;

namespace RestSharpCRUD {
    public partial class EmpSingleForm : Form {
        private bool isAddNewMode = false;

        public EmpSingleForm() {
            InitializeComponent();
        }

        public EmpSingleForm(BindingSource bs): this() {
            empBs = bs;

            // Set data binding
            SetBinding();
        }

        public EmpSingleForm(BindingSource bs, bool addNew): this(bs) {
            isAddNewMode = addNew;
        }

        private void SetBinding() {
            txtEmpID.DataBindings.Add("Text", empBs, "EMPID", true);           
            txtName.DataBindings.Add("Text", empBs, "EMPNAME", true);
            txtAddress.DataBindings.Add("Text", empBs, "EMPADDR", true);
        }

        private void EmpSingleForm_FormClosed(object sender, FormClosedEventArgs e) {
            this.empBs.CancelEdit();
        }

        private void BtnSave_Click(object sender, System.EventArgs e) {
            var emp = new EmpEntity {
                MANDT = "001",
                EMPID = txtEmpID.Text,               
                EMPNAME = txtName.Text,
                EMPADDR = txtAddress.Text
            };

            var empService = new EmpMasterService();
            bool rv = false;
            if (isAddNewMode) {
                try {
                    rv = empService.Create(emp);
                }
                catch (Exception ex) {
                    MessageBox.Show(ex.Message);
                }
            }
            else {                
                rv = empService.Update(emp);
            }            

            if (rv) {
                empBs.EndEdit();
                this.Close();
            }
        }

        private void EmpSingleForm_Load(object sender, EventArgs e) {
            this.Text = "Employee Master Data Maintain";
            txtEmpID.Enabled = (isAddNewMode == true);
        }
    }
}
