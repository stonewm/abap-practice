using System;

namespace RestSharpCRUD {
    public class EmpEntity {
        public EmpEntity() {
            MANDT = "001";
        }

        public String MANDT { get; set; }
        public String EMPID { get; set; }
        public String EMPNAME { get; set; }
        public String EMPADDR { get; set; }
    }
}
