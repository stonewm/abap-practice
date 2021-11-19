using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using RestSharp;
using SAPGlFunctions.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace SAPGlFunctions.Services
{
    public static class GlBalnceService
    {
        public static string BaseUrl = "http://sapecc6:8000/sap/zrfc/";

        public static IList<FSBalance> GetBalances(string companyCode, string fiscalYear, string fiscalPeriod)
        {
            var client = new RestClient(BaseUrl);
            var req = new RestRequest("z_bs_balances", Method.GET);
            req.AddParameter("COMPANYCODE", companyCode);
            req.AddParameter("FISCALYEAR", fiscalYear);
            req.AddParameter("FISCALPERIOD", fiscalPeriod);

            IRestResponse resp = client.Execute(req);

            if (!resp.IsSuccessful) {
                throw new Exception(resp.ErrorMessage);
            }

            return Parse(resp.Content);
        }

        private static IList<FSBalance> Parse(string responseContent)
        {
            JObject content = JObject.Parse(responseContent);
            IList<JToken> results = content["FS_BALANCES"].Children().ToList();
            IList<FSBalance> balances = new List<FSBalance>();
            foreach (JToken token in results) {
                balances.Add(JsonConvert.DeserializeObject<FSBalance>(token.ToString()));
            }

            return balances;
        }
    }
}
