@IsTest
public class KerridgeOrdersRestAPITest {
    
    @TestSetup
    public static void createTestData() {
        Account account = new Account();
        account.Name = 'Account Testing';
        
        insert account;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Opportunity Testing';
        opportunity.AccountId = account.Id;
        opportunity.CloseDate = Date.today().addDays(-10);
        opportunity.StageName = 'Partial Order';
        opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        
        insert opportunity;
    }
    
    @IsTest
    public static void validateKerridgeOrdersCreation() {
        String opportunityIdForKerridge = [SELECT Id, Opportunity_ID_for_Kerridge__c FROM Opportunity WHERE Name = 'Opportunity Testing' ].Opportunity_ID_for_Kerridge__c;
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeOrders';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"kerridgeOrders": [{ "orderName" : "K Orders 12", "SalesforceId" : "'+ opportunityIdForKerridge +'", "kerridgeAccount" : "Testing1", "KerridgeOrder" : "Testing2", "kerridgeQuote" : "Testing3", "status" : "Completed", "HReference" : "22", "SelectionSheetId" : "1122", "dateCreatedInKerridge" : "2022-08-01T12:09:18.000Z", "DateLastModifiedInKerridge" : "2022-08-01T12:09:18.000Z", "shipDate" : "2022-08-02", "orderStartDate" : "2022-08-02" }]}'
        );
        
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeOrdersRestAPI.creatingKerridgeOrders();

        Test.stopTest();
    }
    
    @IsTest
    public static void validateKerridgeOrdersCreationWithRequestBodyEmpty() {
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeOrders';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');
        
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeOrdersRestAPI.creatingKerridgeOrders();

        Test.stopTest();
    }
    
}