@IsTest
public class KerridgeOrdersLineUpdateRestAPITest {
      @TestSetup
    public static void createTestData() {
        Kerridge_Order_Line__c kerridgeOrderLine = new Kerridge_Order_Line__c(Name='Testing kerrige ordr line');
		insert kerridgeOrderLine;
    }
    
    @IsTest
    static void validateSelectionSheetUpdation() {
      id kerridgeOrderLineId = [SELECT Id From Kerridge_Order_Line__c Where Name='Testing kerrige ordr line'].Id;
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeOrders/'+kerridgeOrderLineId;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"kerridgeOrdersLine" : [ { "kerridgeOrderLineName" : "Test1", "LineitemID" : "11", "quantity" : "1212", "LineDescription" : "Testing1212", "lineShipDate" : "2022-08-02", "productName" : "TestProd", "kerridgeOrder" : "123", "listPrice" : "556.50","HReference" : "33",  "DLine" : "33", "formatStatus" : true } ] }' ); 
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeOrdersLineUpdateRestAPI.updateSelectionSheet();      
        Test.stopTest();
    }
    
    @IsTest
    static void validateSelectionSheetUpdationWithRequestBodyNull() {
        
      id kerridgeOrderLineId = [SELECT Id From Kerridge_Order_Line__c Where Name='Testing kerrige ordr line'].Id;
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeOrders/'+kerridgeOrderLineId;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(''); 
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeOrdersLineUpdateRestAPI.updateSelectionSheet();
        Test.stopTest();
        
    }
}