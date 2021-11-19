using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using SAPGlFunctions.Services;

namespace UnitTestProject
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestGetBalances()
        {
            var glAccountBalances = GlBalnceService.GetBalances("Z900", "2020", "10");
            foreach(var item in glAccountBalances) {
                Console.WriteLine($"{ item.FSITEM} \t { item.BALANCE }");
            }
        }
    }
}
