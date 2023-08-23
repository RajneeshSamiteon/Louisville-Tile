@isTest
public class CreditApplicationCodeControllerTest {
    
    @testSetup
    public static void createTestRecord() {
        Contact testContact = new Contact(
            FirstName = 'Testing',
            LastName = 'Contact1',
            Email = 'nonemail@testing.com',
            Roles__c = 'Architect'
        );
        insert testContact;
        
        Contact duplContact = new Contact(
            FirstName = 'Duplicate',
            LastName = 'Contact2'
        );
        insert duplContact;
        
        Contact duplContact2 = new Contact(
            FirstName = 'Duplicate',
            LastName = 'Contact3',
            Email = 'nonemail@testing.com'
        );
        insert duplContact2;
        
        Credit_Application_Form__c testCreditApplicationForm = new Credit_Application_Form__c(
            Contact__c = testContact.Id,
            Completed_Step__c = '1',
            Application_Status__c = 'In Progress',
            Credit_Application_Code__c = '123456',
            Code_Generation_Time__c = Datetime.now().addMinutes(-2)
        );
        insert testCreditApplicationForm;
        
        Credit_Application_Form__c duplCreditApplicationForm = new Credit_Application_Form__c(
            Contact__c = duplContact2.Id,
            Completed_Step__c = '1',
            Application_Status__c = 'In Progress',
            Credit_Application_Code__c = '123456',
            Code_Generation_Time__c = Datetime.now().addMinutes(6)
        );
        insert duplCreditApplicationForm;
    }
    
    @IsTest
    public static void validateGetCreditApplicationFormCode() {
        Id contactId = [SELECT Id, Email FROM Contact WHERE LastName =: 'Contact1' AND Email != NULL LIMIT 1].Id;
        String cCode = [SELECT Id, Credit_Application_Code__c FROM Credit_Application_Form__c WHERE Contact__c =: contactId].Credit_Application_Code__c;
        
        Test.startTest();
        CreditApplicationCodeController.CodeWithMessage codeWithMessage = CreditApplicationCodeController.getCreditApplicationFormCode(contactId);
        Test.stopTest();
        
        system.assert(codeWithMessage != null, 'No response returned.');
        system.assertEquals('123456', codeWithMessage.generatedOTP, 'Unexpectd Code found.');
    }
    
    @IsTest
    public static void validateGetCreditApplicationFormCodeForContactWithoutEmail() {
        Id contactId = [SELECT Id, Email FROM Contact WHERE LastName =: 'Contact2' LIMIT 1].Id;
        
        Test.startTest();
        try {
            CreditApplicationCodeController.getCreditApplicationFormCode(contactId);
        }
        catch(Exception exp) {
            system.debug('\n--Exception method :: validateGetCreditFormCodeForContactWithoutEmail--');
            system.debug('\n--Message--'+exp.getMessage()+'\n--Line Number--'+exp.getLineNumber()+'\n--Stack Trace--'+exp.getStackTraceString());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void validateGetCreditApplicationFormCodeForContactNotExist() {
        Test.startTest();
        try {
            CreditApplicationCodeController.getCreditApplicationFormCode('0032w0000AAA6PGQA0');
        }
        catch(Exception exp) {
            system.debug('\n--Exception method :: validateGetCreditFormCodeForContactNotExist--');
            system.debug('\n--Message--'+exp.getMessage()+'\n--Line Number--'+exp.getLineNumber()+'\n--Stack Trace--'+exp.getStackTraceString());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void validateGenerateCreditApplicationFormCodeWithTimeDelay() {
        Id contactId = [SELECT Id, Email FROM Contact WHERE LastName =: 'Contact1' AND Email != NULL LIMIT 1].Id;
        
        Test.startTest();
        CreditApplicationCodeController.CodeWithMessage codeWithMessage = CreditApplicationCodeController.generateCreditApplicationFormCode(contactId);
        Test.stopTest();
        
        system.assert(codeWithMessage != null, 'No response returned.');
        system.assert(codeWithMessage.generatedOTP != null, 'No response code found returned.');
    }
    
    @IsTest
    public static void validateGgenerateCreditApplicationFormCodeWithoutTimeDelay() {
        Id contactId = [SELECT Id, Email FROM Contact WHERE LastName =: 'Contact3' AND Email != NULL LIMIT 1].Id;
        
        Test.startTest();
        CreditApplicationCodeController.CodeWithMessage codeWithMessage = CreditApplicationCodeController.generateCreditApplicationFormCode(contactId);
        Test.stopTest();
    }
    
    @IsTest
    public static void validateGgenerateCreditApplicationFormCodeForContactWithoutEmail() {
        Id contactId = [SELECT Id, Email FROM Contact WHERE LastName =: 'Contact2' LIMIT 1].Id;
        
        Test.startTest();
        try {
            CreditApplicationCodeController.generateCreditApplicationFormCode(contactId);
        }
        catch(Exception exp) {
            system.debug('\n--Exception method :: validateGenerateCreditFormCodeForContactWithoutEmail--');
            system.debug('\n--Message--'+exp.getMessage()+'\n--Line Number--'+exp.getLineNumber()+'\n--Stack Trace--'+exp.getStackTraceString());
        }
        Test.stopTest();
    }
    
    @IsTest
    public static void validateGgenerateCreditApplicationFormCodeForContactNotExist() {
        Test.startTest();
        try {
            CreditApplicationCodeController.generateCreditApplicationFormCode('0032w000019Q6PGQA0');
        }
        catch(Exception exp) {
            system.debug('\n--Exception method :: validateGenerateCreditFormCodeForContactNotExist--');
            system.debug('\n--Message--'+exp.getMessage()+'\n--Line Number--'+exp.getLineNumber()+'\n--Stack Trace--'+exp.getStackTraceString());
        }
        Test.stopTest();
    }
    
}