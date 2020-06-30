using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using RestSharp;
using RestSharp.Authenticators;

namespace RestSharpCRUD {
    public class RestSharpHelper {
        private String username;
        private String password;

        public String BaseUrl { get; set; }

        private RestClient client;

        public RestSharpHelper(String baseUrl, String username, String password) {
            this.BaseUrl = baseUrl;
            this.username = username;
            this.password = password;

            // construct RestClient object
            client = new RestClient(this.BaseUrl) {
                Authenticator = new HttpBasicAuthenticator(username, password)
            };
        }

        public IRestResponse Get(String resource) {
            var req = new RestRequest(resource, Method.GET);
            var resp = client.Execute(req);

            return resp;
        }

        public IRestResponse Post(String resource, String payload) {
            var req = new RestRequest(resource, Method.POST);
            req.RequestFormat = DataFormat.Json;
            req.AddJsonBody(payload);
            req.AddParameter("application/json", payload, ParameterType.RequestBody);

            var resp = client.Execute(req);

            return resp;
        }

        public IRestResponse Put(String resource, String payload) {
            var req = new RestRequest(resource, Method.PUT);
            req.RequestFormat = DataFormat.Json;
            req.AddJsonBody(payload);
            req.AddParameter("application/json", payload, ParameterType.RequestBody);

            var resp = client.Execute(req);

            return resp;
        }

        public IRestResponse Delete(String resource) {
            var req = new RestRequest(resource, Method.DELETE);
            var resp = client.Execute(req);

            return resp;
        }


        //public static IList<T> ToList<T>(string json) {
        //    JObject generalObj = JObject.Parse(json); // json -> JObject
        //    IList<JToken> jsonList = generalObj["rows"].Children().ToList();

        //    IList<T> genericList = new List<T>();
        //    foreach (JToken tokenItem in jsonList) {
        //        var item = JsonConvert.DeserializeObject<T>(tokenItem.ToString());
        //        genericList.Add(item);
        //    }

        //    return genericList;
        //}
    }
}
