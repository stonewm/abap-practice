namespace VSTOSAP {
    partial class SAPTableForm {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            this.label1 = new System.Windows.Forms.Label();
            this.txtTableName = new System.Windows.Forms.TextBox();
            this.txtCriteria = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.txtRows = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.btnConfirm = new System.Windows.Forms.Button();
            this.tableFieldsCheckBox = new System.Windows.Forms.CheckBox();
            this.tableContentCheckBox = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(59, 46);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(69, 15);
            this.label1.TabIndex = 0;
            this.label1.Text = "SAP表名:";
            // 
            // txtTableName
            // 
            this.txtTableName.Location = new System.Drawing.Point(159, 43);
            this.txtTableName.Name = "txtTableName";
            this.txtTableName.Size = new System.Drawing.Size(189, 25);
            this.txtTableName.TabIndex = 1;
            // 
            // txtCriteria
            // 
            this.txtCriteria.Location = new System.Drawing.Point(159, 84);
            this.txtCriteria.Multiline = true;
            this.txtCriteria.Name = "txtCriteria";
            this.txtCriteria.Size = new System.Drawing.Size(516, 103);
            this.txtCriteria.TabIndex = 3;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(59, 87);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(75, 15);
            this.label2.TabIndex = 2;
            this.label2.Text = "筛选条件:";
            // 
            // txtRows
            // 
            this.txtRows.Location = new System.Drawing.Point(159, 212);
            this.txtRows.Name = "txtRows";
            this.txtRows.Size = new System.Drawing.Size(106, 25);
            this.txtRows.TabIndex = 5;
            this.txtRows.Text = "200";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(59, 215);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(75, 15);
            this.label3.TabIndex = 4;
            this.label3.Text = "输出行数:";
            // 
            // btnConfirm
            // 
            this.btnConfirm.Location = new System.Drawing.Point(566, 285);
            this.btnConfirm.Name = "btnConfirm";
            this.btnConfirm.Size = new System.Drawing.Size(109, 28);
            this.btnConfirm.TabIndex = 6;
            this.btnConfirm.Text = "确认";
            this.btnConfirm.UseVisualStyleBackColor = true;
            this.btnConfirm.Click += new System.EventHandler(this.btnConfirm_Click);
            // 
            // tableFieldsCheckBox
            // 
            this.tableFieldsCheckBox.AutoSize = true;
            this.tableFieldsCheckBox.Checked = true;
            this.tableFieldsCheckBox.CheckState = System.Windows.Forms.CheckState.Checked;
            this.tableFieldsCheckBox.Location = new System.Drawing.Point(50, 285);
            this.tableFieldsCheckBox.Name = "tableFieldsCheckBox";
            this.tableFieldsCheckBox.Size = new System.Drawing.Size(104, 19);
            this.tableFieldsCheckBox.TabIndex = 7;
            this.tableFieldsCheckBox.Text = "输出表结构";
            this.tableFieldsCheckBox.UseVisualStyleBackColor = true;
            // 
            // tableContentCheckBox
            // 
            this.tableContentCheckBox.AutoSize = true;
            this.tableContentCheckBox.Checked = true;
            this.tableContentCheckBox.CheckState = System.Windows.Forms.CheckState.Checked;
            this.tableContentCheckBox.Location = new System.Drawing.Point(208, 285);
            this.tableContentCheckBox.Name = "tableContentCheckBox";
            this.tableContentCheckBox.Size = new System.Drawing.Size(104, 19);
            this.tableContentCheckBox.TabIndex = 8;
            this.tableContentCheckBox.Text = "输出表数据";
            this.tableContentCheckBox.UseVisualStyleBackColor = true;
            // 
            // SAPTableForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(767, 349);
            this.Controls.Add(this.tableContentCheckBox);
            this.Controls.Add(this.tableFieldsCheckBox);
            this.Controls.Add(this.btnConfirm);
            this.Controls.Add(this.txtRows);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.txtCriteria);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.txtTableName);
            this.Controls.Add(this.label1);
            this.MaximizeBox = false;
            this.Name = "SAPTableForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "查询SAP表数据";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtTableName;
        private System.Windows.Forms.TextBox txtCriteria;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtRows;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Button btnConfirm;
        private System.Windows.Forms.CheckBox tableFieldsCheckBox;
        private System.Windows.Forms.CheckBox tableContentCheckBox;
    }
}