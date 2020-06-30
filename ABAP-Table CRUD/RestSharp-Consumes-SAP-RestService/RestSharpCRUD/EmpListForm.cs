using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Windows.Forms;

namespace RestSharpCRUD {
    public partial class EmpListForm : Form {
        public EmpListForm() {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e) {

            var empService = new EmpMasterService();
            IList<EmpEntity> employees = null;
            try {
                employees = empService.ListAll();
            }
            catch (Exception ex) {
                MessageBox.Show(ex.Message);
                return;
            }

            // Binding
            var view = new BindingList<EmpEntity>(employees);
            bindingSource1.DataSource = view;
            dataGridView1.DataSource = bindingSource1;
            bindingNavigator1.BindingSource = bindingSource1;

        }

        private void DataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e) {
            // Double click to open single form
            var empSingleForm = new EmpSingleForm(bindingSource1);
            empSingleForm.ShowDialog();
        }

        private void BindingNavigatorAddNewItem_Click(object sender, EventArgs e) {
            this.bindingSource1.AddNew();
            var empSingleForm = new EmpSingleForm(bindingSource1, true);
            empSingleForm.ShowDialog();
        }

        private void BindingNavigatorDeleteItem_Click(object sender, EventArgs e) {
            doDelete();
        }

        private void doDelete() {
            if (bindingSource1.Current != null) {
                if (MessageBox.Show("确定删除这个员工吗？", "删除", 
                                    MessageBoxButtons.YesNo, 
                                    MessageBoxIcon.Question) == DialogResult.Yes) {
                    var empId = (bindingSource1.Current as EmpEntity).EMPID;

                    var empService = new EmpMasterService();
                    bool rv = empService.Delete(empId);
                    if (rv) {
                        bindingSource1.RemoveCurrent(); // 保持界面同步
                    }
                }
            }
        }
    }
}
