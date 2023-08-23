@IsTest
public class SelectionSheetRestAPITest {
    
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
    public static void validateSelectionSheetCreation() {
        String opportunityIdForKerridge = [SELECT Id, Opportunity_ID_for_Kerridge__c FROM Opportunity WHERE Name = 'Opportunity Testing' ].Opportunity_ID_for_Kerridge__c;
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeOrders';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{ "selectionSheet" :  [ { "SalesforceId": "' +opportunityIdForKerridge + '", "name" : "BIG data", "selectId" : 85156, "dateLastModifiedInSSM" : "2022-09-26", "dateCreatedInSSM" : "2022-05-11", "uom" : "EA", "status" : "order", "quantity" : 12.22, "productName" : "SAM120284", "ssLineNumber" : 1, "ssmCustId" :118024 } ] }'
        );
        
        RestContext.request = req;
        RestContext.response = res;
        
        SelectionSheetRestAPI.creatingSelectionSheet();
        
        Test.stopTest();
    }
    
    @IsTest
    public static void validateSelectionSheetCreationWithRequestBodyEmpty() {
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeOrders';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');
        
        RestContext.request = req;
        RestContext.response = res;
        
        SelectionSheetRestAPI.creatingSelectionSheet();
        
        Test.stopTest();      
    }
}