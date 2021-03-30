namespace VSTOSAP
{
    partial class Ribbon1 : Microsoft.Office.Tools.Ribbon.RibbonBase
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        public Ribbon1()
            : base(Globals.Factory.GetRibbonFactory())
        {
            InitializeComponent();
        }

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.tab1 = this.Factory.CreateRibbonTab();
            this.group1 = this.Factory.CreateRibbonGroup();
            this.btnTableExplorer = this.Factory.CreateRibbonButton();
            this.btnBsItems = this.Factory.CreateRibbonButton();
            this.btnTB = this.Factory.CreateRibbonButton();
            this.group2 = this.Factory.CreateRibbonGroup();
            this.button1 = this.Factory.CreateRibbonButton();
            this.tab1.SuspendLayout();
            this.group1.SuspendLayout();
            this.group2.SuspendLayout();
            this.SuspendLayout();
            // 
            // tab1
            // 
            this.tab1.ControlId.ControlIdType = Microsoft.Office.Tools.Ribbon.RibbonControlIdType.Office;
            this.tab1.Groups.Add(this.group1);
            this.tab1.Groups.Add(this.group2);
            this.tab1.Label = "Smarter";
            this.tab1.Name = "tab1";
            // 
            // group1
            // 
            this.group1.Items.Add(this.btnTableExplorer);
            this.group1.Items.Add(this.btnBsItems);
            this.group1.Items.Add(this.btnTB);
            this.group1.Label = "SAP";
            this.group1.Name = "group1";
            // 
            // btnTableExplorer
            // 
            this.btnTableExplorer.Label = "SAP表数据查看";
            this.btnTableExplorer.Name = "btnTableExplorer";
            this.btnTableExplorer.Click += new Microsoft.Office.Tools.Ribbon.RibbonControlEventHandler(this.btnTableExplorer_Click);
            // 
            // btnBsItems
            // 
            this.btnBsItems.Label = "资产负债表";
            this.btnBsItems.Name = "btnBsItems";
            this.btnBsItems.Click += new Microsoft.Office.Tools.Ribbon.RibbonControlEventHandler(this.btnBsItems_Click);
            // 
            // btnTB
            // 
            this.btnTB.Label = "科目余额表";
            this.btnTB.Name = "btnTB";
            this.btnTB.Click += new Microsoft.Office.Tools.Ribbon.RibbonControlEventHandler(this.btnTB_Click);
            // 
            // group2
            // 
            this.group2.Items.Add(this.button1);
            this.group2.Label = "group2";
            this.group2.Name = "group2";
            // 
            // button1
            // 
            this.button1.Label = "Drill Down";
            this.button1.Name = "button1";
            this.button1.Click += new Microsoft.Office.Tools.Ribbon.RibbonControlEventHandler(this.button1_Click);
            // 
            // Ribbon1
            // 
            this.Name = "Ribbon1";
            this.RibbonType = "Microsoft.Excel.Workbook";
            this.Tabs.Add(this.tab1);
            this.Load += new Microsoft.Office.Tools.Ribbon.RibbonUIEventHandler(this.Ribbon1_Load);
            this.tab1.ResumeLayout(false);
            this.tab1.PerformLayout();
            this.group1.ResumeLayout(false);
            this.group1.PerformLayout();
            this.group2.ResumeLayout(false);
            this.group2.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        internal Microsoft.Office.Tools.Ribbon.RibbonTab tab1;
        internal Microsoft.Office.Tools.Ribbon.RibbonGroup group1;
        internal Microsoft.Office.Tools.Ribbon.RibbonButton btnTableExplorer;
        internal Microsoft.Office.Tools.Ribbon.RibbonButton btnBsItems;
        internal Microsoft.Office.Tools.Ribbon.RibbonButton btnTB;
        internal Microsoft.Office.Tools.Ribbon.RibbonGroup group2;
        internal Microsoft.Office.Tools.Ribbon.RibbonButton button1;
    }

    partial class ThisRibbonCollection
    {
        internal Ribbon1 Ribbon1 {
            get { return this.GetRibbon<Ribbon1>(); }
        }
    }
}
