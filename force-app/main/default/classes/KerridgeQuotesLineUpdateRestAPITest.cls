@IsTest
public class KerridgeQuotesLineUpdateRestAPITest {
    @TestSetup
    public static void createTestData() {
        Kerridge_Quote_Line__c kerridgeQuoteLine =  new Kerridge_Quote_Line__c();
        kerridgeQuoteLine.Name = 'Test Krridge Quote Line';
        kerridgeQuoteLine.Unit_Price__c = 2;
        kerridgeQuoteLine.Product_Name__c = 'Testing Product';
        kerridgeQuoteLine.Quantity__c = '4';
        kerridgeQuoteLine.QUOTE__c = 'Testing';
        
        INSERT kerridgeQuoteLine;
    }
    
      @IsTest
    public static void validateupdateKerridgeQuotesLineUpdate() {
    Kerridge_Quote_Line__c kerridgeQuoteLine = [SELECT Id,Name,Unit_Price__c,Product_Name__c,Quantity__c,QUOTE__c
                                         FROM Kerridge_Quote_Line__c WHERE  Name = 'Test Krridge Quote Line'];
       // System.debug('the kerridgeQuoteLine id : '+kerridgeQuoteLine.id);
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeQuoteLineUpdate/'+kerridgeQuoteLine.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"kerridgeQuotesLine" : [{"kerridgeQuoteLineName" : "quote1","listPrice" : 77.00,"productName" : "product1","quantity" : 60,"quote" : 45}]}'
	        );

        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeQuotesLineUpdateRestAPI.updateKerridgeQuotesLineUpdate();

        Test.stopTest();
    }
    
          @IsTest
    public static void validateupdateKerridgeQuotesLineUpdateForNullBody() {
    Kerridge_Quote_Line__c kerridgeQuoteLine = [SELECT Id,Name,Unit_Price__c,Product_Name__c,Quantity__c,QUOTE__c
                                         FROM Kerridge_Quote_Line__c WHERE  Name = 'Test Krridge Quote Line'];
       // System.debug('the kerridgeQuoteLine id : '+kerridgeQuoteLine.id);
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeQuoteLineUpdate/'+kerridgeQuoteLine.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');

        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeQuotesLineUpdateRestAPI.updateKerridgeQuotesLineUpdate();

        Test.stopTest();
    }
    
}