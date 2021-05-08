using Newtonsoft.Json;
using SAP.Middleware.Connector;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;

namespace VSTOSAP {
    public class BalanceSheetService
    {        
        public List<CellDefinition> CellSettings;

        public BalanceSheetService(string companyCode, string reportYear, string reportPeriod)
        {
            this.CompanyCode = companyCode;
            this.ReportYear = reportYear;
            this.ReportPeriod = reportPeriod;

            this.LoadSettings();
        }

        public string CompanyCode { get; set; }
        public string ReportYear { get; set; }
        public string ReportPeriod { get; set; }

        /// <summary>
        ///  获取资产负债表的报表项及金额
        /// </summary>
        /// <param name="companycode">Company Code</param>
        /// <param name="fisyear">Fiscal Year</param>
        /// <param name="period">Accounting Period</param>
        /// <returns></returns>
        public System.Data.DataTable GetBsItems()
        {
            // validation 
            if (string.IsNullOrEmpty(this.CompanyCode)) {
                throw new Exception("公司代码参数不能为空!");
            }
            if (string.IsNullOrEmpty(this.ReportYear) ) {
                throw new Exception("年度参数不能为空!");
            }
            if (string.IsNullOrEmpty(this.ReportPeriod)) {
                throw new Exception("期间参数不能为空!");
            }

            RfcDestination sap = DestinationProvider.GetSAPDestination();
            IRfcFunction function = sap.Repository.CreateFunction("Z_BS_BALANCES");

            function.SetValue("COMPANYCODE", this.CompanyCode);
            function.SetValue("FISCALYEAR", this.ReportYear);
            function.SetValue("FISCALPERIOD", this.ReportPeriod);

            function.Invoke(sap);

            IRfcTable bsItems = function.GetTable("FS_BALANCES");
            return SAPUtils.ToDataTable(bsItems);
        }

        /// <summary>
        ///  获取资产负债表的报表项及金额
        /// </summary>
        /// <param name="companycode">Company Code</param>
        /// <param name="fisyear">Fiscal Year</param>
        /// <param name="period">Accounting Period</param>
        /// <returns></returns>
        public System.Data.DataTable GetBsItems2(string companycode, string fisyear, string period)
        {
            // validation 
            if (string.IsNullOrEmpty(this.CompanyCode)) {
                throw new Exception("公司代码参数不能为空!");
            }
            if (string.IsNullOrEmpty(this.ReportYear)) {
                throw new Exception("年度参数不能为空!");
            }
            if (string.IsNullOrEmpty(this.ReportPeriod)) {
                throw new Exception("期间参数不能为空!");
            }

            System.Data.DataTable itemsDataTable = GetBsItemsDetail();
            return this.TotalByFsItem(itemsDataTable);
        }

        public System.Data.DataTable GetBsItemsDetail()
        {
            // validation 
            if (string.IsNullOrEmpty(this.CompanyCode)) {
                throw new Exception("公司代码参数不能为空!");
            }
            if (string.IsNullOrEmpty(this.ReportYear)) {
                throw new Exception("年度参数不能为空!");
            }
            if (string.IsNullOrEmpty(this.ReportPeriod)) {
                throw new Exception("期间参数不能为空!");
            }

            RfcDestination sap = DestinationProvider.GetSAPDestination();
            IRfcFunction function = sap.Repository.CreateFunction("Z_BS_BALANCES");

            function.SetValue("COMPANYCODE", this.CompanyCode);
            function.SetValue("FISCALYEAR", this.ReportYear);
            function.SetValue("FISCALPERIOD", this.ReportPeriod);

            function.Invoke(sap);

            IRfcTable bsItems = function.GetTable("ACC_BALANCES");
            return SAPUtils.ToDataTable(bsItems);
        }

        private System.Data.DataTable TotalByFsItem(System.Data.DataTable source)
        {
            // 按照FSItem分组合计
            var query = from bs in source.AsEnumerable()
                        group bs by bs.Field<string>("FSITEM") into g
                        select new
                        {
                            BSITEM = g.Key,
                            YR_OPENBAL = g.Sum(x => Convert.ToDouble(x.Field<string>("YR_OPENBAL"))),
                            BALANCE = g.Sum(x => Convert.ToDouble(x.Field<string>("BALANCE")))
                        };

            System.Data.DataTable dt = new System.Data.DataTable();

            dt.Columns.Add(new DataColumn("FSITEM", typeof(string)));
            dt.Columns.Add(new DataColumn("YR_OPENBAL", typeof(double)));
            dt.Columns.Add(new DataColumn("BALANCE", typeof(double)));

            foreach (var item in query) {
                DataRow dr = dt.NewRow();
                dr["FSITEM"] = item.BSITEM;
                dr["YR_OPENBAL"] = item.YR_OPENBAL;
                dr["BALANCE"] = item.BALANCE;
                dt.Rows.Add(dr);
            }

            return dt;
        }

        public void LoadSettings()
        {
            string path = AppDomain.CurrentDomain.BaseDirectory;
            string settings = File.ReadAllText(path+"BSSettings.json");
            var content = JsonConvert.DeserializeObject<List<CellDefinition>>(settings);

            this.CellSettings = content;
        }

        /// <summary>
        /// 根据FSItem和数据类型查找输出的单元格
        /// </summary>
        /// <param name="FsItem">FS Item</param>
        /// <param name="amountType">金额类型</param>
        /// <returns></returns>
        public string FindCell(string FsItem, int amountType)
        {
            string rv = null;

            var settings = this.CellSettings;
            foreach(CellDefinition item in settings) {
                if (item.FSItem.Equals(FsItem) && item.Type == amountType) {
                    rv = item.Cell;
                }
            }

            return rv;
        }

        public string FindFsItem(string cell) {
            string rv = null;

            var settings = this.CellSettings;
            foreach (CellDefinition item in settings) {
                if (item.Cell.Equals(cell)) {
                    rv = item.FSItem;
                }
            }

            return rv;
        }

        public int Sign(string FsItem, int amountType)
        {
            int rv = 0;

            var settings = this.CellSettings;
            foreach (CellDefinition item in settings) {
                if (item.FSItem.Equals(FsItem) && item.Type == amountType) {
                    rv = item.Sign;
                }
            }

            return rv;
        }

        public override string ToString()
        {
            return $"Balance Sheet<Company code = {CompanyCode}, Year = {ReportYear}, Period={ReportPeriod}>";
        }
    }

    public class CellDefinition
    {
        public string Cell { get; set; }
        public string FSItem { get; set; }
        public int Type { get; set; } // 1 to 6
        public int Sign { get; set; }
    }
}
