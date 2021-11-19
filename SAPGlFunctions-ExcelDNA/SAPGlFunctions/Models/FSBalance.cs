using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SAPGlFunctions.Models
{
    public class FSBalance
    {
        public string FSITEM { get; set; }
        public double YR_OPENBAL { get; set; }
        public double OPEN_BALANCE { get; set; }
        public double DEBIT_PER { get; set; }
        public double CREDIT_PER { get; set; }
        public double PER_AMT { get; set; }
        public double BALANCE { get; set; }
    }
}
