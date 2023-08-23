// Test_Class : CreditApplicationCodeControllerTest
public class CreditApplicationCodeController {
    
    public class CodeWithMessage {
        @AuraEnabled
        public String finalMessage {get;set;}
        @AuraEnabled
        public String generatedOTP {get;set;}
        
        public CodeWithMessage(String finalMessage, String generatedOTP) {
            this.finalMessage = finalMessage;
            this.generatedOTP = generatedOTP;
        }
    }
    
    @AuraEnabled
    public static CodeWithMessage getCreditApplicationFormCode(String contactId){
        String vCode = 'No Code';
        try {
            List<Contact> contacts = ContactSelector.getContacts(new Set<Id>{contactId});
            if(contacts.isEmpty()) {
                throw new AuraHandledException('No Contact Found...');
            }
            if(String.isBlank(contacts[0].Email)){
                throw new AuraHandledException('Email address not found...');
            }
            
            List<Credit_Application_Form__c> creditApplicationForms = CreditApplicationFormSelector.getCreditApplicationFormByContactIds(new Set<Id>{contactId});
            if(!creditApplicationForms.isEmpty()) {
                String creditFormCode = String.valueOf(creditApplicationForms[0].Credit_Application_Code__c);
                if(String.isNotEmpty(creditFormCode)) {
                    return new CodeWithMessage(creditApplicationForms[0].Code_Expire_Time__c, creditFormCode);
                }
            }
            return new CodeWithMessage(null, vCode);
        }
        catch(Exception ex) {
            ExceptionUtils.createExceptionLog('CreditApplicationCodeTabController - getCreditApplicationFormCode', ex.getMessage(), ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static CodeWithMessage generateCreditApplicationFormCode(String contactId){
        String eCode = 'ERROR';
        try {
            List<Contact> contacts = ContactSelector.getContacts(new Set<Id>{contactId});
            if(contacts.isEmpty()){
                throw new AuraHandledException('No Contact Found.');
            }
            if(String.isBlank(contacts[0].Email)){
                throw new AuraHandledException('Email address not found.');
            }
            
            String verificationCode = generateVerificationCode();
            
            List<Credit_Application_Form__c> creditApplicationForms = CreditApplicationFormSelector.getCreditApplicationFormByContactIds(new Set<Id>{contactId});
            if(creditApplicationForms[0].Code_Generation_Time__c != null) {
                DateTime previousTime = creditApplicationForms[0].Code_Generation_Time__c;
                Long differenceMillis = Math.abs(DateTime.now().getTime() - previousTime.getTime());
                
                Long customLabelValue = Long.valueOf(System.Label.credit_Form_Code_Expire_Duration);
                if(differenceMillis < customLabelValue){
                    long remainingMillis = customLabelValue - differenceMillis;
                    long remainingMinutes = remainingMillis / 60000;
                    long remainingSeconds = Math.mod(remainingMillis, 60000) / 1000;
                    String remainingTime = String.valueOf(remainingMinutes) + ' min ' + String.valueOf(remainingSeconds) + ' sec left';
                    return new CodeWithMessage(remainingTime, eCode);
                }
                
                updateCodeOnCreditApplicationForm(contacts[0].Id, verificationCode);
            }

            List<Credit_Application_Form__c> creditApplicationFormsWithUpdatedCode = CreditApplicationFormSelector.getCreditApplicationFormByIdsAndContactIds(new Set<Id>{creditApplicationForms[0].Id}, new Set<Id>{contacts[0].Id}); 
			return new CodeWithMessage(creditApplicationFormsWithUpdatedCode[0].Code_Expire_Time__c, creditApplicationFormsWithUpdatedCode[0].Credit_Application_Code__c);
        }
        catch(Exception ex) {
            ExceptionUtils.createExceptionLog('CreditApplicationCodeController - generateCreditApplicationFormCode', ex.getMessage(), ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @testVisible
    private static String generateVerificationCode(){
        return String.valueOf(Math.round((Math.random() * (900000) + 100000)));
    }
    
    public static void updateCodeOnCreditApplicationForm(Id contactId, String verificationCode) {
        try {
            List<Credit_Application_Form__c> creditApplicationFormByContactId = CreditApplicationFormSelector.getCreditApplicationFormByContactIds(new Set<Id>{contactId}); 
            
            if(!creditApplicationFormByContactId.isEmpty()) {
                creditApplicationFormByContactId[0].Credit_Application_Code__c = verificationCode;
                creditApplicationFormByContactId[0].Code_Generation_Time__c = DateTime.now();
                
                update creditApplicationFormByContactId;
            }
        }
        catch(Exception ex) {
            ExceptionUtils.createExceptionLog('CreditApplicationCodeController - updateCodeOnCreditApplicationForm', ex.getMessage(), ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
}