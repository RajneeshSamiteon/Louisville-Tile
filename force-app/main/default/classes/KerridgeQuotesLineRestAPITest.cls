@isTest
public class KerridgeQuotesLineRestAPITest {
    
 @isTest
    static void validateKerridgeQuotesLineCreation() {
       
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeQuoteLine';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{ "kerridgeQuotesLine" :  [ { "SalesforceId" : "a2A2C000000VdXfUAK", "kerridgeQuoteLineName" : "quote1", "listPrice" : 431.74, "productName" : "product1", "quantity" : 60, "quote" : 45 } ] }');
        RestContext.request = req;
        RestContext.response = res;
        KerridgeQuotesLineRestAPI.creatingKerridgeQuotesLine();
        
        Test.stopTest();
    }
    
     @isTest
    static void validateKerridgeQuotesLineCreationWithRequestBodyNull() {
       
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeQuoteLine';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');
        RestContext.request = req;
        RestContext.response = res;
        KerridgeQuotesLineRestAPI.creatingKerridgeQuotesLine();
        
        Test.stopTest();
    }
}