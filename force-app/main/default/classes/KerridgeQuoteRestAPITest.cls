@IsTest
public class KerridgeQuoteRestAPITest {
    
    @TestSetup 
    public static void createTestData() {
        Account account =  new Account();
        account.Name= 'Testing Account';
        insert account;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Testing Opportunity';
        opportunity.StageName= 'Sampling';
        opportunity.AccountId = account.Id;
        opportunity.CloseDate = Date.today().addDays(2);
        opportunity.RecordTypeId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
        insert opportunity;
    }
    
    @IsTest
    static void validateKerridgeQuoteCreation() {
        String opportunityIdForKerridge = [SELECT Id, Opportunity_ID_for_Kerridge__c FROM Opportunity WHERE Name = 'Testing Opportunity' ].Opportunity_ID_for_Kerridge__c;
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeQuote';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"kerridgeQuote" : [{"SalesforceId" : "' + opportunityIdForKerridge + '","kerridgeQuoteName" : "order22","dateCreatedInCqm" : "2022-08-01T12:09:18.000Z","dateLastModifiedInCqm" : "2022-08-01T12:09:18.000Z","kerridgeQuoteNumber" : 43123,"sequenceToShowMultipleQuotes" : 1,"expirationDate" : "2022-08-01T12:09:18.000Z","KeyId" : "10"}]}'
        );
        
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeQuoteRestAPI.creatingKerridgeQuote();
        
        Test.stopTest();      
    }
    
    @IsTest
    static void validateKerridgeQuoteCreationWithRequestBodyEmpty() {
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/kerridgeQuote';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf( '' );
        
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeQuoteRestAPI.creatingKerridgeQuote();
        
        Test.stopTest();      
    }
}