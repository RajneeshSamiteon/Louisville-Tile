@isTest
public class KerridgeOrdersLineRestAPITest {
    
    @TestSetup
    public static void createTestData() {
        Kerridge_Order__c kerridgeOrder = new Kerridge_Order__c();
        kerridgeOrder.Name = 'Testing kerrige order';
        insert kerridgeOrder; 
        
        Kerridge_Order_Line__c kerridgeOrderLine = new Kerridge_Order_Line__c();
        kerridgeOrderLine.Name='Testing kerrige ordr line';
        kerridgeOrderLine.Kerridge_Order_Id__c = kerridgeOrder.Id;
        
        insert kerridgeOrderLine;
    }
    
    @IsTest
    public static void validateKerridgeOrdersLineCreation() {
        Kerridge_Order_Line__c kerridgeOrderLine = [SELECT Id, Kerridge_Order_Id__c From Kerridge_Order_Line__c Where Name='Testing kerrige ordr line' LIMIT 1];
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeOrders';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{ "kerridgeOrdersLine" : [{ "kerridgeOrderLineName" : "Test1", "KerridgeOrderId" : "'+ kerridgeOrderLine.Kerridge_Order_Id__c +'", "LineitemID" : "11", "quantity" : "1212", "LineDescription" : "Testing1212", "lineShipDate" : "2022-08-02", "productName" : "TestProd", "kerridgeOrder" : "123", "listPrice" : "556.50", "HReference" : "22", "DLine" : "22", "formatStatus" : true }] }'
        );
        
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeOrdersLineRestAPI.creatingKerridgeOrdersLine();
        
        Test.stopTest();
    }
    
    @IsTest
    public static void validateKerridgeOrdersLineCreationWithRequestBodyNull() {
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeOrders';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');
        
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeOrdersLineRestAPI.creatingKerridgeOrdersLine();
        
        Test.stopTest();
    }
    
}