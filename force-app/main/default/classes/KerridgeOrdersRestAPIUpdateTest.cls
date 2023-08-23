@IsTest
public class KerridgeOrdersRestAPIUpdateTest {

    @TestSetup
    public static void createTestData() {
        Kerridge_Order__c kerridgeOrder = new Kerridge_Order__c();
        kerridgeOrder.Name = 'Kerridge Order Testing';
        kerridgeOrder.Kerridge_Account__c = 'Testing';
        kerridgeOrder.Kerridge_Quote__c = 'Testing';
        kerridgeOrder.Kerridge_Order__c = 'Testing';
        kerridgeOrder.Status__c = 'Completed';
        kerridgeOrder.H_Reference__c = 438660;
        kerridgeOrder.Selection_Sheet_ID__c = '81565';
        kerridgeOrder.Date_created_in_Kerridge__c = Date.today();
        kerridgeOrder.Date_last_modified_in_Kerridge__c = Date.today().addDays(5);
        kerridgeOrder.Ship_Date__c = Date.today();
        kerridgeOrder.Order_Start_Date__c = Date.today();
        
        insert kerridgeOrder;
    }
    
    @IsTest
    public static void validateKerridgeOrdersUpdation() {
        Kerridge_Order__c kerridgeOrder = [SELECT Id, Name, Kerridge_Account__c, Kerridge_Quote__c, Kerridge_Order__c, Status__c, H_Reference__c, 
                                           Selection_Sheet_ID__c, Date_created_in_Kerridge__c, Date_last_modified_in_Kerridge__c, Ship_Date__c, 
                                           Order_Start_Date__c 
                                           FROM Kerridge_Order__c
                                           WHERE Name = 'Kerridge Order Testing' ];
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeOrdersUpdate/'+kerridgeOrder.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
        	'{ "kerridgeOrders" : [{ "orderName": "K Orders 12", "kerridgeAccount": "Testing1", "KerridgeOrder": "Testing2", "kerridgeQuote": "Testing3", "status": "Completed", "HReference" : "22", "SelectionSheetId" : "1122", "dateCreatedInKerridge" : "2022-08-01T12:09:18.000Z", "DateLastModifiedInKerridge" : "2022-08-01T12:09:18.000Z", "shipDate" : "2022-08-02", "orderStartDate" : "2022-08-02" } ]}'
        );
        
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeOrdersRestAPIUpdate.UpdatingKerridgeOrders();

        Test.stopTest();
    }
   
    @IsTest
    public static void validateKerridgeOrdersUpdationWithRequestBodyEmpty() {
        Kerridge_Order__c kerridgeOrder = [SELECT Id, Name, Kerridge_Account__c, Kerridge_Quote__c, Kerridge_Order__c, Status__c, H_Reference__c, 
                                           Selection_Sheet_ID__c, Date_created_in_Kerridge__c, Date_last_modified_in_Kerridge__c, Ship_Date__c, 
                                           Order_Start_Date__c 
                                           FROM Kerridge_Order__c
                                           WHERE Name = 'Kerridge Order Testing' ];
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeOrdersUpdate/'+kerridgeOrder.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');
        
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeOrdersRestAPIUpdate.UpdatingKerridgeOrders();

        Test.stopTest();
    }
    
}