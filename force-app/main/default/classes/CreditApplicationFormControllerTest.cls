@isTest
public class CreditApplicationFormControllerTest {

    @testSetup
    public static void createTestRecord() {
        Contact contact = new Contact();
        contact.FirstName = 'Contact';
        contact.LastName = 'Dummy Contact';
        contact.Email = 'dummy@nonemail.com';
        contact.Roles__c = 'Architect';
        insert contact;
        
        Contact duplContact = new Contact();
        contact.FirstName = 'Contact';
        duplContact.LastName = 'Duplicate Contact';
        duplContact.Roles__c = 'Architect';
        insert duplContact;
        
        Credit_Application_Form__c creditForm = new Credit_Application_Form__c();
        creditForm.Contact__c = contact.Id;
        creditForm.Application_Status__c = 'In Progress';
        creditForm.Credit_Application_Code__c = '123456';
        insert creditForm;
        
        Credit_Application_Form__c duplCreditForm = new Credit_Application_Form__c();
        duplCreditForm.Contact__c = duplContact.Id;
        duplCreditForm.Application_Status__c = 'In Progress';
        insert duplCreditForm;
    }
    
    @isTest
    public static void validateSendVerificationCodeEmail(){
        Contact contact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE LastName =: 'Dummy Contact' LIMIT 1];
        
        String verificationCode = '123456';
        CreditApplicationFormController.sendEmail(contact, verificationCode);
        String vCode = CreditApplicationFormController.sendVerificationCodeEmail(contact.Id);
        system.assert(!String.isBlank(vCode), 'No OTP is found.');
        System.assertEquals(6, vCode.length(), 'Unexpected OTP found.');
    }
    
    @isTest
    public static void validateSendVerificationCodeWithoutEmail(){
        Contact dupliContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE LastName =: 'Duplicate Contact' LIMIT 1];
        
        try {
            CreditApplicationFormController.sendVerificationCodeEmail(dupliContact.Id);
        }
        catch(Exception e) {
            system.debug(e.getMessage());
        }
    }
    
    @isTest
    public static void validateSendVerificationCodeWithoutContact(){
        Id contactId = '0030300000j4aktAAA';
        
        try {
            CreditApplicationFormController.sendVerificationCodeEmail(contactId);
        }
        catch(Exception e) {
            system.debug(e.getMessage());
        }
    }
    
    @isTest
    public static void validateSendVerificationCode(){
        Contact contact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE LastName =: 'Dummy Contact' LIMIT 1];
        
        System.test.startTest();
        CreditApplicationFormController.getVerificationCode(contact.Id);
        System.test.stopTest();
    }
    
    @isTest
    public static void validateSendVerificationCodeForNoCode(){
        Contact contact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE LastName =: 'Duplicate Contact' LIMIT 1];
        
        try {
            CreditApplicationFormController.getVerificationCode(contact.Id);
        }
        catch(Exception e) {
            system.debug(e.getMessage());
        }
    }
    
    @isTest
    public static void getIsSubmittedValueTest(){       
        Contact contact = TestDataFactory.getContactInstance();
        insert contact;
        
        System.test.startTest();
        Credit_Application_Form__c creditAppForm = TestDataFactory.getCreditAppFormInstance();
        creditAppForm.Contact__c = contact.Id;
        creditAppForm.Application_Status__c = CreditApplicationContstants.Application_Status_Sent_To_Customer;
        insert creditAppForm;
        
        Boolean isSubmitted = CreditApplicationFormController.getIsSubmittedValue(contact.Id);
        System.test.stopTest();
        
    }
    
    @isTest
    public static void getIsSubmittedValueTest2(){       
         Contact con = TestDataFactory.getContactInstance();
        insert con;
        System.test.startTest();
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        creditAppFormObj.Application_Status__c = CreditApplicationContstants.Application_In_Progress;
        insert creditAppFormObj;
        
        CreditApplicationFormController.getIsSubmittedValue(con.Id);
        System.test.stopTest();
    }
    
    @isTest
    public static void getIsSubmittedValueTest3(){       
         Contact con = TestDataFactory.getContactInstance();
        insert con;
        System.test.startTest();
        Credit_Application_Form__c creditAppFormObj = TestDataFactory.getCreditAppFormInstance();
        creditAppFormObj.Contact__c = con.Id;
        creditAppFormObj.Application_Status__c = CreditApplicationContstants.Application_Status_In_Review;
        insert creditAppFormObj;
        
        CreditApplicationFormController.getIsSubmittedValue(con.Id);
        System.test.stopTest();
    }
    
    @isTest
    public static void getCreditApplicationsTest2(){
        Contact con = TestDataFactory.getContactInstance();
        insert con;
        
        System.test.startTest();
        CreditApplicationFormController.getCreditAppValue(con.Id);
        System.test.stopTest();
    }
}