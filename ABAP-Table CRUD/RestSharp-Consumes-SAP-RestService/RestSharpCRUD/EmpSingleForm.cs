using System;
using System.Windows.Forms;

namespace RestSharpCRUD
{
    public partial class EmpSingleForm : Form
    {
        private bool isAddNewMode = false;

        #region constructors

        public EmpSingleForm()
        {
            InitializeComponent();
        }

        public EmpSingleForm(BindingSource bs) : this()
        {
            empBs = bs;

            //设置数据绑定
            SetBinding();
        }

        public EmpSingleForm(BindingSource bs, bool addNew) : this(bs)
        {
            isAddNewMode = addNew;
        }

        #endregion 

        private void EmpSingleForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            this.empBs.CancelEdit();
        }

        private void BtnSave_Click(object sender, System.EventArgs e)
        {
            bool rv = false; // return value

            var emp = new EmpEntity
            {
                MANDT = "001",
                EMPID = txtEmpID.Text.Trim(),
                EMPNAME = txtName.Text.Trim(),
                EMPADDR = txtAddress.Text.Trim()
            };

            var empService = new EmpService();
            
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

        private void EmpSingleForm_Load(object sender, EventArgs e)
        {
            txtEmpID.Enabled = (isAddNewMode == true);
        }

        private void SetBinding()
        {
            txtEmpID.DataBindings.Add("Text", empBs, "EMPID", true);
            txtName.DataBindings.Add("Text", empBs, "EMPNAME", true);
            txtAddress.DataBindings.Add("Text", empBs, "EMPADDR", true);
        }
    }
}
