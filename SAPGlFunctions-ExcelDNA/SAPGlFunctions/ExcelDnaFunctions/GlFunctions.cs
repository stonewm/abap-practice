using ExcelDna.Integration;
using SAPGlFunctions.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SAPGlFunctions.ExcelDnaFunctions
{
    public class GlFunctions
    {
        [ExcelFunction(Name = "FSBalance", Description = "根据报表项(FS Item)和(Amount type)获取金额")]
        public static double FsItemBalance(
            [ExcelArgument(Description = "公司代码")]
            string companyCode,
            [ExcelArgument(Description = "年度")]
            string year,
            [ExcelArgument(Description = "期间")]
            string period,
            [ExcelArgument(Description = "报表项, 在SAP中用GS03查看")]
            string fsItem,
            [ExcelArgument(Description = "金额类型(1:年初余额,2:期初余额,3:期间借方,4:期间贷方,5:期间净额,6:期末余额)")]
            int amountType)
        {
            double rv = 0.0;

            var glAccountBalances = GlBalnceService.GetBalances(companyCode.ToString(), year, period);
            var fsItemBalances = glAccountBalances.FirstOrDefault(i => i.FSITEM.Equals(fsItem));

            switch (amountType) {
                case 1:
                    rv = fsItemBalances.YR_OPENBAL;  
                    break;
                case 2:
                    rv = fsItemBalances.OPEN_BALANCE;
                    break;
                case 3:
                    rv = fsItemBalances.DEBIT_PER;
                    break;
                case 4:
                    rv = fsItemBalances.CREDIT_PER; 
                    break;
                case 5:
                    rv = fsItemBalances.PER_AMT; 
                    break;
                case 6:
                    rv = fsItemBalances.BALANCE;
                    break;
            }

            return rv;
        }
    }
}
