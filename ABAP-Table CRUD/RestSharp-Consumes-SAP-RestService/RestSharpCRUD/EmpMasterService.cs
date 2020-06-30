using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace RestSharpCRUD {
    public class EmpMasterService {
        private String baseUrl = "http://sapecc6:8000";
        private String username = "stone";
        private String password = "w123456";

        private RestSharpHelper restSharpHelper;

        public EmpMasterService() {
            restSharpHelper = new RestSharpHelper(baseUrl, username, password);
        }

        public IList<EmpEntity> ListAll() {
            IList<EmpEntity> employees = null;

            var resp = restSharpHelper.Get("/zrest/employees");
            if (!resp.IsSuccessful) {                
                throw new Exception(resp.ErrorMessage);                
            }

            employees = JsonConvert.DeserializeObject<List<EmpEntity>>(resp.Content);
                       
            return employees;  
        }

        public bool Create(EmpEntity emp) {
            String payload = JsonConvert.SerializeObject(emp);

            // Call POST method
            var resp = restSharpHelper.Post("/zrest/employees/create", payload);

            if (!resp.IsSuccessful) {
                throw new Exception(resp.Content);
            }

            return true;
        }

        public bool Update(EmpEntity emp) {
            String payload = JsonConvert.SerializeObject(emp);

            // Call POST method
            var resp = restSharpHelper.Put("/zrest/employees/" + emp.EMPID, payload);

            if (!resp.IsSuccessful) {
                throw new Exception(resp.Content);
            }

            return true;
        }

        public bool Delete(String empId) {
            bool rv = false;

            var resp = restSharpHelper.Delete("/zrest/employees/" + empId);
            if (resp.IsSuccessful) rv = true;

            return rv;
        }        
    }
}
