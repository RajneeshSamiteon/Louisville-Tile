@IsTest
public class SelectionSheetRestAPIUpdateTest {

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
        
        Selection_Sheet__c selectionSheet = new Selection_Sheet__c();
        selectionSheet.Opportunity__c = opportunity.Id;
        selectionSheet.Kerridge_Account_ID__c = '123456';
        selectionSheet.SS_Line_Number__c = '123456';
        selectionSheet.Product_name__c = 'ANTHWCOB';
        selectionSheet.Quantity__c = '5';
        selectionSheet.Status__c = 'Order';
        selectionSheet.UOM__c = 'SA';
        selectionSheet.Date_created_in_SSM__c = Date.today();
        selectionSheet.Date_last_modified_in_SSM__c = Date.today().addDays(5);
        selectionSheet.Selection_Sheet_ID__c = '85156';
        
        insert selectionSheet;
    }
    
	@IsTest
    public static void validatedupdateSelectionSheet() {
        Selection_Sheet__c selectionSheet = [SELECT Id, Name, Opportunity__c, Kerridge_Account_ID__c, SS_Line_Number__c, Product_name__c, Quantity__c, 
                                             Status__c, UOM__c,Date_created_in_SSM__c, Date_last_modified_in_SSM__c, Selection_Sheet_ID__c
                                             FROM Selection_Sheet__c
                                             WHERE Opportunity__r.Name = 'Opportunity Testing'];
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SelectionSheetUpdate/'+selectionSheet.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{ "selectionSheet" : [{ "name" : "BIG data", "selectId" : 85156, "dateLastModifiedInSSM" : "2022-12-01", "dateCreatedInSSM" : "2022-12-01", "uom" : "SA", "status" : "Sold", "quantity" : 30, "productName" : "ABOCUSTOMEA", "ssLineNumber" : 10, "ssmCustId" :118024 }] }'
        );
        
        RestContext.request = req;
        RestContext.response = res;
        
        SelectionSheetRestAPIUpdate.updateSelectionSheet();

        Test.stopTest();
    }
    
    @IsTest
    public static void validatedupdateSelectionSheetWithRequestBodyEmpty() {
        Selection_Sheet__c selectionSheet = [SELECT Id, Name, Opportunity__c, Kerridge_Account_ID__c, SS_Line_Number__c, Product_name__c, Quantity__c, 
                                             Status__c, UOM__c,Date_created_in_SSM__c, Date_last_modified_in_SSM__c, Selection_Sheet_ID__c
                                             FROM Selection_Sheet__c
                                             WHERE Opportunity__r.Name = 'Opportunity Testing'];
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SelectionSheetUpdate/'+selectionSheet.Id;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('');
        
        RestContext.request = req;
        RestContext.response = res;
        
        SelectionSheetRestAPIUpdate.updateSelectionSheet();

        Test.stopTest();
    }
    
}