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
            // 加载数据
            IList<EmpEntity> employees = null;
            try {
                employees = LoadEmployees();
            }
            catch (Exception ex) {
                MessageBox.Show(ex.Message);
                return;
            }

            // 数据绑定到控件
            // List绑定到DataGridView不能进行增删改查，所以将List转换为BindingList
            // DataGridView.DataSource = new BindingList<T>(List<T>);  
            bindingSource1.DataSource = new BindingList<EmpEntity>(employees);
            dataGridView1.DataSource = bindingSource1;
            bindingNavigator1.BindingSource = bindingSource1;
        }

        private void DataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e) {
            // 双击打开 EmpSingleForm
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

        private IList<EmpEntity> LoadEmployees() {
            var empService = new EmpService();
            IList<EmpEntity> employees = empService.ListAll();
            return employees;            
        }

        private void doDelete() {
            if (bindingSource1.Current != null) {
                if (MessageBox.Show("确定删除这个员工吗？", "删除", 
                                    MessageBoxButtons.YesNo, 
                                    MessageBoxIcon.Question) == DialogResult.Yes) {
                    var empId = (bindingSource1.Current as EmpEntity).EMPID;

                    var empService = new EmpService();
                    bool rv = empService.Delete(empId);
                    if (rv) {
                        bindingSource1.RemoveCurrent(); // 保持界面同步
                    }
                }
            }
        }
    }
}
