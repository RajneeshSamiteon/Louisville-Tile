@IsTest
public class KerridgeQuoteUpdateRestAPITest {
    
    @TestSetup 
    static void testSetupMethodName() {
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
        
        Kerridge_Quote__c kerridgeQuote = new Kerridge_Quote__c();
        kerridgeQuote.Name = 'Kerridge Quote Testing';
        kerridgeQuote.Date_created_in_CQM__c = Date.today();
        kerridgeQuote.Date_last_modified_in_CQM__c = Date.today();
        kerridgeQuote.Kerridge_Quote__c = '438660';
        kerridgeQuote.Sequence_to_show_multiple_quotes__c = '2';
        kerridgeQuote.Opportunity_Id__c = opportunity.Id;
        kerridgeQuote.Expiration_date__c = Date.today();
        kerridgeQuote.Key_Id__c = 123;
        
        insert kerridgeQuote;
    }
    
    @IsTest
    public static void validateKerridgeQuoteUpdation() {
        Kerridge_Quote__c kerridgeQuote = [SELECT Id, Name, Date_created_in_CQM__c, Date_last_modified_in_CQM__c, Kerridge_Quote__c, Key_Id__c,
                                           Sequence_to_show_multiple_quotes__c, Opportunity_Id__c, Expiration_date__c 
                                           FROM Kerridge_Quote__c 
                                           WHERE Name = 'Kerridge Quote Testing'];
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/KerridgeQuoteUpdate/'+kerridgeQuote.Id;
        
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"kerridgeQuote" : [{"kerridgeQuoteName" : "order22","dateCreatedInCqm" : "2022-08-01T12:09:18.000Z","dateLastModifiedInCqm" : "2022-08-01T12:09:18.000Z","kerridgeQuoteNumber" : 43123,"sequenceToShowMultipleQuotes" : 3,"expirationDate" : "2022-08-01T12:09:18.000Z","KeyId" : "22"}]}'
        );
        
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeQuoteUpdateRestAPI.updateKerridgeQuoteUpdate();
        
        Test.stopTest();
    }
    
    @IsTest
    public static void validateKerridgeQuoteUpdationWithResponseBodyEmpty() {
        Kerridge_Quote__c kerridgeQuote = [SELECT Id, Name, Date_created_in_CQM__c, Date_last_modified_in_CQM__c, Kerridge_Quote__c, Key_Id__c,
                                           Sequence_to_show_multiple_quotes__c, Opportunity_Id__c, Expiration_date__c
                                           FROM Kerridge_Quote__c
                                           WHERE Name = 'Kerridge Quote Testing' 
                                           LIMIT 1];
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/KerridgeQuoteUpdate/'+kerridgeQuote.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');
        
        RestContext.request = req;
        RestContext.response = res;
        
        KerridgeQuoteUpdateRestAPI.updateKerridgeQuoteUpdate();
        
        Test.stopTest();    
    }
}