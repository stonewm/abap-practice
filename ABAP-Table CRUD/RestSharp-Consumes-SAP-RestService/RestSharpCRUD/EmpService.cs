using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace RestSharpCRUD {
    public class EmpService {
        // private String baseUrl = "http://sapecc6:8000";
        private String baseUrl = "http://192.168.44.100:8000";
        private String username = "stone";
        private String password = "w123456";

        private RestSharpHelper restSharpHelper;

        public EmpService() {
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
            var resource = String.Format("/zrest/employees/{0}", emp.EMPID);
            var resp = restSharpHelper.Put(resource, payload);

            if (!resp.IsSuccessful) {
                throw new Exception(resp.Content);
            }

            return true;
        }

        public bool Delete(String empId) {
            bool rv = false;

            var resource = String.Format("/zrest/employees/{0}", empId);
            var resp = restSharpHelper.Delete(resource);
            if (resp.IsSuccessful) rv = true;

            return rv;
        }        
    }
}
